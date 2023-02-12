import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:news_flutter/models/api_response.dart';

class GetStorageHelper {
  static void addToList(Article article) {
    print("adding");
    final storage = GetStorage();
    final savedNewsJson = storage.read("savedNews");
    print(savedNewsJson);
    if (savedNewsJson == "") {
      final savedNewsList = [];
      savedNewsList.add(article);
      storage.write("savedNews", jsonEncode(savedNewsList));
    } else {
      final savedNewsList = jsonDecode(savedNewsJson) as List;
      savedNewsList.add(article);
      storage.write("savedNews", jsonEncode(savedNewsList));
    }
    print(storage.read("savedNews"));
  }

  static void deleteAllSavedNews() {
    GetStorage().write("savedNews", "");
  }

  static void removeFromList(Article article) {
    print("removing");
    final storage = GetStorage();
    final savedNewsJson = storage.read("savedNews") as String;
    var decodedArticles = jsonDecode(savedNewsJson);
    if (savedNewsJson == "") {
      return;
    }
    List<Article> articleList = [];

    for (var element in decodedArticles) {
      articleList.add(Article.fromJson(element));
    }
    final elem =
        articleList.firstWhere((element) => element.title == article.title);
    articleList.remove(elem);
    print(elem);
    storage.write("savedNews", json.encode(articleList));
    print(articleList);
  }

  static List<Article> getAllSavedNews() {
    final storage = GetStorage();
    final savedNewsJson = storage.read("savedNews");
    List<Article> result = [];
    if(savedNewsJson == "") {
      return [];
    }
    for(var element in json.decode(savedNewsJson)) {
      result.add(Article.fromJson(element));
    }
    return result;
  }

  static bool isArticleSaved(Article article) {
    final storage = GetStorage();
    final savedNewsJson = storage.read("savedNews");
    final articleEncoded = jsonEncode(article);
    return savedNewsJson.contains(articleEncoded);
  }
}
