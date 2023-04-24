import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const _databaseName = "spotify_app.db";
  static const _databaseVersion = 1;
  static const String trackTableName = 'TrackDownload';
  static const String playlistTableName = 'PlaylistDownload';

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
    await db.execute("CREATE TABLE ${DBHelper.trackTableName} ("
        "id INTEGER PRIMARY KEY,"
        "playlist_id INTEGER,"
        "album_id INTEGER,"
        "task_id TEXT,"
        "title TEXT,"
        "artist_name TEXT,"
        "artist_picture_small TEXT,"
        "cover_small TEXT,"
        "cover_xl TEXT,"
        "preview TEXT,"
        "duration INTEGER,"
        "type TEXT,"
        "create_time INTEGER"
        ")");

    await db.execute("CREATE TABLE ${DBHelper.playlistTableName} ("
        "id INTEGER PRIMARY KEY,"
        "title TEXT,"
        "picture_medium TEXT,"
        "picture_xl TEXT,"
        "user_name TEXT,"
        "type TEXT,"
        "create_time INTEGER"
        ")");
  }
}
