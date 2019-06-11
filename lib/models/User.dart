import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum SnsProvider {
  email, facebook, google
}

@immutable
class User extends Equatable {
  String uid;
  String name;
  String email;
  SnsProvider provider;

  User(this.uid, this.name, this.email, {this.provider = SnsProvider.email});
    //: this.provider = provider ?? SnsProvider.email;

  static User fromJson(Map<String, Object> json) {
    return User(
      json["uid"] as String,
      json["name"] as String,
      json["email"] as String,
      //provider: json["provider"] as String,
    );
  }

  Map<String, Object> toJson() {
    return {
      "uid": this.uid,
      "name": this.name,
      "email": this.email,
      "provider": this.provider.toString(),
    };
  }

  @override
  String toString() {
    return 'User { uid: $uid, name: $name, email: $email }';
  }
}