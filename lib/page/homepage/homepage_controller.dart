import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../commons/constant.dart';
import 'homepage_data.dart';


class WeatherService {
  final WidgetRef ref;
  final Dio _dio = Dio();

  WeatherService({required this.ref});

  Future<void> fetchWeather(
      {required int nx, required int ny}) async {
    try {
      String baseDate = DateFormat('yyyyMMdd').format(DateTime.now());

      DateTime now = DateTime.now();
      int lastHour = now.hour;
      if (now.minute < 45) {
        lastHour -= 1;
      }
      String baseTime = "${lastHour.toString().padLeft(2, '0')}00";

      final response = await _dio.get(
        "$baseUrl/getUltraSrtNcst",
        queryParameters: {
          "serviceKey": apiKey,
          "pageNo": 1,
          "numOfRows": 1000,
          "dataType": "JSON",
          "base_date": baseDate,
          "base_time": baseTime,
          "nx": nx,
          "ny": ny,
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("응답 데이터: ${response.data}");
        }
        final data = response.data;
        final items = data['response']['body']['items']['item'];

        List<WeatherData> weathers = [];
        for (var i in items) {
          String category = _categoryToKorean(i['category']);
          WeatherData weatherData = WeatherData(
            baseDate: i['baseDate'],
            baseTime: i['baseTime'],
            category: category, // 변환된 카테고리 사용
            obsrValue: i['obsrValue'],
          );
          weathers.add(weatherData);
        }

        ref.read(weatherDataProvider.notifier).state = weathers;
        if (kDebugMode) {
          print('+++ weatherDataProvider: ${ref.read(weatherDataProvider)}');
        }
      } else {
        if (kDebugMode) {
          print("❌ 오류 발생: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("🚨 예외 발생: $e");
      }
    }
  }

  String _categoryToKorean(String category) {
    switch (category) {
      case 'UUU':
        return '기온';
      case 'VVV':
        return '풍속';
      case 'VEC':
        return '풍향';
      case 'TMP':
        return '기온';
      case 'POP':
        return '강수확률';
      case 'REH':
        return '습도';
      case 'PTY':
        return '강수형태';
      case 'wsd':
        return '풍속';
      case 'rn1':
        return '1시간 강수량';
      case 't1h':
        return '기온';
      default:
        return category; // 기본값은 그대로 반환
    }
  }
}