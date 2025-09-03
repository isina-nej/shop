#!/usr/bin/env python
"""Final fix for admin field references"""

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

# Fix products admin - use property names and remove from readonly_fields
products_fixes = {
    "'rating'": "'average_rating'",
    "readonly_fields = ('average_rating'": "readonly_fields = ('review_count'",  # Remove property from readonly
    "'approved'": "'is_featured'",
}
replace_in_file('products/admin.py', products_fixes)

print("Final admin fixes applied!")
