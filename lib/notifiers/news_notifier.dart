import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/models/news.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/services/api.dart';

class NewsState extends StateNotifier<List<News>> {
  NewsState() : super([]);

  static final provider = StateNotifierProvider<NewsState, List<News>>((ref) {
    return NewsState();
  });

  void setNews(List<News> news) {
    state = news;
  }
}

final newsList = FutureProvider<List<News>>((ref) async {
  return await getNewsFromFirebase();
});

final searchFilterProvider = StateProvider<String>((_) => '');

final filteredNews = Provider<List<News>>((ref) {
  final news = ref.watch(newsList) as List<News>;
  final search = ref.watch(searchFilterProvider); // 1

  var filteredNewsList =
      news.where((newz) => newz.title.toLowerCase().contains(search)); // 2

  return filteredNewsList.toList(); // 4
});
