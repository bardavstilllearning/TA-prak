import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'router/appRouter.dart';
import 'services/notificationService.dart';
import 'services/databaseService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);
  await NotificationService.initialize();
  NotificationService.setupListeners();

  await DatabaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bencanaku',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(textTheme: GoogleFonts.plusJakartaSansTextTheme()),
      locale: const Locale('id', 'ID'),
    );
  }
}
