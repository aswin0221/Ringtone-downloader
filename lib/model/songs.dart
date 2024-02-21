class Songs {
  String categoryName;
  String downloadUrl;
  bool isPlaying;
  String name;
  String uniqueId;

  Songs({
    required this.categoryName,
    required this.downloadUrl,
    required this.isPlaying,
    required this.name,
    required this.uniqueId,
  });

  static List<Songs> allSongs() {
    return [];
  }
}
