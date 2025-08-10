// To parse this JSON data, do
//
//     final createOrder = createOrderFromJson(jsonString);

import 'dart:convert';

CreateOrder createOrderFromJson(String str) => CreateOrder.fromJson(json.decode(str));

String createOrderToJson(CreateOrder data) => json.encode(data.toJson());

class CreateOrder {
    bool success;
    String orderId;
    String keyId;
    int amount;
    String currency;

    CreateOrder({
        required this.success,
        required this.orderId,
        required this.keyId,
        required this.amount,
        required this.currency,
    });

    factory CreateOrder.fromJson(Map<String, dynamic> json) => CreateOrder(
        success: json["success"],
        orderId: json["orderId"],
        keyId: json["keyId"],
        amount: json["amount"],
        currency: json["currency"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "orderId": orderId,
        "keyId": keyId,
        "amount": amount,
        "currency": currency,
    };
}
