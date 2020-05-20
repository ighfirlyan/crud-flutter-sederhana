//kode utama Aplikasi tampilan awal
import 'package:flutter/material.dart';
import 'package:crud_flutter_sqlite_cp/ui/home.dart';

//package letak folder Anda
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //judul
      debugShowCheckedModeBanner: false,
      title: 'Tambahkan Daftar',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Home(),
    );
  }
}
