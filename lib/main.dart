import 'package:flutter/material.dart';
import 'package:qr_app/pages/qr_craete.dart';
import 'package:qr_app/pages/qr_reader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/qr_create': (context) => const QrCraete(),
        '/qr_reader': (context) => const QrReader(),
      },
      initialRoute: '/qr_reader',
    );
  }
}