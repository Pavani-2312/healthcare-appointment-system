// Healthcare Appointment System
// Flutter UID Lab Project – CS506PC
// B.Tech III Year I Semester
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/appointment_provider.dart';
import 'providers/doctor_provider.dart';
import 'providers/profile_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/doctor_list_screen.dart';
import 'screens/doctor_detail_screen.dart';
import 'screens/book_appointment_screen.dart';
import 'screens/my_appointments_screen.dart';
import 'screens/health_tips_screen.dart';
import 'screens/profile_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const HealthCareApp());
}

class HealthCareApp extends StatelessWidget {
  const HealthCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        title: 'HealthCare Appointments',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (ctx) => const SplashScreen(),
          '/home': (ctx) => const HomeScreen(),
          '/doctors': (ctx) => const DoctorListScreen(),
          '/doctor-detail': (ctx) => const DoctorDetailScreen(),
          '/book-appointment': (ctx) => const BookAppointmentScreen(),
          '/appointments': (ctx) => const MyAppointmentsScreen(),
          '/health-tips': (ctx) => const HealthTipsScreen(),
          '/profile': (ctx) => const ProfileScreen(),
        },

        // ── Fallback for unknown routes
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (ctx) => Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('404', style: TextStyle(fontSize: 72)),
                  const SizedBox(height: 16),
                  const Text(
                    'Page not found',
                    style: TextStyle(fontSize: 18, color: AppTheme.textMedium),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(ctx, '/home'),
                    child: const Text('Go Home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
