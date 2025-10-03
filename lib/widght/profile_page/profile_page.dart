import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../contoller/auth_controller/logout_controller.dart';
import '../../contoller/profile_controller/profile_controller.dart';
import '../../contoller/upload_video_pdf_controller/pload_image_profile_controller.dart';
import '../../contoller/user_controller/get_user_controller.dart';
import '../../data/model/profile_model.dart';
import 'edite_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final int teacherId;

  const ProfilePage({super.key, required this.teacherId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController controller = Get.put(ProfileController());
  final UploadProfileImageController imageController = Get.put(UploadProfileImageController());
  final LogOutController logOutController = Get.put(LogOutController());
  final UserController userController = Get.put(UserController());

  final ImagePicker picker = ImagePicker();

  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    controller.fetchProfile(widget.teacherId);
    userController.fetchUser();
  }

  Future<void> pickImageAndUpload() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      await imageController.uploadProfileImage(imageFile);
      await userController.fetchUser();
      await controller.fetchProfile(widget.teacherId);
    } else {
      Get.snackbar("Cancelled", "No image was selected.");
    }
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final ProfileModel? profile = controller.profile.value;

        if (profile == null) {
          return const Center(child: Text("No profile data found."));
        }

        final user = userController.user.value;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 6,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: (user?.userImage != null && user!.userImage!.isNotEmpty)
                              ? NetworkImage(user.userImage!)
                              : null,
                          child: (user?.userImage == null || user!.userImage!.isEmpty)
                              ? Icon(Icons.person, size: 70, color: Colors.teal.shade300)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: pickImageAndUpload,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.teal.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.camera_alt, size: 24, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user?.name ?? '',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user?.email ?? '',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.phone ?? '',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const Divider(height: 40, thickness: 1.2),
                    buildInfoRow(Icons.school, 'Specialization', profile.specialization),
                    buildInfoRow(Icons.cake, 'Age', profile.age.toString()),
                    buildInfoRow(Icons.calendar_today, 'Teaching Start Date', profile.teachingStartDate),
                    buildInfoRow(Icons.location_on, 'Province', profile.province),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 4,
                      ),
                      onPressed: () async {
                        await Get.to(() => EditeProfilePage());
                        controller.fetchProfile(widget.teacherId);
                      },
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.teal,
                        side: const BorderSide(color: Colors.teal),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        logOutController.logout();
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        "Logout",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
      floatingActionButton: Obx(() {
        final profile = controller.profile.value;
        if (profile == null) {
          return FloatingActionButton.extended(
            onPressed: () async {
              await Get.to(() => EditeProfilePage());
              controller.fetchProfile(widget.teacherId);
            },
            icon: const Icon(Icons.add, color: Colors.white,),
            label: const Text("Add Profile", style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.teal,
          );
        } else {
          return  const SizedBox.shrink();
        }
      }),
    );
  }
}
