import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String? _userName;
  String? _userEmail;
  bool _isLoading = true;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutQuad),
    );

    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        _userEmail = user.email;
        final response = await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();

        setState(() {
          _userName = response['name'] ?? user.email;
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _userName = Supabase.instance.client.auth.currentUser?.email;
        _userEmail = Supabase.instance.client.auth.currentUser?.email;
        _isLoading = false;
      });
    }
    _slideController.forward();
  }

  Future<void> _logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Logged out successfully'),
            backgroundColor: AppColors.successColor,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error logging out'),
            backgroundColor: AppColors.errorColor,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated background circles
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -80,
                left: -80,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.accentGradient.createShader(bounds),
                      child: Text(
                        'Welcome',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: AppColors.textWhite),
                      onPressed: _logout,
                      tooltip: 'Logout',
                    ),
                  ],
                ),
              ),
              // Main content
              _isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: AppColors.textWhite,
                            strokeWidth: 4,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading profile...',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.textWhite,
                                ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: SingleChildScrollView(
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Success Badge
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: AppColors.accentGradient,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.accentStart
                                            .withOpacity(0.4),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.check_circle,
                                    size: 80,
                                    color: AppColors.textWhite,
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Welcome Text
                                Text(
                                  'Welcome, $_userName! 🎉',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: AppColors.textWhite,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),

                                Text(
                                  'You are successfully logged in',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppColors.textWhite
                                            .withOpacity(0.8),
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 48),

                                // User Info Card
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: AppColors.textWhite.withOpacity(0.95),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 16,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Account Information',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                      ),
                                      const SizedBox(height: 20),
                                      _buildInfoRow(
                                        icon: Icons.person,
                                        label: 'Name',
                                        value: _userName ?? 'N/A',
                                      ),
                                      const SizedBox(height: 16),
                                      _buildInfoRow(
                                        icon: Icons.email,
                                        label: 'Email',
                                        value: _userEmail ?? 'N/A',
                                      ),
                                      const SizedBox(height: 16),
                                      _buildInfoRow(
                                        icon: Icons.verified_user,
                                        label: 'Status',
                                        value: 'Verified ✓',
                                        valueColor: AppColors.successColor,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 48),

                                // Logout Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: AppColors.buttonGradient,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryStart
                                              .withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: _logout,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                      ),
                                      child: const Text(
                                        'Logout',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textWhite,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryStart.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryStart,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? AppColors.textPrimary,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
