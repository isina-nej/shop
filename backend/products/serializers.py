from rest_framework import serializers
from django.db.models import Avg
from .models import Category, Brand, Product, Review, ProductVariant


class CategorySerializer(serializers.ModelSerializer):
    """Category serializer"""
    product_count = serializers.SerializerMethodField()
    subcategories = serializers.SerializerMethodField()

    class Meta:
        model = Category
        fields = [
            'id', 'name', 'description', 'image', 'parent',
            'order', 'is_active', 'product_count', 'subcategories',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']

    def get_product_count(self, obj):
        return obj.products.count()

    def get_subcategories(self, obj):
        if obj.parent is None:
            return CategorySerializer(obj.children.all(), many=True).data
        return []


class BrandSerializer(serializers.ModelSerializer):
    """Brand serializer"""
    product_count = serializers.SerializerMethodField()

    class Meta:
        model = Brand
        fields = [
            'id', 'name', 'description', 'logo', 'website',
            'is_active', 'product_count', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']

    def get_product_count(self, obj):
        return obj.products.count()


class ProductImageSerializer(serializers.Serializer):
    """Product image serializer"""
    id = serializers.IntegerField()
    image = serializers.ImageField()
    alt_text = serializers.CharField()
    is_primary = serializers.BooleanField()
    order = serializers.IntegerField()


class ProductListSerializer(serializers.ModelSerializer):
    """Product list serializer"""
    category_name = serializers.CharField(source='category.name', read_only=True)
    brand_name = serializers.CharField(source='brand.name', read_only=True)
    primary_image = serializers.SerializerMethodField()
    review_count = serializers.SerializerMethodField()
    average_rating = serializers.SerializerMethodField()

    class Meta:
        model = Product
        fields = [
            'id', 'name', 'sku', 'price', 'sale_price', 'currency',
            'stock_quantity', 'is_in_stock', 'category_name', 'brand_name',
            'primary_image', 'rating', 'review_count', 'average_rating',
            'is_featured', 'is_active', 'created_at'
        ]

    def get_primary_image(self, obj):
        primary_image = obj.images.filter(is_primary=True).first()
        if primary_image:
            return ProductImageSerializer(primary_image).data
        return None

    def get_review_count(self, obj):
        return obj.reviews.filter(is_approved=True).count()

    def get_average_rating(self, obj):
        return obj.reviews.filter(is_approved=True).aggregate(
            Avg('rating')
        )['rating__avg'] or 0


class ProductSerializer(serializers.ModelSerializer):
    """Product detail serializer"""
    category = CategorySerializer(read_only=True)
    brand = BrandSerializer(read_only=True)
    images = ProductImageSerializer(many=True, read_only=True)
    variants = serializers.SerializerMethodField()
    reviews = serializers.SerializerMethodField()
    review_count = serializers.SerializerMethodField()
    average_rating = serializers.SerializerMethodField()

    class Meta:
        model = Product
        fields = [
            'id', 'name', 'description', 'sku', 'price', 'sale_price',
            'currency', 'stock_quantity', 'low_stock_threshold',
            'is_in_stock', 'is_featured', 'is_active', 'weight',
            'dimensions', 'category', 'brand', 'images', 'variants',
            'reviews', 'review_count', 'average_rating', 'tags',
            'seo_title', 'seo_description', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']

    def get_variants(self, obj):
        return VariantSerializer(obj.variants.all(), many=True).data

    def get_reviews(self, obj):
        return ReviewSerializer(obj.reviews.filter(is_approved=True), many=True).data

    def get_review_count(self, obj):
        return obj.reviews.filter(is_approved=True).count()

    def get_average_rating(self, obj):
        return obj.reviews.filter(is_approved=True).aggregate(
            Avg('rating')
        )['rating__avg'] or 0


class ReviewSerializer(serializers.ModelSerializer):
    """Review serializer"""
    user_name = serializers.CharField(source='user.get_full_name', read_only=True)
    product_name = serializers.CharField(source='product.name', read_only=True)

    class Meta:
        model = Review
        fields = [
            'id', 'user', 'user_name', 'product', 'product_name',
            'rating', 'title', 'comment', 'is_approved', 'is_featured',
            'helpful_votes', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'user', 'created_at', 'updated_at']


class VariantSerializer(serializers.ModelSerializer):
    """Product variant serializer"""
    product_name = serializers.CharField(source='product.name', read_only=True)

    class Meta:
        model = ProductVariant
        fields = [
            'id', 'product', 'product_name', 'sku', 'name',
            'size', 'color', 'material', 'price', 'sale_price',
            'stock_quantity', 'low_stock_threshold', 'is_active',
            'weight', 'dimensions', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']
