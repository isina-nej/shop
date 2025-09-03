from rest_framework import viewsets, status, generics
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.filters import OrderingFilter
from django_filters.rest_framework import DjangoFilterBackend
from django.db.models import Q, Sum, F
from django.shortcuts import get_object_or_404
from django.utils import timezone
from decimal import Decimal
from .models import Order, OrderItem, Cart, CartItem, Coupon, CouponUsage
from . import serializers
from products.models import Product, ProductVariant


class OrderViewSet(viewsets.ModelViewSet):
    """Order management"""
    queryset = Order.objects.all()
    serializer_class = serializers.OrderSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['status', 'payment_status']
    ordering_fields = ['created_at', 'total_amount']
    ordering = ['-created_at']

    def get_queryset(self):
        if self.request.user.is_staff:
            return Order.objects.all()
        return Order.objects.filter(user=self.request.user)

    def get_serializer_class(self):
        if self.action == 'list':
            return serializers.OrderListSerializer
        return serializers.OrderSerializer

    @action(detail=True, methods=['post'])
    def cancel(self, request, pk=None):
        """Cancel order"""
        order = self.get_object()
        if order.user != request.user and not request.user.is_staff:
            return Response(
                {'error': 'Permission denied'},
                status=status.HTTP_403_FORBIDDEN
            )
        if order.status not in ['pending', 'confirmed']:
            return Response(
                {'error': 'Order cannot be cancelled'},
                status=status.HTTP_400_BAD_REQUEST
            )
        order.status = 'cancelled'
        order.save()
        return Response({'message': 'Order cancelled successfully'})

    @action(detail=True, methods=['post'])
    def update_status(self, request, pk=None):
        """Update order status (admin only)"""
        if not request.user.is_staff:
            return Response(
                {'error': 'Permission denied'},
                status=status.HTTP_403_FORBIDDEN
            )
        order = self.get_object()
        new_status = request.data.get('status')
        if new_status not in dict(Order.STATUS_CHOICES):
            return Response(
                {'error': 'Invalid status'},
                status=status.HTTP_400_BAD_REQUEST
            )
        order.status = new_status
        order.save()
        return Response({'message': f'Order status updated to {new_status}'})


class OrderItemViewSet(viewsets.ModelViewSet):
    """Order item management"""
    queryset = OrderItem.objects.all()
    serializer_class = serializers.OrderItemSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        if self.request.user.is_staff:
            return OrderItem.objects.all()
        return OrderItem.objects.filter(order__user=self.request.user)


