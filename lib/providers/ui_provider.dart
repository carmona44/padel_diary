import 'package:flutter/material.dart';

class UiProvider extends ChangeNotifier {
  int _selectedTabIndex = 1;

  int get selectedTabIndex {
    return this._selectedTabIndex;
  }

  set selectedTabIndex(int tabIndex) {
    this._selectedTabIndex = tabIndex;
    notifyListeners();
  }
}
