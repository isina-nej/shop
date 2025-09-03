# Shop Backend API

This is the Django REST Framework backend for the Shop application.

## Features

- **Django 5.2.5** with Django REST Framework
- **PostgreSQL** database (Neon)
- **Custom User Model** with extended profile
- **JWT Authentication** support
- **CORS** enabled for Flutter web frontend
- **Admin Interface** with full model management
- **API Documentation** with drf-yasg

## Apps Structure

### 1. Accounts (`accounts/`)
- Custom User model with email authentication
- User profiles with social media links
- Address management for shipping/billing
- User activity tracking

### 2. Products (`products/`)
- Product catalog with categories and brands
- Product variants and attributes
- Product images and reviews
- SEO-optimized fields

### 3. Orders (`orders/`)
- Shopping cart functionality
- Order management with status tracking
- Coupon and discount system
- Order items with pricing

### 4. Payments (`payments/`)
- Multiple payment gateway support
- Payment tracking and status management
- Refund processing
- Payment method configuration

## Database Configuration

Currently configured to use **Neon PostgreSQL**:
- Host: `ep-flat-mode-a9eqcfzb-pooler.gwc.azure.neon.tech`
- Database: `shop`
- SSL required

## Installation & Setup

1. **Install Dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Run Migrations:**
   ```bash
   python manage.py migrate
   ```

3. **Create Superuser:**
   ```bash
   python manage.py createsuperuser
   ```

4. **Run Development Server:**
   ```bash
   python manage.py runserver
   ```

## API Endpoints

- **Admin Interface:** `http://127.0.0.1:8000/admin/`
- **API Documentation:** `http://127.0.0.1:8000/swagger/`
- **API Root:** `http://127.0.0.1:8000/api/`

### Available API Endpoints:
- `/api/accounts/` - User management
- `/api/products/` - Product catalog
- `/api/orders/` - Order management
- `/api/payments/` - Payment processing

## Environment Variables

Create a `.env` file in the backend directory:
```env
SECRET_KEY=your-secret-key-here
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1

# Database
DATABASE_URL=postgresql://neondb_owner:password@host:5432/dbname

# CORS for Flutter
CORS_ALLOWED_ORIGINS=http://localhost:3000,https://your-flutter-domain.com
```

## Admin Users

Default superuser:
- Email: `admin@shop.com`
- Password: `admin123`

## Development Notes

- All models include proper `app_label` meta configurations
- Models use Persian/English translation support
- Comprehensive admin interface for all models
- REST API with proper serialization
- Proper error handling and validation

## Production Deployment

For production deployment:
1. Set `DEBUG=False`
2. Configure proper `ALLOWED_HOSTS`
3. Use environment variables for sensitive data
4. Set up proper static file serving
5. Use a production WSGI server (gunicorn)

## Support

This backend is designed to work seamlessly with the Flutter frontend application.
