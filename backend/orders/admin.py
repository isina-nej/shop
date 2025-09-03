from django.contrib import admin
from .models import Order, OrderItem, Cart, CartItem, Coupon, CouponUsage


class OrderItemInline(admin.TabularInline):
    """Order item inline"""
    model = OrderItem
    extra = 0
    readonly_fields = ('product', 'variant', 'quantity', 'unit_price', 'created_at')


@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    """Order admin"""
    list_display = ('order_number', 'user', 'status', 'status', 'total_amount', 'created_at')
    list_filter = ('status', 'status', 'created_at')
    search_fields = ('order_number', 'user__email', 'user__first_name', 'user__last_name')
    ordering = ('-created_at',)
    readonly_fields = ('order_number', 'subtotal', 'tax_amount', 'shipping_cost', 'discount_amount', 'total_amount', 'created_at', 'updated_at')
    inlines = [OrderItemInline]


@admin.register(OrderItem)
class OrderItemAdmin(admin.ModelAdmin):
    """Order item admin"""
    list_display = ('order', 'product', 'variant', 'quantity', 'unit_price', 'created_at')
    list_filter = ('created_at',)
    search_fields = ('order__order_number', 'product__name')
    readonly_fields = ('created_at',)


class CartItemInline(admin.TabularInline):
    """Cart item inline"""
    model = CartItem
    extra = 0


@admin.register(Cart)
class CartAdmin(admin.ModelAdmin):
    """Cart admin"""
    list_display = ('user', 'item_count', 'created_at', 'updated_at')
    search_fields = ('user__email', 'user__first_name', 'user__last_name')
    readonly_fields = ('created_at', 'updated_at')
    inlines = [CartItemInline]

    def item_count(self, obj):
        return obj.items.count()
    item_count.short_description = 'Items'


@admin.register(CartItem)
class CartItemAdmin(admin.ModelAdmin):
    """Cart item admin"""
    list_display = ('cart', 'product', 'variant', 'quantity', 'created_at')
    list_filter = ('created_at',)
    search_fields = ('cart__user__email', 'product__name')
    readonly_fields = ('created_at',)


@admin.register(Coupon)
class CouponAdmin(admin.ModelAdmin):
    """Coupon admin"""
    list_display = ('code', 'name', 'coupon_type', 'value', 'is_active', 'usage_count', 'valid_until')
    list_filter = ('coupon_type', 'is_active', 'valid_from', 'valid_until')
    search_fields = ('code', 'name', 'description')
    ordering = ('-created_at',)
    readonly_fields = ('usage_count', 'created_at', 'updated_at')


@admin.register(CouponUsage)
class CouponUsageAdmin(admin.ModelAdmin):
    """Coupon usage admin"""
    list_display = ('coupon', 'user', 'order', 'used_at')
    list_filter = ('used_at',)
    search_fields = ('coupon__code', 'user__email', 'order__order_number')
    readonly_fields = ('used_at',)
