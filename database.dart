import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'order_model.dart';

class MyDatabase {
  late Database _db;

  Future<void> openDb() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'order_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE orders('
          'orderId INTEGER PRIMARY KEY, '
          'cusName TEXT, '
          'cusAddress TEXT, '
          'contact TEXT, '
          'amount TEXT, '
          'producttype TEXT, '
          'payment TEXT, '
          'status TEXT DEFAULT "", '
          'quantity TEXT, '
          'orderDate TEXT DEFAULT CURRENT_TIMESTAMP, '
          'note TEXT DEFAULT "", '
          'userId TEXT'
          ')',
        );
      },
      version: 1,
    );
  }

// read the orders from the database
  Future<List<Order>> getOrders() async {
    final List<Map<String, dynamic>> maps = await _db.query('orders');
    return List.generate(maps.length, (i) {
      return Order(
        orderId: maps[i]['orderId'],
        cusName: maps[i]['cusName'],
        cusAddress: maps[i]['cusAddress'],
        contact: maps[i]['contact'],
        amount: maps[i]['amount'],
        producttype: maps[i]['producttype'],
        payment: maps[i]['payment'],
        status: maps[i]['status'],
        quantity: maps[i]['quantity'],
        orderDate: DateTime.parse(maps[i]['orderDate']),
      );
    });
  }

  //GET the orders of the login user
  Future<List<Order>> getOrdersByUserId(String userId) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'orders',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return Order(
        orderId: maps[i]['orderId'],
        cusName: maps[i]['cusName'],
        cusAddress: maps[i]['cusAddress'],
        contact: maps[i]['contact'],
        amount: maps[i]['amount'],
        producttype: maps[i]['producttype'],
        payment: maps[i]['payment'],
        status: maps[i]['status'],
        quantity: maps[i]['quantity'],
        orderDate: DateTime.parse(maps[i]['orderDate']),
      );
    });
  }

//   Future<List<Order>> getOrders() async {
//   final currentUser = FirebaseAuth.instance.currentUser!;
//   final db = await Database;
//   final rows = await db.rawQuery(
//       'SELECT * FROM orders WHERE userId = ? ORDER BY orderId DESC',
//       [currentUser.uid]);
//   return List.generate(rows.length, (i) {
//     return Order(
//       orderId: rows[i]['orderId'],
//       cusName: rows[i]['cusName'],
//       cusAddress: rows[i]['cusAddress'],
//       contact: rows[i]['contact'],
//       amount: rows[i]['amount'],
//       producttype: rows[i]['producttype'],
//       payment: rows[i]['payment'],
//       status: rows[i]['status'],
//       quantity: rows[i]['quantity'],
//       orderDate: DateTime.parse(rows[i]['orderDate']),
//       note: rows[i]['note'],
//     );
//   });
// }

  Future<void> insertOrder(Order order, String userId) async {
    await _db.insert(
      'orders',
      order.toMap()..['userId'] = userId, // add user ID to order data
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateOrder(Order order) async {
    await _db.update(
      'orders',
      order.toMap(),
      where: 'orderId = ?',
      whereArgs: [order.orderId],
    );
  }

  Future<void> deleteOrder(int id) async {
    await _db.delete(
      'orders',
      where: 'orderId = ?',
      whereArgs: [id],
    );
  }

  Future<int> countEmp() async {
    final List<Map<String, Object?>> result =
        await _db.rawQuery('SELECT COUNT(*) FROM orders');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count;
  }
}
