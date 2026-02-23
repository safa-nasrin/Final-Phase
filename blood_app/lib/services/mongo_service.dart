import 'package:mongo_dart/mongo_dart.dart';
import '../models/user_model.dart';
import 'dart:developer' as developer;

class MongoService {
  static late Db db;
  static late DbCollection userCollection;

  static Future<void> connect() async {
    try {
      db = await Db.create('mongodb://localhost:27017/blood_app');
      await db.open();
      userCollection = db.collection('users');
      developer.log("Connected to MongoDB!");
    } catch (e) {
      developer.log("Error connecting to MongoDB: $e");
    }
  }

  static Future<User?> login(String email, String password) async {
    try {
      final result = await userCollection.findOne({
        'email': email,
        'password': password,
      });

      if (result != null) {
        return User.fromMap(result);
      }
      return null;
    } catch (e) {
      developer.log('Login error: $e');
      return null;
    }
  }

  static Future<bool> signup(User user) async {
    try {
      // Check if user exists
      final existingUser = await userCollection.findOne({'email': user.email});
      if (existingUser != null) {
        return false; // User already exists
      }

      await userCollection.insertOne(user.toMap());
      return true;
    } catch (e) {
      developer.log('Signup error: $e');
      return false;
    }
  }

  static Future<bool> resetPassword(String email, String newPassword) async {
      try {
        final result = await userCollection.updateOne(
          where.eq('email', email),
          modify.set('password', newPassword),
        );
        return result.isAcknowledged;
      } catch (e) {
        developer.log('Reset pass error: $e');
        return false;
      }
  }

  static Future<bool> addScanResult(ObjectId userId, ScanResult result) async {
    try {
      final updateResult = await userCollection.updateOne(
        where.eq('_id', userId),
        modify.push('history', result.toMap()),
      );
      return updateResult.isAcknowledged;
    } catch (e) {
      developer.log('Add scan error: $e');
      return false;
    }
  }
  
  static Future<User?> getUser(ObjectId userId) async {
      try {
          final result = await userCollection.findOne(where.eq('_id', userId));
          if (result != null) {
              return User.fromMap(result);
          }
          return null;
      } catch (e) {
          developer.log('Get user error: $e');
          return null;
      }
  }
}
