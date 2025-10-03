import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project2teacher/widght/favorite_page/view_bank_quastion_page.dart';
import '../../contoller/favorite_controller/add_test_fav_controller.dart';
import '../../contoller/favorite_controller/view_all_test_controller.dart';
import '../test_page/view_test_page.dart';

class FavoritesPage extends StatefulWidget {
  FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavTestController controller = Get.put(FavTestController());
  final AddTestToFavoriteController addTestToFavoriteController =
      Get.put(AddTestToFavoriteController());

  @override
  void initState() {
    super.initState();
    controller.fetchFavTests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return RefreshIndicator(
              onRefresh: () async {
                await controller.fetchFavTests();
              },
              child: const Center(child: CircularProgressIndicator()));
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchFavTests();
          },
          child: controller.tests.isEmpty
              ? const Center(child: Text("There are no favorite tests."))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: controller.tests.length,
                  itemBuilder: (context, index) {
                    final test = controller.tests[index];

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Text('${test.id}',
                              style: const TextStyle(color: Colors.white)),
                        ),
                        title: Text(
                          'Test ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Get.to(() => TestScreen(testId: test.id));
                        },
                      ),
                    );
                  },
                ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Get.to(() => const ViewBankQuastionPage());
        },
      ),
    );
  }
}
