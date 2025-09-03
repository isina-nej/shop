from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Payment, Refund


@receiver(post_save, sender=Payment)
def update_order_payment_status(sender, instance, **kwargs):
    """Update order payment status when payment is saved"""
    if instance.status == 'completed':
        instance.order.payment_status = 'paid'
        instance.order.status = 'confirmed'
        instance.order.save()
    elif instance.status == 'failed':
        instance.order.payment_status = 'failed'
        instance.order.save()


@receiver(post_save, sender=Refund)
def update_payment_status_on_refund(sender, instance, **kwargs):
    """Update payment status when refund is processed"""
    if instance.status == 'completed':
        payment = instance.payment
        total_refunded = payment.refunds.filter(
            status='completed'
        ).aggregate(total=models.Sum('amount'))['total'] or 0

        if total_refunded >= payment.amount:
            payment.status = 'refunded'
            payment.save()
