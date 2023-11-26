import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  var _contact;

  Future<void> getContact() async {
    List<Contact> contact = await ContactsService.getContacts();
    print(contact);
    setState(() {
      _contact = contact;
    });
  }

  @override
  initState() {
    getContact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact")),
      body: _contact != null && _contact.length != 0
          ? ListView.builder(
              itemCount: _contact?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Contact? contact = _contact?.elementAt(index);
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                  leading:
                      (contact?.avatar != null && contact!.avatar!.isNotEmpty)
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(contact.avatar!),
                            )
                          : CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(contact!.initials()),
                            ),
                  title: Text(contact.displayName ?? ''),
                );
              },
            )
          : Center(child: Text('Kontak Kosong')),
    );
  }
}
