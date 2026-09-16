/// حالة المنفذ
enum PortStatus { open, closed, error }

/// نتيجة فحص منفذ واحد
class PortScanResult {
  final int port;
  final PortStatus status;

  PortScanResult({
    required this.port,
    required this.status,
  });
}
