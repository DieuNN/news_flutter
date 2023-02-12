import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:like_button/like_button.dart';
import 'package:news_flutter/models/api_response.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/get_box_helper.dart';

class NewsDetail extends StatelessWidget {
  Article article;
  NewsDetail(this.article, {super.key});

  @override
  Widget build(BuildContext context) {


    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(article.url!));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Detail',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        actions: [
          LikeButton(
            mainAxisAlignment: MainAxisAlignment.end,
            onTap: (bool isLiked) async {
              if(isLiked) {
                GetStorageHelper.removeFromList(article);
                Fluttertoast.showToast(msg: "Removed from saved news");
              } else {
                GetStorageHelper.addToList(article);
                Fluttertoast.showToast(msg: "News saved");
              }
              return !isLiked;
            },
            isLiked: GetStorageHelper.isArticleSaved(article),
          ),
          SizedBox(
            width: 16,
          )
        ],
        centerTitle: true,
        elevation: 1,
      ),
      body: WebViewWidget(controller: controller,),
    );
  }
}
