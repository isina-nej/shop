from django.db import models
from django.utils.translation import gettext_lazy as _
from django.core.validators import MinValueValidator, MaxValueValidator
from django.urls import reverse
from django.utils.text import slugify
from django.contrib.auth import get_user_model

User = get_user_model()


class Category(models.Model):
    """Product category model"""

    name = models.CharField(max_length=100, unique=True, verbose_name=_('Name'))
    slug = models.SlugField(max_length=120, unique=True, blank=True)
    description = models.TextField(blank=True, verbose_name=_('Description'))

    # Category hierarchy
    parent = models.ForeignKey(
        'self',
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name='children',
        verbose_name=_('Parent Category')
    )

    # Category image
    image = models.ImageField(
        upload_to='categories/',
        blank=True,
        null=True,
        verbose_name=_('Image')
    )

    # SEO fields
    meta_title = models.CharField(max_length=60, blank=True, verbose_name=_('Meta Title'))
    meta_description = models.CharField(max_length=160, blank=True, verbose_name=_('Meta Description'))

    # Display settings
    is_active = models.BooleanField(default=True, verbose_name=_('Is Active'))
    display_order = models.PositiveIntegerField(default=0, verbose_name=_('Display Order'))

    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        app_label = 'products'
        verbose_name = _('Category')
        verbose_name_plural = _('Categories')
        ordering = ['display_order', 'name']

    def __str__(self):
        return self.name

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        super().save(*args, **kwargs)

    @property
    def is_parent(self):
        return self.parent is None

    def get_absolute_url(self):
        return reverse('products:category_detail', kwargs={'slug': self.slug})


class Brand(models.Model):
    """Product brand/manufacturer model"""

    name = models.CharField(max_length=100, unique=True, verbose_name=_('Name'))
    slug = models.SlugField(max_length=120, unique=True, blank=True)
    description = models.TextField(blank=True, verbose_name=_('Description'))

    # Brand details
    website = models.URLField(blank=True, verbose_name=_('Website'))
    logo = models.ImageField(
        upload_to='brands/',
        blank=True,
        null=True,
        verbose_name=_('Logo')
    )

    # Contact information
    email = models.EmailField(blank=True, verbose_name=_('Email'))
    phone = models.CharField(max_length=20, blank=True, verbose_name=_('Phone'))

    # SEO fields
    meta_title = models.CharField(max_length=60, blank=True, verbose_name=_('Meta Title'))
    meta_description = models.CharField(max_length=160, blank=True, verbose_name=_('Meta Description'))

    # Status
    is_active = models.BooleanField(default=True, verbose_name=_('Is Active'))

    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        app_label = 'products'
        verbose_name = _('Brand')
        verbose_name_plural = _('Brands')
        ordering = ['name']

    def __str__(self):
        return self.name

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        super().save(*args, **kwargs)

    def get_absolute_url(self):
        return reverse('products:brand_detail', kwargs={'slug': self.slug})


