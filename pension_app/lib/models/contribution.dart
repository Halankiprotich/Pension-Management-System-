class Contribution {
  final int id;
  final String memberNumber;
  final String fullName;
  final double amount;
  final String? contributionDate;
  final String? paymentMethod;
  final String? referenceNumber;
  final String? notes;

  Contribution({
    required this.id,
    required this.memberNumber,
    required this.fullName,
    required this.amount,
    this.contributionDate,
    this.paymentMethod,
    this.referenceNumber,
    this.notes,
  });

  factory Contribution.fromJson(Map<String, dynamic> json) {
    return Contribution(
      id: json['id'],
      memberNumber: json['memberNumber'],
      fullName: json['fullName'] ?? '',
      amount: double.parse((json['amount'] ?? 0).toString()),
      contributionDate: json['contributionDate'],
      paymentMethod: json['paymentMethod'],
      referenceNumber: json['referenceNumber'],
      notes: json['notes'],
    );
  }
}