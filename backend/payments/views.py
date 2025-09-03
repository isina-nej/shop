from rest_framework import viewsets, status, generics
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.filters import OrderingFilter
from django_filters.rest_framework import DjangoFilterBackend
from django.db.models import Q
from django.shortcuts import get_object_or_404
from django.utils import timezone
from decimal import Decimal
from .models import Payment, PaymentGateway, Refund
from . import serializers
from orders.models import Order


class PaymentViewSet(viewsets.ModelViewSet):
    """Payment management"""
    queryset = Payment.objects.all()
    serializer_class = serializers.PaymentSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['status', 'gateway', 'currency']
    ordering_fields = ['created_at', 'amount']
    ordering = ['-created_at']

    def get_queryset(self):
        if self.request.user.is_staff:
            return Payment.objects.all()
        return Payment.objects.filter(order__user=self.request.user)

    @action(detail=True, methods=['post'])
    def process(self, request, pk=None):
        """Process payment"""
        payment = self.get_object()
        if payment.status != 'pending':
            return Response(
                {'error': 'Payment already processed'},
                status=status.HTTP_400_BAD_REQUEST
            )

        # Here you would integrate with actual payment gateway
        # For now, we'll simulate payment processing
        success = self._process_payment_gateway(payment)

        if success:
            payment.status = 'completed'
            payment.processed_at = timezone.now()
            payment.save()

            # Update order status
            payment.order.status = 'confirmed'
            payment.order.payment_status = 'paid'
            payment.order.save()

            return Response({'message': 'Payment processed successfully'})
        else:
            payment.status = 'failed'
            payment.save()
            return Response(
                {'error': 'Payment processing failed'},
                status=status.HTTP_400_BAD_REQUEST
            )

    @action(detail=True, methods=['post'])
    def refund(self, request, pk=None):
        """Process refund"""
        payment = self.get_object()
        if payment.status != 'completed':
            return Response(
                {'error': 'Can only refund completed payments'},
                status=status.HTTP_400_BAD_REQUEST
            )

        amount = request.data.get('amount')
        if not amount:
            amount = payment.amount

        if Decimal(amount) > payment.amount:
            return Response(
                {'error': 'Refund amount cannot exceed payment amount'},
                status=status.HTTP_400_BAD_REQUEST
            )

        # Create refund record
        refund = Refund.objects.create(
            payment=payment,
            amount=Decimal(amount),
            reason=request.data.get('reason', ''),
            processed_by=request.user
        )

        # Process refund through gateway
        success = self._process_refund_gateway(refund)

        if success:
            refund.status = 'completed'
            refund.processed_at = timezone.now()
            refund.save()

            # Update payment status if full refund
            if refund.amount == payment.amount:
                payment.status = 'refunded'
                payment.save()

            return Response({'message': 'Refund processed successfully'})
        else:
            refund.status = 'failed'
            refund.save()
            return Response(
                {'error': 'Refund processing failed'},
                status=status.HTTP_400_BAD_REQUEST
            )

    def _process_payment_gateway(self, payment):
        """Simulate payment gateway processing"""
        # In real implementation, integrate with payment gateway API
        # For demo purposes, we'll assume success
        return True

    def _process_refund_gateway(self, refund):
        """Simulate refund processing"""
        # In real implementation, integrate with payment gateway API
        # For demo purposes, we'll assume success
        return True


class PaymentGatewayViewSet(viewsets.ModelViewSet):
    """Payment gateway management"""
    queryset = PaymentGateway.objects.all()
    serializer_class = serializers.PaymentGatewaySerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        if self.request.user.is_staff:
            return PaymentGateway.objects.all()
        return PaymentGateway.objects.filter(is_active=True)

    @action(detail=True, methods=['post'])
    def toggle_active(self, request, pk=None):
        """Toggle gateway active status"""
        if not request.user.is_staff:
            return Response(
                {'error': 'Permission denied'},
                status=status.HTTP_403_FORBIDDEN
            )
        gateway = self.get_object()
        gateway.is_active = not gateway.is_active
        gateway.save()
        return Response({
            'message': f'Gateway {"activated" if gateway.is_active else "deactivated"}'
        })


class RefundViewSet(viewsets.ModelViewSet):
    """Refund management"""
    queryset = Refund.objects.all()
    serializer_class = serializers.RefundSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['status', 'payment__gateway']
    ordering_fields = ['created_at', 'amount']
    ordering = ['-created_at']

    def get_queryset(self):
        if self.request.user.is_staff:
            return Refund.objects.all()
        return Refund.objects.filter(payment__order__user=self.request.user)


class PaymentIntentView(generics.GenericAPIView):
    """Create payment intent"""
    serializer_class = serializers.PaymentIntentSerializer
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            order_id = serializer.validated_data['order_id']
            gateway_id = serializer.validated_data['gateway_id']

            try:
                order = Order.objects.get(id=order_id, user=request.user)
            except Order.DoesNotExist:
                return Response(
                    {'error': 'Order not found'},
                    status=status.HTTP_404_NOT_FOUND
                )

            if order.payment_status == 'paid':
                return Response(
                    {'error': 'Order already paid'},
                    status=status.HTTP_400_BAD_REQUEST
                )

            try:
                gateway = PaymentGateway.objects.get(id=gateway_id, is_active=True)
            except PaymentGateway.DoesNotExist:
                return Response(
                    {'error': 'Payment gateway not found'},
                    status=status.HTTP_404_NOT_FOUND
                )

            # Create payment record
            payment = Payment.objects.create(
                order=order,
                gateway=gateway,
                amount=order.total_amount,
                currency=order.currency,
                status='pending'
            )

            # Create payment intent with gateway
            intent_data = self._create_payment_intent(payment, gateway)

            return Response({
                'payment_id': payment.id,
                'client_secret': intent_data.get('client_secret'),
                'intent_id': intent_data.get('intent_id'),
                'gateway_data': intent_data
            })

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def _create_payment_intent(self, payment, gateway):
        """Create payment intent with gateway"""
        # In real implementation, call gateway API
        # For demo purposes, return mock data
        return {
            'client_secret': f'pi_mock_{payment.id}',
            'intent_id': f'intent_{payment.id}',
            'amount': str(payment.amount),
            'currency': payment.currency
        }


class PaymentWebhookView(generics.GenericAPIView):
    """Handle payment webhooks"""
    permission_classes = []  # Allow unauthenticated access for webhooks

    def post(self, request, gateway_name, *args, **kwargs):
        # Verify webhook signature (implementation depends on gateway)
        payload = request.data

        # Process webhook based on gateway
        if gateway_name == 'stripe':
            return self._handle_stripe_webhook(payload)
        elif gateway_name == 'paypal':
            return self._handle_paypal_webhook(payload)
        else:
            return Response(
                {'error': 'Unknown gateway'},
                status=status.HTTP_400_BAD_REQUEST
            )

    def _handle_stripe_webhook(self, payload):
        """Handle Stripe webhook"""
        # Implement Stripe webhook handling
        return Response({'status': 'ok'})

    def _handle_paypal_webhook(self, payload):
        """Handle PayPal webhook"""
        # Implement PayPal webhook handling
        return Response({'status': 'ok'})


class PaymentMethodsView(generics.ListAPIView):
    """List available payment methods"""
    serializer_class = serializers.PaymentGatewaySerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return PaymentGateway.objects.filter(is_active=True)