class Product(models.Model):
    """Main product model"""

    # Basic information
    name = models.CharField(max_length=200, verbose_name=_('Name'))
    slug = models.SlugField(max_length=220, unique=True, blank=True)
    sku = models.CharField(
        max_length=50,
        unique=True,
        blank=True,
        null=True,
        verbose_name=_('SKU')
    )

    # Description
    short_description = models.TextField(blank=True, verbose_name=_('Short Description'))
    description = models.TextField(blank=True, verbose_name=_('Description'))

    # Relationships
    category = models.ForeignKey(
        Category,
        on_delete=models.CASCADE,
        related_name='products',
        verbose_name=_('Category')
    )
    brand = models.ForeignKey(
        Brand,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='products',
        verbose_name=_('Brand')
    )

    # Pricing
    price = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        validators=[MinValueValidator(0)],
        verbose_name=_('Price')
    )
    compare_price = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        null=True,
        blank=True,
        validators=[MinValueValidator(0)],
        verbose_name=_('Compare Price')
    )

    # Inventory
    stock_quantity = models.PositiveIntegerField(default=0, verbose_name=_('Stock Quantity'))
    low_stock_threshold = models.PositiveIntegerField(default=10, verbose_name=_('Low Stock Threshold'))

    # Product status
    is_active = models.BooleanField(default=True, verbose_name=_('Is Active'))
    is_featured = models.BooleanField(default=False, verbose_name=_('Is Featured'))
    is_digital = models.BooleanField(default=False, verbose_name=_('Is Digital Product'))

    # Product images
    main_image = models.ImageField(
        upload_to='products/',
        blank=True,
        null=True,
        verbose_name=_('Main Image')
    )

    # SEO fields
    meta_title = models.CharField(max_length=60, blank=True, verbose_name=_('Meta Title'))
    meta_description = models.CharField(max_length=160, blank=True, verbose_name=_('Meta Description'))

    # Product attributes
    weight = models.DecimalField(
        max_digits=8,
        decimal_places=2,
        null=True,
        blank=True,
        validators=[MinValueValidator(0)],
        verbose_name=_('Weight (kg)')
    )
    dimensions = models.CharField(max_length=50, blank=True, verbose_name=_('Dimensions'))

    # Sales tracking
    total_sales = models.PositiveIntegerField(default=0, verbose_name=_('Total Sales'))
    view_count = models.PositiveIntegerField(default=0, verbose_name=_('View Count'))

    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        app_label = 'products'
        verbose_name = _('Product')
        verbose_name_plural = _('Products')
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['category']),
            models.Index(fields=['brand']),
            models.Index(fields=['is_active', 'is_featured']),
            models.Index(fields=['price']),
        ]

    def __str__(self):
        return self.name

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        if not self.sku:
            # Generate SKU
            import uuid
            self.sku = f"PRD-{uuid.uuid4().hex[:8].upper()}"
        super().save(*args, **kwargs)

    def get_absolute_url(self):
        return reverse('products:product_detail', kwargs={'slug': self.slug})

    @property
    def is_in_stock(self):
        return self.stock_quantity > 0

    @property
    def is_low_stock(self):
        return self.stock_quantity <= self.low_stock_threshold

    @property
    def discount_percentage(self):
        if self.compare_price and self.compare_price > self.price:
            return round(((self.compare_price - self.price) / self.compare_price) * 100, 2)
        return 0

    @property
    def average_rating(self):
        reviews = self.reviews.filter(is_active=True)
        if reviews.exists():
            return round(reviews.aggregate(models.Avg('rating'))['rating__avg'], 1)
        return 0

    @property
    def review_count(self):
        return self.reviews.filter(is_active=True).count()


class ProductImage(models.Model):
    """Additional product images"""

    product = models.ForeignKey(
        Product,
        on_delete=models.CASCADE,
        related_name='images'
    )
    image = models.ImageField(upload_to='products/', verbose_name=_('Image'))
    alt_text = models.CharField(max_length=100, blank=True, verbose_name=_('Alt Text'))
    display_order = models.PositiveIntegerField(default=0, verbose_name=_('Display Order'))

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        app_label = 'products'
        verbose_name = _('Product Image')
        verbose_name_plural = _('Product Images')
        ordering = ['display_order']

    def __str__(self):
        return f"{self.product.name} - Image {self.display_order}"


