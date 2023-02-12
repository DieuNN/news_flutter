import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/api_response.dart';

class API extends GetConnect {
  Future<APIResponse?> getLatestNews() async {
    final country = GetStorage().read("currentCountry") ?? "us";
    final result = await get(
        "https://newsapi.org/v2/top-headlines?country=$country&apiKey=6b6075bb686c4fb7bcc74c3910412710");
    return APIResponse.fromJson(result.body);
  }

  Future<APIResponse> getNews(String country, String category) async {
    final result = await get(
        "https://newsapi.org/v2/top-headlines?country=$country&apiKey=6b6075bb686c4fb7bcc74c3910412710&category=$category");
    return APIResponse.fromJson(result.body);
  }
}
