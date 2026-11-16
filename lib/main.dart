import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latres_mobile/pages/login_page.dart';
import 'package:latres_mobile/pages/main_page.dart';
import 'package:latres_mobile/services/session_service.dart';
import 'package:latres_mobile/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(AppConst.favBox);
  final loggedIn = await SessionService.isLoggedIn();
  runApp(MyApp(loggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConst.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(primary: AppConst.primary),
      ),
      home: loggedIn ? const MainPage() : const LoginPage(),
    );
  }
}
