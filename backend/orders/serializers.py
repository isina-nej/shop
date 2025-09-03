from rest_framework import serializers
from django.utils import timezone
from decimal import Decimal
from .models import Order, OrderItem, Cart, CartItem, Coupon, CouponUsage
from django.contrib.auth import get_user_model
from accounts.models import Address
from products.models import Product, ProductVariant

User = get_user_model()


class OrderItemSerializer(serializers.ModelSerializer):
    """Order item serializer"""
    product_name = serializers.CharField(source='product.name', read_only=True)
    variant_name = serializers.CharField(source='variant.name', read_only=True)
    product_image = serializers.SerializerMethodField()
    total_price = serializers.SerializerMethodField()

    class Meta:
        model = OrderItem
        fields = [
            'id', 'product', 'product_name', 'variant', 'variant_name',
            'quantity', 'price', 'total_price', 'product_image',
            'created_at'
        ]
        read_only_fields = ['id', 'created_at']

    def get_product_image(self, obj):
        primary_image = obj.product.images.filter(is_primary=True).first()
        if primary_image:
            return primary_image.image.url
        return None

    def get_total_price(self, obj):
        return obj.quantity * obj.price


class OrderListSerializer(serializers.ModelSerializer):
    """Order list serializer"""
    item_count = serializers.SerializerMethodField()
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    payment_status_display = serializers.CharField(source='get_payment_status_display', read_only=True)

    class Meta:
        model = Order
        fields = [
            'id', 'order_number', 'status', 'status_display',
            'payment_status', 'payment_status_display', 'total_amount',
            'item_count', 'created_at', 'updated_at'
        ]

    def get_item_count(self, obj):
        return obj.items.count()


class OrderSerializer(serializers.ModelSerializer):
    """Order detail serializer"""
    items = OrderItemSerializer(many=True, read_only=True)
    shipping_address_details = serializers.SerializerMethodField()
    billing_address_details = serializers.SerializerMethodField()
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    payment_status_display = serializers.CharField(source='get_payment_status_display', read_only=True)
    item_count = serializers.SerializerMethodField()

    class Meta:
        model = Order
        fields = [
            'id', 'order_number', 'user', 'status', 'status_display',
            'payment_status', 'payment_status_display', 'subtotal',
            'tax_amount', 'shipping_amount', 'discount_amount',
            'total_amount', 'currency', 'shipping_address',
            'shipping_address_details', 'billing_address',
            'billing_address_details', 'coupon', 'notes',
            'items', 'item_count', 'created_at', 'updated_at'
        ]
        read_only_fields = [
            'id', 'order_number', 'user', 'created_at', 'updated_at'
        ]

    def get_shipping_address_details(self, obj):
        if obj.shipping_address:
            return {
                'title': obj.shipping_address.title,
                'first_name': obj.shipping_address.first_name,
                'last_name': obj.shipping_address.last_name,
                'address_line_1': obj.shipping_address.address_line_1,
                'address_line_2': obj.shipping_address.address_line_2,
                'city': obj.shipping_address.city,
                'state': obj.shipping_address.state,
                'postal_code': obj.shipping_address.postal_code,
                'country': obj.shipping_address.country,
                'phone_number': obj.shipping_address.phone_number,
            }
        return None

    def get_billing_address_details(self, obj):
        if obj.billing_address:
            return {
                'title': obj.billing_address.title,
                'first_name': obj.billing_address.first_name,
                'last_name': obj.billing_address.last_name,
                'address_line_1': obj.billing_address.address_line_1,
                'address_line_2': obj.billing_address.address_line_2,
                'city': obj.billing_address.city,
                'state': obj.billing_address.state,
                'postal_code': obj.billing_address.postal_code,
                'country': obj.billing_address.country,
                'phone_number': obj.billing_address.phone_number,
            }
        return None

    def get_item_count(self, obj):
        return obj.items.count()


