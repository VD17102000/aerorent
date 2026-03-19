import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/drone_model.dart';
import '../../screens/splash_screen.dart';
import 'drone_detail_screen.dart';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerFade;
  String _selectedCategory = 'All';
  int _selectedTab = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<DroneModel> get _filteredDrones {
    List<DroneModel> result = DroneData.drones;
    if (_selectedCategory != 'All') {
      result = result.where((d) => d.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      result = result
          .where(
            (d) =>
                d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                d.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                d.location.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.bgGradient),
        child: CustomPaint(
          painter: GridPatternPainter(),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildSearchBar(),
                _buildCategoryTabs(),
                Expanded(child: _buildDroneGrid()),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _headerFade,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover Drones 🚁',
                  style: AppTextStyles.headingLarge,
                ),
                Text(
                  '${_filteredDrones.length} drones near you',
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppColors.navyLight.withOpacity(0.3)),
                ),
                child: const Icon(Icons.notifications_outlined,
                    color: AppColors.white, size: 22),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                shape: BoxShape.circle,
              ),
              child: const Center(
                  child: Text('👤', style: TextStyle(fontSize: 18))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.navyLight.withOpacity(0.3)),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _searchQuery = v),
          style: const TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            hintText: 'Search drones, brands, locations...',
            hintStyle: AppTextStyles.bodySecondary,
            prefixIcon:
                const Icon(Icons.search, color: AppColors.textSecondary),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close,
                        color: AppColors.textSecondary, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.tune,
                        color: AppColors.orange, size: 18),
                  ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        itemCount: DroneData.categories.length,
        itemBuilder: (context, i) {
          final cat = DroneData.categories[i];
          final isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.orangeGradient : null,
                color: isSelected ? null : AppColors.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : AppColors.navyLight.withOpacity(0.3),
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDroneGrid() {
    final drones = _filteredDrones;
    if (drones.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔍', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text('No drones found', style: AppTextStyles.headingMedium),
            Text('Try a different category or location',
                style: AppTextStyles.bodySecondary),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: drones.length,
      itemBuilder: (context, i) => _DroneCard(drone: drones[i], index: i),
    );
  }

  Widget _buildBottomNav() {
    return Container(
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
              _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Explore',
                  isActive: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0)),
              _NavItem(
                  icon: Icons.favorite_outline_rounded,
                  label: 'Saved',
                  isActive: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1)),
              _NavItem(
                  icon: Icons.receipt_long_outlined,
                  label: 'Bookings',
                  isActive: _selectedTab == 2,
                  onTap: () => setState(() => _selectedTab = 2)),
              _NavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  isActive: _selectedTab == 3,
                  onTap: () => setState(() => _selectedTab = 3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.orange.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isActive ? AppColors.orange : AppColors.textSecondary,
                size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? AppColors.orange : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DroneCard extends StatefulWidget {
  final DroneModel drone;
  final int index;

  const _DroneCard({required this.drone, required this.index});

  @override
  State<_DroneCard> createState() => _DroneCardState();
}

class _DroneCardState extends State<_DroneCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  DroneDetailScreen(drone: widget.drone),
              transitionsBuilder: (_, anim, __, child) => SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(
                    CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                child: child,
              ),
              transitionDuration: const Duration(milliseconds: 400),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.navyLight.withOpacity(0.25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image area
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.navyMid,
                              AppColors.navyDark.withOpacity(0.5),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.drone.imageEmoji,
                                style: const TextStyle(fontSize: 52),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 60,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Availability badge
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.drone.isAvailable
                                ? Colors.green.withOpacity(0.9)
                                : Colors.red.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.drone.isAvailable
                                ? '● Available'
                                : '● Booked',
                            style: const TextStyle(
                                fontSize: 9,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      // Favorite button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _isFavorite = !_isFavorite),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _isFavorite
                                  ? AppColors.orange.withOpacity(0.9)
                                  : Colors.black.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Info area
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.drone.name,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.drone.brand,
                          style: AppTextStyles.bodySecondary
                              .copyWith(fontSize: 11),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.orange, size: 13),
                            const SizedBox(width: 2),
                            Text(
                              '${widget.drone.rating}',
                              style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              ' (${widget.drone.reviewCount})',
                              style: AppTextStyles.bodySecondary
                                  .copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹${widget.drone.pricePerDay.toInt()}',
                              style: const TextStyle(
                                color: AppColors.orange,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '/day',
                              style: AppTextStyles.bodySecondary
                                  .copyWith(fontSize: 10),
                            ),
                          ],
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
    );
  }
}
