
import 'package:sqflite/sqflite.dart' as sql;

class ApiDB {
 static Future<void> createTables(sql.Database database) async {
    await database.execute('''
          CREATE TABLE Csc (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            country TEXT,
            state TEXT,
            city TEXT
          )
        ''');
  }
 static Future<sql.Database> db() async {
    return sql.openDatabase(
      'auth_db.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        // ignore: avoid_print
        print('...database');
        await createTables(database);
      },
    );
  }
  static Future<dynamic> createItems(
    String country, String state, String city) async {
    final db = await ApiDB.db();
    final data = {
    'country': country,
      'state': state,
      'city': city,
    };
    final id = await db.insert('Csc', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await ApiDB.db();
    return db.query('Csc', orderBy: "id");
  }
}
// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   factory DatabaseHelper() => _instance;

//   DatabaseHelper._internal();

//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }
//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'location.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute('''
//           CREATE TABLE location(
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             country TEXT,
//             state TEXT,
//             city TEXT
//           )
//         ''');
//       },
//     );
//   }
//   Future<void> insertLocation(
//     String country, String state, String city) async {
//     final db = await database;
//     await db.insert('location', {
//       'country': country,
//       'state': state,
//       'city': city,
//     });
//   }

//   Future<List<Map<String, dynamic>>> getLocations() async {
//     final db = await database;
//     return await db.query('location');
//   }
// }
