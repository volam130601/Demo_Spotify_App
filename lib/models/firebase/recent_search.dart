import 'package:cloud_firestore/cloud_firestore.dart';

class RecentSearchItem {
  final String id;
  final String itemId;
  final String title;
  final String image;
  final String type;

  RecentSearchItem({
    required this.id,
    required this.itemId,
    required this.title,
    required this.image,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemId': itemId,
      'title': title,
      'image': image,
      'type': type,
    };
  }

  RecentSearchItem.fromMap(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        itemId = doc.data()!["itemId"],
        title = doc.data()!["title"],
        image = doc.data()!["image"],
        type = doc.data()!["type"];
}
