class Member {
  final String memberNumber;
  final String fullName;
  final String? dateOfBirth;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final double totalContributions;
  final bool active;
  final String? registrationDate;

  Member({
    required this.memberNumber,
    required this.fullName,
    this.dateOfBirth,
    this.email,
    this.phoneNumber,
    this.address,
    required this.totalContributions,
    required this.active,
    this.registrationDate,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      memberNumber: json['memberNumber'],
      fullName: json['fullName'],
      dateOfBirth: json['dateOfBirth'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      totalContributions: double.parse((json['totalContributions'] ?? 0).toString()),
      active: json['active'] ?? false,
      registrationDate: json['registrationDate'],
    );
  }
}