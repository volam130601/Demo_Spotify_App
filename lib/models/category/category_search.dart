class CategorySearch {
  String name;
  String code;

  CategorySearch({required this.name, required this.code});

  static const String tracks = "TR";
  static const String artists = "ART";
  static const String playlists = "PLS";
  static const String albums = "AB";
  static const String genreMoods = "G&M";
  static const String podcastsShows = "P&S";
  static const String top = "TOP";
}

List<CategorySearch> categories= [
  CategorySearch(name: 'Tracks', code: CategorySearch.tracks),
  CategorySearch(name: 'Artists', code: CategorySearch.artists),
  CategorySearch(name: 'Playlists', code: CategorySearch.playlists),
  CategorySearch(name: 'Albums', code: CategorySearch.albums),
  CategorySearch(name: 'Genres & Moods', code: CategorySearch.genreMoods),
  CategorySearch(name: 'Podcasts & Shows', code: CategorySearch.podcastsShows),
  CategorySearch(name: 'Top', code: CategorySearch.top),
];

