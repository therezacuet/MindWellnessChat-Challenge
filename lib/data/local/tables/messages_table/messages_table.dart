import 'dart:convert';

import 'package:drift/drift.dart';

class MessagesTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get mongoId => text()();

  TextColumn get msgContentType => text()();

  TextColumn get msgContent => text()();

  IntColumn get msgStatus => integer()();

  TextColumn get senderId => text()();

  TextColumn get receiverId => text()();
  TextColumn get receiverName => text().nullable()();
  TextColumn get receiverCompressedProfileImage => text().nullable()();

  IntColumn get createdAt => integer()();

  IntColumn get deliveredAt => integer().nullable()();

  IntColumn get seenAt => integer().nullable()();

  BoolColumn get isSent => boolean().withDefault(const Constant(false))();

  TextColumn get localFileUrl => text().nullable()();

  TextColumn get networkFileUrl => text().nullable()();
  TextColumn get blurHashImageUrl => text().nullable()();

  TextColumn get imageInfo =>
      text().map(const ImageInfoConvertor()).nullable()();


}

class ImageInfoConvertor extends TypeConverter<Map<String, dynamic>, String> {
  const ImageInfoConvertor();

  includes() {}

  @override
  Map<String, dynamic> fromSql(String fromDb) {
    return (json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String toSql(Map<String, dynamic> value) {
    return json.encode(value);
  }
}
