import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doctor_app/controllers/doctor_controller.dart';
import 'package:doctor_app/Constants/app_colors.dart';
import 'package:doctor_app/Constants/app_styles.dart';

class HomeScreen extends StatelessWidget {
  final DoctorController controller = Get.put(DoctorController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor App'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => Get.toNamed('/appointments'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'Find Your Doctor',
              style: AppStyles.h1.copyWith(color: Colors.blue[800]),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: controller.doctors.length,
                itemBuilder: (context, index) {
                  final doctor = controller.doctors[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        doctor.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doctor.specialization, style: AppStyles.body),
                          Text(
                            'Experience: ${doctor.experience}',
                            style: AppStyles.body,
                          ),
                          Text(
                            'Available: ${doctor.availableTime}',
                            style: AppStyles.body,
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 16),
                              Text(' ${doctor.rating}'),
                              Spacer(),
                              Text(
                                'PKR ${doctor.consultationFee}',
                                style: AppStyles.price,
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          controller.selectDoctor(doctor);
                          Get.toNamed('/booking');
                        },
                        child: Text('Book'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
