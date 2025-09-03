from django.db.models.signals import post_save, pre_save
from django.dispatch import receiver
from .models import Product, Review


@receiver(post_save, sender=Review)
def update_product_rating(sender, instance, **kwargs):
    """Update product rating when review is saved"""
    if instance.is_approved:
        instance.product.update_rating()


@receiver(pre_save, sender=Product)
def generate_sku(sender, instance, **kwargs):
    """Generate SKU if not provided"""
    if not instance.sku:
        # Generate SKU based on category and product ID
        if instance.category:
            prefix = instance.category.name[:3].upper()
        else:
            prefix = 'PRD'
        instance.sku = f"{prefix}-{instance.id or 'NEW'}"
