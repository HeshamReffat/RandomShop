
import 'package:sqflite/sqflite.dart';

class DataProvider{
  Future<Database> createDatabase() async {
    return await openDatabase('ItemData.db',
        version: 1,
        onCreate: (db, _) async {
          await db.execute(
              'CREATE TABLE Items(id INTEGER PRIMARY KEY, image TEXT, name TEXT, price INTEGER, offer INTEGER, discount INTEGER, favorite INTEGER)');
          print('created');
        },
        onOpen: (db) => print('opened'));
  }
  Future<void> insertData({
    Database database,
    String image,
    String name,
    int price,
    int offer,
    int discount,
  }) async {
    await database.transaction((txn) async {
      await txn
          .rawInsert(
          'INSERT INTO Items (image, name, price, offer, discount, favorite) values("$image" , "$name" , $price , $offer , $discount , 0)')
          .then((value) => print(value));
    });
  }
  Future<void> updateFavorite({
    Database database,
    int favorite,
    int id
  }) async {
    return await database.rawUpdate(
        'UPDATE Items SET favorite = ? WHERE id = "$id"',
        ['$favorite']).then((value) => print(value));
  }
  Future<List<Map>> getData(Database database) async {
    return await database.rawQuery('SELECT * FROM Items');
  }
  Future<List<Map>> searchItem(Database database, String name) async {
    return await database.rawQuery('SELECT * FROM Items WHERE name Like "$name%"');
  }
  Future<List<Map>> favoriteItem(Database database) async {
    return await database.rawQuery('SELECT * FROM Items WHERE favorite = 1');
  }
}