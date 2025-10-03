import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contoller/subject_controller/subject_controller.dart';
import '../../contoller/user_controller/get_user_controller.dart';
import '../../contoller/notification_controller/notification_unread_count_controller.dart';
import '../challenge_wedght/create_challenge_page.dart';
import '../challenge_wedght/view_challenge_page.dart';
import '../favorite_page/favorite_page.dart';
import '../notification_page/notification_page.dart';
import '../profile_page/profile_page.dart';
import '../requst_student_page/get_student_in_subject_page.dart';
import '../requst_student_page/get_student_request_page.dart';
import '../student_favorite_page/all_student_in_app_page.dart';
import '../student_favorite_page/student_favorite_page.dart';
import 'home_content.dart';
import 'chat_content.dart';

class HomePage extends StatefulWidget {
  final int teacherId;

  const HomePage({super.key, required this.teacherId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SubjectController subjectController = Get.put(SubjectController());
  final UserController userController = Get.put(UserController());
  final NotificationUnreadCountController notificationController =
  Get.put(NotificationUnreadCountController());

  int _currentIndex = 0;

  late final List<Widget> _pages;
  late final List<String> _titles;

  @override
  void initState() {
    super.initState();
    subjectController.fetchSubjects();
    userController.fetchUser();
    notificationController.fetchUnreadCount();


    _pages = [
      HomeContent(),
      FavoritesPage(),
      const ChatContent(),
      ProfilePage(teacherId: widget.teacherId),
    ];

    _titles = [
      'Home Page',
      'Favorites',
      'Chat',
      'Profile',
    ];
  }

  void showMoreOptions(BuildContext context, Offset offset) async {
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
          offset.dx, offset.dy, offset.dx + 1, offset.dy + 1),
      items: [
        const PopupMenuItem(
          value: 'view_student',
          child: Text('View Student'),
        ),
        const PopupMenuItem(
          value: 'add_student',
          child: Text('Add Student'),
        ),
      ],
    );

    if (selected == 'view_student') {
      Get.to(() => FavoriteStudentsPage());
    } else if (selected == 'add_student') {
      Get.to(() => AllStudentPage());
    } else if (selected == 'create_challenge') {
      Get.to(() => CreateChallengePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Center(
          child: Text(
            _titles[_currentIndex],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Obx(() {
            int count = notificationController.unreadCount.value;
            return Stack(
              children: [
                IconButton(
                  onPressed: () async {
                    await Get.to(() => const NotificationPage());
                    // refresh count after back
                    notificationController.fetchUnreadCount();
                  },
                  icon: const Icon(Icons.notifications),
                ),
                if (count > 0)
                  Positioned(
                    right: 4,
                    top: 3,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 10,
                      ),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          }),
          if (_currentIndex == 1)
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    final RenderBox button =
                    context.findRenderObject() as RenderBox;
                    final RenderBox overlay =
                    Overlay.of(context).context.findRenderObject()
                    as RenderBox;
                    final Offset offset =
                    button.localToGlobal(Offset.zero, ancestor: overlay);
                    showMoreOptions(context, offset);
                  },
                );
              },
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Obx(() {
              if (userController.isLoading.value) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.24,
                  child: const Center(
                      child:
                      CircularProgressIndicator(color: Colors.white)),
                );
              }

              final user = userController.user.value;
              return Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: (user?.userImage != null &&
                            user!.userImage!.isNotEmpty)
                            ? NetworkImage(user.userImage!)
                            : null,
                        child: (user?.userImage == null ||
                            user!.userImage!.isEmpty)
                            ? Icon(Icons.person,
                            size: 70, color: Colors.teal.shade300)
                            : null,
                      ),
                      Text(
                        user?.name ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_agenda_sharp),
              title: const Text('View student in subject'),
              onTap: () {
                Get.to(() => StudentInSubjectPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.request_quote_rounded),
              title: const Text('View request student'),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => RequestsPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('View Challenge'),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const ChallengePage());
              },
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
