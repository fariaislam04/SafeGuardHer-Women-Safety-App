class EmergencyContact {
  final String name;
  final String number;
  final String profilePic;

  EmergencyContact({
    required this.name,
    required this.number,
    required this.profilePic,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'emergency_contact_name': name,
      'emergency_contact_number': number,
      'emergency_contact_profile_pic': profilePic,
    };
  }

  factory EmergencyContact.fromFirestore(Map<String, dynamic> data) {
    return EmergencyContact(
      name: data['emergency_contact_name'] ?? '',
      number: data['emergency_contact_number'] ?? '',
      profilePic:
          (data['emergency_contact_profile_pic'] as String?)?.isEmpty ?? true
              ? 'assets/placeholders/default_profile_pic.png'
              : data['emergency_contact_profile_pic'],
    );
  }
}
