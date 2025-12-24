import 'package:flutter/material.dart';

class PaymentHistory {
  final String paymentCycle;
  final double paymentAmount;
  final String paymentStatus;

  PaymentHistory({
    required this.paymentCycle,
    required this.paymentAmount,
    required this.paymentStatus,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      paymentCycle: json['paymentCycle'],
      paymentAmount: json['paymentAmount'],
      paymentStatus: json['paymentStatus']
    );
  }

  Map<String, dynamic> toJson() {
    return {
    'paymentCycle': paymentCycle,
    'paymentAmount': paymentAmount,
    'paymentStatus': paymentStatus,
    };
  }
}