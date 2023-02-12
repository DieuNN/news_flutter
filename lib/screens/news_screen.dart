import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news_flutter/api/API.dart';
import 'package:news_flutter/components/latest_news_item.dart';
import 'package:news_flutter/components/shimmer_box.dart';
import 'package:news_flutter/utils/constants.dart';
import 'package:news_flutter/fragments/news_list_by_category_fragment.dart';
import 'package:news_flutter/utils/global.dart';
import 'package:news_flutter/models/api_response.dart';
import 'package:news_flutter/screens/all_latest_news_screen.dart';
import 'package:news_flutter/screens/setting_screen.dart';
import 'package:news_flutter/utils/get_box_helper.dart';
import 'package:shimmer/shimmer.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);
  static const _category = [
    "Business",
    "Entertainment",
    "General",
    "Health",
    "Science",
    "Sport",
    "Technology"
  ];

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    Future<APIResponse?> _latestNews = API().getLatestNews();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'News',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingScreen()));
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ),
        ],
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1.1,
          child: DefaultTabController(
            length: NewsScreen._category.length,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Latest News",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      FutureBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              snapshot.hasError) {
                            return SizedBox();
                          } else {
                            return GestureDetector(
                                child: Row(
                                  children: [
                                    Text(
                                      "See All ",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.blue),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.blue,
                                    )
                                  ],
                                ),
                                onTap: () {
                                  print("see all");
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AllLatestNewsScreen(
                                          snapshot.data?.articles
                                              as List<Article>)));
                                });
                          }
                        },
                        future: _latestNews,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  FutureBuilder(
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.hasError) {
                        return Container(
                            height: MediaQuery.of(context).size.height / 3.5,
                            child: ListView(
                              children: [
                                ShimmerBox(),
                                SizedBox(
                                  width: 16,
                                ),
                                ShimmerBox(),
                              ],
                              scrollDirection: Axis.horizontal,
                            ));
                      } else {
                        List<Article> articles =
                            snapshot.data?.articles as List<Article>;
                        List<Widget> articleCards = [];
                        for (var article in articles) {
                          articleCards.add(LatestNewsItem(article, true));
                        }
                        return Container(
                          child: ListView(
                            children: articleCards,
                            scrollDirection: Axis.horizontal,
                          ),
                          height: MediaQuery.of(context).size.height / 3.5,
                        );
                      }
                    },
                    future: _latestNews,
                  ),
                  ButtonsTabBar(
                    backgroundColor: Colors.red,
                    unselectedBackgroundColor: Colors.grey[300],
                    contentPadding: EdgeInsets.all(12),
                    unselectedLabelStyle: TextStyle(color: Colors.black),
                    radius: 40,
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    tabs: [
                      Tab(
                        text: NewsScreen._category[0],
                      ),
                      Tab(
                        text: NewsScreen._category[1],
                      ),
                      Tab(
                        text: NewsScreen._category[2],
                      ),
                      Tab(
                        text: NewsScreen._category[3],
                      ),
                      Tab(
                        text: NewsScreen._category[4],
                      ),
                      Tab(
                        text: NewsScreen._category[5],
                      ),
                      Tab(
                        text: NewsScreen._category[6],
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        NewsListByCategoryFragment(
                            GlobalVariables.currentLanguage,
                            Constants.business),
                        NewsListByCategoryFragment(
                            GlobalVariables.currentLanguage,
                            Constants.entertainment),
                        NewsListByCategoryFragment(
                            GlobalVariables.currentLanguage, Constants.general),
                        NewsListByCategoryFragment(
                            GlobalVariables.currentLanguage, Constants.health),
                        NewsListByCategoryFragment(
                            GlobalVariables.currentLanguage, Constants.science),
                        NewsListByCategoryFragment(
                            GlobalVariables.currentLanguage, Constants.sports),
                        NewsListByCategoryFragment(
                            GlobalVariables.currentLanguage,
                            Constants.technology),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
