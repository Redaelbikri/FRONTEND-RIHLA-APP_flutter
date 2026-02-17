class PaymentIntentResponse {
  final String paymentIntentId;
  final String clientSecret;

  PaymentIntentResponse({required this.paymentIntentId, required this.clientSecret});

  factory PaymentIntentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentIntentResponse(
      paymentIntentId: (json['paymentIntentId'] ?? '').toString(),
      clientSecret: (json['clientSecret'] ?? '').toString(),
    );
  }
}
