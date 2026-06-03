import 'package:flutter/material.dart';
import 'package:garuda_user_app/features/profile/presentation/widgets/new_profile/profile_components.dart';
import 'package:garuda_user_app/features/profile/presentation/widgets/new_profile/profile_sections.dart';

// --- Main Page ---
class NewProfilePage extends StatefulWidget {
  const NewProfilePage({super.key});

  @override
  State<NewProfilePage> createState() => _NewProfilePageState();
}

class _NewProfilePageState extends State<NewProfilePage> {
  // Top Tabs: 0: CART, 1: VISITS, 2: MY LANDS
  int _selectedTopTabIndex = 0;
  // Action Grid (only visible in CART tab): 0: WISHLIST, 1: ENQUIRY CHARGES, 2: ENQUIRY, 3: CART, 4: VISITING CHARGES
  int _selectedActionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: const ProfileAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600), // Responsive max width constraint
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ProfileTopTabsCard(
                      selectedIndex: _selectedTopTabIndex,
                      onSelected: (index) {
                        setState(() {
                          _selectedTopTabIndex = index;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    if (_selectedTopTabIndex == 0)
                      _MainContentCard(
                        selectedIndex: _selectedActionIndex,
                        onActionSelected: (index) {
                          setState(() {
                            _selectedActionIndex = index;
                          });
                        },
                      )
                    else if (_selectedTopTabIndex == 1)
                      const VisitsMainContentCard()
                    else
                      const MyLandsSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget? _buildFloatingActionButton() {
    // If we are in the VISITS top tab:
    if (_selectedTopTabIndex == 1) {
      return CustomProfileFab(
        icon: Icons.call,
        label: 'CALL',
        onTap: () {
          // TODO: Implement call
        },
      );
    } else if (_selectedTopTabIndex == 2) {
      // My Lands tab has no FAB
      return null;
    }

    // Otherwise, we are in the CART top tab. The FAB depends on _selectedActionIndex:
    if (_selectedActionIndex == 0) {
      // Wishlist tab
      return CustomProfileFab(
        icon: Icons.arrow_forward,
        label: 'ENQUIRY (2)',
        onTap: () {
          // TODO: Implement proceed to enquiry
        },
      );
    } else if (_selectedActionIndex == 1) {
      // Enquiry Charges tab
      return CustomProfileFab(
        icon: Icons.check, // Using check mark to represent the 'V' shape in the image
        label: 'ENQUIRY',
        onTap: () {
          // TODO: Implement enquiry action
        },
      );
    } else if (_selectedActionIndex == 2) {
      // Enquiry tab
      return CustomProfileFab(
        icon: Icons.shopping_cart_outlined,
        label: 'CART',
        onTap: () {
          // TODO: Implement cart action
        },
      );
    } else if (_selectedActionIndex == 3) {
      // Cart tab
      return CustomProfileFab(
        icon: Icons.receipt_long_outlined,
        label: 'PAYMENT',
        onTap: () {
          // TODO: Implement payment
        },
      );
    } else if (_selectedActionIndex == 4) {
      // Visiting Charges tab
      return CustomProfileFab(
        icon: Icons.near_me_outlined,
        label: 'VISIT FEE',
        onTap: () {
          // TODO: Implement visit fee action
        },
      );
    }
    return null;
  }
}

// --- Main Content Component ---
class _MainContentCard extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onActionSelected;

  const _MainContentCard({
    required this.selectedIndex,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    Widget activeSection;
    if (selectedIndex == 1) {
      activeSection = const EnquiryChargesSection();
    } else if (selectedIndex == 2) {
      activeSection = const EnquiryScreenSection();
    } else if (selectedIndex == 3) {
      activeSection = const CartScreenSection();
    } else if (selectedIndex == 4) {
      activeSection = const VisitingChargesSection();
    } else {
      activeSection = const EnquirySelectionSection();
    }

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
          ProfileActionIconsGrid(
            selectedIndex: selectedIndex,
            onSelected: onActionSelected,
          ),
          const Divider(color: Color(0xFFF5F5F5), height: 1, thickness: 1),
          // Toggle content based on selected tab
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: activeSection,
          ),
        ],
      ),
    );
  }
}
