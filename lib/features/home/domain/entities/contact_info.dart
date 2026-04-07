import 'package:equatable/equatable.dart';

class ContactInfo extends Equatable {
  const ContactInfo({
    required this.title,
    required this.description,
    required this.phoneNumber,
    required this.buttonLabel,
  });

  final String title;
  final String description;
  final String phoneNumber;
  final String buttonLabel;

  @override
  List<Object?> get props => <Object?>[
    title,
    description,
    phoneNumber,
    buttonLabel,
  ];
}
