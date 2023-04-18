class CategoryLibrary {
  String image;
  String title;
  String code;

  CategoryLibrary(
      {required this.image, required this.title, required this.code});

  static const String favoriteSong = 'FavoriteSong';
  static const String downloaded = 'Downloaded';
  static const String artist = 'Artist';
  static const String podcast = 'Podcast';
  static const String upload = 'Upload';
}

List<CategoryLibrary> categoryLibraries = [
  CategoryLibrary(
    image: 'assets/images/library/library_heart_icon.png',
    title: 'Favorite song',
    code: CategoryLibrary.favoriteSong,
  ),
  CategoryLibrary(
      image: 'assets/images/library/library_download_icon.png',
      title: 'Downloaded',
      code: CategoryLibrary.downloaded),
  CategoryLibrary(
      image: 'assets/images/library/library_artist_icon.png',
      title: 'Artist',
      code: CategoryLibrary.artist),
  CategoryLibrary(
      image: 'assets/images/library/library_podcast_icon.png',
      title: 'Podcast',
      code: CategoryLibrary.podcast),
  CategoryLibrary(
      image: 'assets/images/library/library_upload_icon.png',
      title: 'Upload',
      code: CategoryLibrary.upload),
];
