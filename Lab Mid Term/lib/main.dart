import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doctor_app/views/home_screen.dart';
import 'package:doctor_app/views/booking_screen.dart';
import 'package:doctor_app/views/appointments_screen.dart';
import 'package:doctor_app/Constants/app_colors.dart';

void main() {
  runApp(DoctorApp());
}

class DoctorApp extends StatelessWidget {
  const DoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor App',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      home: HomeScreen(),
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/booking', page: () => BookingScreen()),
        GetPage(name: '/appointments', page: () => AppointmentsScreen()),
      ],
    );
  }
}