class CartItemSerializer(serializers.ModelSerializer):
    """Cart item serializer"""
    product_name = serializers.CharField(source='product.name', read_only=True)
    variant_name = serializers.CharField(source='variant.name', read_only=True)
    product_image = serializers.SerializerMethodField()
    unit_price = serializers.SerializerMethodField()
    total_price = serializers.SerializerMethodField()
    stock_available = serializers.SerializerMethodField()

    class Meta:
        model = CartItem
        fields = [
            'id', 'product', 'product_name', 'variant', 'variant_name',
            'quantity', 'unit_price', 'total_price', 'product_image',
            'stock_available', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']

    def get_product_image(self, obj):
        primary_image = obj.product.images.filter(is_primary=True).first()
        if primary_image:
            return primary_image.image.url
        return None

    def get_unit_price(self, obj):
        return obj.get_price()

    def get_total_price(self, obj):
        return obj.get_total_price()

    def get_stock_available(self, obj):
        if obj.variant:
            return obj.variant.stock_quantity
        return obj.product.stock_quantity


class CartSerializer(serializers.ModelSerializer):
    """Cart serializer"""
    items = CartItemSerializer(many=True, read_only=True)
    item_count = serializers.SerializerMethodField()
    subtotal = serializers.SerializerMethodField()
    discount = serializers.SerializerMethodField()
    total = serializers.SerializerMethodField()

    class Meta:
        model = Cart
        fields = [
            'id', 'user', 'items', 'item_count', 'coupon',
            'subtotal', 'discount', 'total', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'user', 'created_at', 'updated_at']

    def get_item_count(self, obj):
        return obj.items.count()

    def get_subtotal(self, obj):
        return sum(item.get_total_price() for item in obj.items.all())

    def get_discount(self, obj):
        if obj.coupon:
            subtotal = self.get_subtotal(obj)
            if obj.coupon.discount_type == 'percentage':
                return subtotal * (obj.coupon.discount_value / 100)
            else:
                return min(obj.coupon.discount_value, subtotal)
        return Decimal('0.00')

    def get_total(self, obj):
        return self.get_subtotal(obj) - self.get_discount(obj)


class CouponSerializer(serializers.ModelSerializer):
    """Coupon serializer"""
    discount_display = serializers.SerializerMethodField()
    is_valid = serializers.SerializerMethodField()

    class Meta:
        model = Coupon
        fields = [
            'id', 'code', 'name', 'description', 'discount_type',
            'discount_value', 'discount_display', 'minimum_amount',
            'maximum_discount', 'usage_limit', 'per_user_limit',
            'start_date', 'end_date', 'is_active', 'is_valid',
            'times_used', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'times_used', 'created_at', 'updated_at']

    def get_discount_display(self, obj):
        if obj.discount_type == 'percentage':
            return f'{obj.discount_value}%'
        else:
            return f'${obj.discount_value}'

    def get_is_valid(self, obj):
        now = timezone.now()
        return (
            obj.is_active and
            obj.start_date <= now <= obj.end_date and
            (not obj.usage_limit or obj.times_used < obj.usage_limit)
        )


class CouponUsageSerializer(serializers.ModelSerializer):
    """Coupon usage serializer"""

    class Meta:
        model = CouponUsage
        fields = [
            'id', 'coupon', 'user', 'order', 'used_at'
        ]
        read_only_fields = ['id', 'used_at']


class CheckoutSerializer(serializers.Serializer):
    """Checkout serializer"""
    shipping_address_id = serializers.IntegerField()
    billing_address_id = serializers.IntegerField(required=False)
    notes = serializers.CharField(required=False, allow_blank=True)

    def validate_shipping_address_id(self, value):
        try:
            address = Address.objects.get(
                id=value,
                user=self.context['request'].user
            )
            return address
        except Address.DoesNotExist:
            raise serializers.ValidationError('Invalid shipping address')

    def validate_billing_address_id(self, value):
        if value:
            try:
                address = Address.objects.get(
                    id=value,
                    user=self.context['request'].user
                )
                return address
            except Address.DoesNotExist:
                raise serializers.ValidationError('Invalid billing address')
        return None
