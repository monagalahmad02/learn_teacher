import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contoller/auth_controller/change_password_controller.dart';

class ChangePasswordPage extends StatelessWidget {
  final ChangePasswordController controller = Get.put(ChangePasswordController());

  ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight - 40,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0 , horizontal: 20),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0 , horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(child: Text('you can change your password', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)),
                      const SizedBox(height: 30),
                      Obx(() => TextField(
                        controller: controller.oldPasswordController,
                        obscureText: !controller.showOldPassword.value,
                        decoration: InputDecoration(
                          labelText: 'Old Password',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.showOldPassword.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              controller.showOldPassword.toggle();
                            },
                          ),
                        ),
                      )),
                      const SizedBox(height: 20),

                      // New Password
                      Obx(() => TextField(
                        controller: controller.newPasswordController,
                        obscureText: !controller.showNewPassword.value,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.showNewPassword.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              controller.showNewPassword.toggle();
                            },
                          ),
                        ),
                      )),
                      const SizedBox(height: 30),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final message = await controller.changePassword();

                            Get.snackbar(
                              "Change Password",
                              message,
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.white,
                              colorText: Colors.black,
                              duration: const Duration(seconds: 3),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
