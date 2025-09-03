from django.db import models
from django.utils.translation import gettext_lazy as _
from django.core.validators import MinValueValidator
from django.contrib.auth import get_user_model
from accounts.models import Address
from products.models import Product, ProductVariant

User = get_user_model()


class Order(models.Model):
    """Order model"""

    ORDER_STATUS = [
        ('pending', _('Pending')),
        ('confirmed', _('Confirmed')),
        ('processing', _('Processing')),
        ('shipped', _('Shipped')),
        ('delivered', _('Delivered')),
        ('cancelled', _('Cancelled')),
        ('refunded', _('Refunded')),
    ]

    # Order identification
    order_number = models.CharField(
        max_length=20,
        unique=True,
        verbose_name=_('Order Number')
    )

    # Relationships
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='orders',
        verbose_name=_('User')
    )

    # Addresses
    shipping_address = models.ForeignKey(
        Address,
        on_delete=models.SET_NULL,
        null=True,
        related_name='shipping_orders',
        verbose_name=_('Shipping Address')
    )
    billing_address = models.ForeignKey(
        Address,
        on_delete=models.SET_NULL,
        null=True,
        related_name='billing_orders',
        verbose_name=_('Billing Address')
    )

    # Order details
    status = models.CharField(
        max_length=20,
        choices=ORDER_STATUS,
        default='pending',
        verbose_name=_('Status')
    )

    # Pricing
    subtotal = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        validators=[MinValueValidator(0)],
        verbose_name=_('Subtotal')
    )
    tax_amount = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name=_('Tax Amount')
    )
    shipping_cost = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name=_('Shipping Cost')
    )
    discount_amount = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name=_('Discount Amount')
    )
    total_amount = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        validators=[MinValueValidator(0)],
        verbose_name=_('Total Amount')
    )

    # Currency
    currency = models.CharField(max_length=3, default='IRR', verbose_name=_('Currency'))

    # Order notes
    customer_notes = models.TextField(blank=True, verbose_name=_('Customer Notes'))
    internal_notes = models.TextField(blank=True, verbose_name=_('Internal Notes'))

    # Tracking
    tracking_number = models.CharField(max_length=100, blank=True, verbose_name=_('Tracking Number'))
    carrier = models.CharField(max_length=50, blank=True, verbose_name=_('Carrier'))

    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    shipped_at = models.DateTimeField(null=True, blank=True, verbose_name=_('Shipped At'))
    delivered_at = models.DateTimeField(null=True, blank=True, verbose_name=_('Delivered At'))

    class Meta:
        app_label = 'orders'
        verbose_name = _('Order')
        verbose_name_plural = _('Orders')
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['user']),
            models.Index(fields=['status']),
            models.Index(fields=['created_at']),
            models.Index(fields=['order_number']),
        ]

    def __str__(self):
        return f"Order {self.order_number}"

    def save(self, *args, **kwargs):
        if not self.order_number:
            # Generate order number
            import uuid
            from datetime import datetime
            now = datetime.now()
            self.order_number = f"ORD-{now.strftime('%Y%m%d')}-{uuid.uuid4().hex[:6].upper()}"
        super().save(*args, **kwargs)

    @property
    def item_count(self):
        return sum(item.quantity for item in self.items.all())

    @property
    def can_cancel(self):
        return self.status in ['pending', 'confirmed']

    @property
    def can_ship(self):
        return self.status == 'processing'

    @property
    def can_deliver(self):
        return self.status == 'shipped'


class OrderItem(models.Model):
    """Individual items in an order"""

    order = models.ForeignKey(
        Order,
        on_delete=models.CASCADE,
        related_name='items',
        verbose_name=_('Order')
    )

    # Product information
    product = models.ForeignKey(
        Product,
        on_delete=models.CASCADE,
        related_name='order_items',
        verbose_name=_('Product')
    )
    variant = models.ForeignKey(
        ProductVariant,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='order_items',
        verbose_name=_('Product Variant')
    )

    # Item details
    product_name = models.CharField(max_length=200, verbose_name=_('Product Name'))
    variant_name = models.CharField(max_length=100, blank=True, verbose_name=_('Variant Name'))
    sku = models.CharField(max_length=50, verbose_name=_('SKU'))

    # Pricing
    unit_price = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        validators=[MinValueValidator(0)],
        verbose_name=_('Unit Price')
    )
    quantity = models.PositiveIntegerField(verbose_name=_('Quantity'))
    total_price = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        validators=[MinValueValidator(0)],
        verbose_name=_('Total Price')
    )

    # Item image (snapshot at time of order)
    product_image = models.URLField(blank=True, verbose_name=_('Product Image'))

    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        app_label = 'orders'
        verbose_name = _('Order Item')
        verbose_name_plural = _('Order Items')
        ordering = ['created_at']

    def __str__(self):
        return f"{self.product_name} x{self.quantity}"

    def save(self, *args, **kwargs):
        self.total_price = self.unit_price * self.quantity
        super().save(*args, **kwargs)


class Cart(models.Model):
    """Shopping cart model"""

    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name='cart',
        verbose_name=_('User')
    )

    # Cart totals
    subtotal = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name=_('Subtotal')
    )
    tax_amount = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name=_('Tax Amount')
    )
    discount_amount = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name=_('Discount Amount')
    )
    total_amount = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name=_('Total Amount')
    )

    # Currency
    currency = models.CharField(max_length=3, default='IRR', verbose_name=_('Currency'))

    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        app_label = 'orders'
        verbose_name = _('Cart')
        verbose_name_plural = _('Carts')

    def __str__(self):
        return f"{self.user.email}'s cart"

    @property
    def item_count(self):
        return sum(item.quantity for item in self.items.all())

    def update_totals(self):
        """Update cart totals"""
        items = self.items.all()
        self.subtotal = sum(item.total_price for item in items)
        # Add tax and discount calculations here
        self.total_amount = self.subtotal + self.tax_amount - self.discount_amount
        self.save()


