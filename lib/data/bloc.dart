import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/data/database.dart';
import 'package:restaurant_app/data/order.dart';
import 'package:restaurant_app/data/service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as developer;

class OrderBloc {
  final Service service = new Service();
  final OrderDatabase db = OrderDatabase();

  OrderBloc() {
//    db.deleteCache();
//    db.deleteOrdersTable();
    getReady();
  }

  final _readySubject = BehaviorSubject<List<Order>>();
  final _recordedSubject = BehaviorSubject<List<Order>>();

  Stream<List<Order>> get readyOrders => _readySubject.stream;

  Stream<List<Order>> get recordedOrders => _recordedSubject.stream;

  getReady() async {
    developer.log("get ready orders", name: "bloc");
    List<Order> orders;
    if (Service.isConnected) {
      orders = await service.getReady();
    } else {
      orders = await db.orders();
      orders.removeWhere((o) {
        return o.status != 'ready';
      });
    }
    _readySubject.sink.add(orders);
  }

  getRecorded() async {
    developer.log("get recorded orders", name: "bloc");
    List<Order> orders;
    if (Service.isConnected) {
      orders = await service.getRecorded();
      _recordedSubject.sink.add(orders);
    }
  }

  Future<Order> getOrder(int id) async {
//    developer.log("get Order", name: "bloc");
    if (Service.isConnected) {
      Order order = await service.getOrder(id);
      return order;
    }
    return Order();
  }

  Future<Order> getMyOrder(String table) async {
//    developer.log("get my order", name: "bloc");
    if (Service.isConnected) {
      Order order = await service.getMyOrder(table);
      return order;
    }
    throw Exception("You are offline! Cannot get your order.");
  }

  add(Order order) async {
    try {
      final id = await db.insertOrder(order);
      if (Service.isConnected) {
        order.id = id;
//        developer.log(" add id = " + id.toString(), name: "bloc");
        await service.insert(order).then((inserted) {
          if (inserted)
            developer.log("Added to server", name: "bloc");
          else {
            developer.log("Add to server failed", name: "bloc");
            throw Exception("Add to server failed");

          }
        });
      }
      else{
        // add to cache and push to server when online
        db.insertCache(id);
      }
        _recordedSubject.sink.add(await db.orders());
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  addLocal(Order order) async {
    final id = db.insertOrder(order);
    id.then((id) async {
      developer.log("Add locally, id = " + id.toString(), name: "bloc");
      _recordedSubject.sink.add(await db.orders());
    });
  }

  sync() async {
    if (Service.isConnected) {
      developer.log("sync", name: "bloc");

      List<Order> orders = List<Order>();
      List<int> ids = await db.cache();
      developer.log("cache ids: " + ids.toString(),name: "bloc");
      ids.forEach((id) async {
        service.insert(await db.order(id));
      });
      orders.clear();
      db.deleteCache();

      orders = await service.getReady();
      orders.forEach((order) {
        db.insertOrder(order);
      });

      orders.clear();
      orders = await service.getRecorded();
      orders.forEach((order) {
        db.insertOrder(order);
      });
    }
    getRecorded();
    getReady();
  }

  dispose() {
    _readySubject.close();
    _recordedSubject.close();
  }

  Future<bool> isOnline() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) return true;
    return false;
  }

  void status(int id, String status) {
    service.status(id, status);
    getRecorded();
    getReady();
  }
}
