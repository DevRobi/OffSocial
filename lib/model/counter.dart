import 'package:flutter/foundation.dart';

class PageIndexProviderModel extends ChangeNotifier {
  int _count = 1;
  int get pageNumber => _count;

  void setPage(int pageNumber) {
    _count = pageNumber;
    notifyListeners();
  }
}
