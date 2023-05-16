class Order {
  final int? orderId;
  final String? cusName;
  final String? cusAddress;
  final String? contact;
  final String? amount;
  final String? producttype;
  final String? payment;
  final String status;
  final String? quantity;
  final DateTime orderDate;
  final String? note;
  final String? userId; // new field for user ID

  Order({
    this.orderId,
    this.cusName,
    this.cusAddress,
    this.contact,
    this.amount,
    this.producttype,
    this.payment,
    required this.status,
    this.quantity,
    required this.orderDate,
    this.note,
    this.userId, // new field for user ID
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'cusName': cusName,
      'cusAddress': cusAddress,
      'contact': contact,
      'amount': amount,
      'producttype': producttype,
      'payment': payment,
      'status': status,
      'quantity': quantity,
      'orderDate': orderDate.toIso8601String(),
      'note': note,
      'userId': userId, // new field for user ID
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'],
      cusName: map['cusName'],
      cusAddress: map['cusAddress'],
      contact: map['contact'],
      amount: map['amount'],
      producttype: map['producttype'],
      payment: map['payment'],
      status: map['status'],
      quantity: map['quantity'],
      orderDate: DateTime.parse(map['orderDate']),
      note: map['note'],
      userId: map['userId'], // new field for user ID
    );
  }
}
