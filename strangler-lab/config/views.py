from django.http import HttpResponse, JsonResponse
from django.db import connection

from prometheus_client import CONTENT_TYPE_LATEST, generate_latest


def metrics(request):
    return HttpResponse(
        generate_latest(),
        content_type=CONTENT_TYPE_LATEST,
    )


def health(request):
    """Readiness probe - checks critical dependencies"""
    errors = []

    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
    except Exception as e:
        errors.append(f"Database error: {str(e)}")

    if errors:
        return JsonResponse(
            {"status": "unhealthy", "errors": errors}, 
            status=503,
        )
    return JsonResponse({"status": "ok"})
