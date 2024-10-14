

class UserRepository {
  Future<String> login(String phoneNumber) async {
    
    return '';
  }

  Future<void> loadMe() async {
    try {} on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> requestOtp(String contactInfo) async {
    return true;
  }
}
