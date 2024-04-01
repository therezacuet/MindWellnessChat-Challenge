import 'dart:convert';

import 'package:drift/drift.dart';

class RecentChatTable extends Table{

  TextColumn get id => text()();
  // TextColumn get mongoId => text()();

  TextColumn get user_name => text()();
  TextColumn get user_compressed_image => text().nullable()();
  // TextColumn get user2_name => text()();
  // TextColumn get user2_compressed_image => text().nullable()();
  TextColumn get participants =>text().map(const ParticipantListConvertor())();

  IntColumn get unread_msg => integer().nullable()();
  // IntColumn get user2_unread_msg => integer()();
  IntColumn get last_msg_time => integer().nullable()();
  TextColumn get last_msg_text => text().nullable()();
  // BoolColumn get should_update => boolean().nullable().withDefault(const Constant(false))();

  // BoolColumn get user1_local_updated => boolean().nullable().withDefault(const Constant(false))();
  // BoolColumn get user2_local_updated => boolean().nullable().withDefault(const Constant(false))();



  @override
  Set<Column> get primaryKey => {id};

}

class ParticipantListConvertor extends TypeConverter<List<String>, String> {
  const ParticipantListConvertor();

  includes(){

  }

  @override
  List<String> fromSql(String fromDb) {
    return (json.decode(fromDb) as List).cast<String>();
  }

  @override
  String toSql(List<String> value) {
    return json.encode(value);
  }
}