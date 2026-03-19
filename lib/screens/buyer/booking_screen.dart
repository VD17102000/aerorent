import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/drone_model.dart';

class BookingScreen extends StatefulWidget {
  final DroneModel drone;
  const BookingScreen({super.key, required this.drone});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with TickerProviderStateMixin {
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 3));
  int _selectedInsurance = 0;
  bool _withPilot = false;
  bool _isBooking = false;
  bool _bookingSuccess = false;

  late AnimationController _successController;
  late Animation<double> _successScale;

  int get _days => _endDate.difference(_startDate).inDays + 1;
  double get _baseAmount => widget.drone.pricePerDay * _days;
  num get _insuranceAmount => _selectedInsurance == 0
      ? 0
      : (_selectedInsurance == 1 ? 299 : 599) * _days;
  num get _pilotAmount => _withPilot ? 1500 * _days : 0;
  double get _totalAmount => _baseAmount + _insuranceAmount + _pilotAmount;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _successScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _successController.dispose();
    super.dispose();
  }

  Future<void> _confirmBooking() async {
    setState(() => _isBooking = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isBooking = false;
      _bookingSuccess = true;
    });
    _successController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (_bookingSuccess) return _buildSuccessScreen();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: AppColors.white),
                    ),
                    const SizedBox(width: 16),
                    Text('Book Drone', style: AppTextStyles.headingMedium),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drone summary
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
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: AppColors.navyGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                  child: Text(widget.drone.imageEmoji,
                                      style: const TextStyle(fontSize: 30))),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.drone.name,
                                    style: AppTextStyles.bodyLarge
                                        .copyWith(fontWeight: FontWeight.w700)),
                                Text(widget.drone.brand,
                                    style: AppTextStyles.bodySecondary),
                                Text(
                                  '₹${widget.drone.pricePerDay.toInt()}/day',
                                  style: const TextStyle(
                                      color: AppColors.orange,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Date selection
                      Text('RENTAL PERIOD', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                              child: _DateSelector(
                            label: 'Start Date',
                            date: _startDate,
                            onTap: () async {
                              final d = await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                                builder: (context, child) => Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.dark(
                                        primary: AppColors.orange),
                                  ),
                                  child: child!,
                                ),
                              );
                              if (d != null) setState(() => _startDate = d);
                            },
                          )),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _DateSelector(
                            label: 'End Date',
                            date: _endDate,
                            onTap: () async {
                              final d = await showDatePicker(
                                context: context,
                                initialDate: _endDate,
                                firstDate: _startDate,
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                                builder: (context, child) => Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.dark(
                                        primary: AppColors.orange),
                                  ),
                                  child: child!,
                                ),
                              );
                              if (d != null) setState(() => _endDate = d);
                            },
                          )),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.info_outline,
                                color: AppColors.orange, size: 16),
                            const SizedBox(width: 8),
                            Text(
                                '$_days day rental • ₹${_baseAmount.toInt()} base price',
                                style: const TextStyle(
                                    color: AppColors.orange, fontSize: 13)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Insurance
                      Text('INSURANCE PLAN', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      ...[
                        'No Insurance',
                        'Basic (₹299/day)',
                        'Premium (₹599/day)'
                      ].asMap().entries.map(
                            (e) => GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedInsurance = e.key),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: _selectedInsurance == e.key
                                      ? AppColors.orange.withOpacity(0.15)
                                      : AppColors.cardBg,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _selectedInsurance == e.key
                                        ? AppColors.orange
                                        : AppColors.navyLight.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _selectedInsurance == e.key
                                            ? AppColors.orange
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: _selectedInsurance == e.key
                                              ? AppColors.orange
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                      child: _selectedInsurance == e.key
                                          ? const Icon(Icons.check,
                                              color: Colors.white, size: 12)
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      e.value,
                                      style: TextStyle(
                                        color: _selectedInsurance == e.key
                                            ? AppColors.orange
                                            : AppColors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      const SizedBox(height: 24),
                      // Pilot option
                      Text('ADD-ONS', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => setState(() => _withPilot = !_withPilot),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _withPilot
                                ? AppColors.skyBlue.withOpacity(0.1)
                                : AppColors.cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _withPilot
                                  ? AppColors.skyBlue
                                  : AppColors.navyLight.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Text('👨‍✈️',
                                  style: TextStyle(fontSize: 28)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Include Pilot',
                                        style: AppTextStyles.bodyLarge.copyWith(
                                            fontWeight: FontWeight.w600)),
                                    Text('Expert pilot included • ₹1,500/day',
                                        style: AppTextStyles.bodySecondary),
                                  ],
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: _withPilot
                                      ? AppColors.skyBlue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: _withPilot
                                          ? AppColors.skyBlue
                                          : AppColors.textSecondary),
                                ),
                                child: _withPilot
                                    ? const Icon(Icons.check,
                                        color: Colors.white, size: 16)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Price breakdown
                      Text('PRICE BREAKDOWN', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: AppColors.navyLight.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            _PriceRow(
                                label:
                                    '₹${widget.drone.pricePerDay.toInt()} × $_days days',
                                amount: _baseAmount),
                            if (_selectedInsurance > 0)
                              _PriceRow(
                                  label: 'Insurance', amount: _insuranceAmount),
                            if (_withPilot)
                              _PriceRow(
                                  label: 'Pilot fee', amount: _pilotAmount),
                            const Divider(
                                color: AppColors.navyLight, height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total',
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16)),
                                Text(
                                  '₹${_totalAmount.toInt()}',
                                  style: const TextStyle(
                                      color: AppColors.orange,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: GestureDetector(
                  onTap: _isBooking ? null : _confirmBooking,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.orange.withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6))
                      ],
                    ),
                    child: Center(
                      child: _isBooking
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5))
                          : Text('Confirm Booking • ₹${_totalAmount.toInt()}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16)),
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

  Widget _buildSuccessScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.bgGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _successScale,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.orange.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 10)
                    ],
                  ),
                  child: const Center(
                      child: Text('✅', style: TextStyle(fontSize: 52))),
                ),
              ),
              const SizedBox(height: 32),
              Text('Booking Confirmed!', style: AppTextStyles.headingLarge),
              const SizedBox(height: 8),
              Text('Your drone is ready for pickup',
                  style: AppTextStyles.bodySecondary),
              const SizedBox(height: 8),
              Text(
                  'Booking ID: #AR${DateTime.now().millisecondsSinceEpoch % 100000}',
                  style: const TextStyle(
                      color: AppColors.skyBlue, fontWeight: FontWeight.w600)),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text('Back to Home',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DateSelector(
      {required this.label, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.navyLight.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: AppTextStyles.bodySecondary.copyWith(fontSize: 11)),
            const SizedBox(height: 4),
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final num amount;

  const _PriceRow({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySecondary),
          Text('₹${amount.toInt()}',
              style: const TextStyle(
                  color: AppColors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
