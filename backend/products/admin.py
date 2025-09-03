from django.contrib import admin
from .models import Category, Brand, Product, Review, ProductVariant, ProductImage


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    """Category admin"""
    list_display = ('name', 'parent', 'display_order', 'is_active', 'created_at')
    list_filter = ('is_active', 'created_at')
    search_fields = ('name', 'description')
    ordering = ('display_order', 'name')
    prepopulated_fields = {'slug': ('name',)}


@admin.register(Brand)
class BrandAdmin(admin.ModelAdmin):
    """Brand admin"""
    list_display = ('name', 'website', 'is_active', 'created_at')
    list_filter = ('is_active', 'created_at')
    search_fields = ('name', 'description')
    ordering = ('name',)


class ProductImageInline(admin.TabularInline):
    """Product image inline"""
    model = ProductImage
    extra = 1


class VariantInline(admin.TabularInline):
    """Product variant inline"""
    model = ProductVariant
    extra = 0


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    """Product admin"""
    list_display = ('name', 'sku', 'price', 'stock_quantity', 'is_active', 'is_featured', 'average_rating')
    list_filter = ('is_active', 'is_featured', 'category', 'brand', 'created_at')
    search_fields = ('name', 'sku', 'description')
    ordering = ('-created_at',)
    prepopulated_fields = {'slug': ('name',)}
    inlines = [ProductImageInline, VariantInline]
    readonly_fields = ('review_count', 'created_at', 'updated_at')


@admin.register(Review)
class ReviewAdmin(admin.ModelAdmin):
    """Review admin"""
    list_display = ('product', 'user', 'rating', 'is_featured', 'created_at')
    list_filter = ('rating', 'is_featured', 'created_at')
    search_fields = ('product__name', 'user__email', 'title', 'comment')
    ordering = ('-created_at',)
    readonly_fields = ('created_at', 'updated_at')


@admin.register(ProductVariant)
class VariantAdmin(admin.ModelAdmin):
    """Variant admin"""
    list_display = ('product', 'name', 'sku', 'price', 'stock_quantity', 'is_active')
    list_filter = ('is_active', 'product__category', 'created_at')
    search_fields = ('product__name', 'name', 'sku')
    ordering = ('product', 'name')
    readonly_fields = ('created_at', 'updated_at')
