import 'package:newsapp/models/news.dart';
import 'package:flutter/material.dart';

class NewsNotifier extends ChangeNotifier {
  List<List<News>> Newss = [];

  // List<List<Map<String, List<News>>>>

  List<List<News>> get Newsslist => Newss;

  set Newsslist(List<List<News>> Newslist) {
    Newss = Newslist;
    notifyListeners();
  }

  void clearNewss() {
    Newss = [];
    notifyListeners();
  }

  void clearExtras() {
    Newss = [];
    notifyListeners();
  }
}
