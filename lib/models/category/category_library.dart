class CategoryLibrary {
  String image;
  String title;

  CategoryLibrary({required this.image, required this.title});
}

List<CategoryLibrary> categoryLibraries = [
  CategoryLibrary(
      image: 'assets/images/library/library_heart_icon.png',
      title: 'Favorite song'),
  CategoryLibrary(
      image: 'assets/images/library/library_download_icon.png',
      title: 'Downloaded'),
  CategoryLibrary(image: 'assets/images/library/library_artist_icon.png', title: 'Artist'),
  CategoryLibrary(
      image: 'assets/images/library/library_podcast_icon.png',
      title: 'Podcast'),
  CategoryLibrary(image: 'assets/images/library/library_upload_icon.png', title: 'Upload'),
];
