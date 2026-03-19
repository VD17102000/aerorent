import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/drone_model.dart';
import 'add_drone_screen.dart';

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  int _selectedTab = 0;

  // Seller's drones (first seller's drones as example)
  List<DroneModel> get _myDrones =>
      DroneData.drones.where((d) => d.sellerId == 's1').toList();

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _headerSlide =
        Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEarningsBanner(),
                      const SizedBox(height: 20),
                      _buildStatsRow(),
                      const SizedBox(height: 24),
                      _buildActiveBookings(),
                      const SizedBox(height: 24),
                      _buildMyListings(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const AddDroneScreen(),
            transitionsBuilder: (_, anim, __, child) => SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: anim, curve: Curves.easeOutCubic)),
              child: child,
            ),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        ),
        backgroundColor: AppColors.orange,
        label: const Text('Add Drone',
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          border: Border(
              top: BorderSide(color: AppColors.navyLight.withOpacity(0.3))),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SellerNavItem(
                    icon: Icons.dashboard_outlined,
                    label: 'Dashboard',
                    isActive: _selectedTab == 0,
                    onTap: () => setState(() => _selectedTab = 0)),
                _SellerNavItem(
                    icon: Icons.flight_outlined,
                    label: 'My Drones',
                    isActive: _selectedTab == 1,
                    onTap: () => setState(() => _selectedTab = 1)),
                _SellerNavItem(
                    icon: Icons.receipt_outlined,
                    label: 'Bookings',
                    isActive: _selectedTab == 2,
                    onTap: () => setState(() => _selectedTab = 2)),
                _SellerNavItem(
                    icon: Icons.analytics_outlined,
                    label: 'Analytics',
                    isActive: _selectedTab == 3,
                    onTap: () => setState(() => _selectedTab = 3)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SlideTransition(
      position: _headerSlide,
      child: FadeTransition(
        opacity: _headerFade,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withOpacity(0.5),
            border: Border(
                bottom:
                    BorderSide(color: AppColors.navyLight.withOpacity(0.2))),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.navyMid.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: AppColors.white, size: 16),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Seller Dashboard',
                        style: AppTextStyles.headingMedium),
                    Text('SkyView Rentals', style: AppTextStyles.bodySecondary),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppColors.navyGradient,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.skyBlue.withOpacity(0.4), width: 2),
                ),
                child: const Center(
                    child: Text('🏪', style: TextStyle(fontSize: 20))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEarningsBanner() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A2980), Color(0xFF26C6DA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: AppColors.skyBlue.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('This Month\'s Earnings',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 4),
                const Text('₹84,200',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _EarningBadge(
                        icon: '📈', label: '+23.4%', subtitle: 'vs last month'),
                    const SizedBox(width: 16),
                    _EarningBadge(
                        icon: '📦',
                        label: '12 Bookings',
                        subtitle: 'this month'),
                    const SizedBox(width: 16),
                    _EarningBadge(
                        icon: '⭐', label: '4.9 Rating', subtitle: 'average'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
            child: _StatCard(
                value: '${_myDrones.length}',
                label: 'Active\nListings',
                icon: '🚁',
                color: AppColors.skyBlue)),
        const SizedBox(width: 12),
        Expanded(
            child: _StatCard(
                value: '3',
                label: 'Active\nRentals',
                icon: '📦',
                color: AppColors.orange)),
        const SizedBox(width: 12),
        Expanded(
            child: _StatCard(
                value: '97%',
                label: 'Acceptance\nRate',
                icon: '✅',
                color: Colors.green)),
      ],
    );
  }

  Widget _buildActiveBookings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Active Bookings', style: AppTextStyles.headingMedium),
            Text('View all',
                style: AppTextStyles.bodySecondary
                    .copyWith(color: AppColors.skyBlue)),
          ],
        ),
        const SizedBox(height: 12),
        ...[
          (
            'Raj Patel',
            'Phantom Pro X',
            '19 Mar - 22 Mar',
            '₹7,497',
            Colors.green
          ),
          (
            'Priya Shah',
            'Inspire 3 Cinema',
            '20 Mar - 23 Mar',
            '₹17,997',
            AppColors.orange
          ),
        ].map((b) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: AppColors.navyLight.withOpacity(0.25)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: b.$5.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: Text(b.$1[0],
                            style: TextStyle(
                                color: b.$5,
                                fontWeight: FontWeight.w800,
                                fontSize: 18))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b.$1,
                            style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600)),
                        Text('${b.$2} • ${b.$3}',
                            style: AppTextStyles.bodySecondary
                                .copyWith(fontSize: 12)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(b.$4,
                          style: TextStyle(
                              color: b.$5, fontWeight: FontWeight.w700)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Active',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildMyListings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('My Drones', style: AppTextStyles.headingMedium),
            Text('${_myDrones.length} listings',
                style: AppTextStyles.bodySecondary),
          ],
        ),
        const SizedBox(height: 12),
        ..._myDrones.map((drone) => _SellerDroneItem(drone: drone)),
      ],
    );
  }
}

class _EarningBadge extends StatelessWidget {
  final String icon;
  final String label;
  final String subtitle;

  const _EarningBadge(
      {required this.icon, required this.label, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
          ],
        ),
        Text(subtitle,
            style: const TextStyle(color: Colors.white60, fontSize: 10)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String icon;
  final Color color;

  const _StatCard(
      {required this.value,
      required this.label,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 22, fontWeight: FontWeight.w800)),
          Text(label,
              style: AppTextStyles.bodySecondary
                  .copyWith(fontSize: 11, height: 1.3)),
        ],
      ),
    );
  }
}

class _SellerDroneItem extends StatelessWidget {
  final DroneModel drone;

  const _SellerDroneItem({required this.drone});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.navyLight.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: AppColors.navyGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
                child: Text(drone.imageEmoji,
                    style: const TextStyle(fontSize: 26))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(drone.name,
                    style: const TextStyle(
                        color: AppColors.white, fontWeight: FontWeight.w700)),
                Text('${drone.category} • ₹${drone.pricePerDay.toInt()}/day',
                    style: AppTextStyles.bodySecondary.copyWith(fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.orange, size: 13),
                    const SizedBox(width: 3),
                    Text('${drone.rating} (${drone.reviewCount})',
                        style: const TextStyle(
                            color: AppColors.white, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: drone.isAvailable
                      ? Colors.green.withOpacity(0.15)
                      : Colors.red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  drone.isAvailable ? 'Available' : 'Rented',
                  style: TextStyle(
                    color: drone.isAvailable ? Colors.green : Colors.redAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.edit_outlined,
                      color: AppColors.textSecondary, size: 16),
                  const SizedBox(width: 8),
                  const Icon(Icons.more_vert,
                      color: AppColors.textSecondary, size: 16),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SellerNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SellerNavItem(
      {required this.icon,
      required this.label,
      required this.isActive,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.skyBlue.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isActive ? AppColors.skyBlue : AppColors.textSecondary,
                size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? AppColors.skyBlue : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
