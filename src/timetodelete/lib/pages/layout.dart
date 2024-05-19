import 'package:flutter/material.dart';
import 'package:timetodelete/data/theme_data.dart';
import 'package:timetodelete/pages/home.dart';
import 'package:timetodelete/pages/scheduled_files.dart';
import 'package:timetodelete/pages/settings.dart';
import 'package:timetodelete/main.dart';

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  Future<void> importantChecks() async {
    await isBatteryOptimizationDisable();
    await initializeService();
  }

  @override
  void initState() {
    super.initState();
    importantChecks();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MediaQuery.of(context).platformBrightness == Brightness.dark
          ? darkTheme
          : lightTheme,
      home: Scaffold(
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) => setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          }),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              label: 'Scheduled Files',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (value) => setState(() => _selectedIndex = value),
          children: const <Widget>[
            Home(),
            ScheduledFiles(),
            Settings(),
          ],
        ),
      ),
    );
  }
}