class CartItem(models.Model):
    """Items in shopping cart"""

    cart = models.ForeignKey(
        Cart,
        on_delete=models.CASCADE,
        related_name='items',
        verbose_name=_('Cart')
    )

    # Product information
    product = models.ForeignKey(
        Product,
        on_delete=models.CASCADE,
        related_name='cart_items',
        verbose_name=_('Product')
    )
    variant = models.ForeignKey(
        ProductVariant,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='cart_items',
        verbose_name=_('Product Variant')
    )

    # Item details
    quantity = models.PositiveIntegerField(default=1, verbose_name=_('Quantity'))

    # Pricing (snapshot)
    unit_price = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        validators=[MinValueValidator(0)],
        verbose_name=_('Unit Price')
    )
    total_price = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        validators=[MinValueValidator(0)],
        verbose_name=_('Total Price')
    )

    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        app_label = 'orders'
        verbose_name = _('Cart Item')
        verbose_name_plural = _('Cart Items')
        unique_together = ['cart', 'product', 'variant']

    def __str__(self):
        variant_str = f" ({self.variant.name})" if self.variant else ""
        return f"{self.product.name}{variant_str} x{self.quantity}"

    def save(self, *args, **kwargs):
        self.total_price = self.unit_price * self.quantity
        super().save(*args, **kwargs)
        # Update cart totals
        self.cart.update_totals()

    @property
    def is_available(self):
        """Check if item is still available"""
        if self.variant:
            return self.variant.is_in_stock and self.variant.stock_quantity >= self.quantity
        return self.product.is_in_stock and self.product.stock_quantity >= self.quantity


class Coupon(models.Model):
    """Discount coupon model"""

    COUPON_TYPES = [
        ('percentage', _('Percentage')),
        ('fixed', _('Fixed Amount')),
        ('free_shipping', _('Free Shipping')),
    ]

    code = models.CharField(max_length=20, unique=True, verbose_name=_('Code'))
    name = models.CharField(max_length=100, verbose_name=_('Name'))
    description = models.TextField(blank=True, verbose_name=_('Description'))

    # Coupon type and value
    coupon_type = models.CharField(
        max_length=20,
        choices=COUPON_TYPES,
        default='percentage',
        verbose_name=_('Coupon Type')
    )
    value = models.DecimalField(
        max_digits=8,
        decimal_places=2,
        validators=[MinValueValidator(0)],
        verbose_name=_('Value')
    )

    # Usage limits
    usage_limit = models.PositiveIntegerField(
        null=True,
        blank=True,
        verbose_name=_('Usage Limit')
    )
    usage_count = models.PositiveIntegerField(default=0, verbose_name=_('Usage Count'))

    # User limits
    per_user_limit = models.PositiveIntegerField(
        default=1,
        verbose_name=_('Per User Limit')
    )

    # Validity period
    valid_from = models.DateTimeField(verbose_name=_('Valid From'))
    valid_until = models.DateTimeField(verbose_name=_('Valid Until'))

    # Minimum order amount
    minimum_amount = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name=_('Minimum Order Amount')
    )

    # Applicable products/categories
    applicable_products = models.ManyToManyField(
        Product,
        blank=True,
        related_name='coupons',
        verbose_name=_('Applicable Products')
    )
    applicable_categories = models.ManyToManyField(
        'products.Category',
        blank=True,
        related_name='coupons',
        verbose_name=_('Applicable Categories')
    )

    # Status
    is_active = models.BooleanField(default=True, verbose_name=_('Is Active'))

    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        app_label = 'orders'
        verbose_name = _('Coupon')
        verbose_name_plural = _('Coupons')
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.code} - {self.name}"

    @property
    def is_valid(self):
        from django.utils import timezone
        now = timezone.now()
        return (
            self.is_active and
            self.valid_from <= now <= self.valid_until and
            (self.usage_limit is None or self.usage_count < self.usage_limit)
        )

    def can_use(self, user, order_total):
        """Check if coupon can be used by user"""
        if not self.is_valid:
            return False

        if order_total < self.minimum_amount:
            return False

        # Check per user limit
        user_usage = self.coupon_usages.filter(user=user).count()
        if user_usage >= self.per_user_limit:
            return False

        return True


class CouponUsage(models.Model):
    """Track coupon usage"""

    coupon = models.ForeignKey(
        Coupon,
        on_delete=models.CASCADE,
        related_name='coupon_usages',
        verbose_name=_('Coupon')
    )
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='coupon_usages',
        verbose_name=_('User')
    )
    order = models.ForeignKey(
        Order,
        on_delete=models.CASCADE,
        related_name='coupon_usages',
        verbose_name=_('Order')
    )

    # Usage details
    discount_amount = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        validators=[MinValueValidator(0)],
        verbose_name=_('Discount Amount')
    )

    # Timestamps
    used_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        app_label = 'orders'
        verbose_name = _('Coupon Usage')
        verbose_name_plural = _('Coupon Usages')
        unique_together = ['coupon', 'user', 'order']

    def __str__(self):
        return f"{self.coupon.code} used by {self.user.email}"
