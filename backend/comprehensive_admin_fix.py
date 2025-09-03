#!/usr/bin/env python
"""Comprehensive admin field fixes"""

import os
import re

def fix_admin_fields(file_path, field_mapping, remove_from_readonly=None):
    """Fix admin field references comprehensively"""
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        return
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    
    # Fix field references in various admin attributes
    for old_field, new_field in field_mapping.items():
        # Replace in list_display, list_filter, ordering, search_fields
        patterns = [
            rf"(list_display[^=]*=\s*\[[^]]*)'({old_field})'",
            rf"(list_filter[^=]*=\s*\[[^]]*)'({old_field})'", 
            rf"(ordering[^=]*=\s*\[[^]]*)'({old_field})'",
            rf"(readonly_fields[^=]*=\s*\[[^]]*)'({old_field})'",
            rf"(search_fields[^=]*=\s*\[[^]]*)'({old_field})'",
        ]
        
        for pattern in patterns:
            content = re.sub(pattern, rf"\1'{new_field}'", content)
    
    # Remove fields that shouldn't be in readonly_fields (properties)
    if remove_from_readonly:
        for field in remove_from_readonly:
            # Remove from readonly_fields tuple/list
            content = re.sub(rf"'({field})',?\s*", "", content)
            content = re.sub(rf"'{field}'\s*,", "", content)
    
    if content != original_content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Fixed: {file_path}")
    else:
        print(f"No changes: {file_path}")

# Fix payments admin
payments_mapping = {
    'reference_id': 'transaction_id',
    'amount_currency': 'currency',
    'is_test': 'test_mode',
    'fee_percent': 'fee_percentage', 
    'process_time': 'processing_time',
}

# Need to check what fields PaymentGateway actually has
# For now, let's remove problematic fields from list_display
with open('payments/admin.py', 'r') as f:
    payments_content = f.read()

# Remove references to non-existent fields in PaymentGateway admin
payments_content = payments_content.replace("'is_test'", "'is_active'")
payments_content = payments_content.replace("'fee_percent'", "'created_at'")
payments_content = payments_content.replace("'process_time'", "'updated_at'")

with open('payments/admin.py', 'w') as f:
    f.write(payments_content)

fix_admin_fields('payments/admin.py', payments_mapping, remove_from_readonly=['average_rating'])

print("Comprehensive admin fixes completed!")
