abstract class UserRepository {
  // Future<UserModel> getUser();

  Future<void> login({String email, String password});

  Future<void> register({String email, String password});

  Future<void> changePassword({String email});

  Future<void> updateUser({String name, String numberPhone, String address});

  Future<void> addUser({
    String name,
    String phone,
    String address,
    String email,
  });

  Future<void> signOut();
}
