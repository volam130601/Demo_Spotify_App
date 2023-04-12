import 'package:flutter/material.dart';

import '../views/home/home_screen.dart';
import '../views/layout_screen.dart';
import '../views/search/search_screen.dart';

class LayoutScreenViewModel with ChangeNotifier {
  final List<Widget> _pageWidget = const [
    HomeScreen(),
    SearchScreen(),
    Placeholder(),
    ProfileScreen(),
  ];

  bool _isShowBottomBar = true;
  int _pageIndex = 0;

  Widget _screen = const SizedBox();

  Widget get screen => _screen;

  void setScreenWidget() {
    _screen = _pageWidget[_pageIndex];
  }

  bool get isShowBottomBar => _isShowBottomBar;

  int get pageIndex => _pageIndex;

  void setIsShotBottomBar(newValue) {
    _isShowBottomBar = newValue;
    notifyListeners();
  }

  void setPageIndex(newValue) {
    _pageIndex = newValue;
    notifyListeners();
  }
}
