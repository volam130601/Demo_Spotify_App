import 'package:cloud_firestore/cloud_firestore.dart';

class RecentSearchItem {
   String? id;
   String? itemId;
   String? title;
   String? image;
   String? type;

  RecentSearchItem({
    required this.id,
    required this.itemId,
    required this.title,
    required this.image,
    required this.type,
  });

   RecentSearchItem.fromJson(DocumentSnapshot<Map<String, dynamic>> doc) {
     id = doc.id;
     itemId = doc.data()!["itemId"];
     title = doc.data()!["title"];
     image = doc.data()!["image"];
     type = doc.data()!["type"];
   }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'title': title,
      'image': image,
      'type': type,
    };
  }
}

class ArtistSearch {

}
