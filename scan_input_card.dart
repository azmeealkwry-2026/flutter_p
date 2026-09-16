import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// بطاقة إدخال بيانات الفحص (المضيف + المنافذ + زر البدء)
class ScanInputCard extends StatelessWidget {
  final TextEditingController hostController;
  final TextEditingController portsController;
  final bool isScanning;
  final VoidCallback onScanPressed;

  const ScanInputCard({
    super.key,
    required this.hostController,
    required this.portsController,
    required this.isScanning,
    required this.onScanPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إعدادات الفحص',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: hostController,
              decoration: const InputDecoration(
                labelText: 'عنوان المضيف (IP أو النطاق)',
                hintText: 'مثال: 127.0.0.1 أو google.com',
                prefixIcon: Icon(Icons.dns_outlined),
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.next,
              enabled: !isScanning,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: portsController,
              decoration: const InputDecoration(
                labelText: 'المنافذ (مفصولة بفواصل)',
                hintText: 'مثال: 22,80,443,3306',
                prefixIcon: Icon(Icons.numbers),
              ),
              keyboardType: TextInputType.text,
              enabled: !isScanning,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9,\s]')),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                // ⬇️ عند الضغط يُستدعى onScanPressed الذي ينفذ كود الفحص
                onPressed: isScanning ? null : onScanPressed,
                icon: isScanning
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.search),
                label: Text(isScanning ? 'جاري الفحص...' : 'بدء الفحص'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
