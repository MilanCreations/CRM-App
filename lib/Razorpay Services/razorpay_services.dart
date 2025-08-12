import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  static final Razorpay _razorpay = Razorpay();
  static Function(PaymentSuccessResponse)? _onSuccess;
  static Function(PaymentFailureResponse)? _onError;
  static Function(ExternalWalletResponse)? _onExternalWallet;

  static void init({
    Function(PaymentSuccessResponse)? onSuccess,
    Function(PaymentFailureResponse)? onError,
    Function(ExternalWalletResponse)? onExternalWallet,
  }) {
    _onSuccess = onSuccess;
    _onError = onError;
    _onExternalWallet = onExternalWallet;

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  static void dispose() {
    _razorpay.clear();
    _onSuccess = null;
    _onError = null;
    _onExternalWallet = null;
  }

  static void makePayment({
    required int amount,
    required String name,
    required String email,
    required String contact,
    String description = 'Payment',
    String? orderId,
    Map<String, dynamic>? extraOptions,
    Function(PaymentSuccessResponse)? onSuccess,
    Function(PaymentFailureResponse)? onError,
    Function(ExternalWalletResponse)? onExternalWallet,
  }) {
    // Initialize with new callbacks if provided
    if (onSuccess != null || onError != null || onExternalWallet != null) {
      init(
        onSuccess: onSuccess,
        onError: onError,
        onExternalWallet: onExternalWallet,
      );
    }

    var options = {
      'key': 'rzp_test_DmPlNBr7sliimo',
      'amount': amount * 100,
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
      if (onError != null) {
        onError(PaymentFailureResponse(-1, e.toString(), null));
      }
    }
  }

  static void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Successful: ${response.paymentId}");
    if (_onSuccess != null) {
      _onSuccess!(response);
    }
    // Here you should verify the payment with your backend
  }

  static void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed: ${response.code} - ${response.message}");
    if (_onError != null) {
      _onError!(response);
    }
  }

  static void _handleExternalWallet(ExternalWalletResponse response) {
    print("💼 External Wallet Selected: ${response.walletName}");
    if (_onExternalWallet != null) {
      _onExternalWallet!(response);
    }
  }
}
