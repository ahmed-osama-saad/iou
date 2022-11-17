// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';

class Receipt {
  final int id;
  final String? description;
  final num amount;
  final Uint8List? image;
  final String currency;
  final int senderId;
  final int receiverId;
  Receipt({
    required this.id,
    this.description,
    required this.amount,
    this.image,
    required this.currency,
    required this.senderId,
    required this.receiverId,
  });

  Receipt copyWith({
    int? id,
    String? description,
    num? amount,
    Uint8List? image,
    String? currency,
    int? senderId,
    int? receiverId,
  }) {
    return Receipt(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      image: image ?? this.image,
      currency: currency ?? this.currency,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'amount': amount,
      'image': image,
      'currency': currency,
      'senderId': senderId,
      'receiverId': receiverId,
    };
  }

  factory Receipt.fromMap(Map<String, dynamic> map) {
    return Receipt(
      id: map['id'] as int,
      description:
          map['description'] != null ? map['description'] as String : null,
      amount: map['amount'] as num,
      image: map['image'] != null ? map['image'] as Uint8List : null,
      currency: map['currency'] as String,
      senderId: map['senderId'] as int,
      receiverId: map['receiverId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Receipt.fromJson(String source) =>
      Receipt.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Receipt(id: $id, description: $description, amount: $amount, currency: $currency, senderId: $senderId, receiverId: $receiverId, image: $image)';
  }

  @override
  bool operator ==(covariant Receipt other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.description == description &&
        other.amount == amount &&
        other.image == image &&
        other.currency == currency &&
        other.senderId == senderId &&
        other.receiverId == receiverId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        amount.hashCode ^
        image.hashCode ^
        currency.hashCode ^
        senderId.hashCode ^
        receiverId.hashCode;
  }
}
