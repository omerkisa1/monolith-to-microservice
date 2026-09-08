from decimal import Decimal

from django.contrib.auth.models import User
from django.contrib.sessions.backends.db import SessionStore
from django.test import RequestFactory, TestCase
from django.urls import reverse

from cart.services import CART_SESSION_KEY, get_cart_items
from catalog.models import Category, Product

from . import services
from .models import Order


class CheckoutIdempotencyTests(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username="customer", email="customer@example.com", password="pw"
        )
        category = Category.objects.create(name="Gadgets", slug="gadgets")
        self.product = Product.objects.create(
            category=category,
            name="Widget",
            slug="widget",
            price=Decimal("10.00"),
            stock=100,
        )
        self.factory = RequestFactory()

    def _request_with_cart(self, quantity=1):
        request = self.factory.post("/orders/checkout/")
        request.session = SessionStore()
        request.session[CART_SESSION_KEY] = {str(self.product.id): quantity}
        return request

    def test_same_key_second_checkout_raises_duplicate(self):
        request = self._request_with_cart()
        items = get_cart_items(request)

        first = services.checkout(
            request,
            user=self.user,
            cart_items=items,
            shipping_address="1 Main St",
            payment_method="card",
            idempotency_key="key-1",
        )

        replay = self._request_with_cart()
        replay_items = get_cart_items(replay)
        with self.assertRaises(services.DuplicateOrder) as ctx:
            services.checkout(
                replay,
                user=self.user,
                cart_items=replay_items,
                shipping_address="1 Main St",
                payment_method="card",
                idempotency_key="key-1",
            )

        self.assertEqual(ctx.exception.order.id, first.id)
        self.assertEqual(Order.objects.filter(idempotency_key="key-1").count(), 1)

    def test_duplicate_key_view_redirects_to_existing_order(self):
        self.client.force_login(self.user)

        session = self.client.session
        session[CART_SESSION_KEY] = {str(self.product.id): 1}
        session.save()

        url = reverse("orders:checkout")
        payload = {
            "shipping_address": "1 Main St",
            "payment_method": "card",
            "idempotency_key": "view-key",
        }

        first = self.client.post(url, payload)
        replay = self.client.post(url, payload)

        self.assertEqual(first.status_code, 302)
        self.assertEqual(replay.status_code, 302)
        self.assertEqual(replay["Location"], first["Location"])
        self.assertEqual(Order.objects.filter(idempotency_key="view-key").count(), 1)

    def test_distinct_keys_create_distinct_orders(self):
        request = self._request_with_cart()
        items = get_cart_items(request)

        first = services.checkout(
            request,
            user=self.user,
            cart_items=items,
            shipping_address="1 Main St",
            payment_method="card",
            idempotency_key="key-a",
        )

        second_request = self._request_with_cart()
        second_items = get_cart_items(second_request)
        second = services.checkout(
            second_request,
            user=self.user,
            cart_items=second_items,
            shipping_address="2 Main St",
            payment_method="card",
            idempotency_key="key-b",
        )

        self.assertNotEqual(first.id, second.id)
        self.assertEqual(
            Order.objects.filter(idempotency_key__in=["key-a", "key-b"]).count(),
            2,
        )