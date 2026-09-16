import 'package:flutter/material.dart';
import 'scan_result.dart';
import 'scan_result_title.dart';

/// قائمة عرض نتائج الفحص
class ResultsList extends StatelessWidget {
  final List<PortScanResult> results;

  const ResultsList({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ScanResultTile(result: results[index]);
      },
    );
  }
}
