class PropertyMockData {
  final String title;
  final String subtitle;
  final String price;
  final String imageUrl;
  final bool saleAvailability;
  final bool mortgageAvailability;
  final bool inCart;

  const PropertyMockData({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    this.saleAvailability = false,
    this.mortgageAvailability = false,
    this.inCart = false,
  });
}

final List<PropertyMockData> mockPropertiesData = [
  const PropertyMockData(
    title: 'IBRAHIMPATNAM',
    subtitle: '18 AC 35 GTS',
    price: '₹75.0L',
    imageUrl: 'https://images.unsplash.com/photo-1477959858617-67f8516f1099?w=600&q=80',
    saleAvailability: false,
    mortgageAvailability: false,
    inCart: false,
  ),
  const PropertyMockData(
    title: 'VIKARABAD',
    subtitle: '18 AC 18 GTS',
    price: '₹27.0L',
    imageUrl: 'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=600&q=80',
    saleAvailability: false,
    mortgageAvailability: true,
    inCart: true,
  ),
  const PropertyMockData(
    title: 'JADCHERLA',
    subtitle: '', // Doesn't show in the new card
    price: '₹40.0L',
    imageUrl: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=600&q=80',
    saleAvailability: true,
    mortgageAvailability: true,
    inCart: false,
  ),
  const PropertyMockData(
    title: 'CHIVELLA',
    subtitle: '',
    price: '₹110.0L',
    imageUrl: 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=600&q=80',
    saleAvailability: false,
    mortgageAvailability: false,
    inCart: false,
  ),
];
