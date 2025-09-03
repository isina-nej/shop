#!/usr/bin/env python
"""Fix admin field references with correct model field names"""

import os

def replace_in_file(file_path, replacements):
    """Replace text in file"""
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        return
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    
    for old_text, new_text in replacements.items():
        content = content.replace(old_text, new_text)
    
    if content != original_content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated: {file_path}")
    else:
        print(f"No changes: {file_path}")

# Fix orders admin
orders_fixes = {
    "'type'": "'coupon_type'",
    "'expires_at'": "'valid_until'",
    "'valid_from'": "'valid_from'",  # This one is correct
}
replace_in_file('orders/admin.py', orders_fixes)

# Fix products admin - need to check actual fields
products_fixes = {
    "'sort_order'": "'display_order'",
    "'avg_rating'": "'rating'",  # Let's see if this works
    "'approved'": "'is_featured'",  # Reviews might use is_featured instead
}
replace_in_file('products/admin.py', products_fixes)

# Fix payments admin - need to check actual fields
payments_fixes = {
    "'reference_id'": "'transaction_id'",
    "'amount_currency'": "'currency'",
}
replace_in_file('payments/admin.py', payments_fixes)

print("Fixed admin field references!")
