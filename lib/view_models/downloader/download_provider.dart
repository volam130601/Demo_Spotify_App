import 'package:demo_spotify_app/models/local_model/track_download.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DownloadProvider {
  static const _databaseName = "my_database.db";
  static const _databaseVersion = 1;

  static Database? _database;

  DownloadProvider._privateConstructor();

  static final DownloadProvider instance =
      DownloadProvider._privateConstructor();

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
        "task_id TEXT,"
        "title TEXT,"
        "artist_name TEXT,"
        "artist_picture_small TEXT,"
        "cover_small TEXT,"
        "cover_xl TEXT,"
        "preview TEXT"
        ")");
  }

  newTrackDownload(TrackDownload trackDownload) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM TrackDownload");
    Object? id = table.first["id"];
    return await db.rawInsert(
        "INSERT Into TrackDownload ("
        "id,"
        "task_id,"
        "title,"
        "artist_name,"
        "artist_picture_small,"
        "cover_small,"
        "cover_xl,"
        "preview"
        ")"
        " VALUES (?,?,?,?,?,?,?,?)",
        [
          id,
          trackDownload.taskId,
          trackDownload.title,
          trackDownload.artistName,
          trackDownload.artistPictureSmall,
          trackDownload.coverSmall,
          trackDownload.coverXl,
          trackDownload.preview
        ]);
  }

  getTrackDownload(String taskId) async {
    final db = await database;
    var res = await db
        .query("TrackDownload", where: "task_id = ?", whereArgs: [taskId]);
    return res.isNotEmpty ? TrackDownload.fromMap(res.first) : null;
  }

  Future<List<TrackDownload>> getAllTrackDownloads() async {
    final db = await database;
    var res = await db.query("TrackDownload");
    List<TrackDownload> list =
        res.isNotEmpty ? res.map((c) => TrackDownload.fromMap(c)).toList() : [];
    return list;
  }

  deleteTrackDownload(int id) async {
    final db = await database;
    return db.delete("TrackDownload", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from TrackDownload");
  }
}
