import 'package:shared_preferences/shared_preferences.dart';

abstract class MembersLocalDataSource {
  Future<List<String>> getFavoriteMemberIds();
  Future<void> toggleFavorite(String memberId);
  Future<bool> isFavorite(String memberId);
}

class MembersLocalDataSourceImpl implements MembersLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _favoriteMembersKey = 'favorite_members';

  MembersLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<String>> getFavoriteMemberIds() async {
    final favorites = sharedPreferences.getStringList(_favoriteMembersKey);
    return favorites ?? [];
  }

  @override
  Future<bool> isFavorite(String memberId) async {
    final favorites = await getFavoriteMemberIds();
    return favorites.contains(memberId);
  }

  @override
  Future<void> toggleFavorite(String memberId) async {
    final favorites = await getFavoriteMemberIds();

    if (favorites.contains(memberId)) {
      favorites.remove(memberId);
    } else {
      favorites.add(memberId);
    }

    await sharedPreferences.setStringList(_favoriteMembersKey, favorites);
  }
}
