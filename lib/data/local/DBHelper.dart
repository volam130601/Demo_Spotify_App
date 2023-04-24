import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const _databaseName = "spotify_app.db";
  static const _databaseVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE TrackDownload ("
        "id INTEGER PRIMARY KEY,"
        "track_id TEXT,"
        "playlist_id TEXT,"
        "album_id TEXT,"
        "task_id TEXT,"
        "title TEXT,"
        "artist_name TEXT,"
        "artist_picture_small TEXT,"
        "cover_small TEXT,"
        "cover_xl TEXT,"
        "preview TEXT,"
        "duration INTEGER,"
        "type TEXT"
        ")");

    await db.execute("CREATE TABLE PlaylistDownload ("
        "id INTEGER PRIMARY KEY,"
        "playlist_id TEXT,"
        "title TEXT,"
        "picture_medium TEXT,"
        "picture_xl TEXT,"
        "user_name TEXT,"
        "type TEXT"
        ")");
  }
}
