from django.db import models
from django.utils.translation import gettext_lazy as _
from django.core.validators import MinValueValidator
from django.contrib.auth import get_user_model
from orders.models import Order

User = get_user_model()


class Payment(models.Model):
    """Payment model"""

    PAYMENT_METHOD_CHOICES = [
        ('credit_card', _('Credit Card')),
        ('debit_card', _('Debit Card')),
        ('bank_transfer', _('Bank Transfer')),
        ('paypal', _('PayPal')),
        ('cash_on_delivery', _('Cash on Delivery')),
        ('wallet', _('Digital Wallet')),
    ]

    STATUS_CHOICES = [
        ('pending', _('Pending')),
        ('processing', _('Processing')),
        ('completed', _('Completed')),
        ('failed', _('Failed')),
        ('cancelled', _('Cancelled')),
        ('refunded', _('Refunded')),
        ('partially_refunded', _('Partially Refunded')),
    ]

    # Payment identification
    payment_id = models.CharField(
        max_length=100,
        unique=True,
        verbose_name=_('Payment ID')
    )

    order = models.OneToOneField(
        Order,
        on_delete=models.CASCADE,
        related_name='payment',
        verbose_name=_('Order')
    )

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='payments',
        verbose_name=_('User')
    )

    # Payment details
    payment_method = models.CharField(
        max_length=20,
        choices=PAYMENT_METHOD_CHOICES,
        verbose_name=_('Payment Method')
    )

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default='pending',
        verbose_name=_('Status')
    )

    amount = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        validators=[MinValueValidator(0)],
        verbose_name=_('Amount')
    )

    currency = models.CharField(
        max_length=3,
        default='IRR',
        verbose_name=_('Currency')
    )

    # Transaction details
    transaction_id = models.CharField(
        max_length=255,
        blank=True,
        null=True,
        verbose_name=_('Transaction ID')
    )

    gateway_response = models.JSONField(
        blank=True,
        null=True,
        verbose_name=_('Gateway Response')
    )

    # Payment gateway specific fields
    gateway_name = models.CharField(
        max_length=100,
        blank=True,
        null=True,
        verbose_name=_('Gateway Name')
    )

    gateway_transaction_id = models.CharField(
        max_length=255,
        blank=True,
        null=True,
        verbose_name=_('Gateway Transaction ID')
    )

    # Refund information
    refund_amount = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name=_('Refund Amount')
    )

    refund_reason = models.TextField(
        blank=True,
        null=True,
        verbose_name=_('Refund Reason')
    )

    # Card information (masked for security)
    card_last_four = models.CharField(
        max_length=4,
        blank=True,
        null=True,
        verbose_name=_('Card Last Four Digits')
    )

    card_brand = models.CharField(
        max_length=50,
        blank=True,
        null=True,
        verbose_name=_('Card Brand')
    )

    # Billing address
    billing_address = models.TextField(
        blank=True,
        null=True,
        verbose_name=_('Billing Address')
    )

    # IP address and user agent for fraud detection
    ip_address = models.GenericIPAddressField(
        blank=True,
        null=True,
        verbose_name=_('IP Address')
    )

    user_agent = models.TextField(
        blank=True,
        null=True,
        verbose_name=_('User Agent')
    )

    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    processed_at = models.DateTimeField(
        blank=True,
        null=True,
        verbose_name=_('Processed At')
    )
    refunded_at = models.DateTimeField(
        blank=True,
        null=True,
        verbose_name=_('Refunded At')
    )

    class Meta:
        app_label = 'payments'
        verbose_name = _('Payment')
        verbose_name_plural = _('Payments')
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['order']),
            models.Index(fields=['user']),
            models.Index(fields=['status']),
            models.Index(fields=['payment_method']),
            models.Index(fields=['created_at']),
        ]

    def __str__(self):
        return f"Payment {self.payment_id} - {self.amount} {self.currency}"

    def save(self, *args, **kwargs):
        if not self.payment_id:
            # Generate payment ID
            import uuid
            self.payment_id = f"PAY-{uuid.uuid4().hex[:8].upper()}"
        super().save(*args, **kwargs)

    @property
    def is_successful(self):
        return self.status == 'completed'

    @property
    def is_refundable(self):
        return self.status in ['completed', 'partially_refunded'] and self.refund_amount < self.amount

    @property
    def remaining_amount(self):
        return self.amount - self.refund_amount


