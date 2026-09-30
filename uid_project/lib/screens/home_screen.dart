import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import '../providers/profile_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
    final doctorProvider = context.watch<DoctorProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primary, Color(0xFF0D47A1)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              profile.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/profile'),
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white54,
                                    width: 1.5,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white70,
                                    size: 26,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            context.read<DoctorProvider>().clearFilters();
                            Navigator.pushNamed(context, '/doctors');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.search, color: Colors.white54),
                                SizedBox(width: 12),
                                Text(
                                  'Search doctors, specialties...',
                                  style: TextStyle(color: Colors.white54),
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
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SectionHeader(title: 'Quick Actions'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _ActionButton(
                        icon: Icons.calendar_month,
                        label: 'Book\nAppointment',
                        color: AppTheme.primary,
                        onTap: () {
                          context.read<DoctorProvider>().clearFilters();
                          Navigator.pushNamed(context, '/doctors');
                        },
                      ),
                      const SizedBox(width: 12),
                      _ActionButton(
                        icon: Icons.assignment,
                        label: 'My\nAppointments',
                        color: AppTheme.success,
                        onTap: () =>
                            Navigator.pushNamed(context, '/appointments'),
                      ),
                      const SizedBox(width: 12),
                      _ActionButton(
                        icon: Icons.health_and_safety,
                        label: 'Health\nTips',
                        color: AppTheme.accent,
                        onTap: () =>
                            Navigator.pushNamed(context, '/health-tips'),
                      ),
                      const SizedBox(width: 12),
                      _ActionButton(
                        icon: Icons.person,
                        label: 'My\nProfile',
                        color: AppTheme.warning,
                        onTap: () =>
                            Navigator.pushNamed(context, '/profile'),
                      ),
                    ],
                  ),
                ),

                const SectionHeader(title: 'Browse Specialties'),
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _SpecialtyChip(label: 'Cardiologist'),
                      _SpecialtyChip(label: 'Neurologist'),
                      _SpecialtyChip(label: 'Orthopedic Surgeon'),
                      _SpecialtyChip(label: 'Pediatrician'),
                      _SpecialtyChip(label: 'General Physician'),
                      _SpecialtyChip(label: 'Dermatologist'),
                    ],
                  ),
                ),

                SectionHeader(
                  title: 'Our Doctors',
                  actionText: 'See All',
                  onActionTap: () {
                    context.read<DoctorProvider>().clearFilters();
                    Navigator.pushNamed(context, '/doctors');
                  },
                ),
                ...doctorProvider.filteredDoctors.take(3).map(
                      (doctor) => DoctorCard(
                        doctor: doctor,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/doctor-detail',
                          arguments: doctor.id,
                        ),
                      ),
                    ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.textLight,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              context.read<DoctorProvider>().clearFilters();
              Navigator.pushNamed(context, '/doctors');
              break;
            case 2:
              Navigator.pushNamed(context, '/appointments');
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Doctors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tapping a specialty chip sets the filter in DoctorProvider
// then navigates to the doctor list, which reads that filter.
class _SpecialtyChip extends StatelessWidget {
  final String label;

  const _SpecialtyChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<DoctorProvider>().updateSpecialty(label);
        Navigator.pushNamed(context, '/doctors');
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppTheme.primary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