class ProductVariant(models.Model):
    """Product variants (size, color, etc.)"""

    product = models.ForeignKey(
        Product,
        on_delete=models.CASCADE,
        related_name='variants'
    )

    # Variant details
    name = models.CharField(max_length=100, verbose_name=_('Variant Name'))
    sku = models.CharField(max_length=50, unique=True, blank=True, verbose_name=_('SKU'))

    # Pricing (can override parent product price)
    price = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        null=True,
        blank=True,
        validators=[MinValueValidator(0)],
        verbose_name=_('Price')
    )
    compare_price = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        null=True,
        blank=True,
        validators=[MinValueValidator(0)],
        verbose_name=_('Compare Price')
    )

    # Inventory
    stock_quantity = models.PositiveIntegerField(default=0, verbose_name=_('Stock Quantity'))

    # Variant image
    image = models.ImageField(
        upload_to='product_variants/',
        blank=True,
        null=True,
        verbose_name=_('Image')
    )

    # Status
    is_active = models.BooleanField(default=True, verbose_name=_('Is Active'))

    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        app_label = 'products'
        verbose_name = _('Product Variant')
        verbose_name_plural = _('Product Variants')
        unique_together = ['product', 'name']

    def __str__(self):
        return f"{self.product.name} - {self.name}"

    def save(self, *args, **kwargs):
        if not self.sku:
            # Generate variant SKU
            import uuid
            self.sku = f"VAR-{uuid.uuid4().hex[:8].upper()}"
        super().save(*args, **kwargs)

    @property
    def final_price(self):
        return self.price or self.product.price

    @property
    def is_in_stock(self):
        return self.stock_quantity > 0


class ProductAttribute(models.Model):
    """Product attributes (color, size, material, etc.)"""

    name = models.CharField(max_length=100, unique=True, verbose_name=_('Attribute Name'))
    display_name = models.CharField(max_length=100, verbose_name=_('Display Name'))

    # Attribute type
    ATTRIBUTE_TYPES = [
        ('text', _('Text')),
        ('color', _('Color')),
        ('size', _('Size')),
        ('material', _('Material')),
        ('style', _('Style')),
    ]

    attribute_type = models.CharField(
        max_length=20,
        choices=ATTRIBUTE_TYPES,
        default='text',
        verbose_name=_('Attribute Type')
    )

    # For color attributes
    color_value = models.CharField(max_length=7, blank=True, verbose_name=_('Color Value (Hex)'))

    # Status
    is_active = models.BooleanField(default=True, verbose_name=_('Is Active'))

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        app_label = 'products'
        verbose_name = _('Product Attribute')
        verbose_name_plural = _('Product Attributes')
        ordering = ['name']

    def __str__(self):
        return self.display_name


class ProductAttributeValue(models.Model):
    """Values for product attributes"""

    attribute = models.ForeignKey(
        ProductAttribute,
        on_delete=models.CASCADE,
        related_name='values'
    )
    product = models.ForeignKey(
        Product,
        on_delete=models.CASCADE,
        related_name='attribute_values'
    )

    value = models.CharField(max_length=100, verbose_name=_('Value'))

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        app_label = 'products'
        verbose_name = _('Product Attribute Value')
        verbose_name_plural = _('Product Attribute Values')
        unique_together = ['attribute', 'product', 'value']

    def __str__(self):
        return f"{self.product.name} - {self.attribute.display_name}: {self.value}"


class Review(models.Model):
    """Product reviews and ratings"""

    product = models.ForeignKey(
        Product,
        on_delete=models.CASCADE,
        related_name='reviews'
    )
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='reviews'
    )

    # Review content
    rating = models.PositiveIntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(5)],
        verbose_name=_('Rating')
    )
    title = models.CharField(max_length=100, verbose_name=_('Title'))
    comment = models.TextField(verbose_name=_('Comment'))

    # Review images
    images = models.JSONField(default=list, blank=True, verbose_name=_('Images'))

    # Review status
    is_active = models.BooleanField(default=True, verbose_name=_('Is Active'))
    is_verified_purchase = models.BooleanField(default=False, verbose_name=_('Verified Purchase'))

    # Moderation
    is_featured = models.BooleanField(default=False, verbose_name=_('Is Featured'))

    # Helpful votes
    helpful_votes = models.PositiveIntegerField(default=0, verbose_name=_('Helpful Votes'))

    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        app_label = 'products'
        verbose_name = _('Review')
        verbose_name_plural = _('Reviews')
        ordering = ['-created_at']
        unique_together = ['product', 'user']
        indexes = [
            models.Index(fields=['product', 'rating']),
            models.Index(fields=['user']),
            models.Index(fields=['is_active']),
        ]

    def __str__(self):
        return f"{self.user.email} - {self.product.name} - {self.rating}★"
