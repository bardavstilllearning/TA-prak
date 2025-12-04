import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String username;

  @HiveField(2)
  late String namaLengkap;

  @HiveField(3)
  late String password;

  @HiveField(4)
  String? urlFoto;

  @HiveField(5)
  late DateTime createdAt;

  @HiveField(6)
  DateTime? updatedAt;

  User({
    required this.id,
    required this.username,
    required this.namaLengkap,
    required this.password,
    this.urlFoto,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'nama_lengkap': namaLengkap,
      'url_foto': urlFoto,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      namaLengkap: map['nama_lengkap'],
      password: map['password'] ?? '',
      urlFoto: map['url_foto'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }
}
