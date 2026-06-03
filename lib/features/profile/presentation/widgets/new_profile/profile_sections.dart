import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/features/profile/data/models/property_mock_data.dart';

// --- Enquiry Screen UI (New Section) ---
class EnquiryScreenSection extends StatelessWidget {
  const EnquiryScreenSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: mockPropertiesData.length,
        separatorBuilder: (_, __) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          return EnquiryCard(property: mockPropertiesData[index]);
        },
      ),
    );
  }
}

class EnquiryCard extends StatelessWidget {
  final PropertyMockData property;
  final bool showInCartBadge;

  const EnquiryCard({
    super.key,
    required this.property,
    this.showInCartBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image with trash icon
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  property.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // TODO: Implement delete
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.delete_outline, size: 16, color: Colors.red[300]),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      property.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      property.price,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildAvailabilityRow(
                  icon: Icons.sync,
                  label: 'SALE AVAILABILITY',
                  isAvailable: property.saleAvailability,
                ),
                const SizedBox(height: 12),
                _buildAvailabilityRow(
                  icon: Icons.account_balance_outlined,
                  label: 'MORTGAGE AVAILABILITY',
                  isAvailable: property.mortgageAvailability,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'VIEW DETAILS →',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF8B8379),
                      ),
                    ),
                    if (showInCartBadge && property.inCart)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9F5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'IN CART',
                          style: TextStyle(
                            color: AppColors.primaryOrange,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityRow({
    required IconData icon,
    required String label,
    required bool isAvailable,
  }) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.primaryOrange),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8B8379),
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        Text(
          isAvailable ? 'YES' : 'NO',
          style: TextStyle(
            color: isAvailable ? const Color(0xFF1CB561) : const Color(0xFFE53935),
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

// --- Cart Screen UI (New Section) ---
class CartScreenSection extends StatelessWidget {
  const CartScreenSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = mockPropertiesData.where((p) => p.inCart).toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cartItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          return EnquiryCard(
            property: cartItems[index],
            showInCartBadge: false, // Hide badge since we are in the cart
          );
        },
      ),
    );
  }
}

// --- Enquiry Charges UI ---
class EnquiryChargesSection extends StatelessWidget {
  const EnquiryChargesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final horizontalPadding = size.width * 0.06;
    final verticalPadding = size.height * 0.04;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding > 32 ? 32 : horizontalPadding,
        vertical: verticalPadding > 40 ? 40 : verticalPadding,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDF8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF2DCA5), width: 1.0),
        ),
        child: Column(
          children: [
            const Text(
              'BATCH SERVICE FEE',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 10,
                letterSpacing: 1.2,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '₹500',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 48,
                color: Colors.black,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'COORDINATION FOR ALL 2 PROPERTIES.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF8B8379),
                fontWeight: FontWeight.w800,
                fontSize: 9,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'PAY ENQUIRY FEE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 0.5,
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

// --- Visiting Charges UI ---
class VisitingChargesSection extends StatelessWidget {
  const VisitingChargesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final horizontalPadding = size.width * 0.06;
    final verticalPadding = size.height * 0.04;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding > 32 ? 32 : horizontalPadding,
        vertical: verticalPadding > 40 ? 40 : verticalPadding,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.primaryOrange,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              'VISITING COORDINATION FEE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '₹4,981',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 48,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'TOTAL COMBINED BUDGET PLAN IS\nCALCULATED FOR ALL 2 PROPERTIES.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w800,
                fontSize: 8,
                letterSpacing: 0.2,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryOrange,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'PAY VISITING FEE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 0.5,
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

// --- Enquiry Selection UI (Wishlist Section) ---
class EnquirySelectionSection extends StatelessWidget {
  const EnquirySelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Text(
            'ENQUIRY SELECTION',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primaryOrange,
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'TRACK STATUS OF THESE PROPERTIES BELOW.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6B6B6B),
              fontWeight: FontWeight.w800,
              fontSize: 10,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockPropertiesData.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return PropertySelectionCard(property: mockPropertiesData[index]);
            },
          ),
        ],
      ),
    );
  }
}

class PropertySelectionCard extends StatelessWidget {
  final PropertyMockData property;

