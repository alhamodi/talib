class UserModel {
  String? email;
  String? uid;
  String? name;
  bool? isEmailVerified;
  String? profileImage;
  String? coverImage;
  String? bio;

  UserModel(
      { this.name,
       this.email,
       this.uid,
       this.isEmailVerified,
       this.profileImage,
       this.coverImage,
       this.bio,
      });

  UserModel.fromJson(Map<String, dynamic>? json) {
    email = json!['email'];
    name = json['name'];
    uid = json['uid'];
    isEmailVerified = json['isEmailVerified'];
    profileImage = json['profileImage'];
    coverImage = json['coverImage'];
    bio = json['bio'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'profileImage': profileImage,
      'coverImage': coverImage,
      'bio': bio,

    };
  }
}
