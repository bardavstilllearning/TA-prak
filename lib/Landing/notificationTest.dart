import 'package:flutter/material.dart';
import '../controller/notificationController.dart';
import 'widgets/custom_snackbar.dart';

class NotificationTestPage extends StatefulWidget {
  const NotificationTestPage({super.key});

  @override
  State<NotificationTestPage> createState() => _NotificationTestPageState();
}

class _NotificationTestPageState extends State<NotificationTestPage> {
  final NotificationController _controller = NotificationController();

  @override
  void initState() {
    super.initState();
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Test Notifikasi',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.analytics,
                      color: Color(0xFF2196F3),
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Total Notifikasi',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    ValueListenableBuilder<int>(
                      valueListenable: _controller.totalSent,
                      builder: (context, total, child) {
                        return Text(
                          '$total',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2196F3),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // button test notifikasi gempa
              _buildTestButton(
                icon: Icons.notifications_active,
                title: 'Test Notifikasi Gempa',
                color: const Color(0xFFFF9800),
                onPressed: _controller.sendTest,
              ),

              const SizedBox(height: 12),

              _buildTestButton(
                icon: Icons.directions_run,
                title: 'Peringatan Evakuasi',
                color: const Color(0xFFF44336),
                onPressed: _controller.sendEvacuation,
              ),

              const SizedBox(height: 20),

              // tes terjadwal card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.schedule, color: Color(0xFF9C27B0)),
                        SizedBox(width: 8),
                        Text(
                          'Test Terjadwal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildScheduleButton(
                            title: '1 Menit',
                            onPressed: () =>
                                _controller.scheduleTest(delayMinutes: 1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildScheduleButton(
                            title: '2 Menit',
                            onPressed: () =>
                                _controller.scheduleTest(delayMinutes: 2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Auto Test Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.autorenew, color: Color(0xFF4CAF50)),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Auto Test',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Kirim otomatis setiap 10 detik',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _controller.isAutoActive,
                      builder: (context, isActive, child) {
                        return Switch(
                          value: isActive,
                          onChanged: (value) {
                            if (value) {
                              _controller.startAuto();
                              CustomSnackbar.show(
                                context,
                                message: "Auto tes dimulai",
                                backgroundColor: Colors.red,
                              );
                            } else {
                              _controller.stopAuto();
                              CustomSnackbar.show(
                                context,
                                message: "Auto test dihentikan",
                                backgroundColor: Colors.red,
                              );
                            }
                          },
                          activeColor: const Color(0xFF4CAF50),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // cancel button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _controller.cancelAll();

                    CustomSnackbar.show(
                      context,
                      message: "Semua notifikasi dibatalkan",
                      backgroundColor: Colors.red,
                    );
                  },
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Batalkan Semua'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildScheduleButton({
    required String title,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
        CustomSnackbar.show(
          context,
          message: "Test dijadwalkan untuk $title",
          backgroundColor: Colors.red,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF9C27B0).withOpacity(0.1),
        foregroundColor: const Color(0xFF9C27B0),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: const Color(0xFF9C27B0).withOpacity(0.3)),
        ),
        elevation: 0,
      ),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
