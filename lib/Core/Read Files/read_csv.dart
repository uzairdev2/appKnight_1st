import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class CsvService {
  Future<List<List<dynamic>>> processCsv() async {
    var result = await rootBundle.loadString("assets/file/hrang.csv");
    return const CsvToListConverter().convert(result, eol: "\n");
  }
}
