import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/controllers/gym_controller.dart';
import 'package:pocketpersonaltrainer/src/controllers/user_controller.dart';
import 'package:pocketpersonaltrainer/src/ui/gyms/gyms_view.dart';
import 'package:pocketpersonaltrainer/src/ui/settings/settings_view.dart';
import 'package:pocketpersonaltrainer/src/widgets/ads/custom_ads.dart';
import '../../app/theme/text_theme.dart';
import 'package:pocketpersonaltrainer/src/ui/category/category_view.dart';
import 'package:pocketpersonaltrainer/src/ui/home/widgets/multi-floatactionbutton/multi_floatbutton.dart';
import 'package:pocketpersonaltrainer/src/ui/home/widgets/multi-floatactionbutton/widgets/action_button.dart';
import 'package:pocketpersonaltrainer/src/ui/home/widgets/user_exercises_list.dart';
import 'package:pocketpersonaltrainer/src/ui/profile/profile_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //}  {
  late PageController pageController;
  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBar(BuildContext context) {
    return [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home),
        label: AppLocalizations.of(context)!.menuItem1Text,
      ),
      BottomNavigationBarItem(icon: const Icon(Icons.list), label: AppLocalizations.of(context)!.menuItem2Text),
      BottomNavigationBarItem(icon: const Icon(Icons.person), label: AppLocalizations.of(context)!.menuItem3Text),
      BottomNavigationBarItem(icon: const Icon(Icons.store), label: AppLocalizations.of(context)!.menuItem5Text),
    ];
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  Widget buildHomeView() {
    return Stack(
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.bottomCenter,
      fit: StackFit.loose,
      children: [
        Positioned(
          top: 0,
          left: 15,
          right: 15,
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              AppLocalizations.of(context)!.bemvindo,
              style: AppTextTheme.theme.headlineSmall,
            ),
          ),
        ),
        Positioned(
          top: 25,
          left: 15,
          right: 15,
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              AppLocalizations.of(context)!.exerciseListTitle,
              style: AppTextTheme.theme.headlineSmall,
            ),
          ),
        ),
        Positioned(
          top: 50,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              child: UserExerciseList(
                currentUser: Get.find<UserController>(tag: 'user').user!,
                pageContrller: pageController,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: CustomAds(isSmall: true),
        ),
      ],
    );
  }

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: [
        buildHomeView(),
        const CategoryPage(),
        ProfileScreen(model: Get.find<UserController>(tag: 'user').user!),
        GymsView(
          controller: Get.find<GymController>(tag: 'gyms'),
        ),
      ],
    );
  }

  @override
  void initState() {
    pageController = PageController();
    //initSettingsController(widget.settingsController);
    Get.find<GymController>(tag: 'gyms').loadAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage()));
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: true,
        useLegacyColorScheme: false,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: bottomSelectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.3799999952316284),
        onTap: (index) {
          bottomTapped(index);
        },
        items: buildBottomNavBar(context),
      ),
      floatingActionButton: ExpandableFab(
        distance: 100,
        children: [
          ActionButton(
            icon: Icon(
              Icons.camera_alt,
              color: Theme.of(context).primaryColor,
            ),
          ),
          ActionButton(
            icon: Icon(
              Icons.book,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
