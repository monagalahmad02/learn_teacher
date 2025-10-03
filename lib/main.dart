import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project2teacher/widght/auth_page/login_page.dart';
import 'package:project2teacher/widght/home_page/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final box = GetStorage();
  final String? token = box.read('token');
  final int? teacherId = box.read('teacherId');

  runApp(MyApp(token: token, teacherId: teacherId));
}

class MyApp extends StatelessWidget {
  final String? token;
  final int? teacherId;

  const MyApp({super.key, this.token, this.teacherId});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/login',  //(token != null && teacherId != null) ? '/home' :
      getPages: [
        GetPage(
          name: '/home',
          page: () {
            if (teacherId != null) {
              return HomePage(teacherId: teacherId!);
            } else {
              return const LoginPage();
            }
          },
        ),
        GetPage(name: '/login', page: () => const LoginPage()),
      ],

    );
  }
}

