import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doctor_app/controllers/doctor_controller.dart';
import 'package:doctor_app/Constants/app_colors.dart';
import 'package:doctor_app/Constants/app_styles.dart';

class AppointmentsScreen extends StatelessWidget {
  final DoctorController controller = Get.find<DoctorController>();

  AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Appointments'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.appointments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No appointments yet',
                  style: AppStyles.body.copyWith(fontSize: 18),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: Text('Book an Appointment'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.appointments.length,
          itemBuilder: (context, index) {
            final appointment = controller.appointments[index];
            return Card(
              margin: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            appointment.doctorName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            appointment.status,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Patient: ${appointment.patientName}',
                      style: AppStyles.body,
                    ),
                    Text(
                      'Phone: ${appointment.patientPhone}',
                      style: AppStyles.body,
                    ),
                    Text(
                      'Date: ${appointment.appointmentDate.day}/${appointment.appointmentDate.month}/${appointment.appointmentDate.year}',
                      style: AppStyles.body,
                    ),
                    Text(
                      'Time: ${appointment.appointmentTime}',
                      style: AppStyles.body,
                    ),
                    Text(
                      'Fee: PKR ${appointment.consultationFee}',
                      style: AppStyles.price,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
