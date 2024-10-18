import 'package:aplikasimanajemenbuku/helpers/user_info.dart';
import 'package:aplikasimanajemenbuku/ui/buku_page.dart';
import 'package:aplikasimanajemenbuku/ui/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Widget> _initialPage; // Use Future to manage asynchronous page loading

  @override
  void initState() {
    super.initState();
    _initialPage = _checkLoginStatus(); // Initialize the Future
  }

  Future<Widget> _checkLoginStatus() async {
    var token = await UserInfo().getToken();
    return token != null ? const BukuPage() : const LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Manajemen Buku',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Widget>(
        future: _initialPage, // Wait for the Future to complete
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading page'));
          } else {
            return snapshot.data!;
          }
        },
      ),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Courier New',
      ),
    );
  }
}
