import 'package:pocketbase/pocketbase.dart';

class PocketBaseService {
  static final pb = PocketBase('http://127.0.0.1:8090');

  static Future<RecordModel> signUp(String name, String email, String password) async {
    final body = <String, dynamic>{
      'email': email,
      'password': password,
      'passwordConfirm': password,
      'name': name,
    };
    return await pb.collection('users').create(body: body);
  }

  static Future<RecordModel> signIn(String email, String password) async {
    final result = await pb.collection('users').authWithPassword(email, password);
    return result.record!;
  }

  static Future<void> signOut() async {
    pb.authStore.clear();
  }

  static bool get isLoggedIn => pb.authStore.isValid;
  static String? get currentUserId => pb.authStore.model?.id;

  static Future<List<RecordModel>> getDevices() async {
    try {
      final result = await pb.collection('devices').getList(
        filter: 'user_id = "${currentUserId ?? ''}"',
        sort: '-created',
      );
      return result.items;
    } catch (e) {
      print('Error loading devices: $e');
      return [];
    }
  }

  static Future<RecordModel> saveDevice(Map<String, dynamic> data) async {
    data['user_id'] = currentUserId;
    return await pb.collection('devices').create(body: data);
  }

  static Future<void> saveInteraction(Map<String, dynamic> data) async {
    data['user_id'] = currentUserId;
    try {
      await pb.collection('interactions').create(body: data);
    } catch (e) {
      print('Error saving interaction: $e');
    }
  }
}