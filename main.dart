import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'port_scanner_page.dart';

void main() {
  runApp(const PortScannerApp());
}

/// التطبيق الرئيسي - يستقبل الواجهة من ملف خارجي
class PortScannerApp extends StatelessWidget {
  const PortScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'فاحص المنافذ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // ⬇️ الواجهة تأتي من ملف خارجي (screens/port_scanner_page.dart)
      home: const PortScannerPage(),
    );
  }
}