class PaymentGateway(models.Model):
    """Payment gateway configuration"""

    GATEWAY_CHOICES = [
        ('zarinpal', _('ZarinPal')),
        ('payping', _('PayPing')),
        ('idpay', _('IDPay')),
        ('paypal', _('PayPal')),
        ('stripe', _('Stripe')),
    ]

    name = models.CharField(
        max_length=100,
        unique=True,
        verbose_name=_('Name')
    )

    gateway_type = models.CharField(
        max_length=20,
        choices=GATEWAY_CHOICES,
        verbose_name=_('Gateway Type')
    )

    api_key = models.CharField(
        max_length=255,
        verbose_name=_('API Key')
    )

    api_secret = models.CharField(
        max_length=255,
        blank=True,
        null=True,
        verbose_name=_('API Secret')
    )

    merchant_id = models.CharField(
        max_length=255,
        blank=True,
        null=True,
        verbose_name=_('Merchant ID')
    )

    is_active = models.BooleanField(
        default=True,
        verbose_name=_('Is Active')
    )

    is_sandbox = models.BooleanField(
        default=True,
        verbose_name=_('Is Sandbox')
    )

    # Gateway specific settings
    settings = models.JSONField(
        default=dict,
        blank=True,
        verbose_name=_('Settings')
    )

    # Currency support
    supported_currencies = models.JSONField(
        default=list,
        verbose_name=_('Supported Currencies')
    )

    # Fees
    transaction_fee = models.DecimalField(
        max_digits=5,
        decimal_places=2,
        default=0,
        verbose_name=_('Transaction Fee (%)')
    )

    fixed_fee = models.DecimalField(
        max_digits=8,
        decimal_places=2,
        default=0,
        verbose_name=_('Fixed Fee')
    )

    # Limits
    min_amount = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        default=1000,
        validators=[MinValueValidator(0)],
        verbose_name=_('Minimum Amount')
    )

    max_amount = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        default=50000000,
        validators=[MinValueValidator(0)],
        verbose_name=_('Maximum Amount')
    )

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        app_label = 'payments'
        verbose_name = _('Payment Gateway')
        verbose_name_plural = _('Payment Gateways')
        ordering = ['name']

    def __str__(self):
        return f"{self.name} ({'Sandbox' if self.is_sandbox else 'Production'})"


class Refund(models.Model):
    """Refund model"""

    STATUS_CHOICES = [
        ('pending', _('Pending')),
        ('processing', _('Processing')),
        ('completed', _('Completed')),
        ('failed', _('Failed')),
        ('cancelled', _('Cancelled')),
    ]

    refund_id = models.CharField(
        max_length=100,
        unique=True,
        verbose_name=_('Refund ID')
    )

    payment = models.ForeignKey(
        Payment,
        on_delete=models.CASCADE,
        related_name='refunds',
        verbose_name=_('Payment')
    )

    order = models.ForeignKey(
        Order,
        on_delete=models.CASCADE,
        related_name='refunds',
        verbose_name=_('Order')
    )

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='refunds',
        verbose_name=_('User')
    )

    amount = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        validators=[MinValueValidator(0)],
        verbose_name=_('Refund Amount')
    )

    reason = models.TextField(
        verbose_name=_('Refund Reason')
    )

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default='pending',
        verbose_name=_('Status')
    )

    # Gateway response
    gateway_response = models.JSONField(
        blank=True,
        null=True,
        verbose_name=_('Gateway Response')
    )

    # Processing information
    processed_by = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        blank=True,
        null=True,
        related_name='processed_refunds',
        verbose_name=_('Processed By')
    )

    notes = models.TextField(
        blank=True,
        null=True,
        verbose_name=_('Notes')
    )

    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    processed_at = models.DateTimeField(
        blank=True,
        null=True,
        verbose_name=_('Processed At')
    )

    class Meta:
        app_label = 'payments'
        verbose_name = _('Refund')
        verbose_name_plural = _('Refunds')
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['payment']),
            models.Index(fields=['order']),
            models.Index(fields=['user']),
            models.Index(fields=['status']),
        ]

    def __str__(self):
        return f"Refund {self.refund_id} - {self.amount}"

    def save(self, *args, **kwargs):
        if not self.refund_id:
            # Generate refund ID
            import uuid
            self.refund_id = f"REF-{uuid.uuid4().hex[:8].upper()}"
        super().save(*args, **kwargs)

    @property
    def is_successful(self):
        return self.status == 'completed'
