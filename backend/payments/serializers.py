from rest_framework import serializers
from django.db import models
from .models import Payment, PaymentGateway, Refund


class PaymentSerializer(serializers.ModelSerializer):
    """Payment serializer"""
    order_number = serializers.CharField(source='order.order_number', read_only=True)
    gateway_name = serializers.CharField(source='gateway.name', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    refundable_amount = serializers.SerializerMethodField()

    class Meta:
        model = Payment
        fields = [
            'id', 'order', 'order_number', 'gateway', 'gateway_name',
            'amount', 'currency', 'status', 'status_display',
            'transaction_id', 'gateway_response', 'processed_at',
            'refundable_amount', 'created_at', 'updated_at'
        ]
        read_only_fields = [
            'id', 'transaction_id', 'gateway_response',
            'processed_at', 'created_at', 'updated_at'
        ]

    def get_refundable_amount(self, obj):
        if obj.status == 'completed':
            refunded_amount = obj.refunds.filter(
                status='completed'
            ).aggregate(total=models.Sum('amount'))['total'] or 0
            return obj.amount - refunded_amount
        return 0


class PaymentGatewaySerializer(serializers.ModelSerializer):
    """Payment gateway serializer"""
    supported_currencies_display = serializers.SerializerMethodField()

    class Meta:
        model = PaymentGateway
        fields = [
            'id', 'name', 'display_name', 'description', 'logo',
            'supported_currencies', 'supported_currencies_display',
            'is_active', 'test_mode', 'config', 'fee_percentage',
            'fee_fixed', 'processing_time', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']

    def get_supported_currencies_display(self, obj):
        return obj.supported_currencies


class RefundSerializer(serializers.ModelSerializer):
    """Refund serializer"""
    payment_amount = serializers.DecimalField(
        source='payment.amount',
        max_digits=10,
        decimal_places=2,
        read_only=True
    )
    order_number = serializers.CharField(
        source='payment.order.order_number',
        read_only=True
    )
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    processed_by_name = serializers.CharField(
        source='processed_by.get_full_name',
        read_only=True
    )

    class Meta:
        model = Refund
        fields = [
            'id', 'payment', 'payment_amount', 'order_number',
            'amount', 'currency', 'reason', 'status', 'status_display',
            'transaction_id', 'gateway_response', 'processed_by',
            'processed_by_name', 'processed_at', 'created_at', 'updated_at'
        ]
        read_only_fields = [
            'id', 'transaction_id', 'gateway_response',
            'processed_at', 'created_at', 'updated_at'
        ]


class PaymentIntentSerializer(serializers.Serializer):
    """Payment intent serializer"""
    order_id = serializers.IntegerField()
    gateway_id = serializers.IntegerField()
    return_url = serializers.URLField(required=False)


class PaymentWebhookSerializer(serializers.Serializer):
    """Payment webhook serializer"""
    event_type = serializers.CharField()
    data = serializers.DictField()
    signature = serializers.CharField(required=False)
