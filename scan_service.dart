import 'package:dart_port_scanner/dart_port_scanner.dart';
import 'scan_result.dart';

/// ⚙️ هذا الملف يحتوي على منطق الفحص فقط.
/// لا يُستدعى إلا عند الضغط على زر "بدء الفحص" من الواجهة.
class ScanService {
  /// فحص قائمة منافذ على مضيف معين وإرجاع Stream بالنتائج.
  Stream<PortScanResult> scanPorts(
      String host,
      List<int> ports, {
        int parallelism = 50,
      }) async* {
    if (host.trim().isEmpty) {
      throw ArgumentError('عنوان المضيف لا يمكن أن يكون فارغاً.');
    }
    if (ports.isEmpty) {
      throw ArgumentError('قائمة المنافذ لا يمكن أن تكون فارغة.');
    }

    try {
      final task = TcpScannerTask(host, ports, parallelism: parallelism);
      final report = await task.start();

      for (var port in ports) {
        if (report.openPorts.contains(port)) {
          yield PortScanResult(port: port, status: PortStatus.open);
        } else {
          yield PortScanResult(port: port, status: PortStatus.closed);
        }
      }
    } catch (e) {
      for (var port in ports) {
        yield PortScanResult(port: port, status: PortStatus.error);
      }
    }
  }

  /// تحويل نص المستخدم إلى قائمة أرقام منافذ صحيحة.
  List<int> parsePorts(String input) {
    if (input.trim().isEmpty) return [];
    return input
        .split(',')
        .map((s) => int.tryParse(s.trim()))
        .whereType<int>()
        .where((p) => p > 0 && p <= 65535)
        .toList();
  }
}
