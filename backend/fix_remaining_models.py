import re
import os

def fix_models_file(file_path, app_name):
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        return
        
    print(f"Processing {file_path}...")
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Find all Meta classes that don't have app_label
    lines = content.split('\n')
    new_lines = []
    i = 0
    
    while i < len(lines):
        line = lines[i]
        new_lines.append(line)
        
        # Look for "class Meta:" lines
        if re.match(r'\s*class Meta:\s*$', line):
            # Check if the next few lines contain app_label
            has_app_label = False
            j = i + 1
            while j < len(lines) and j < i + 10:  # Look ahead max 10 lines
                if lines[j].strip() == '' or lines[j].startswith('    '):
                    if 'app_label' in lines[j]:
                        has_app_label = True
                        break
                    if lines[j].strip() and not lines[j].startswith('        '):
                        break  # End of Meta class
                    j += 1
                else:
                    break
            
            # If no app_label found, add it
            if not has_app_label:
                indent = len(line) - len(line.lstrip())
                app_label_line = ' ' * (indent + 4) + f"app_label = '{app_name}'"
                new_lines.append(app_label_line)
        
        i += 1
    
    # Write back to file
    new_content = '\n'.join(new_lines)
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print(f"Updated {file_path}")

# Fix all model files
apps = [
    ('products', 'products'),
    ('orders', 'orders'), 
    ('payments', 'payments')
]

base_path = r'D:\project\shop'

for app_dir, app_name in apps:
    models_file = os.path.join(base_path, app_dir, 'models.py')
    fix_models_file(models_file, app_name)

print("All done!")
