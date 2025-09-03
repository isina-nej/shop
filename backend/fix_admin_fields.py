#!/usr/bin/env python
"""Fix admin field references to match actual model fields"""

import os
import re

def fix_admin_file(file_path, field_fixes):
    """Fix field references in admin file"""
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        return
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    
    for old_field, new_field in field_fixes.items():
        # Fix in list_display, list_filter, readonly_fields, ordering
        content = re.sub(f"'{old_field}'", f"'{new_field}'", content)
        content = re.sub(f'"{old_field}"', f'"{new_field}"', content)
    
    if content != original_content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Fixed: {file_path}")
    else:
        print(f"No changes needed: {file_path}")

# Define field fixes for each admin file
admin_fixes = {
    'orders/admin.py': {
        'payment_status': 'status',
        'shipping_amount': 'shipping_cost',
        'price': 'unit_price',
        'times_used': 'usage_count',
        'discount_type': 'type',
        'discount_value': 'value',
        'end_date': 'expires_at',
        'start_date': 'valid_from',
    },
    'payments/admin.py': {
        'gateway': 'payment_method',
        'display_name': 'name',
        'test_mode': 'is_test',
        'fee_percentage': 'fee_percent',
        'processing_time': 'process_time',
        'transaction_id': 'reference_id',
        'currency': 'amount_currency',
    },
    'products/admin.py': {
        'order': 'sort_order',
        'rating': 'avg_rating',
        'is_approved': 'approved',
    },
}

# Apply fixes
for admin_file, fixes in admin_fixes.items():
    fix_admin_file(admin_file, fixes)

print("Admin field fixes applied!")
