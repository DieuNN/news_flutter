import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:like_button/like_button.dart';

import '../components/latest_news_item.dart';
import '../models/api_response.dart';
import '../utils/get_box_helper.dart';
import 'news_detail.dart';
import 'package:get/get.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    List<Article> articles = [];
    List<Widget> articleCards = [];
    articles = GetStorageHelper.getAllSavedNews();
    for (var article in articles) {
      articleCards.add(LatestNewsItem(article, false));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Saved news',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {
              var temp = GetStorageHelper.getAllSavedNews();
              GetStorageHelper.deleteAllSavedNews();
              setState(() {
                articles = [];
              });
              Get.snackbar(
                "Deleted",
                "All saved news has been deleted",
                mainButton: TextButton(onPressed: () {
                  for(var element in temp) {
                    GetStorageHelper.addToList(element);
                  }
                  setState(() {
                    articles = GetStorageHelper.getAllSavedNews();
                  });
                }, child: Text("UNDO")),
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.black,
                colorText: Colors.white
              );
            },
            icon: Icon(Icons.delete_outline, color: Colors.black),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "There are ${articles.length} saved news.",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () {
                  setState(() {
                    articles = GetStorageHelper.getAllSavedNews();
                  });
                  return Future(() => {
                    null
                  });
                },
                child: ListView.builder(
                  itemCount: articleCards.length,
                  itemBuilder: (buildContext, index) {
                    bool isArticleSaved =
                        GetStorageHelper.isArticleSaved(articles[index]);
                    if (kDebugMode) {
                      print(isArticleSaved);
                    }
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: GestureDetector(
                              child: LatestNewsItem(articles[index], false),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            NewsDetail(articles[index])));
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            articles[index].title!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  articles[index].author == null
                                      ? "No author"
                                      : "By ${articles[index].author!}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: LikeButton(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    onTap: (bool isLiked) async {
                                      if (isLiked) {
                                        GetStorageHelper.removeFromList(
                                            articles[index]);
                                        Fluttertoast.showToast(msg: "Removed from saved news");
                                        setState(() {
                                          articles =
                                              GetStorageHelper.getAllSavedNews();
                                        });
                                      } else {
                                        GetStorageHelper.addToList(
                                            articles[index]);
                                        Fluttertoast.showToast(msg: "Added to saved news");
                                      }
                                      return !isLiked;
                                    },
                                    isLiked: isArticleSaved,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
