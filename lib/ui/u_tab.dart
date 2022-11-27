import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:iou/services/providers.dart';
import 'package:iou/models/user.dart';

class UTab extends ConsumerWidget {
  const UTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    Widget _addUserDialog(BuildContext context) {
      final _formKey = GlobalKey<FormBuilderState>();
      return FormBuilder(
        key: _formKey,
        child: AlertDialog(
          title: const Text('Add User'),
          content: FormBuilderTextField(
            name: 'name',
            decoration: const InputDecoration(labelText: 'Name'),
            validator: FormBuilderValidators.required(),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Reset'),
              onPressed: () {
                _formKey.currentState?.reset();
              },
            ),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                if (_formKey.currentState?.saveAndValidate() == true) {
                  debugPrint(_formKey.currentState!.value.toString());
                  final int id = DateTime.now().millisecondsSinceEpoch;
                  final String name = _formKey.currentState!.value['name'];
                  final user = User(id: id, name: name);
                  ref.read(addUserProvider(user));
                  ref.invalidate(usersProvider);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      );
    }

    return usersAsync.when(
      data: (users) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(users[index].name),
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: ((context) => _addUserDialog(context)),
                      );
                    },
                    child: const Text('Add User'),
                  ),
                ],
              )
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
