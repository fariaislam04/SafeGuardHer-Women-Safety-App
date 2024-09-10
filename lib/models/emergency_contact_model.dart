class EmergencyContact
{
  final String phone;
  final String name;
  final String profilePic;

  EmergencyContact({
    required this.phone,
    required this.name,
    required this.profilePic,
  });

  factory EmergencyContact.fromFirestore(Map<String, dynamic> data)
  {
    return EmergencyContact(
      phone: data['phone'] ?? '',
      name: data['name'] ?? '',
      profilePic: data['profilePic'] ?? 'assets/placeholders/default_profile_pic.png',
    );
  }
}
