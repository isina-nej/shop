#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script to find hardcoded text in Flutter/Dart files
"""

import os
import re
import json
import sys
from pathlib import Path

# Set UTF-8 encoding for stdout
sys.stdout.reconfigure(encoding='utf-8')

def load_translation_keys():
    """Load translation keys from JSON files"""
    keys = set()

    # Load English translations
    try:
        with open('assets/translations/en.json', 'r', encoding='utf-8') as f:
            en_data = json.load(f)
            keys.update(en_data.keys())
    except Exception as e:
        print(f"Error loading English translations: {e}")

    # Load Persian translations
    try:
        with open('assets/translations/fa.json', 'r', encoding='utf-8') as f:
            fa_data = json.load(f)
            keys.update(fa_data.keys())
    except Exception as e:
        print(f"Error loading Persian translations: {e}")

    return keys

def find_hardcoded_text_in_file(file_path, translation_keys):
    """Find hardcoded text in a single file"""
    hardcoded_texts = []

    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        # Find Text() widgets with string literals
        text_pattern = r'Text\(\s*[\'"]([^\'"]+)[\'"]'
        matches = re.findall(text_pattern, content)

        for match in matches:
            # Skip if it's a translation key (contains only letters, numbers, underscores)
            if re.match(r'^[a-zA-Z0-9_]+$', match):
                if match not in translation_keys:
                    hardcoded_texts.append(match)
            # Persian text
            elif re.search(r'[آ-ی]', match):
                hardcoded_texts.append(match)
            # English text longer than 2 words (likely UI text)
            elif len(match.split()) > 2:
                hardcoded_texts.append(match)

        # Find other string literals that might be UI text
        string_pattern = r'[\'"]([^\'"]{10,})[\'"]'  # Strings longer than 10 characters
        all_strings = re.findall(string_pattern, content)

        for string_match in all_strings:
            # Skip if it's a translation key
            if re.match(r'^[a-zA-Z0-9_]+$', string_match):
                if string_match not in translation_keys:
                    # Check if it's used in UI context
                    if is_ui_context(content, string_match):
                        hardcoded_texts.append(string_match)
            # Persian text
            elif re.search(r'[آ-ی]', string_match):
                if is_ui_context(content, string_match):
                    hardcoded_texts.append(string_match)
            # English text that looks like UI text
            elif re.search(r'[A-Z][a-z]+ [a-z]+', string_match):  # Title case words
                if is_ui_context(content, string_match):
                    hardcoded_texts.append(string_match)

    except Exception as e:
        print(f"Error processing {file_path}: {e}")

    return list(set(hardcoded_texts))  # Remove duplicates

def is_ui_context(content, text):
    """Check if text is used in UI context"""
    ui_indicators = [
        'Text(', 'title:', 'label:', 'hintText:', 'errorText:',
        'SnackBar(', 'AlertDialog(', 'showDialog(', 'TextButton(',
        'ElevatedButton(', 'OutlinedButton(', 'appBar:', 'AppBar('
    ]

    # Check if the text appears near UI components
    for indicator in ui_indicators:
        if indicator in content:
            # Get context around the text
            start = content.find(text) - 100
            end = content.find(text) + len(text) + 100
            context = content[max(0, start):min(len(content), end)]

            if any(indicator in context for indicator in ui_indicators):
                return True

    return False

def scan_directory(directory, translation_keys):
    """Scan directory for Dart files with hardcoded text"""
    results = {}

    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                hardcoded_texts = find_hardcoded_text_in_file(file_path, translation_keys)

                if hardcoded_texts:
                    results[file_path] = hardcoded_texts

    return results

def main():
    print("Searching for hardcoded text in Flutter/Dart files...")
    print("=" * 60)

    # Load translation keys
    translation_keys = load_translation_keys()
    print(f"Loaded {len(translation_keys)} translation keys")

    # Scan lib directory
    results = scan_directory('lib', translation_keys)

    if not results:
        print("✅ No hardcoded text found!")
        return

    # Display results
    total_files = len(results)
    total_texts = sum(len(texts) for texts in results.values())

    print(f"\nFound hardcoded text in {total_files} files ({total_texts} instances)")
    print("=" * 60)

    for file_path, texts in results.items():
        print(f"\n{file_path}:")
        for text in texts:
            print(f"   • '{text}'")

    print(f"\n{'=' * 60}")
    print("Tip: Move these texts to translation files and use context.tr('key')")

if __name__ == "__main__":
    main()
