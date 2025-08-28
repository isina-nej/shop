import 'package:flutter/material.dart';
import '../../core/localization/localization_extension.dart';

/// صفحه تست ترجمه‌ها
class TranslationTestPage extends StatefulWidget {
  const TranslationTestPage({super.key});

  @override
  State<TranslationTestPage> createState() => _TranslationTestPageState();
}

class _TranslationTestPageState extends State<TranslationTestPage> {
  String translatedText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('app_name'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Translation Test',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),

            // تست ترجمه‌های مختلف
            _buildTestRow('app_name', context.tr('app_name')),
            _buildTestRow('welcome', context.tr('welcome')),
            _buildTestRow('login', context.tr('login')),
            _buildTestRow('home', context.tr('home')),
            _buildTestRow('products', context.tr('products')),
            _buildTestRow('cart', context.tr('cart')),
            _buildTestRow('profile', context.tr('profile')),

            const SizedBox(height: 20),

            // تست ترجمه async
            ElevatedButton(
              onPressed: () async {
                final translated = await context.trAsync('loading');
                setState(() {
                  translatedText = translated;
                });
              },
              child: const Text('Test Async Translation'),
            ),

            if (translatedText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Async Result: $translatedText',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestRow(String key, String translation) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$key:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              translation,
              style: TextStyle(
                color: translation == key ? Colors.red : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
