class Transaction {
  final String id;
  final String userId;
  final String itemId;
  final double amount;
  final DateTime date;
  final String status; // 'pending', 'completed', 'cancelled'
  final String? notes;

  Transaction({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.amount,
    required this.date,
    required this.status,
    this.notes,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['userId'],
      itemId: json['itemId'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      status: json['status'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'itemId': itemId,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }
}