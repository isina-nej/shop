from django.contrib import admin
from .models import Payment, PaymentGateway, Refund


@admin.register(Payment)
class PaymentAdmin(admin.ModelAdmin):
    """Payment admin"""
    list_display = ('order', 'payment_method', 'amount', 'currency', 'status', 'processed_at', 'created_at')
    list_filter = ('status', 'payment_method', 'currency', 'created_at')
    search_fields = ('order__order_number', 'transaction_id')
    readonly_fields = ('transaction_id', 'gateway_response', 'processed_at', 'created_at', 'updated_at')
    ordering = ('-created_at',)


@admin.register(PaymentGateway)
class PaymentGatewayAdmin(admin.ModelAdmin):
    """Payment gateway admin"""
    list_display = ('name', 'is_active', 'created_at', 'updated_at')
    list_filter = ('is_active',)
    search_fields = ('name', 'description')
    readonly_fields = ('created_at', 'updated_at')


@admin.register(Refund)
class RefundAdmin(admin.ModelAdmin):
    """Refund admin"""
    list_display = ('payment', 'amount', 'status', 'processed_by', 'processed_at', 'created_at')
    list_filter = ('status', 'created_at')
    search_fields = ('payment__order__order_number', 'refund_id', 'reason')
    readonly_fields = ('refund_id', 'gateway_response', 'processed_at', 'created_at', 'updated_at')
    ordering = ('-created_at',)
