import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../screens/splash_screen.dart';
import 'buyer/buyer_home_screen.dart';
import 'seller/seller_home_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _cardController;
  late Animation<Offset> _titleSlide;
  late Animation<double> _cardFade;
  late Animation<Offset> _card1Slide;
  late Animation<Offset> _card2Slide;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _cardFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );

    _card1Slide = Tween<Offset>(
      begin: const Offset(-0.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut));

    _card2Slide = Tween<Offset>(
      begin: const Offset(0.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut));

    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Header
                SlideTransition(
                  position: _titleSlide,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.navyMid,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppColors.skyBlue.withOpacity(0.3)),
                            ),
                            child: const Text('🚁',
                                style: TextStyle(fontSize: 20)),
                          ),
                          const SizedBox(width: 12),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Aero',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Rent',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Welcome\nAboard! 👋',
                        style: AppTextStyles.displayLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Choose how you want to use AeroRent today',
                        style: AppTextStyles.bodySecondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                // Role Cards
                FadeTransition(
                  opacity: _cardFade,
                  child: Column(
                    children: [
                      SlideTransition(
                        position: _card1Slide,
                        child: _RoleCard(
                          icon: '🏪',
                          title: 'Drone Seller',
                          subtitle: 'List & manage your drones',
                          description:
                              'Earn money by renting out your drones to customers. Manage bookings, pricing & analytics.',
                          features: [
                            'List unlimited drones',
                            'Set your own pricing',
                            'Real-time bookings',
                            'Earnings dashboard'
                          ],
                          gradient: const LinearGradient(
                            colors: [AppColors.navyMid, Color(0xFF1E3F6F)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          accentColor: AppColors.skyBlue,
                          onTap: () =>
                              _navigateTo(context, const SellerHomeScreen()),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SlideTransition(
                        position: _card2Slide,
                        child: _RoleCard(
                          icon: '🎯',
                          title: 'Drone Renter',
                          subtitle: 'Discover & rent drones',
                          description:
                              'Browse hundreds of drones for photography, cinema, agriculture & more. Book instantly.',
                          features: [
                            'Browse all categories',
                            'Instant booking',
                            'GPS tracking',
                            'Verified sellers'
                          ],
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C2D12), Color(0xFF9A3412)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          accentColor: AppColors.orange,
                          onTap: () =>
                              _navigateTo(context, const BuyerHomeScreen()),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Trusted by 10,000+ users across India',
                    style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}

class _RoleCard extends StatefulWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String description;
  final List<String> features;
  final LinearGradient gradient;
  final Color accentColor;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.features,
    required this.gradient,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scale;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _pressController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _pressController.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _pressController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.accentColor.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.accentColor.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: widget.accentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: widget.accentColor.withOpacity(0.3)),
                      ),
                      child: Center(
                        child: Text(widget.icon,
                            style: const TextStyle(fontSize: 26)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: AppTextStyles.headingMedium,
                        ),
                        Text(
                          widget.subtitle,
                          style: AppTextStyles.bodySecondary
                              .copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_forward_ios,
                          color: widget.accentColor, size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(widget.description, style: AppTextStyles.bodySecondary),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.features
                      .map((f) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: widget.accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: widget.accentColor.withOpacity(0.25)),
                            ),
                            child: Text(
                              '✓ $f',
                              style: TextStyle(
                                fontSize: 11,
                                color: widget.accentColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
