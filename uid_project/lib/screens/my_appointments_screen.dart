import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/appointment.dart';
import '../providers/appointment_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, provider, _) {
          return TabBarView(
            controller: _tabController,
            children: [
              _AppointmentList(
                appointments: provider.upcoming,
                emptyMessage: 'No upcoming appointments',
                emptySubtitle: 'Book your first appointment with a doctor',
                showCancelButton: true,
              ),
              _AppointmentList(
                appointments: provider.completed,
                emptyMessage: 'No completed appointments',
                emptySubtitle: 'Your completed visits will appear here',
                showCancelButton: false,
              ),
              _AppointmentList(
                appointments: provider.cancelled,
                emptyMessage: 'No cancelled appointments',
                emptySubtitle: 'Cancelled appointments appear here',
                showCancelButton: false,
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/doctors'),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Appointment',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

// ─── Appointment list helper ──────────────────────────────────
class _AppointmentList extends StatelessWidget {
  final List<Appointment> appointments;
  final String emptyMessage;
  final String emptySubtitle;
  final bool showCancelButton;

  const _AppointmentList({
    required this.appointments,
    required this.emptyMessage,
    required this.emptySubtitle,
    required this.showCancelButton,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📋', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppTheme.textMedium,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              emptySubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textLight, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: appointments.length,
      itemBuilder: (ctx, i) {
        return _AppointmentCard(
          appointment: appointments[i],
          showCancelButton: showCancelButton,
        );
      },
    );
  }
}

// ─── Appointment card widget ──────────────────────────────────
class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final bool showCancelButton;

  const _AppointmentCard({
    required this.appointment,
    required this.showCancelButton,
  });

  Color get _statusColor {
    switch (appointment.status) {
      case AppointmentStatus.upcoming:
        return AppTheme.primary;
      case AppointmentStatus.completed:
        return AppTheme.success;
      case AppointmentStatus.cancelled:
        return AppTheme.error;
    }
  }

  String get _statusLabel {
    switch (appointment.status) {
      case AppointmentStatus.upcoming:
        return 'Upcoming';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor info row + status chip
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('👨‍⚕️', style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        appointment.doctorSpecialty,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusChip(label: _statusLabel, color: _statusColor),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InfoTile(
                    icon: Icons.calendar_today_outlined,
                    label: 'Date',
                    value: DateFormat('d MMM yyyy')
                        .format(appointment.appointmentDate),
                  ),
                ),
                Expanded(
                  child: InfoTile(
                    icon: Icons.access_time_outlined,
                    label: 'Time',
                    value: appointment.timeSlot,
                  ),
                ),
              ],
            ),
            InfoTile(
              icon: Icons.person_outline,
              label: 'Patient',
              value:
                  '${appointment.patientName}, ${appointment.patientAge} yrs (${appointment.patientGender})',
            ),
            InfoTile(
              icon: Icons.notes_outlined,
              label: 'Reason',
              value: appointment.reason,
            ),

            // Cancel button (only for upcoming)
            if (showCancelButton) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmCancel(context),
                      icon: const Icon(Icons.cancel_outlined,
                          color: AppTheme.error, size: 18),
                      label: const Text(
                        'Cancel Appointment',
                        style: TextStyle(color: AppTheme.error),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.error),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Appointment?'),
        content: const Text(
          'Are you sure you want to cancel this appointment? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No, Keep It'),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<AppointmentProvider>()
                  .cancelAppointment(appointment.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Appointment cancelled.'),
                  backgroundColor: AppTheme.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
