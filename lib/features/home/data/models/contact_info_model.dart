import 'package:garuda_user_app/features/home/domain/entities/contact_info.dart';

class ContactInfoModel extends ContactInfo {
  const ContactInfoModel({
    required super.title,
    required super.description,
    required super.phoneNumber,
    required super.buttonLabel,
  });

  factory ContactInfoModel.fromMap(Map<String, dynamic> map) {
    return ContactInfoModel(
      title: map['title'] as String,
      description: map['description'] as String,
      phoneNumber: map['phoneNumber'] as String,
      buttonLabel: map['buttonLabel'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'phoneNumber': phoneNumber,
      'buttonLabel': buttonLabel,
    };
  }
}
