class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String bloodGroup;
  final String dateOfBirth;
  final String address;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.bloodGroup,
    required this.dateOfBirth,
    required this.address,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? bloodGroup,
    String? dateOfBirth,
    String? address,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
    );
  }

  static UserProfile defaultProfile() {
    return const UserProfile(
      name: 'Pavani',
      email: 'pavani@email.com',
      phone: '+91 98765 43210',
      bloodGroup: 'B+',
      dateOfBirth: '12 Mar 2004',
      address: '15, Kukatpally, Hyderabad, Telangana',
    );
  }
}
