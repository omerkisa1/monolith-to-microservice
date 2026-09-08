from django.conf import settings
from django.db import IntegrityError, transaction

from cart.services import release_all_reservations
from catalog.models import Product
from payments.services import charge

from .models import Order, OrderItem


class CheckoutError(Exception):
    pass


class EmptyCart(CheckoutError):
    pass


class DuplicateOrder(CheckoutError):
    def __init__(self, order):
        self.order = order
        super().__init__(f"Order {order.id} was already placed for this checkout")


class OutOfStock(CheckoutError):
    def __init__(self, product, available):
        self.product = product
        self.available = available
        super().__init__(f"Only {available} left of {product.name}")


def _append_order_log(order, payment):
    """
    Durable-ish audit trail of completed orders, written from inside the
    checkout transaction so a rollback never leaves an orphaned log line.
    """
    settings.LOG_DIR.mkdir(parents=True, exist_ok=True)
    line = (
        f"{order.created_at.isoformat()} order={order.id} user={order.user_id} "
        f"total={order.total} status={order.status} txn={payment.transaction_ref}\n"
    )
    with open(settings.ORDERS_LOG_FILE, "a") as fh:
        fh.write(line)


@transaction.atomic
def checkout(request, user, cart_items, shipping_address, payment_method, idempotency_key=None):
    """
    The one transaction the whole store's data integrity rests on: stock,
    order, order items and payment all move together or not at all.

    idempotency_key is the duplicate-order guard: a unique key generated when
    the checkout page is rendered and re-sent with the POST. If two POSTs race
    with the same key, the unique index lets exactly one create the order and
    the loser is answered with DuplicateOrder pointing at the winner's order.
    """
    if not cart_items:
        raise EmptyCart()

    total = sum((item["subtotal"] for item in cart_items), start=0)

    try:
        with transaction.atomic():
            order = Order.objects.create(
                user=user,
                status="pending",
                total=total,
                shipping_address=shipping_address,
                idempotency_key=idempotency_key,
            )
    except IntegrityError:
        if not idempotency_key:
            raise
        existing = Order.objects.get(idempotency_key=idempotency_key)
        raise DuplicateOrder(existing)

    for item in cart_items:
        product = Product.objects.select_for_update().get(pk=item["product"].id)
        quantity = item["quantity"]

        if product.stock < quantity:
            raise OutOfStock(product, product.stock)

        product.stock -= quantity
        product.reserved_stock = max(0, product.reserved_stock - quantity)
        product.save(update_fields=["stock", "reserved_stock"])

        OrderItem.objects.create(
            order=order,
            product=product,
            quantity=quantity,
            unit_price=product.price,
        )

    payment = charge(order, payment_method, total)

    order.status = "paid"
    order.save(update_fields=["status"])

    _append_order_log(order, payment)

    release_all_reservations(request)

    return order
