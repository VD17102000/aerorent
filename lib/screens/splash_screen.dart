import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'role_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _droneController;
  late AnimationController _fadeController;
  late AnimationController _waveController;
  late AnimationController _pulseController;

  late Animation<double> _droneFloat;
  late Animation<Offset> _droneSlide;
  late Animation<double> _fadeIn;
  late Animation<double> _waveFade;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _droneController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _droneFloat = Tween<double>(begin: 0, end: -15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _droneSlide = Tween<Offset>(
      begin: const Offset(0, -2),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _droneController, curve: Curves.elasticOut));

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _waveFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeOut),
    );

    _pulse = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _droneController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _waveController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _fadeController.forward();

    await Future.delayed(const Duration(milliseconds: 2800));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const RoleSelectionScreen(),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(
            opacity: anim,
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _droneController.dispose();
    _fadeController.dispose();
    _waveController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.bgGradient),
        child: Stack(
          children: [
            // Background grid pattern
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height),
              painter: GridPatternPainter(),
            ),
            // Glow effect
            Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.navyLight.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Drone icon with animations
                  AnimatedBuilder(
                    animation:
                        Listenable.merge([_droneController, _pulseController]),
                    builder: (context, child) {
                      return SlideTransition(
                        position: _droneSlide,
                        child: Transform.translate(
                          offset: Offset(0, _droneFloat.value),
                          child: Transform.scale(
                            scale: _pulse.value,
                            child: _buildDroneLogo(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  // Brand name
                  FadeTransition(
                    opacity: _fadeIn,
                    child: Column(
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Aero',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.white,
                                  letterSpacing: -1,
                                ),
                              ),
                              TextSpan(
                                text: 'Rent',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.orange,
                                  letterSpacing: -1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'DRONE RENTAL MARKETPLACE',
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.skyBlue,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Loading indicator
                  FadeTransition(
                    opacity: _waveFade,
                    child: _buildLoadingDots(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDroneLogo() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.navyMid, AppColors.navyDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.skyBlue.withOpacity(0.4),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
        border: Border.all(
          color: AppColors.skyBlue.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: const Center(
        child: Text('🚁', style: TextStyle(fontSize: 60)),
      ),
    );
  }

  Widget _buildLoadingDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _pulseController,
          builder: (context, _) {
            final delay = i * 0.3;
            final value = ((_pulseController.value + delay) % 1.0);
            final opacity =
                (value < 0.5 ? value * 2 : (1 - value) * 2).clamp(0.3, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.orange.withOpacity(opacity),
              ),
            );
          },
        );
      }),
    );
  }
}

class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.navyLight.withOpacity(0.05)
      ..strokeWidth = 1;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