  const PropertySelectionCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  property.imageUrl,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 64,
                    height: 64,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      property.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF8F8379),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                property.price,
                style: const TextStyle(
                  color: AppColors.primaryOrange,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Action for remove wishlist
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE8E8E8)),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'REMOVE FROM WISHLIST',
                  style: TextStyle(
                    color: Color(0xFF8B8379),
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Visits Main Content Card (New Section) ---
class VisitsMainContentCard extends StatefulWidget {
  const VisitsMainContentCard({super.key});

  @override
  State<VisitsMainContentCard> createState() => _VisitsMainContentCardState();
}

class _VisitsMainContentCardState extends State<VisitsMainContentCard> {
  int _selectedVisitTabIndex = 0; // 0: PRIMARY, 1: SHORTLIST, 2: FINAL

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _VisitsActionTabs(
            selectedIndex: _selectedVisitTabIndex,
            onSelected: (index) => setState(() => _selectedVisitTabIndex = index),
          ),
          const Divider(color: Color(0xFFF5F5F5), height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Builder(
              builder: (context) {
                List<PropertyMockData> properties = [];
                if (_selectedVisitTabIndex == 0) {
                  // Primary visits
                  properties = mockPropertiesData.reversed.toList();
                } else if (_selectedVisitTabIndex == 1) {
                  // Shortlist visits - screenshot shows Ibrahimpatnam
                  properties = [mockPropertiesData[0]]; 
                } else {
                  // Final visits - screenshot shows Ibrahimpatnam
                  properties = [mockPropertiesData[0]]; 
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: properties.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    return VisitPropertyCard(
                      property: properties[index],
                      visitTabIndex: _selectedVisitTabIndex,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _VisitsActionTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _VisitsActionTabs({
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _VisitTabItem(
            icon: Icons.near_me_outlined,
            label: 'PRIMARY VISIT',
            isSelected: selectedIndex == 0,
            onTap: () => onSelected(0),
          ),
          _VisitTabItem(
            icon: Icons.favorite_border,
            label: 'SHORTLIST VISIT',
            isSelected: selectedIndex == 1,
            onTap: () => onSelected(1),
          ),
          _VisitTabItem(
            icon: Icons.check_circle_outline,
            label: 'FINAL VISIT',
            isSelected: selectedIndex == 2,
            onTap: () => onSelected(2),
          ),
        ],
      ),
    );
  }
}

class _VisitTabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _VisitTabItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primaryOrange;
    final inactiveColor = const Color(0xFF8B8379);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFFFFF9F5),
                borderRadius: BorderRadius.circular(24),
              )
            : const BoxDecoration(color: Colors.transparent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? activeColor : inactiveColor,
                fontWeight: FontWeight.w900,
                fontSize: 8,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VisitPropertyCard extends StatelessWidget {
  final PropertyMockData property;
  final int visitTabIndex;

  const VisitPropertyCard({
    super.key, 
    required this.property,
    required this.visitTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              property.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 120,
                color: Colors.grey[300],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      property.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      property.price,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildAvailabilityRow(
                  icon: Icons.sync,
                  label: 'SALE AVAILABILITY',
                  isAvailable: property.saleAvailability,
                ),
                const SizedBox(height: 12),
                _buildAvailabilityRow(
                  icon: Icons.account_balance_outlined,
                  label: 'MORTGAGE AVAILABILITY',
                  isAvailable: property.mortgageAvailability,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'DETAILS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF8B8379),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: visitTabIndex == 2 ? const Color(0xFFFFF9F5) : AppColors.primaryOrange,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            visitTabIndex == 0 ? 'SHORTLIST' : visitTabIndex == 1 ? 'FINAL VISIT' : 'FINALIZED',
                            style: TextStyle(
                              color: visitTabIndex == 2 ? AppColors.primaryOrange : Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF5F5),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFFFEAEA)),
                          ),
                          child: Icon(Icons.delete_outline, size: 14, color: Colors.red[300]),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityRow({
    required IconData icon,
    required String label,
    required bool isAvailable,
  }) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.primaryOrange),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8B8379),
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        Text(
          isAvailable ? 'YES' : 'NO',
          style: TextStyle(
            color: isAvailable ? const Color(0xFF1CB561) : const Color(0xFFE53935),
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

// --- My Lands Section (New Section) ---
class MyLandsSection extends StatelessWidget {
  const MyLandsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'LIST OF LANDS',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.add, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'LIST NEW LAND',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 1, // Currently just using 1 mock item based on UI
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final property = mockPropertiesData.firstWhere(
              (p) => p.title == 'JADCHERLA',
              orElse: () => mockPropertiesData.first,
            );
            return _MyLandCard(property: property);
          },
        ),
      ],
    );
  }
}

class _MyLandCard extends StatelessWidget {
  final PropertyMockData property;

  const _MyLandCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              property.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 64,
                height: 64,
                color: Colors.grey[300],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      property.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      property.price,
                      style: const TextStyle(
                        color: AppColors.primaryOrange,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF8F8379)),
                    SizedBox(width: 4),
                    Text(
                      'MAHABUBNAGAR • 5 AC',
                      style: TextStyle(
                        color: Color(0xFF8F8379),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
