import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:like_button/like_button.dart';
import 'package:news_flutter/screens/news_detail.dart';
import 'package:news_flutter/utils/get_box_helper.dart';
import '';

import '../components/latest_news_item.dart';
import '../models/api_response.dart';

class AllLatestNewsScreen extends StatefulWidget {
  AllLatestNewsScreen(this.articles, {super.key});

  List<Article> articles;

  @override
  State<AllLatestNewsScreen> createState() => _AllLatestNewsScreenState();
}

class _AllLatestNewsScreenState extends State<AllLatestNewsScreen> {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    List<Widget> articleCards = [];
    for (var article in widget.articles) {
      articleCards.add(LatestNewsItem(article, false));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Latest news',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "There are ${widget.articles.length} latest news.",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: articleCards.length,
                itemBuilder: (buildContext, index) {
                  bool isArticleSaved =
                      GetStorageHelper.isArticleSaved(widget.articles[index]);
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
                            child: LatestNewsItem(widget.articles[index], false),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => NewsDetail(
                                          widget.articles[index])));
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          widget.articles[index].title!,
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
                                widget.articles[index].author == null
                                    ? "No author"
                                    : "By ${widget.articles[index].author!}",
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
                                          widget.articles[index]);
                                      Fluttertoast.showToast(msg: "Removed from saved news");
                                    } else {
                                      GetStorageHelper.addToList(
                                          widget.articles[index]);
                                      Fluttertoast.showToast(msg: "News added");
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
            )
          ],
        ),
      ),
    );
  }
}
