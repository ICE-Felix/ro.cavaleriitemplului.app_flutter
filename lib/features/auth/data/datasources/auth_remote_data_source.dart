import '../../../../core/error/exceptions.dart';
import '../../../../core/network/supabase_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel> register(String name, String email, String password);
  Future<UserModel> getProfile();
  Future<void> resetPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseAuthClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final user = await supabaseClient.signIn(
        email: email,
        password: password,
      );

      final session = supabaseClient.currentSession;
      final token = session?.accessToken ?? '';

      return UserModel(
        id: int.tryParse(user.id) ?? 0,
        name: user.userMetadata?['name'] as String? ?? '',
        email: user.email ?? '',
        token: token,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabaseClient.signOut();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    try {
      final user = await supabaseClient.signUp(
        email: email,
        password: password,
        userData: {'name': name},
      );

      final session = supabaseClient.currentSession;
      final token = session?.accessToken ?? '';

      return UserModel(
        id: int.tryParse(user.id) ?? 0,
        name: name,
        email: user.email ?? '',
        token: token,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final user = await supabaseClient.getProfile();
      final session = supabaseClient.currentSession;
      final token = session?.accessToken ?? '';

      return UserModel(
        id: int.tryParse(user.id) ?? 0,
        name: user.userMetadata?['name'] as String? ?? '',
        email: user.email ?? '',
        token: token,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await supabaseClient.resetPassword(email: email);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