class CartViewSet(viewsets.ModelViewSet):
    """Shopping cart management"""
    queryset = Cart.objects.all()
    serializer_class = serializers.CartSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Cart.objects.filter(user=self.request.user)

    def get_object(self):
        cart, created = Cart.objects.get_or_create(user=self.request.user)
        return cart

    @action(detail=True, methods=['post'])
    def add_item(self, request, pk=None):
        """Add item to cart"""
        cart = self.get_object()
        product_id = request.data.get('product_id')
        variant_id = request.data.get('variant_id')
        quantity = request.data.get('quantity', 1)

        try:
            product = Product.objects.get(id=product_id, is_active=True)
        except Product.DoesNotExist:
            return Response(
                {'error': 'Product not found'},
                status=status.HTTP_404_NOT_FOUND
            )

        variant = None
        if variant_id:
            try:
                variant = ProductVariant.objects.get(
                    id=variant_id,
                    product=product,
                    is_active=True
                )
            except ProductVariant.DoesNotExist:
                return Response(
                    {'error': 'Variant not found'},
                    status=status.HTTP_404_NOT_FOUND
                )

        # Check stock
        available_stock = variant.stock_quantity if variant else product.stock_quantity
        if quantity > available_stock:
            return Response(
                {'error': 'Insufficient stock'},
                status=status.HTTP_400_BAD_REQUEST
            )

        # Get or create cart item
        cart_item, created = CartItem.objects.get_or_create(
            cart=cart,
            product=product,
            variant=variant,
            defaults={'quantity': quantity}
        )

        if not created:
            cart_item.quantity += quantity
            cart_item.save()

        serializer = serializers.CartItemSerializer(cart_item)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    @action(detail=True, methods=['post'])
    def update_item(self, request, pk=None):
        """Update cart item quantity"""
        cart = self.get_object()
        item_id = request.data.get('item_id')
        quantity = request.data.get('quantity')

        try:
            item = CartItem.objects.get(id=item_id, cart=cart)
        except CartItem.DoesNotExist:
            return Response(
                {'error': 'Cart item not found'},
                status=status.HTTP_404_NOT_FOUND
            )

        if quantity <= 0:
            item.delete()
            return Response({'message': 'Item removed from cart'})

        # Check stock
        available_stock = (
            item.variant.stock_quantity if item.variant
            else item.product.stock_quantity
        )
        if quantity > available_stock:
            return Response(
                {'error': 'Insufficient stock'},
                status=status.HTTP_400_BAD_REQUEST
            )

        item.quantity = quantity
        item.save()

        serializer = serializers.CartItemSerializer(item)
        return Response(serializer.data)

    @action(detail=True, methods=['post'])
    def remove_item(self, request, pk=None):
        """Remove item from cart"""
        cart = self.get_object()
        item_id = request.data.get('item_id')

        try:
            item = CartItem.objects.get(id=item_id, cart=cart)
            item.delete()
            return Response({'message': 'Item removed from cart'})
        except CartItem.DoesNotExist:
            return Response(
                {'error': 'Cart item not found'},
                status=status.HTTP_404_NOT_FOUND
            )

    @action(detail=True, methods=['post'])
    def clear(self, request, pk=None):
        """Clear cart"""
        cart = self.get_object()
        cart.items.all().delete()
        return Response({'message': 'Cart cleared'})

    @action(detail=True, methods=['post'])
    def apply_coupon(self, request, pk=None):
        """Apply coupon to cart"""
        cart = self.get_object()
        coupon_code = request.data.get('coupon_code')

        try:
            coupon = Coupon.objects.get(
                code=coupon_code,
                is_active=True,
                start_date__lte=timezone.now(),
                end_date__gte=timezone.now()
            )
        except Coupon.DoesNotExist:
            return Response(
                {'error': 'Invalid coupon'},
                status=status.HTTP_400_BAD_REQUEST
            )

        # Check usage limit
        if coupon.usage_limit and coupon.times_used >= coupon.usage_limit:
            return Response(
                {'error': 'Coupon usage limit exceeded'},
                status=status.HTTP_400_BAD_REQUEST
            )

        # Check user usage
        if coupon.per_user_limit:
            user_usage = CouponUsage.objects.filter(
                coupon=coupon,
                user=request.user
            ).count()
            if user_usage >= coupon.per_user_limit:
                return Response(
                    {'error': 'Coupon per user limit exceeded'},
                    status=status.HTTP_400_BAD_REQUEST
                )

        cart.coupon = coupon
        cart.save()

        serializer = self.get_serializer(cart)
        return Response(serializer.data)


class CartItemViewSet(viewsets.ModelViewSet):
    """Cart item management"""
    queryset = CartItem.objects.all()
    serializer_class = serializers.CartItemSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return CartItem.objects.filter(cart__user=self.request.user)


class CouponViewSet(viewsets.ModelViewSet):
    """Coupon management"""
    queryset = Coupon.objects.all()
    serializer_class = serializers.CouponSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        if self.request.user.is_staff:
            return Coupon.objects.all()
        return Coupon.objects.filter(is_active=True)


class CheckoutView(generics.GenericAPIView):
    """Checkout process"""
    serializer_class = serializers.CheckoutSerializer
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            cart = Cart.objects.get(user=request.user)
            if not cart.items.exists():
                return Response(
                    {'error': 'Cart is empty'},
                    status=status.HTTP_400_BAD_REQUEST
                )

            # Create order
            order = Order.objects.create(
                user=request.user,
                shipping_address=serializer.validated_data['shipping_address'],
                billing_address=serializer.validated_data.get('billing_address'),
                coupon=cart.coupon
            )

            # Create order items
            for cart_item in cart.items.all():
                OrderItem.objects.create(
                    order=order,
                    product=cart_item.product,
                    variant=cart_item.variant,
                    quantity=cart_item.quantity,
                    price=cart_item.get_price()
                )

            # Update coupon usage
            if cart.coupon:
                CouponUsage.objects.create(
                    coupon=cart.coupon,
                    user=request.user,
                    order=order
                )
                cart.coupon.times_used += 1
                cart.coupon.save()

            # Clear cart
            cart.items.all().delete()
            cart.coupon = None
            cart.save()

            # Calculate totals
            order.calculate_totals()

            serializer = serializers.OrderSerializer(order)
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
