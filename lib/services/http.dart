import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class RequestResult {
  bool ok;
  int status;
  dynamic data;
  RequestResult(this.ok, this.status, this.data);
}

const PROTOCOL = 'https';
const DOMAIN = "order-api.newsapp.ng/api";
Future<RequestResult> httpGet(String route, [dynamic data]) async {
  var dataStr = jsonEncode(data);
  var url = "$PROTOCOL://$DOMAIN/$route";
  Uri encoded = Uri.parse(url);
  var result = await http.get(encoded, headers: {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*"
  });
  print(result.statusCode);
  return RequestResult(true, result.statusCode, jsonDecode(result.body));
}

Future<RequestResult> httpGetSec(String route, [dynamic data]) async {
  var dataStr = jsonEncode(data);
  var url = "$PROTOCOL://$DOMAIN/$route";
  Uri encoded = Uri.parse(url);
  var result = await http.get(encoded, headers: {
    "Access-Control-Allow-Origin": "*",
    "Authorization": "Bearer " + data['token']
  });
  print(result.statusCode);
  return RequestResult(true, result.statusCode, jsonDecode(result.body));
}

Future<RequestResult> httpPost(String route, [dynamic data]) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  Uri encoded = Uri.parse(url);
  var dataStr = jsonEncode(data);
  var result = await http.post(encoded, body: dataStr, headers: {
    "Content-Type": "application/json",
    // "Access-Control-Allow-Origin": "*"
  });
  return RequestResult(true, result.statusCode, jsonDecode(result.body));
}

Future<RequestResult> httpPostSec(String route, [dynamic data]) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  Uri encoded = Uri.parse(url);
  var dataStr = jsonEncode(data);
  var result = await http.post(encoded, body: dataStr, headers: {
    "Content-Type": "application/json",
    // "Access-Control-Allow-Origin": "*",
    // 'Authorization': data['token']
    "Authorization": "Bearer " + data['token']
  });

  return RequestResult(true, result.statusCode, jsonDecode(result.body));
}

Future<RequestResult> httpPatch(String route, [dynamic data]) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  Uri encoded = Uri.parse(url);
  var dataStr = jsonEncode(data);
  var result = await http.patch(encoded, body: dataStr, headers: {
    "Content-Type": "application/json",
    // "Access-Control-Allow-Origin": "*"
    "Authorization": "Bearer " + data['token']
  });
  return RequestResult(true, result.statusCode, jsonDecode(result.body));
}
