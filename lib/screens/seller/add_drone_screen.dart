import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AddDroneScreen extends StatefulWidget {
  const AddDroneScreen({super.key});

  @override
  State<AddDroneScreen> createState() => _AddDroneScreenState();
}

class _AddDroneScreenState extends State<AddDroneScreen>
    with TickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = 'Photography';
  bool _isSaving = false;
  bool _saved = false;

  late AnimationController _successController;
  late Animation<double> _successScale;

  final List<String> _categories = [
    'Photography',
    'Cinema',
    'Racing',
    'Agriculture',
    'Travel',
    'Beginner'
  ];
  final List<String> _selectedFeatures = [];
  final List<String> _availableFeatures = [
    '4K Camera',
    'GPS',
    '3-Axis Gimbal',
    'Obstacle Avoidance',
    'Night Vision',
    'FPV Goggles',
    'Auto Return',
    'Wind Resistance'
  ];

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
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _successController.dispose();
    super.dispose();
  }

  Future<void> _saveDrone() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all required fields'),
            backgroundColor: Colors.red),
      );
      return;
    }
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isSaving = false;
      _saved = true;
    });
    _successController.forward();
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: AppColors.white),
                    ),
                    const SizedBox(width: 16),
                    Text('List New Drone', style: AppTextStyles.headingMedium),
                    const Spacer(),
                    if (_saved)
                      ScaleTransition(
                        scale: _successScale,
                        child: const Icon(Icons.check_circle,
                            color: Colors.green, size: 28),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Upload image placeholder
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.orange.withOpacity(0.4),
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: AppColors.orange.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                    Icons.add_photo_alternate_outlined,
                                    color: AppColors.orange,
                                    size: 28),
                              ),
                              const SizedBox(height: 8),
                              const Text('Upload Drone Photos',
                                  style: TextStyle(
                                      color: AppColors.orange,
                                      fontWeight: FontWeight.w600)),
                              Text('Add up to 5 photos',
                                  style: AppTextStyles.bodySecondary
                                      .copyWith(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('BASIC INFORMATION', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      _InputField(
                          controller: _nameController,
                          label: 'Drone Name *',
                          hint: 'e.g. DJI Phantom Pro X'),
                      const SizedBox(height: 12),
                      _InputField(
                          controller: _brandController,
                          label: 'Brand *',
                          hint: 'e.g. DJI, Autel, Parrot'),
                      const SizedBox(height: 12),
                      // Category picker
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.navyLight.withOpacity(0.3)),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          isExpanded: true,
                          underline: const SizedBox(),
                          dropdownColor: AppColors.cardBg2,
                          style: const TextStyle(color: AppColors.white),
                          hint: Text('Category',
                              style: AppTextStyles.bodySecondary),
                          items: _categories
                              .map((c) =>
                                  DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedCategory = v!),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('PRICING', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.navyLight.withOpacity(0.3)),
                        ),
                        child: TextField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            prefixText: '₹ ',
                            prefixStyle: const TextStyle(
                                color: AppColors.orange,
                                fontSize: 28,
                                fontWeight: FontWeight.w700),
                            suffixText: '/day',
                            suffixStyle: AppTextStyles.bodySecondary,
                            hintText: '0',
                            hintStyle: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 28),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('FEATURES', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _availableFeatures.map((f) {
                          final isSelected = _selectedFeatures.contains(f);
                          return GestureDetector(
                            onTap: () => setState(() {
                              if (isSelected)
                                _selectedFeatures.remove(f);
                              else
                                _selectedFeatures.add(f);
                            }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.orange.withOpacity(0.2)
                                    : AppColors.cardBg,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.orange
                                      : AppColors.navyLight.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                '${isSelected ? '✓ ' : '+ '}$f',
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.orange
                                      : AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      Text('DESCRIPTION', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.navyLight.withOpacity(0.3)),
                        ),
                        child: TextField(
                          controller: _descController,
                          maxLines: 4,
                          style: const TextStyle(color: AppColors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            hintText:
                                'Describe your drone, its condition, and any special features...',
                            hintStyle: AppTextStyles.bodySecondary,
                          ),
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
                  onTap: _isSaving ? null : _saveDrone,
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
                      child: _isSaving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5))
                          : const Text('🚀  List My Drone',
                              style: TextStyle(
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
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;

  const _InputField(
      {required this.controller, required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.navyLight.withOpacity(0.3)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: AppColors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.bodySecondary,
          hintText: hint,
          hintStyle: AppTextStyles.bodySecondary.copyWith(fontSize: 13),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    );
  }
}
