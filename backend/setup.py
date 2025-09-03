#!/usr/bin/env python
"""
Django Backend Setup and Deployment Script
"""

import os
import sys
import subprocess

def run_command(command, description):
    """Run a command and print its status"""
    print(f"\n🔄 {description}...")
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        print(f"✅ {description} completed successfully")
        if result.stdout:
            print(result.stdout)
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ {description} failed")
        print(f"Error: {e.stderr}")
        return False

def main():
    """Main setup function"""
    print("🚀 Django Backend Setup")
    print("=" * 50)
    
    # Check if we're in the right directory
    if not os.path.exists('manage.py'):
        print("❌ manage.py not found. Please run this script from the backend directory.")
        sys.exit(1)
    
    # Install dependencies
    if not run_command("pip install -r requirements.txt", "Installing Python dependencies"):
        sys.exit(1)
    
    # Run Django system check
    if not run_command("python manage.py check", "Running Django system check"):
        sys.exit(1)
    
    # Create and apply migrations
    if not run_command("python manage.py makemigrations", "Creating migrations"):
        print("⚠️  No new migrations needed")
    
    if not run_command("python manage.py migrate", "Applying migrations"):
        sys.exit(1)
    
    # Collect static files (for production)
    # run_command("python manage.py collectstatic --noinput", "Collecting static files")
    
    print("\n✅ Backend setup completed successfully!")
    print("\n📋 Next steps:")
    print("1. Create a superuser: python manage.py createsuperuser")
    print("2. Run the development server: python manage.py runserver")
    print("3. Access admin at: http://127.0.0.1:8000/admin/")
    print("4. Access API docs at: http://127.0.0.1:8000/swagger/")

if __name__ == "__main__":
    main()
