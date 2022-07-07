import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../_product/widgets/bottom-sheet/custom_bottom_sheet.dart';
import '../../_product/widgets/button/custom_button.dart';
import '../../_product/widgets/text-form-field/custom_text_form_field.dart';

void main() {
  const title = 'Vanilla Sample 101';

  runApp(
    const MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: MyPage(),
    ),
  );
}

class Contact {
  final String id;
  final String name;

  Contact({
    required this.name,
  }) : id = const Uuid().v4();
}

class ContactBook extends ValueNotifier<List<Contact>> {
  ContactBook._init() : super([]);
  static final ContactBook _instance = ContactBook._init();
  factory ContactBook() => _instance;

  int get length => value.length;

  void add({required Contact contact}) {
    value.add(contact);
    notifyListeners();
  }

  void remove({required Contact contact}) {
    value.remove(contact);
    notifyListeners();
  }
}

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  final title = 'Vanilla 101 - Single Variable';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<Contact>>(
        valueListenable: ContactBook(),
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              final contact = value[index];
              return Dismissible(
                key: ValueKey(contact.id),
                onDismissed: (direction) {
                  ContactBook().remove(contact: contact);
                },
                child: Card(
                  margin: const EdgeInsets.all(6),
                  child: ListTile(
                    title: Text(contact.name),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addContact(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addContact(BuildContext context) {
    const hintText = 'Name';
    const buttonText = 'Add';
    String text = '';

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      context: context,
      builder: (c) => CustomBottomSheet(
        children: [
          CustomTextFormField(
            hintText: hintText,
            onChanged: (value) => text = value,
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: buttonText,
            onPressed: () {
              final contact = Contact(name: text);
              ContactBook().add(contact: contact);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
