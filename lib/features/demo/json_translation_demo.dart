import 'package:flutter/material.dart';
import '../../core/localization/localization_extension.dart';

/// نمونه صفحه که از سیستم ترجمه JSON استفاده می‌کند
class JsonTranslationDemo extends StatelessWidget {
  const JsonTranslationDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('app_name')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان صفحه
            Text(
              context.tr('welcome'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),

            const SizedBox(height: 20),

            // منوی اصلی
            _buildMenuCard(
              context,
              context.tr('home'),
              Icons.home,
              () => _showSnackbar(context, context.tr('home')),
            ),

            _buildMenuCard(
              context,
              context.tr('products'),
              Icons.shopping_bag,
              () => _showSnackbar(context, context.tr('products')),
            ),

            _buildMenuCard(
              context,
              context.tr('cart'),
              Icons.shopping_cart,
              () => _showSnackbar(context, context.tr('cart')),
            ),

            _buildMenuCard(
              context,
              context.tr('profile'),
              Icons.person,
              () => _showSnackbar(context, context.tr('profile')),
            ),

            const Spacer(),

            // دکمه‌های اکشن
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _showLoginDialog(context),
                  child: Text(context.tr('login')),
                ),

                OutlinedButton(
                  onPressed: () => _showRegisterDialog(context),
                  child: Text(context.tr('register')),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${context.tr('selected')}: $message'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('login')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: context.tr('email'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: context.tr('password'),
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackbar(context, context.tr('login'));
            },
            child: Text(context.tr('login')),
          ),
        ],
      ),
    );
  }

  void _showRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('register')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: context.tr('email'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: context.tr('password'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: context.tr('confirm_password'),
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackbar(context, context.tr('register'));
            },
            child: Text(context.tr('register')),
          ),
        ],
      ),
    );
  }
}
