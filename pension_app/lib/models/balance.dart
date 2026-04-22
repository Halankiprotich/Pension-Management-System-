class Balance {
  final String memberNumber;
  final String fullName;
  final double totalContributions;
  final bool active;

  Balance({
    required this.memberNumber,
    required this.fullName,
    required this.totalContributions,
    required this.active,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      memberNumber: json['memberNumber'],
      fullName: json['fullName'],
      totalContributions: double.parse((json['totalContributions'] ?? 0).toString()),
      active: json['active'] ?? false,
    );
  }
}