import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contoller/auth_controller/change_password_controller.dart';
import '../../contoller/auth_controller/login_controller.dart';
import 'change_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController loginController = Get.put(LoginController());
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ChangePasswordController changePasswordController = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Center(
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center( // <-- هذا يخلي المحتوى بالنص
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min, // <-- يمنع التمدد العمودي
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  child: Text(
                    'Welcome back',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Phone Number',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: 'Enter your phone number',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() => TextField(
                          controller: passwordController,
                          obscureText: loginController.obscurePassword.value,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(loginController.obscurePassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                loginController.obscurePassword.toggle();
                              },
                            ),
                          ),
                        )),
                        const SizedBox(height: 30),
                        Obx(() => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            onPressed: loginController.isLoading.value
                                ? null
                                : () {
                              final phone = phoneController.text.trim();
                              final password = passwordController.text.trim();

                              if (phone.isEmpty || password.isEmpty) {
                                Get.snackbar('Error', 'Please enter phone and password');
                                return;
                              }

                              loginController.login(phone, password);
                            },
                            child: loginController.isLoading.value
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : const Text(
                              'Login',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        )),
                        TextButton(
                          onPressed: () {
                            Get.to(() => ChangePasswordPage());
                          },
                          child: const Text(
                            'Change password',
                            style: TextStyle(color: Colors.teal),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
