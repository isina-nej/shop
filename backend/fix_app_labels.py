import re
import os

def add_app_label_to_models(app_path, app_name):
    models_file = os.path.join(app_path, 'models.py')
    
    if not os.path.exists(models_file):
        print(f"Models file not found: {models_file}")
        return
    
    with open(models_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Find all class Meta: patterns that don't already have app_label
    pattern = r'(\s+class Meta:\s*\n)((?:\s+[^a].*\n)*)'
    matches = re.findall(pattern, content)
    
    def replacement(match):
        meta_start = match.group(1)
        meta_content = match.group(2)
        
        # Check if app_label already exists
        if 'app_label' in meta_content:
            return match.group(0)
        
        # Add app_label as the first line after class Meta:
        return meta_start + f"        app_label = '{app_name}'\n" + meta_content
    
    # Apply the replacement
    new_content = re.sub(pattern, replacement, content)
    
    with open(models_file, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print(f"Updated {models_file}")

# Apply to all apps
apps = [
    ('accounts', 'accounts'),
    ('products', 'products'), 
    ('orders', 'orders'),
    ('payments', 'payments')
]

base_path = r'D:\project\shop'

for app_dir, app_name in apps:
    app_path = os.path.join(base_path, app_dir)
    add_app_label_to_models(app_path, app_name)
    
print("All done!")
