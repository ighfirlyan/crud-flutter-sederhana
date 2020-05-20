//letak package folder flutter
import 'package:flutter/material.dart';
import 'package:crud_flutter_sqlite_cp/ui/entryform.dart';
import 'package:crud_flutter_sqlite_cp/models/contact.dart';
import 'package:crud_flutter_sqlite_cp/helpers/dbhelper.dart';
//untuk memanggil fungsi yg terdapat di daftar pustaka sqflite
import 'package:sqflite/sqflite.dart';
//pendukung program asinkron
import 'dart:async';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  //membuat object dbHelper
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Contact> contactList;

  @override
  Widget build(BuildContext context) {
    if (contactList == null) {
      contactList = List<Contact>();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Kontak Telepon'),
      ),
      body: createListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Add Contact',
        onPressed: () async {
          var contact = await navigateToEntryForm(context, null);
          if (contact != null) addContact(contact);
        },
      ),
    );
  }

  //method untuk pindah halaman sekaligus mengupdate data setelah ditambah/diedit
  Future<Contact> navigateToEntryForm(
      BuildContext context, Contact contact) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryForm(contact);
    }));
    return result;
  }

  //method untuk membuat tampilan listview yang dapat discroll
  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            title: Text(
              this.contactList[index].name,
              style: textStyle,
            ),
            subtitle: Text(this.contactList[index].phone),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () {
                deleteContact(contactList[index]);
              },
            ),
            onTap: () async {
              var contact =
                  await navigateToEntryForm(context, this.contactList[index]);
              if (contact != null) editContact(contact);
            },
          ),
        );
      },
    );
  }

  //membuat contact
  void addContact(Contact object) async {
    int result = await dbHelper.insert(object);
    if (result > 0) {
      updateListView();
    }
  }

  //mengedit contact
  void editContact(Contact object) async {
    int result = await dbHelper.update(object);
    if (result > 0) {
      updateListView();
    }
  }

  //menghapus contact
  void deleteContact(Contact object) async {
    int result = await dbHelper.delete(object.id);
    if (result > 0) {
      updateListView();
    }
  }

  //mengupdate contact
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Contact>> contactListFuture = dbHelper.getContactList();
      contactListFuture.then((contactList) {
        setState(() {
          this.contactList = contactList;
          this.count = contactList.length;
        });
      });
    });
  }
}
