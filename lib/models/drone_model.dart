class DroneModel {
  final String id;
  final String name;
  final String brand;
  final String category;
  final double pricePerDay;
  final double rating;
  final int reviewCount;
  final String sellerId;
  final String sellerName;
  final String location;
  final List<String> features;
  final String description;
  final double maxSpeed;
  final double flightTime;
  final double maxAltitude;
  final String cameraRes;
  final bool isAvailable;
  final String imageEmoji; // Using emojis as placeholder for images

  const DroneModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.pricePerDay,
    required this.rating,
    required this.reviewCount,
    required this.sellerId,
    required this.sellerName,
    required this.location,
    required this.features,
    required this.description,
    required this.maxSpeed,
    required this.flightTime,
    required this.maxAltitude,
    required this.cameraRes,
    required this.isAvailable,
    required this.imageEmoji,
  });
}

class DroneData {
  static final List<DroneModel> drones = [
    const DroneModel(
      id: 'd1',
      name: 'Phantom Pro X',
      brand: 'DJI',
      category: 'Photography',
      pricePerDay: 2499,
      rating: 4.9,
      reviewCount: 128,
      sellerId: 's1',
      sellerName: 'SkyView Rentals',
      location: 'Ahmedabad, GJ',
      features: ['4K Camera', 'GPS', '3-Axis Gimbal', 'Obstacle Avoidance'],
      description: 'Professional drone perfect for aerial photography and cinematography. Features advanced stabilization for butter-smooth footage.',
      maxSpeed: 72,
      flightTime: 30,
      maxAltitude: 500,
      cameraRes: '4K/60fps',
      isAvailable: true,
      imageEmoji: '🚁',
    ),
    const DroneModel(
      id: 'd2',
      name: 'Mavic Air Ultra',
      brand: 'DJI',
      category: 'Travel',
      pricePerDay: 1799,
      rating: 4.7,
      reviewCount: 94,
      sellerId: 's2',
      sellerName: 'AeroFleet India',
      location: 'Mumbai, MH',
      features: ['Foldable Design', '4K HDR', 'Smart Tracking', 'Wind Resistance'],
      description: 'Compact yet powerful travel drone. Folds into a backpack and delivers stunning 4K footage anywhere.',
      maxSpeed: 68,
      flightTime: 34,
      maxAltitude: 400,
      cameraRes: '4K/30fps',
      isAvailable: true,
      imageEmoji: '🛸',
    ),
    const DroneModel(
      id: 'd3',
      name: 'Inspire 3 Cinema',
      brand: 'DJI',
      category: 'Cinema',
      pricePerDay: 5999,
      rating: 5.0,
      reviewCount: 47,
      sellerId: 's1',
      sellerName: 'SkyView Rentals',
      location: 'Ahmedabad, GJ',
      features: ['8K RAW', 'Dual Operator', 'CineCore 3.0', 'Zenmuse X9'],
      description: 'Hollywood-grade cinema drone for professional productions. Used in major Bollywood productions.',
      maxSpeed: 94,
      flightTime: 28,
      maxAltitude: 600,
      cameraRes: '8K RAW',
      isAvailable: false,
      imageEmoji: '✈️',
    ),
    const DroneModel(
      id: 'd4',
      name: 'FPV Racer Titan',
      brand: 'Autel',
      category: 'Racing',
      pricePerDay: 999,
      rating: 4.6,
      reviewCount: 73,
      sellerId: 's3',
      sellerName: 'DroneZone Pro',
      location: 'Bangalore, KA',
      features: ['150km/h Speed', 'FPV Goggles', 'Manual Mode', 'Acrobatic Ready'],
      description: 'Feel the adrenaline! Race-spec drone with FPV goggles included. Perfect for thrill seekers.',
      maxSpeed: 150,
      flightTime: 18,
      maxAltitude: 300,
      cameraRes: '1080p/120fps',
      isAvailable: true,
      imageEmoji: '⚡',
    ),
    const DroneModel(
      id: 'd5',
      name: 'Agras T40 Agri',
      brand: 'DJI',
      category: 'Agriculture',
      pricePerDay: 3999,
      rating: 4.8,
      reviewCount: 56,
      sellerId: 's4',
      sellerName: 'AgriDrone Solutions',
      location: 'Surat, GJ',
      features: ['40L Tank', 'Terrain Following', 'Smart Farm Mode', 'Night Operation'],
      description: 'Agricultural powerhouse covering 40 acres/hour. Revolutionize your farming with precision spraying.',
      maxSpeed: 48,
      flightTime: 22,
      maxAltitude: 200,
      cameraRes: 'Multispectral',
      isAvailable: true,
      imageEmoji: '🌿',
    ),
    const DroneModel(
      id: 'd6',
      name: 'Mini 4 Explorer',
      brand: 'DJI',
      category: 'Beginner',
      pricePerDay: 799,
      rating: 4.5,
      reviewCount: 201,
      sellerId: 's2',
      sellerName: 'AeroFleet India',
      location: 'Mumbai, MH',
      features: ['249g Weight', 'No License Needed', '4K Video', 'Wind Mode'],
      description: 'Perfect entry-level drone. No DGCA license required under 250g. Ideal for beginners.',
      maxSpeed: 57,
      flightTime: 34,
      maxAltitude: 120,
      cameraRes: '4K/30fps',
      isAvailable: true,
      imageEmoji: '🎯',
    ),
  ];

  static List<String> get categories => ['All', 'Photography', 'Cinema', 'Racing', 'Agriculture', 'Travel', 'Beginner'];
}
