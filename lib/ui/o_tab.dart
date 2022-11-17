import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iou/models/user.dart';
import 'package:iou/services/providers.dart';

class OTab extends ConsumerWidget {
  const OTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptsAscync = ref.watch(receiptsProvider);
    return receiptsAscync.when(
      data: (receipts) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: receipts.length,
                  itemBuilder: (context, index) {
                    final senderAsync =
                        ref.watch(userProvider(receipts[index].senderId));
                    User? sender;
                    senderAsync.whenData(
                      (value) => sender = value,
                    );
                    final receiverAsync =
                        ref.watch(userProvider(receipts[index].receiverId));
                    User? receiver;
                    receiverAsync.whenData((value) => receiver = value);
                    return Card(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                                '${receipts[index].amount} ${receipts[index].currency}'),
                          ),
                          Expanded(
                              child: Text(
                                  'From ${sender?.name} To ${receiver?.name}')),
                          Expanded(
                            child: Text('${receipts[index].description}'),
                          ),
                          ElevatedButton(
                              onPressed: (receipts[index].image != null)
                                  ? () async {
                                      await showDialog(
                                          context: context,
                                          builder: (_) => ImageDialog(
                                                rawImage:
                                                    receipts[index].image!,
                                              ));
                                    }
                                  : null,
                              child: const Text('Image'))
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return ErrorWidget(error);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class ImageDialog extends StatelessWidget {
  const ImageDialog({super.key, required this.rawImage});
  final Uint8List rawImage;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(image: MemoryImage(rawImage)),
        ),
      ),
    );
  }
}
