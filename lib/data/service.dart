import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'order.dart';

class Service {
  static final serverUrl = 'http://192.168.2.104:2301';
  static bool isConnected = false;

  Future<List<Order>> getReady() async {
    developer.log("get Ready", name: 'service');
    http.Response response = await http.get(serverUrl + "/orders", headers: {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/json",
//        HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      // or 304 not modified !!!
//      developer.log(response.body);
      Iterable decodedBody = json.decode(response.body);
      List<Order> orders = decodedBody.map((i) => Order.fromJson(i)).toList();
      return orders;
    } else {
      throw Exception("Failed to load ready orders from the Server");
    }
  }

  Future<List<Order>> getRecorded() async {
    developer.log("get Recorded ", name: 'service');
    http.Response response = await http.get(serverUrl + "/recorded", headers: {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/json",
//        HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
//      developer.log(response.body);
      Iterable decodedBody = json.decode(response.body);
      List<Order> orders = decodedBody.map((i) => Order.fromJson(i)).toList();
      return orders;
    } else {
      print(response.statusCode);
      throw Exception("Failed to load ready orders from the Server");
    }
  }

  Future<bool> insert(Order order) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
    };
    final response = await http.post(serverUrl + "/order",
        headers: headers,
        body: json.encode({
          "id": order.id,
          "table": order.table,
          "details": order.details,
          "status": order.status,
          "time": order.time,
          "type": order.type,
        }));
    if (response.statusCode != 200) {
      developer.log("add failed: " + response.body, name: "service");
      throw Exception("Couldn't add your order! Missing or invalid information.");
    }
    return true;
  }

  getOrder(int id) async {
    developer.log("get order", name: 'service');
    http.Response response =
        await http.get(serverUrl + "/order" + "/$id", headers: {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (response.statusCode == 200) {
      Order order = Order.fromJson(json.decode(response.body));
      return order;
    } else {
      print(response.statusCode);
      throw Exception("Failed to load order from the Server");
    }
  }

  getMyOrder(String table) async {
    developer.log("get my order", name: 'service');
    http.Response response =
        await http.get(serverUrl + "/my" + "/$table", headers: {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (response.statusCode == 200) {
      Order order = Order.fromJson(json.decode(response.body));
      return order;
    } else {
      print(response.statusCode);
      throw Exception("Failed to load my order from the Server");
    }
  }

  void status(int id, String status) async {
    http.Response response = await http.post(serverUrl + "/status", headers: {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/json",
    }, body: json.encode({
      "id": id,
      "status": status
    }));
    if (response.statusCode == 200) {
      developer.log("Status changed!", name: "service");
    } else {
      developer.log(response.statusCode.toString(), name: 'service');

      throw Exception("Failed to load my order from the Server");
    }
  }
}
