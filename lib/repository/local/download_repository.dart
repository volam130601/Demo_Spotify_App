import 'dart:developer';

import 'package:demo_spotify_app/models/local/playlist_download.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/local/db_helper.dart';
import '../../models/local/track_download.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';

class DownloadRepository {
  static const String typeTrack = 'track_local';
  static const String typePlaylist = 'playlist_local';

  DownloadRepository._privateConstructor();

  static final DownloadRepository instance =
      DownloadRepository._privateConstructor();

  DBHelper dbHelper = DBHelper();

  Future<void> insertTrackDownload(
      {required Track track,
      required String taskId,
      required DownloadTask task,
      int? playlistId}) async {
    final db = await dbHelper.database;
    TrackDownload trackDownload = TrackDownload(
        id: track.id,
        playlistId: (playlistId != 0) ? playlistId : 0,
        albumId: track.album!.id,
        taskId: taskId,
        title: track.title,
        artistName: track.artist!.name,
        artistPictureSmall: track.artist!.pictureSmall,
        coverSmall: track.album!.coverSmall,
        coverXl: track.album!.coverXl,
        preview: '${task.savedDir}/${task.filename}',
        duration: track.duration,
        type: typeTrack);
    await db.insert(DBHelper.trackTableName, trackDownload.toMap());
  }

  Future<TrackDownload> getTrackByTrackId(String trackId) async {
    final db = await dbHelper.database;
    var res = await db
        .query(DBHelper.trackTableName, where: "id = ?", whereArgs: [trackId]);
    return res.isNotEmpty ? TrackDownload.fromMap(res.first) : TrackDownload();
  }

  Future<bool> trackDownloadExists(int trackId) async {
    final db = await dbHelper.database;
    var res = await db
        .query(DBHelper.trackTableName, where: "id = ?", whereArgs: [trackId]);
    return res.isNotEmpty;
  }

  Future<List<TrackDownload>> getAllTrackDownloads() async {
    final db = await dbHelper.database;
    var res =
        await db.query(DBHelper.trackTableName, orderBy: 'create_time DESC');
    List<TrackDownload> list =
        res.isNotEmpty ? res.map((c) => TrackDownload.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<TrackDownload>> getTracksByPlaylistId(int playlistId) async {
    final db = await dbHelper.database;
    var res = await db.query(DBHelper.trackTableName,
        where: 'playlist_id = ?',
        whereArgs: [playlistId],
        orderBy: 'create_time DESC');
    List<TrackDownload> list =
        res.isNotEmpty ? res.map((c) => TrackDownload.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> deleteTrackDownload(int trackId) async {
    var db = await dbHelper.database;
    await db
        .delete(DBHelper.trackTableName, where: "id = ?", whereArgs: [trackId]);
  }

  Future<void> deleteTrackDownloadByTaskId(String taskId) async {
    final db = await dbHelper.database;
    await db.delete(DBHelper.trackTableName,
        where: "task_id = ?", whereArgs: [taskId]);
  }

  Future<void> deleteAllTrack() async {
    final db = await dbHelper.database;
    await db.delete(DBHelper.trackTableName);
  }

  //Playlist DB
  Future<void> insertPlaylistDownload(Playlist playlist) async {
    final db = await dbHelper.database;
    bool isExists = await playlistDownloadExists(playlist.id!);
    if (!isExists) {
      PlaylistDownload playlistDownload = PlaylistDownload(
          id: playlist.id,
          title: playlist.title,
          pictureMedium: playlist.pictureMedium,
          pictureXl: playlist.pictureXl,
          userName: playlist.user!.name,
          type: typePlaylist);
      await db.insert(DBHelper.playlistTableName, playlistDownload.toMap());
    } else {
      log('Playlist ${playlist.id} exists!');
    }
  }

  Future<List<PlaylistDownload>> getAllPlaylistDownloads() async {
    final db = await dbHelper.database;
    var res =
        await db.query(DBHelper.playlistTableName, orderBy: 'create_time DESC');
    List<PlaylistDownload> list = res.isNotEmpty
        ? res.map((c) => PlaylistDownload.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<PlaylistDownload> getPlaylistDownloadByPlaylistId(
      int playlistId) async {
    final db = await dbHelper.database;
    var res = await db.query(DBHelper.playlistTableName,
        where: "id = ?", whereArgs: [playlistId]);
    return res.isNotEmpty
        ? PlaylistDownload.fromMap(res.first)
        : PlaylistDownload();
  }

  Future<bool> playlistDownloadExists(int playlistId) async {
    final db = await dbHelper.database;
    var res = await db.query(DBHelper.playlistTableName,
        where: "id = ?", whereArgs: [playlistId]);
    return res.isNotEmpty;
  }

  Future<void> deletePlaylistDownload(int playlistId) async {
    final db = await dbHelper.database;
    await db.delete(DBHelper.playlistTableName,
        where: "id = ?", whereArgs: [playlistId]);
  }

  Future<void> deleteAllPlaylist() async {
    final db = await dbHelper.database;
    await db.delete(DBHelper.playlistTableName);
  }

  Future<void> removeAll() async {
    List<DownloadTask>? tasks = await FlutterDownloader.loadTasks();
    for (int i = 0; i < tasks!.length; i++) {
      FlutterDownloader.remove(taskId: tasks[i].taskId);
    }
    await deleteAllTrack();
    await deleteAllPlaylist();
  }

  Future<void> downloadTracks(List<Track> tracks, int? playlistId) async {
    final externalDir = await getExternalStorageDirectory();
    for (var track in tracks) {
      final isBool = await trackDownloadExists(track.id!);
      if (!isBool) {
        await FlutterDownloader.enqueue(
          url: '${track.preview}',
          savedDir: externalDir!.path,
          fileName: (playlistId != null)
              ? 'playlist-$playlistId-${track.id}.mp3'
              : 'track-${track.id}.mp3',
          showNotification: false,
          openFileFromNotification: false,
        );
      } else {
        log('Track ${track.id} downloaded');
      }
    }
  }
}
