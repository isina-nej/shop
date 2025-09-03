from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

app_name = 'payments'

router = DefaultRouter()
router.register(r'payments', views.PaymentViewSet)
router.register(r'gateways', views.PaymentGatewayViewSet)
router.register(r'refunds', views.RefundViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('payment-intent/', views.PaymentIntentView.as_view(), name='payment-intent'),
    path('webhooks/<str:gateway_name>/', views.PaymentWebhookView.as_view(), name='payment-webhook'),
    path('methods/', views.PaymentMethodsView.as_view(), name='payment-methods'),
]
