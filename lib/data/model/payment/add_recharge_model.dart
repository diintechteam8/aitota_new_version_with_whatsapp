class AddRechargeModel {
  final bool? success;
  final String? message;
  final String? orderId;
  final String? orderToken; // Matches API response
  final int? orderAmount;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;

  AddRechargeModel({
    this.success,
    this.message,
    this.orderId,
    this.orderToken,
    this.orderAmount,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
  });

  factory AddRechargeModel.fromJson(Map<String, dynamic> json) {
    return AddRechargeModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      orderId: json['orderId'] as String?,
      orderToken: json['orderToken'] as String?,
      orderAmount: json['orderAmount'] is int
          ? json['orderAmount'] as int
          : int.tryParse(json['orderAmount']?.toString() ?? ''),
      customerName: json['customerName'] as String?,
      customerEmail: json['customerEmail'] as String?,
      customerPhone: json['customerPhone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'orderId': orderId,
      'orderToken': orderToken,
      'orderAmount': orderAmount,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
    };
  }
}
