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
              ? 'https://firebasestorage.googleapis.com/v0/b/safeguardher-app.appspot.com/o/profile_pics%2F01719958727%2F1000007043.png?alt=media&token=34a85510-d1e2-40bd-b84b-5839bef880bc'
              : data['emergency_contact_profile_pic'],
    );
  }
}
