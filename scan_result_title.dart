import 'package:flutter/material.dart';
import 'scan_result.dart';

/// عنصر عرض نتيجة فحص منفذ واحد
class ScanResultTile extends StatelessWidget {
  final PortScanResult result;

  const ScanResultTile({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOpen = result.status == PortStatus.open;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isOpen
              ? Colors.green.withOpacity(0.15)
              : theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            isOpen ? Icons.lock_open : Icons.lock,
            color: isOpen ? Colors.green : theme.colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text('المنفذ ${result.port}'),
        subtitle: Text(
          isOpen ? 'مفتوح' : 'مغلق',
          style: TextStyle(
            color:
            isOpen ? Colors.green : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          isOpen ? Icons.check_circle : Icons.cancel_outlined,
          color: isOpen ? Colors.green : theme.colorScheme.outline,
        ),
      ),
    );
  }
}
