// Home Page - Responsive E-commerce Homepage
import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/enhanced_home_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            // Enhanced modern content
            Expanded(child: const EnhancedHomeContent()),
          ],
        ),
      ),
      floatingActionButton: const HomeFloatingHub(),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: EnhancedHomeContent(),
        ),
      ),
      floatingActionButton: const HomeFloatingHub(),
    );
  }

  Future<void> _onRefresh() async {
    debugPrint('Home: Refreshing content...');
    // TODO: Implement refresh logic
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Home: Refresh completed');
  }
}
