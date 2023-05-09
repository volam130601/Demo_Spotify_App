import 'package:demo_spotify_app/views/library/library_screen.dart';
import 'package:flutter/material.dart';

import '../views/home/home_screen.dart';
import '../views/search/search_screen.dart';
import '../views/settings/settings_screen.dart';

class LayoutScreenViewModel with ChangeNotifier {
  final List<Widget> _pageWidget = const [
    HomeScreen(),
    SearchScreen(),
    LibraryScreen(),
    SettingScreen(),
  ];

  int _pageIndex = 0;

  Widget _screen = const SizedBox();

  Widget get screen => _screen;

  void setScreenWidget() {
    _screen = _pageWidget[_pageIndex];
  }

  int get pageIndex => _pageIndex;

  void setIsShotBottomBar(newValue) {
    notifyListeners();
  }

  void setPageIndex(newValue) {
    _pageIndex = newValue;
    notifyListeners();
  }

  void clear() {
    _pageIndex = 0;
  }
}
