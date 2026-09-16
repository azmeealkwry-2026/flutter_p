import 'package:flutter/material.dart';
import 'scan_result.dart';
import 'scan_service.dart';
import 'scan_input_card.dart';
import 'results_list.dart';
import 'empty_state_widget.dart';
import 'error_banner.dart';

/// الواجهة الرئيسية - تجمع كل الـ widgets وتربطها بمنطق الفحص
class PortScannerPage extends StatefulWidget {
  const PortScannerPage({super.key});

  @override
  State<PortScannerPage> createState() => _PortScannerPageState();
}

class _PortScannerPageState extends State<PortScannerPage> {
  // وحدات التحكم بالنصوص
  final _hostController = TextEditingController(text: '127.0.0.1');
  final _portsController =
  TextEditingController(text: '22,80,443,3306,5432,8080');

  // خدمة الفحص (ملف الأكواد)
  final _scanService = ScanService();

  // حالة الواجهة
  bool _isScanning = false;
  List<PortScanResult> _results = [];
  String? _errorMessage;

  @override
  void dispose() {
    _hostController.dispose();
    _portsController.dispose();
    super.dispose();
  }

  /// 🔘 يُستدعى عند الضغط على زر "بدء الفحص"
  /// هنا ننتقل إلى أكواد الفحص في scan_service.dart
  Future<void> _startScan() async {
    setState(() {
      _results = [];
      _errorMessage = null;
      _isScanning = true;
    });

    final host = _hostController.text.trim();
    final ports = _scanService.parsePorts(_portsController.text);

    // التحقق من المدخلات
    if (host.isEmpty) {
      setState(() {
        _errorMessage = 'الرجاء إدخال عنوان المضيف (IP أو النطاق).';
        _isScanning = false;
      });
      return;
    }

    if (ports.isEmpty) {
      setState(() {
        _errorMessage = 'الرجاء إدخال منفذ واحد على الأقل (مفصولة بفواصل).';
        _isScanning = false;
      });
      return;
    }

    try {
      // ⬇️ هنا يتم استدعاء أكواد الفحص من الملف المنفصل
      await for (final result in _scanService.scanPorts(host, ports)) {
        if (mounted) {
          setState(() {
            _results.add(result);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'حدث خطأ أثناء الفحص: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('فاحص المنافذ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'فاحص المنافذ',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.security),
                children: const [
                  Text('أداة بسيطة لفحص المنافذ المفتوحة على مضيف معين.'),
                ],
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1️⃣ بطاقة الإدخال
            ScanInputCard(
              hostController: _hostController,
              portsController: _portsController,
              isScanning: _isScanning,
              onScanPressed: _startScan, // ⬅️ عند الضغط يُستدعى كود الفحص
            ),
            const SizedBox(height: 16),

            // 2️⃣ شريط الأخطاء (يظهر فقط عند وجود خطأ)
            if (_errorMessage != null) ErrorBanner(message: _errorMessage!),

            // 3️⃣ منطقة عرض النتائج
            Expanded(
              child: _results.isEmpty && !_isScanning
                  ? const EmptyStateWidget()
                  : _results.isEmpty && _isScanning
                  ? const Center(child: Text('بدء الفحص...'))
                  : ResultsList(results: _results),
            ),
          ],
        ),
      ),
    );
  }
}
