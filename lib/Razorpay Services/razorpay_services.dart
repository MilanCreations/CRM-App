import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  static final Razorpay _razorpay = Razorpay();

  static void init() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  static void dispose() {
    _razorpay.clear();
  }

  static void makePayment({
    required int amount, // INR
    required String name,
    required String email,
    required String contact,
    String description = 'Payment',
    String? orderId,
    Map<String, dynamic>? extraOptions,
  }) {
    var options = {
      'key': 'rzp_test_DmPlNBr7sliimo', // Replace with your Razorpay Key
      'amount': amount * 100, // Razorpay uses paise
      'name': name,
      'description': description,
      'prefill': {'contact': contact, 'email': email},
      if (orderId != null) 'order_id': orderId,
      'external': {
        'wallets': ['paytm'],
      },
      if (extraOptions != null) ...extraOptions,
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay open error: $e');
    }
  }

  static void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("✅ Payment Successful: ${response.paymentId}");
  }

  static void _handlePaymentError(PaymentFailureResponse response) {
    print("❌ Payment Failed: ${response.code} - ${response.message}");
  }

  static void _handleExternalWallet(ExternalWalletResponse response) {
    print("💼 External Wallet Selected: ${response.walletName}");
  }
}
