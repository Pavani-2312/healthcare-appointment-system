import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = context.watch<DoctorProvider>();
    final doctors = doctorProvider.filteredDoctors;
    final specialties = doctorProvider.specialties;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Doctors'),
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
            ),
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: AppTheme.primary,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<DoctorProvider>().updateSearch(value);
                setState(() {}); // update clear button state
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by name, specialty or hospital...',
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () {
                          _searchController.clear();
                          context.read<DoctorProvider>().updateSearch('');
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white54),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _showFilters ? 60 : 0,
            child: _showFilters
                ? Container(
                    color: const Color(0xFFF0F4FF),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      itemCount: specialties.length,
                      itemBuilder: (ctx, i) {
                        final spec = specialties[i];
                        final selected =
                            doctorProvider.selectedSpecialty == spec;
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<DoctorProvider>()
                                .updateSpecialty(spec);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppTheme.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? AppTheme.primary
                                    : AppTheme.primary.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              spec,
                              style: TextStyle(
                                fontSize: 13,
                                color: selected
                                    ? Colors.white
                                    : AppTheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // ── Results count bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${doctors.length} doctor${doctors.length != 1 ? 's' : ''} found',
                  style: const TextStyle(
                    color: AppTheme.textMedium,
                    fontSize: 13,
                  ),
                ),
                if (doctorProvider.searchQuery.isNotEmpty ||
                    doctorProvider.selectedSpecialty != 'All')
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      context.read<DoctorProvider>().clearFilters();
                    },
                    child: const Text(
                      'Clear filters',
                      style: TextStyle(
                        color: AppTheme.error,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: doctors.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔍',
                            style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 16),
                        const Text(
                          'No doctors found',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppTheme.textMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Try a different search or clear filters',
                          style: TextStyle(color: AppTheme.textLight),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            _searchController.clear();
                            context.read<DoctorProvider>().clearFilters();
                          },
                          child: const Text('Clear Filters'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: doctors.length,
                    itemBuilder: (ctx, i) {
                      final doctor = doctors[i];
                      return DoctorCard(
                        doctor: doctor,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/doctor-detail',
                          arguments: doctor.id,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
