import 'package:flutter/material.dart';
import 'package:ott_platforms_app/screens/homepage.dart';
import 'package:ott_platforms_app/screens/sitepage.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const HomePage(),
        'site_page': (context) => const SitePage(),
      },
    ),
  );
}
