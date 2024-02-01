enum DiscountType {
  coupon,
  period,
  person,
  // Add more types as needed
}

class Discount {
  String id;
  DiscountType type;
  double amount;

  Discount({
    required this.id,
    required this.type,
    required this.amount,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      id: json['id'] as String,
      type: _parseDiscountType(json['type'] as String),
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': _getDiscountTypeString(type),
      'amount': amount,
    };
  }

  static DiscountType _parseDiscountType(String typeString) {
    switch (typeString.toLowerCase()) {
      case 'coupon':
        return DiscountType.coupon;
      case 'period':
        return DiscountType.period;
      case 'person':
        return DiscountType.person;
      // Add more cases as needed
      default:
        throw ArgumentError('Invalid discount type: $typeString');
    }
  }

  static String _getDiscountTypeString(DiscountType type) {
    return type.toString().split('.').last.toLowerCase();
  }
}
