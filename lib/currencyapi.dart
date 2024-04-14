




import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyConvert {
  static Future<dynamic> currencyapi(String baseCurrency) async {
    var request = http.Request(
        'GET', Uri.parse('https://open.er-api.com/v6/latest/$baseCurrency'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      return res;
    } else {
      print(response.reasonPhrase);
    }
  }
}
