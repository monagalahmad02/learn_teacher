import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contoller/challange_controller/add_challange_controller.dart';

class CreateChallengePage extends StatefulWidget {
  const CreateChallengePage({super.key});

  @override
  State<CreateChallengePage> createState() => _CreateChallengePageState();
}

class _CreateChallengePageState extends State<CreateChallengePage> {
  final ChallengeController controller = Get.put(ChallengeController());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  DateTime? selectedStartTime;
  int? durationMinutes;

  /// Pick date & time
  Future<void> _pickStartDateTime() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (pickedTime != null) {
        final fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          selectedStartTime = fullDateTime;
          startTimeController.text =
          "${pickedDate.year}-${pickedDate.month}-${pickedDate.day} ${pickedTime.hour}:${pickedTime.minute}";
        });
      }
    }
  }

  void _submitChallenge() async {
    if (titleController.text.isEmpty || selectedStartTime == null || durationController.text.isEmpty) {
      Get.snackbar("Warning", "Please fill in all fields");
      return;
    }

    final minutes = int.tryParse(durationController.text);
    if (minutes == null || minutes <= 0) {
      Get.snackbar("Warning", "Please enter a valid duration in minutes");
      return;
    }

    durationMinutes = minutes;

    await controller.createChallenge(
      title: titleController.text,
      startTime: selectedStartTime.toString(),
      durationMinutes: durationMinutes!,
    );

    // ⚡️ تفريغ الحقول فقط إذا ما صار خطأ
    if (!controller.isLoading.value) {
      titleController.clear();
      startTimeController.clear();
      durationController.clear();
      selectedStartTime = null;
      durationMinutes = null;
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.teal),
      filled: true,
      fillColor: Colors.teal.withOpacity(0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.teal, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Create Challenge", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 35.0),
                  child: Text("Please! .. Enter a new challenge", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), ),
                ),
                const SizedBox(height: 25,),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: titleController,
                    decoration: _inputDecoration("Challenge Title", Icons.title),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: startTimeController,
                    readOnly: true,
                    onTap: _pickStartDateTime,
                    decoration: _inputDecoration("Start Time", Icons.calendar_month),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration("Duration (minutes)", Icons.timer),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: _submitChallenge,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Submit Challenge",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
