from django.db.models.signals import post_save, pre_save
from django.dispatch import receiver
from .models import Order, OrderItem


@receiver(pre_save, sender=Order)
def generate_order_number(sender, instance, **kwargs):
    """Generate order number if not provided"""
    if not instance.order_number:
        from django.utils import timezone
        import uuid
        timestamp = timezone.now().strftime('%Y%m%d')
        unique_id = str(uuid.uuid4())[:8].upper()
        instance.order_number = f"ORD-{timestamp}-{unique_id}"


@receiver(post_save, sender=OrderItem)
def update_order_totals(sender, instance, **kwargs):
    """Update order totals when order item is saved"""
    instance.order.calculate_totals()
