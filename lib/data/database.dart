
import 'dart:developer' as developer;
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'order.dart';

class OrderDatabase{
  static final OrderDatabase _instance = OrderDatabase._();
  static Database _database;
  OrderDatabase._();

  factory OrderDatabase(){
    return _instance;
  }

  Future<Database> get db async {
    if (_database != null){
      return _database;
    }
    _database = await init();

    return _database;
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, "restauranDatabase.db");
    var database = openDatabase(dbPath, version: 3, onCreate: _onCreate);
    return database;

  }

  void _onCreate(Database db, int version) async{
    await db.execute('''
      CREATE TABLE IF NOT EXISTS orders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        'table' TEXT,
        details TEXT,
        status TEXT,
        time INTEGER,
        type TEXT)      
      ''');
    developer.log("Database created!");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS cache (id INTEGER PRIMARY KEY)");
    developer.log("Cache created!");
  }


  Future<List<Order>> orders() async {
    developer.log("Get all orders", name: "db");
    final Database database = await db;
    final List<Map<String, dynamic>> maps = await database.query('orders');
    return List.generate(maps.length,(i){
      return Order.withDetails(
          id: maps[i]['id'],
          table: maps[i]["table"],
          details: maps[i]["details"],
          status: maps[i]["status"],
          time: maps[i]["time"],
          type: maps[i]["type"],

      );
    });
  }


  Future<int> insertOrder(Order order) async {
    if (order != null && order.details != null && order.status != null && order.type != null&& order.time != null&& order.table != null) {
      // Get a reference to the database.
      final Database database = await db;
      final id = await database.insert(
        'orders',
        order.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      developer.log("insert, id =  " + id.toString(), name: "db");
      return id;
    }
    else throw Exception("Missing fields!");
  }

  insertCache(int id) async{
    developer.log("Insert in cache", name: "db");

    final Database database = await db;
    database.insert(
        "cache",
        {"id":id},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<int>> cache() async {
    developer.log("Get cache", name: "db");
    final Database database = await db;
    final List<Map<String, dynamic>> maps = await database.query('cache');
    return List.generate(maps.length,(i){
      return maps[i]['id'];
    });
  }

  Future<Order> order(int id) async {
    developer.log("Get order " + id.toString(), name: "db");
    final Database database = await db;
    final List<Map<String, dynamic>> maps1 = await database.query('orders');
    developer.log(maps1.toString());
    final List<Map<String, dynamic>> maps = await database.query('orders',where: "id = ?",whereArgs: [id]);
    try {
      return Order.withDetails(
        id: maps[0]['id'],
        table: maps[0]["table"],
        details: maps[0]["details"],
        status: maps[0]["status"],
        time: maps[0]["time"],
        type: maps[0]["type"],
      );
    }
    on Exception catch(e){
      throw Exception("get order db " + e.toString());
    }
  }

  void deleteOrdersTable() async{
    var client = await db;
    await client.delete(
      'orders',
    );
  }

  void deleteCache() async{
    var client = await db;
    await client.delete(
      'cache',
    );
  }

  Future closeDb() async {
    var database = await db;
    database.close();
  }

}