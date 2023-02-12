import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:like_button/like_button.dart';
import 'package:news_flutter/api/API.dart';
import 'package:news_flutter/components/shimmer_box.dart';
import 'package:news_flutter/utils/global.dart';
import 'package:news_flutter/utils/get_box_helper.dart';

import '../components/latest_news_item.dart';
import '../models/api_response.dart';
import '../screens/news_detail.dart';

class NewsListByCategoryFragment extends StatefulWidget {
  String country;
  String category;

  NewsListByCategoryFragment( this.country, this.category);

  @override
  State<NewsListByCategoryFragment> createState() =>
      _NewsListByCategoryFragmentState();
}

class _NewsListByCategoryFragmentState
    extends State<NewsListByCategoryFragment> {
  @override
  Widget build(BuildContext context) {
    final _articles = API().getNews(widget.country, widget.category);
    return Container(
      height: 300,
      child: FutureBuilder(
          future: _articles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.articles?.length,
                itemBuilder: (buildContext, index) {
                  bool isArticleSaved = GetStorageHelper.isArticleSaved(
                      snapshot.data!.articles![index]);
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: GestureDetector(
                            child: LatestNewsItem(
                                snapshot.data!.articles![index], false),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => NewsDetail(
                                          snapshot.data!.articles![index])));
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          snapshot.data!.articles![index].title!,
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
                                snapshot.data!.articles![index].author == null
                                    ? "No author"
                                    : "By ${snapshot.data!.articles![index].author!}",
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
                                          snapshot.data!.articles![index]);
                                      Fluttertoast.showToast(msg: "Removed from saved news");
                                    } else {
                                      GetStorageHelper.addToList(
                                          snapshot.data!.articles![index]);
                                      Fluttertoast.showToast(msg: "News saved");
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
              );
            } else {
              return const ShimmerBox();
            }
          }),
    );
  }
}
