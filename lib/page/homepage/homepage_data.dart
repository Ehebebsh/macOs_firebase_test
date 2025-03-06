import 'package:flutter_riverpod/flutter_riverpod.dart';

final weatherDataProvider = StateProvider<List<WeatherData>>((ref) => []);

class WeatherData {
  final String baseDate;
  final String baseTime;
  final String category;
  final String obsrValue;

  WeatherData({
    required this.baseDate,
    required this.baseTime,
    required this.category,
    required this.obsrValue,
  });
}