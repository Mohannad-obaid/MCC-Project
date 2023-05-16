import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
late String id;
late String name;
late String specialty;
late String address;
late String phoneNumber;
late String image;
late String email;
late String birthDate;


DoctorModel({
  required this.id,
  required this.name,
  required this.specialty,
  required this.address,
  required this.phoneNumber,
  required this.image,
  required this.email,
  required this.birthDate,
});

DoctorModel.fromMap(Map<String, dynamic> json) {
  id = json['id'];
  name = json['name'];
  specialty = json['specialty'];
  address = json['address'];
  phoneNumber = json['phoneNumber'];
  image = json['image'];
  birthDate = json['birthDate'];

}

factory DoctorModel.fromSnapshot(DocumentSnapshot doc) {
  final data = doc.data()! as Map<String, dynamic>;
  return DoctorModel(
    id: doc.id,
    name: data['name'],
    email: data['email'],
    image: data['image'],
    phoneNumber: data['phone'],
    address: data['address'],
    birthDate: data['birthDate'],
    specialty: data['specialty'],
  );
}

Map<String, dynamic> toJson() {
  return {
    'id': id,
    'name': name,
    'email': email,
    'image': image,
    'phone': phoneNumber,
    'address': address,
    'birthDate': birthDate,
    'specialty': specialty,
  };
}
}