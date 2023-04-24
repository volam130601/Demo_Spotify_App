import 'dart:developer';

import 'package:demo_spotify_app/data/local/util.dart';
import 'package:demo_spotify_app/models/local/playlist_download.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/local/DBHelper.dart';
import '../../models/local/track_download.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';

class DownloadRepository {
  DownloadRepository._privateConstructor();

  static final DownloadRepository instance =
      DownloadRepository._privateConstructor();

  DBHelper dbHelper = DBHelper();

  Future<void> trackDownloadInsert(
      {required Track track,
      required String taskId,
      required DownloadTask task,
      String? playlistId}) async {
    final db = await dbHelper.database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $trackTableName");
    Object? id = table.first["id"];
    TrackDownload trackDownload = TrackDownload(
        id: id as int,
        trackId: track.id.toString(),
        playlistId: (playlistId != null) ? playlistId.toString() : null,
        albumId: track.album!.id.toString(),
        taskId: taskId,
        title: track.title,
        artistName: track.artist!.name,
        artistPictureSmall: track.artist!.pictureSmall,
        coverSmall: track.album!.coverSmall,
        coverXl: track.album!.coverXl,
        preview: '${task.savedDir}/${task.filename}',
        duration: track.duration,
        type: 'track_local');
    await db.insert(trackTableName, trackDownload.toMap());
  }

  Future<void> playlistDownloadInsert(Playlist playlist) async {
    final db = await dbHelper.database;
    var table =
        await db.rawQuery("SELECT MAX(id)+1 as id FROM $playlistTableName");
    Object? id = table.first["id"];
    PlaylistDownload playlistDownload = PlaylistDownload(
        id: int.parse(id.toString()),
        playlistId: playlist.id.toString(),
        title: playlist.title,
        pictureMedium: playlist.pictureMedium,
        pictureXl: playlist.pictureXl,
        userName: playlist.user!.name,
        type: 'playlist_local');
    await db.insert(playlistTableName, playlistDownload.toMap());
  }

  Future<TrackDownload> getTrackDownload(String trackId) async {
    final db = await dbHelper.database;
    var res = await db
        .query(trackTableName, where: "track_id = ?", whereArgs: [trackId]);
    return res.isNotEmpty ? TrackDownload.fromMap(res.first) : TrackDownload();
  }

  Future<bool> trackDownloadExists(String trackId) async {
    final db = await dbHelper.database;
    var res = await db
        .query(trackTableName, where: "track_id = ?", whereArgs: [trackId]);
    return res.isNotEmpty;
  }

  Future<List<TrackDownload>> getAllTrackDownloads() async {
    final db = await dbHelper.database;
    var res = await db.query(trackTableName);
    List<TrackDownload> list =
        res.isNotEmpty ? res.map((c) => TrackDownload.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<TrackDownload>> getTracksByPlaylistId(String playlistId) async {
    final db = await dbHelper.database;
    var res = await db.query(trackTableName,
        where: 'playlist_id = ?', whereArgs: [playlistId]);
    List<TrackDownload> list =
        res.isNotEmpty ? res.map((c) => TrackDownload.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> deleteTrackDownload(String trackId) async {
    var db = await dbHelper.database;
    await db
        .delete(trackTableName, where: "track_id = ?", whereArgs: [trackId]);
  }

  Future<void> deleteTrackDownloadByTaskId(String taskId) async {
    final db = await dbHelper.database;
    await db.delete(trackTableName, where: "task_id = ?", whereArgs: [taskId]);
  }

  Future<void> deleteAllTrack() async {
    final db = await dbHelper.database;
    await db.delete(trackTableName);
  }

  //Playlist DB
  Future<PlaylistDownload> getPlaylistDownload(String playlistId) async {
    final db = await dbHelper.database;
    var res = await db.query(playlistTableName,
        where: "playlist_id = ?", whereArgs: [playlistId]);
    return res.isNotEmpty
        ? PlaylistDownload.fromMap(res.first)
        : PlaylistDownload();
  }

  Future<bool> playlistDownloadExists(String playlistId) async {
    final db = await dbHelper.database;
    var res = await db.query(playlistTableName,
        where: "playlist = ?", whereArgs: [playlistId]);
    return res.isNotEmpty;
  }

  Future<List<PlaylistDownload>> getAllPlaylistDownloads() async {
    final db = await dbHelper.database;
    var res = await db.query(playlistTableName);
    List<PlaylistDownload> list = res.isNotEmpty
        ? res.map((c) => PlaylistDownload.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<void> deletePlaylistDownload(String playlistId) async {
    final db = await dbHelper.database;
    await db.delete(playlistTableName,
        where: "playlist_id = ?", whereArgs: [playlistId]);
  }

  Future<void> deleteAllPlaylist() async {
    final db = await dbHelper.database;
    await db.delete(playlistTableName);
  }

  Future<void> removeAll() async {
    List<DownloadTask>? tasks = await FlutterDownloader.loadTasks();
    for (int i = 0; i < tasks!.length; i++) {
      FlutterDownloader.remove(taskId: tasks[i].taskId);
    }
    await deleteAllTrack();
    await deleteAllPlaylist();
  }

  Future<void> downloadTracks(List<Track> tracks) async {
    final externalDir = await getExternalStorageDirectory();
    for (int index = 0; index < tracks.length; index++) {
      final isBool = await trackDownloadExists(tracks[index].id.toString());
      if (!isBool) {
        await FlutterDownloader.enqueue(
          url: '${tracks[index].preview}',
          savedDir: externalDir!.path,
          fileName: 'track-${tracks[index].id}.mp3',
          showNotification: false,
          openFileFromNotification: false,
        );
      } else {
        log('Track ${tracks[index].id} downloaded');
      }
    }
  }
}
