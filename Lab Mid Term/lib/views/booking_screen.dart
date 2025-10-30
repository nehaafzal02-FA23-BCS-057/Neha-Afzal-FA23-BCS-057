import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doctor_app/controllers/doctor_controller.dart';
import 'package:doctor_app/Constants/app_colors.dart';
import 'package:doctor_app/Constants/app_styles.dart';
import 'package:doctor_app/Constants/app_text_field.dart';

class BookingScreen extends StatelessWidget {
  final DoctorController controller = Get.find<DoctorController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final RxString selectedTime = '9:00 AM'.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final doctor = controller.selectedDoctor.value;
        if (doctor == null) {
          return Center(child: Text('No doctor selected'));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor.name, style: AppStyles.h2),
                      Text(doctor.specialization, style: AppStyles.body),
                      Text(
                        'Fee: PKR ${doctor.consultationFee}',
                        style: AppStyles.price,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Patient Information', style: AppStyles.h2),
              SizedBox(height: 10),
              AppTextField(controller: nameController, label: 'Patient Name'),
              SizedBox(height: 16),
              AppTextField(
                controller: phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              Text('Select Date', style: AppStyles.h2),
              SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate.value,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 30)),
                  );
                  if (date != null) {
                    selectedDate.value = date;
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 10),
                      Obx(
                        () => Text(
                          '${selectedDate.value.day}/${selectedDate.value.month}/${selectedDate.value.year}',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Select Time', style: AppStyles.h2),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children:
                    [
                          '9:00 AM',
                          '10:00 AM',
                          '11:00 AM',
                          '2:00 PM',
                          '3:00 PM',
                          '4:00 PM',
                        ]
                        .map(
                          (time) => Obx(
                            () => ChoiceChip(
                              label: Text(time),
                              selected: selectedTime.value == time,
                              onSelected: (selected) {
                                if (selected) selectedTime.value = time;
                              },
                            ),
                          ),
                        )
                        .toList(),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        phoneController.text.isNotEmpty) {
                      controller.bookAppointment(
                        doctorId: doctor.id,
                        doctorName: doctor.name,
                        patientName: nameController.text,
                        patientPhone: phoneController.text,
                        appointmentDate: selectedDate.value,
                        appointmentTime: selectedTime.value,
                        consultationFee: doctor.consultationFee,
                      );
                      Get.offAllNamed('/');
                    } else {
                      Get.snackbar(
                        'Error',
                        'Please fill all fields',
                        backgroundColor: AppColors.error,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Book Appointment',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
