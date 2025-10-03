import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contoller/profile_controller/edit_profile_controller.dart';
import '../../contoller/subject_controller/subject_controller.dart'; // ✅ استدعاء الكنترولر تبع المواد

class EditeProfilePage extends StatelessWidget {
  EditeProfilePage({super.key});

  final EditProfileController controller = Get.put(EditProfileController());
  final SubjectController subjectController = Get.put(SubjectController()); // ✅ ربط الكنترولر
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        return controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  kToolbarHeight - 32,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Please enter your information!',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Teaching start date
                            _buildTextField(
                              controller:
                              controller.teachingDateController,
                              label: 'Teaching Start Date',
                              readOnly: true,
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1980),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  final formatted = pickedDate
                                      .toIso8601String()
                                      .split('T')
                                      .first;
                                  controller
                                      .teachingDateController.text =
                                      formatted;
                                  controller.teachingStartDate.value =
                                      formatted;
                                }
                              },
                            ),
                            const SizedBox(height: 12),

                            // Province
                            _buildTextField(
                              controller: TextEditingController(
                                  text: controller.province.value),
                              label: 'Province',
                              readOnly: true,
                              onTap: () {
                                _showProvincePicker(context);
                              },
                            ),
                            const SizedBox(height: 12),

                            // Specialization (Subjects API)
                            _buildTextField(
                              controller: TextEditingController(
                                  text: controller.specialization.value),
                              label: 'Specialization',
                              readOnly: true,
                              onTap: () {
                                _showSubjectPicker(context);
                              },
                            ),
                            const SizedBox(height: 12),

                            // Bio
                            _buildTextField(
                              label: 'Bio',
                              maxLines: 3,
                              onChanged: (val) => controller.bio.value =
                                  val,
                            ),
                            const SizedBox(height: 12),

                            // Age
                            _buildTextField(
                              label: 'Age',
                              keyboardType: TextInputType.number,
                              onChanged: (val) => controller.age.value =
                                  val,
                            ),
                            const SizedBox(height: 20),

                            // Save button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    controller.submitProfile();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Save Changes',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  /// Province picker
  void _showProvincePicker(BuildContext context) {
    final provinces = [
      "Damascus",
      "Rif Dimashq",
      "Aleppo",
      "Homs",
      "Hama",
      "Latakia",
      "Tartus",
      "Idlib",
      "Deir ez-Zor",
      "Hasakah",
      "Raqqa",
      "Daraa",
      "As-Suwayda",
      "Quneitra",
    ];

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: provinces.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(provinces[index]),
              onTap: () {
                controller.province.value = provinces[index];
                Get.back();
              },
            );
          },
        ),
      ),
    );
  }

  /// Subject picker from API
  void _showSubjectPicker(BuildContext context) async {
    await subjectController.fetchSubjects(); // ✅ استدعاء API

    Get.bottomSheet(
      Obx(() {
        if (subjectController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (subjectController.subjectList.isEmpty) {
          return const Center(child: Text("No subjects available"));
        }

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: subjectController.subjectList.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final subject = subjectController.subjectList[index];
              return ListTile(
                title: Text(subject.title), // ✅ عرض اسم المادة فقط
                onTap: () {
                  controller.specialization.value = subject.title;
                  Get.back();
                },
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    String? label,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: validator ??
              (val) => (val == null || val.isEmpty) ? 'Required' : null,
      onChanged: onChanged,
    );
  }
}
