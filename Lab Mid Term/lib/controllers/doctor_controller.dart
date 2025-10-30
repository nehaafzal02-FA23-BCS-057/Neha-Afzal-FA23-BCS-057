import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/models/doctor.dart';
import 'package:doctor_app/models/appointment.dart';

class DoctorController extends GetxController {
  var doctors = <Doctor>[].obs;
  var appointments = <Appointment>[].obs;
  var selectedDoctor = Rx<Doctor?>(null);

  @override
  void onInit() {
    super.onInit();
    loadDoctors();
  }

  void loadDoctors() {
    doctors.value = [
      Doctor(
        id: '1',
        name: 'Dr. Awais Karim',
        specialization: 'Cardiologist',
        experience: '10 years',
        rating: 4.8,
        availableTime: '9:00 AM - 5:00 PM',
        consultationFee: 15000,
      ),
      Doctor(
        id: '2',
        name: 'Dr. Aasma Tayyab',
        specialization: 'Dermatologist',
        experience: '8 years',
        rating: 4.6,
        availableTime: '10:00 AM - 6:00 PM',
        consultationFee: 12000.0,
      ),
      Doctor(
        id: '3',
        name: 'Dr. Muhammad Tayyab',
        specialization: 'Pediatrician',
        experience: '12 years',
        rating: 4.9,
        availableTime: '8:00 AM - 4:00 PM',
        consultationFee: 10000.0,
      ),
      Doctor(
        id: '4',
        name: 'Dr. Muhammad Bilal',
        specialization: 'Orthopedic',
        experience: '15 years',
        rating: 4.7,
        availableTime: '9:00 AM - 3:00 PM',
        consultationFee: 18000.0,
      ),
      Doctor(
        id: '5',
        name: 'Dr. Adeeb Rizvi',
        specialization: 'Urology & Transplant Surgery',
        experience: '17 years',
        rating: 4.8,
        availableTime: '8:00 AM - 4:00 PM',
        consultationFee: 20000.0,
      ),
      Doctor(
        id: '6',
        name: 'Dr. Sania Nishtar',
        specialization: 'Cardiology & Public Health',
        experience: '14 years',
        rating: 5.0,
        availableTime: '8:00 AM - 4:00 PM',
        consultationFee: 25000.0,
      ),
      Doctor(
        id: '7',
        name: 'Dr. Ruth Pfau',
        specialization: 'Leprosy Specialist',
        experience: '21 years',
        rating: 5.0,
        availableTime: '8:00 AM - 4:00 PM',
        consultationFee: 18000.0,
      ),
      Doctor(
        id: '8',
        name: 'Dr. Arif Alvi',
        specialization: 'Dentistry',
        experience: '16 years',
        rating: 4.6,
        availableTime: '8:00 AM - 4:00 PM',
        consultationFee: 13000.0,
      ),
      Doctor(
        id: '9',
        name: 'Dr. Seemin Jamali',
        specialization: 'Emergency Medicine',
        experience: '23 years',
        rating: 5.0,
        availableTime: '8:00 AM - 4:00 PM',
        consultationFee: 8000.0,
      ),
      Doctor(
        id: '10',
        name: 'Dr. Nausherwan K. Burki',
        specialization: 'Pulmonology & Medical Research',
        experience: '15 years',
        rating: 4.9,
        availableTime: '8:00 AM - 4:00 PM',
        consultationFee: 15000.0,
      ),
    ];
  }

  void bookAppointment({
    required String doctorId,
    required String doctorName,
    required String patientName,
    required String patientPhone,
    required DateTime appointmentDate,
    required String appointmentTime,
    required double consultationFee,
  }) {
    final appointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      doctorId: doctorId,
      doctorName: doctorName,
      patientName: patientName,
      patientPhone: patientPhone,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      status: 'Scheduled',
      consultationFee: consultationFee,
    );

    appointments.add(appointment);
    Get.snackbar(
      'Success',
      'Appointment booked successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void selectDoctor(Doctor doctor) {
    selectedDoctor.value = doctor;
  }
}
