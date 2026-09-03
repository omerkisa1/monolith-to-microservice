import time

from prometheus_client import Counter, Histogram, Gauge

REQUEST_COUNT = Counter(
    "django_http_requests_total",
    "Toplam istek sayısı",
    ["method", "endpoint", "status"],
)

REQUEST_LATENCY = Histogram(
    "django_http_request_duration_seconds",
    "İstek süresi (saniye)",
    ["method", "endpoint"],
    buckets=[0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5, 5.0, 10.0],
)

ACTIVE_REQUESTS = Gauge(
    "django_active_requests",
    "Şu an işlenmekte olan istek sayısı",
)


class PrometheusMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if request.path == "/metrics/":
            return self.get_response(request)

        ACTIVE_REQUESTS.inc()
        start = time.time()

        try:
            response = self.get_response(request)
        finally:
            ACTIVE_REQUESTS.dec()

        duration = time.time() - start

        if request.path not in ("/health/", "/metrics/"):
            REQUEST_COUNT.labels(
                method=request.method,
                endpoint=request.path,
                status=response.status_code,
            ).inc()
            REQUEST_LATENCY.labels(
                method=request.method,
                endpoint=request.path,
            ).observe(duration)

        return response
