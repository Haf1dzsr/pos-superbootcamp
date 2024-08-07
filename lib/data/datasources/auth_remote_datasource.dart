import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pos_superbootcamp/data/utils/auth_helper.dart';

class AuthRemoteDatasource {
  static final AuthRemoteDatasource instance = AuthRemoteDatasource._internal();
  AuthRemoteDatasource._internal();
  factory AuthRemoteDatasource() => instance;

  Future<Either<String, String>> register({
    required String name,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': name,
          'phoneNumber': phoneNumber,
          'email': email,
        });
        return right('please-verify-your-email');
      }
      return right('please-verify-your-email');
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        return left('verify-your-email-first');
      }

      final userToken = await FirebaseAuth.instance.currentUser!.getIdToken();
      String uid = userCredential.user!.uid;

      await setUserToken(token: userToken!);
      await setUserId(userId: uid);

      return right('login-success');
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<void> setUserToken({required String token}) async {
    await AuthHelper.instance.saveToken(token);
  }

  Future<void> setUserId({required String userId}) async {
    await AuthHelper.instance.saveUserId(userId);
  }
}
