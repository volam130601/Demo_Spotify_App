class Category {
  String name;
  String code;

  Category({required this.name, required this.code});

  static const String tracks = "TR";
  static const String artists = "ART";
  static const String playlists = "PLS";
  static const String albums = "AB";
  static const String genreMoods = "G&M";
  static const String podcastsShows = "P&S";
  static const String top = "TOP";
}

List<Category> categories= [
  Category(name: 'Tracks', code: Category.tracks),
  Category(name: 'Artists', code: Category.artists),
  Category(name: 'Playlists', code: Category.playlists),
  Category(name: 'Albums', code: Category.albums),
  Category(name: 'Genres & Moods', code: Category.genreMoods),
  Category(name: 'Podcasts & Shows', code: Category.podcastsShows),
  Category(name: 'Top', code: Category.top),
];

