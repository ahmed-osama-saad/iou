import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iou/models/receipt.dart';
import 'package:iou/services/providers.dart';

class ITab extends ConsumerWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  ITab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);
    return users.when(
        data: (users) {
          List<DropdownMenuItem> usersDropdown = users.map((user) {
            return DropdownMenuItem(value: user.id, child: Text(user.name));
          }).toList();
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: FormBuilderImagePicker(
                              name: 'image',
                              // displayCustomType: (obj) =>
                              //     obj is ApiImage ? obj.imageUrl : obj,
                              decoration: const InputDecoration(
                                labelText: 'Receipt',
                              ),
                              valueTransformer: (value) {
                                final image = value?[0] as XFile?;
                                return image;
                              },
                              showDecoration: false,
                              maxImages: 1,
                              previewAutoSizeWidth: true,
                              // onImage: (image) {},
                              // initialValue: const [
                              //   'https://images.pexels.com/photos/7078045/pexels-photo-7078045.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
                              // ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: FormBuilderTextField(
                              name: 'description',
                              expands: true,
                              maxLines: null,
                              minLines: null,
                              decoration: const InputDecoration(
                                  labelText: 'Description'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: FormBuilderTextField(
                            name: 'amount',
                            decoration:
                                const InputDecoration(labelText: 'Amount'),
                            keyboardType: TextInputType.number,
                            valueTransformer: (value) => num.tryParse(value!),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.numeric(),
                            ]),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FormBuilderDropdown(
                            name: 'currency',
                            decoration:
                                const InputDecoration(labelText: 'Currency'),
                            items: const [
                              DropdownMenuItem(
                                value: 'egp',
                                child: Text('EGP'),
                              ),
                              DropdownMenuItem(
                                value: 'usd',
                                child: Text('USD'),
                              ),
                              DropdownMenuItem(
                                value: 'eur',
                                child: Text('EUR'),
                              ),
                            ],
                            validator: FormBuilderValidators.required(),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: FormBuilderDropdown(
                            name: 'senderId',
                            decoration:
                                const InputDecoration(labelText: 'sender'),
                            items: usersDropdown,
                            validator: FormBuilderValidators.required(),
                          ),
                        ),
                        Expanded(
                          child: FormBuilderDropdown(
                            name: 'receiverId',
                            decoration:
                                const InputDecoration(labelText: 'Receiver'),
                            items: usersDropdown,
                            validator: FormBuilderValidators.required(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: const Text('Submit'),
                            onPressed: () async {
                              if (_formKey.currentState?.saveAndValidate() ==
                                  true) {
                                final formValue = _formKey.currentState!.value;
                                final int id =
                                    DateTime.now().millisecondsSinceEpoch;
                                XFile? image = formValue['image'];
                                Uint8List? imageRaw =
                                    await image?.readAsBytes();
                                Map<String, dynamic> user = Map.of(formValue);
                                user['image'] = imageRaw;
                                user['id'] = id;
                                final Receipt r = Receipt.fromMap(user);
                                ref.read(addReceiptProvider(r));
                                _formKey.currentState?.reset();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            child: const Text('Reset'),
                            onPressed: () {
                              _formKey.currentState?.reset();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return ErrorWidget(error);
        },
        loading: () => const CircularProgressIndicator());
  }
}
