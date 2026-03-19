import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/drone_model.dart';
import 'booking_screen.dart';

class DroneDetailScreen extends StatefulWidget {
  final DroneModel drone;
  const DroneDetailScreen({super.key, required this.drone});

  @override
  State<DroneDetailScreen> createState() => _DroneDetailScreenState();
}

class _DroneDetailScreenState extends State<DroneDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _float;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _float = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.bgGradient),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    expandedHeight: 300,
                    pinned: true,
                    leading: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: AppColors.white, size: 18),
                      ),
                    ),
                    actions: [
                      GestureDetector(
                        onTap: () => setState(() => _isFavorite = !_isFavorite),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _isFavorite
                                ? AppColors.orange
                                : AppColors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.navyMid, AppColors.navyDark],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Background circles
                            Positioned(
                              top: -30,
                              right: -30,
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.skyBlue.withOpacity(0.08),
                                ),
                              ),
                            ),
                            Center(
                              child: AnimatedBuilder(
                                animation: _float,
                                builder: (context, child) =>
                                    Transform.translate(
                                  offset: Offset(0, _float.value),
                                  child: child,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 60),
                                    Text(
                                      widget.drone.imageEmoji,
                                      style: const TextStyle(fontSize: 100),
                                    ),
                                    Container(
                                      width: 120,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.3),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.drone.name,
                                        style: AppTextStyles.headingLarge),
                                    Text(widget.drone.brand,
                                        style: AppTextStyles.bodySecondary),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${widget.drone.pricePerDay.toInt()}',
                                    style: const TextStyle(
                                      color: AppColors.orange,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text('per day',
                                      style: AppTextStyles.bodySecondary),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Rating & location
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: AppColors.orange, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.drone.rating} (${widget.drone.reviewCount} reviews)',
                                style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 16),
                              const Icon(Icons.location_on_outlined,
                                  color: AppColors.textSecondary, size: 16),
                              const SizedBox(width: 4),
                              Text(widget.drone.location,
                                  style: AppTextStyles.bodySecondary),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Specs grid
                          Text('SPECIFICATIONS', style: AppTextStyles.label),
                          const SizedBox(height: 12),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: 2.5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            children: [
                              _SpecTile(
                                  icon: '⚡',
                                  label: 'Max Speed',
                                  value: '${widget.drone.maxSpeed} km/h'),
                              _SpecTile(
                                  icon: '🔋',
                                  label: 'Flight Time',
                                  value: '${widget.drone.flightTime} min'),
                              _SpecTile(
                                  icon: '📸',
                                  label: 'Camera',
                                  value: widget.drone.cameraRes),
                              _SpecTile(
                                  icon: '🏔️',
                                  label: 'Max Altitude',
                                  value: '${widget.drone.maxAltitude}m'),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Features
                          Text('FEATURES', style: AppTextStyles.label),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.drone.features
                                .map((f) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.cardBg,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: AppColors.skyBlue
                                                .withOpacity(0.3)),
                                      ),
                                      child: Text(
                                        '✓ $f',
                                        style: const TextStyle(
                                          color: AppColors.skyBlue,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 24),
                          // Description
                          Text('ABOUT THIS DRONE', style: AppTextStyles.label),
                          const SizedBox(height: 10),
                          Text(widget.drone.description,
                              style: AppTextStyles.bodySecondary
                                  .copyWith(height: 1.6)),
                          const SizedBox(height: 24),
                          // Seller info
                          Text('LISTED BY', style: AppTextStyles.label),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppColors.navyLight.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.navyGradient,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                      child: Text('🏪',
                                          style: TextStyle(fontSize: 22))),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.drone.sellerName,
                                        style: AppTextStyles.bodyLarge.copyWith(
                                            fontWeight: FontWeight.w600)),
                                    Text('Verified Seller • 4.8 ⭐',
                                        style: AppTextStyles.bodySecondary),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.navyLight.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('Chat',
                                      style: TextStyle(
                                          color: AppColors.skyBlue,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          border: Border(
              top: BorderSide(color: AppColors.navyLight.withOpacity(0.3))),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹${widget.drone.pricePerDay.toInt()}/day',
                  style: const TextStyle(
                      color: AppColors.orange,
                      fontSize: 20,
                      fontWeight: FontWeight.w800),
                ),
                Text('All inclusive',
                    style: AppTextStyles.bodySecondary.copyWith(fontSize: 11)),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (widget.drone.isAvailable) {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            BookingScreen(drone: widget.drone),
                        transitionsBuilder: (_, anim, __, child) =>
                            SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                              parent: anim, curve: Curves.easeOutCubic)),
                          child: child,
                        ),
                        transitionDuration: const Duration(milliseconds: 400),
                      ),
                    );
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: widget.drone.isAvailable
                        ? AppColors.orangeGradient
                        : null,
                    color: widget.drone.isAvailable
                        ? null
                        : AppColors.textSecondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: widget.drone.isAvailable
                        ? [
                            BoxShadow(
                                color: AppColors.orange.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4))
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      widget.drone.isAvailable
                          ? '🚀  Book Now'
                          : '❌  Not Available',
                      style: TextStyle(
                        color: widget.drone.isAvailable
                            ? AppColors.white
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecTile extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _SpecTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.navyLight.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label,
                    style: AppTextStyles.bodySecondary.copyWith(fontSize: 10)),
                Text(value,
                    style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
