from rest_framework import viewsets, status, generics
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated
from rest_framework.filters import SearchFilter, OrderingFilter
from django_filters.rest_framework import DjangoFilterBackend
from django.db.models import Q, Avg, Count
from django.shortcuts import get_object_or_404
from .models import Category, Brand, Product, Review, ProductVariant as Variant
from . import serializers


class CategoryViewSet(viewsets.ModelViewSet):
    """Category management"""
    queryset = Category.objects.all()
    serializer_class = serializers.CategorySerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    filter_backends = [SearchFilter, OrderingFilter]
    search_fields = ['name', 'description']
    ordering_fields = ['name', 'created_at', 'order']
    ordering = ['order', 'name']

    @action(detail=True, methods=['get'])
    def products(self, request, pk=None):
        """Get products in category"""
        category = self.get_object()
        products = Product.objects.filter(
            Q(category=category) | Q(category__parent=category)
        ).distinct()
        serializer = serializers.ProductListSerializer(products, many=True)
        return Response(serializer.data)


class BrandViewSet(viewsets.ModelViewSet):
    """Brand management"""
    queryset = Brand.objects.all()
    serializer_class = serializers.BrandSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    filter_backends = [SearchFilter, OrderingFilter]
    search_fields = ['name', 'description']
    ordering_fields = ['name', 'created_at']
    ordering = ['name']

    @action(detail=True, methods=['get'])
    def products(self, request, pk=None):
        """Get products by brand"""
        brand = self.get_object()
        products = Product.objects.filter(brand=brand)
        serializer = serializers.ProductListSerializer(products, many=True)
        return Response(serializer.data)


class ProductViewSet(viewsets.ModelViewSet):
    """Product management"""
    queryset = Product.objects.all()
    serializer_class = serializers.ProductSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['category', 'brand', 'is_active', 'is_featured']
    search_fields = ['name', 'description', 'sku']
    ordering_fields = ['name', 'price', 'created_at', 'rating']
    ordering = ['-created_at']

    def get_serializer_class(self):
        if self.action == 'list':
            return serializers.ProductListSerializer
        return serializers.ProductSerializer

    def get_queryset(self):
        queryset = Product.objects.select_related(
            'category', 'brand'
        ).prefetch_related(
            'images', 'variants', 'reviews'
        ).filter(is_active=True)

        # Price range filter
        min_price = self.request.query_params.get('min_price')
        max_price = self.request.query_params.get('max_price')
        if min_price:
            queryset = queryset.filter(price__gte=min_price)
        if max_price:
            queryset = queryset.filter(price__lte=max_price)

        # Rating filter
        min_rating = self.request.query_params.get('min_rating')
        if min_rating:
            queryset = queryset.filter(rating__gte=min_rating)

        return queryset

    @action(detail=True, methods=['get'])
    def reviews(self, request, pk=None):
        """Get product reviews"""
        product = self.get_object()
        reviews = product.reviews.all()
        serializer = serializers.ReviewSerializer(reviews, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=['post'], permission_classes=[IsAuthenticated])
    def add_review(self, request, pk=None):
        """Add review to product"""
        product = self.get_object()
        serializer = serializers.ReviewSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=request.user, product=product)
            # Update product rating
            product.update_rating()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=True, methods=['get'])
    def variants(self, request, pk=None):
        """Get product variants"""
        product = self.get_object()
        variants = product.variants.all()
        serializer = serializers.VariantSerializer(variants, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def featured(self, request):
        """Get featured products"""
        products = Product.objects.filter(is_featured=True, is_active=True)
        serializer = serializers.ProductListSerializer(products, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def popular(self, request):
        """Get popular products"""
        products = Product.objects.filter(
            is_active=True
        ).annotate(
            review_count=Count('reviews')
        ).order_by('-review_count', '-rating')[:20]
        serializer = serializers.ProductListSerializer(products, many=True)
        return Response(serializer.data)


class ReviewViewSet(viewsets.ModelViewSet):
    """Review management"""
    queryset = Review.objects.all()
    serializer_class = serializers.ReviewSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['product', 'user', 'rating']
    ordering_fields = ['created_at', 'rating']
    ordering = ['-created_at']

    def get_queryset(self):
        if self.request.user.is_authenticated:
            return Review.objects.filter(
                Q(is_approved=True) | Q(user=self.request.user)
            )
        return Review.objects.filter(is_approved=True)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    @action(detail=True, methods=['post'], permission_classes=[IsAuthenticated])
    def approve(self, request, pk=None):
        """Approve review (admin only)"""
        if not request.user.is_staff:
            return Response(
                {'error': 'Permission denied'},
                status=status.HTTP_403_FORBIDDEN
            )
        review = self.get_object()
        review.is_approved = True
        review.save()
        return Response({'message': 'Review approved'})


class VariantViewSet(viewsets.ModelViewSet):
    """Product variant management"""
    queryset = Variant.objects.all()
    serializer_class = serializers.VariantSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['product', 'size', 'color', 'is_active']
    ordering_fields = ['price', 'stock_quantity']
    ordering = ['price']

    def get_queryset(self):
        return Variant.objects.filter(is_active=True)


class ProductSearchView(generics.ListAPIView):
    """Advanced product search"""
    serializer_class = serializers.ProductListSerializer
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    search_fields = ['name', 'description', 'sku', 'tags__name']
    ordering_fields = ['name', 'price', 'created_at', 'rating']
    ordering = ['-rating', '-created_at']

    def get_queryset(self):
        queryset = Product.objects.select_related(
            'category', 'brand'
        ).prefetch_related(
            'images', 'variants', 'reviews'
        ).filter(is_active=True)

        query = self.request.query_params.get('q')
        if query:
            queryset = queryset.filter(
                Q(name__icontains=query) |
                Q(description__icontains=query) |
                Q(sku__icontains=query) |
                Q(tags__name__icontains=query)
            ).distinct()

        return queryset
