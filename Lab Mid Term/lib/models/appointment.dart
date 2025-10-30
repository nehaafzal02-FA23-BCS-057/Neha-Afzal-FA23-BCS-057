class Appointment {
  final String id;
  final String doctorId;
  final String doctorName;
  final String patientName;
  final String patientPhone;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String status;
  final double consultationFee;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.patientName,
    required this.patientPhone,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    required this.consultationFee,
  });
}
