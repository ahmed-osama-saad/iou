import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iou/models/receipt.dart';
import 'package:iou/services/database.dart';
import 'package:iou/models/user.dart';

final userProvider =
    FutureProvider.family.autoDispose<User, int>((ref, int id) async {
  return DatabaseService().user(id);
});
final usersProvider = FutureProvider.autoDispose<List<User>>((ref) async {
  return DatabaseService().users();
});
final addUserProvider =
    FutureProvider.family<void, User>((ref, User user) async {
  return DatabaseService().insertUser(user);
});
final receiptsProvider = FutureProvider.autoDispose<List<Receipt>>((ref) async {
  return DatabaseService().receipts();
});
final addReceiptProvider =
    FutureProvider.family<void, Receipt>((ref, Receipt receipt) async {
  return DatabaseService().insertReceipt(receipt);
});
