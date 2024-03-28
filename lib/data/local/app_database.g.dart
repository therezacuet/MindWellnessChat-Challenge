// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MessagesTableTable extends MessagesTable
    with TableInfo<$MessagesTableTable, MessagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _mongoIdMeta =
      const VerificationMeta('mongoId');
  @override
  late final GeneratedColumn<String> mongoId = GeneratedColumn<String>(
      'mongo_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _msgContentTypeMeta =
      const VerificationMeta('msgContentType');
  @override
  late final GeneratedColumn<String> msgContentType = GeneratedColumn<String>(
      'msg_content_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _msgContentMeta =
      const VerificationMeta('msgContent');
  @override
  late final GeneratedColumn<String> msgContent = GeneratedColumn<String>(
      'msg_content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _msgStatusMeta =
      const VerificationMeta('msgStatus');
  @override
  late final GeneratedColumn<int> msgStatus = GeneratedColumn<int>(
      'msg_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _senderIdMeta =
      const VerificationMeta('senderId');
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
      'sender_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _receiverIdMeta =
      const VerificationMeta('receiverId');
  @override
  late final GeneratedColumn<String> receiverId = GeneratedColumn<String>(
      'receiver_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _receiverNameMeta =
      const VerificationMeta('receiverName');
  @override
  late final GeneratedColumn<String> receiverName = GeneratedColumn<String>(
      'receiver_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _receiverCompressedProfileImageMeta =
      const VerificationMeta('receiverCompressedProfileImage');
  @override
  late final GeneratedColumn<String> receiverCompressedProfileImage =
      GeneratedColumn<String>(
          'receiver_compressed_profile_image', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deliveredAtMeta =
      const VerificationMeta('deliveredAt');
  @override
  late final GeneratedColumn<int> deliveredAt = GeneratedColumn<int>(
      'delivered_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _seenAtMeta = const VerificationMeta('seenAt');
  @override
  late final GeneratedColumn<int> seenAt = GeneratedColumn<int>(
      'seen_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isSentMeta = const VerificationMeta('isSent');
  @override
  late final GeneratedColumn<bool> isSent = GeneratedColumn<bool>(
      'is_sent', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_sent" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _localFileUrlMeta =
      const VerificationMeta('localFileUrl');
  @override
  late final GeneratedColumn<String> localFileUrl = GeneratedColumn<String>(
      'local_file_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _networkFileUrlMeta =
      const VerificationMeta('networkFileUrl');
  @override
  late final GeneratedColumn<String> networkFileUrl = GeneratedColumn<String>(
      'network_file_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _blurHashImageUrlMeta =
      const VerificationMeta('blurHashImageUrl');
  @override
  late final GeneratedColumn<String> blurHashImageUrl = GeneratedColumn<String>(
      'blur_hash_image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageInfoMeta =
      const VerificationMeta('imageInfo');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      imageInfo = GeneratedColumn<String>('image_info', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, dynamic>?>(
              $MessagesTableTable.$converterimageInfon);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        mongoId,
        msgContentType,
        msgContent,
        msgStatus,
        senderId,
        receiverId,
        receiverName,
        receiverCompressedProfileImage,
        createdAt,
        deliveredAt,
        seenAt,
        isSent,
        localFileUrl,
        networkFileUrl,
        blurHashImageUrl,
        imageInfo
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages_table';
  @override
  VerificationContext validateIntegrity(Insertable<MessagesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mongo_id')) {
      context.handle(_mongoIdMeta,
          mongoId.isAcceptableOrUnknown(data['mongo_id']!, _mongoIdMeta));
    } else if (isInserting) {
      context.missing(_mongoIdMeta);
    }
    if (data.containsKey('msg_content_type')) {
      context.handle(
          _msgContentTypeMeta,
          msgContentType.isAcceptableOrUnknown(
              data['msg_content_type']!, _msgContentTypeMeta));
    } else if (isInserting) {
      context.missing(_msgContentTypeMeta);
    }
    if (data.containsKey('msg_content')) {
      context.handle(
          _msgContentMeta,
          msgContent.isAcceptableOrUnknown(
              data['msg_content']!, _msgContentMeta));
    } else if (isInserting) {
      context.missing(_msgContentMeta);
    }
    if (data.containsKey('msg_status')) {
      context.handle(_msgStatusMeta,
          msgStatus.isAcceptableOrUnknown(data['msg_status']!, _msgStatusMeta));
    } else if (isInserting) {
      context.missing(_msgStatusMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(_senderIdMeta,
          senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta));
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('receiver_id')) {
      context.handle(
          _receiverIdMeta,
          receiverId.isAcceptableOrUnknown(
              data['receiver_id']!, _receiverIdMeta));
    } else if (isInserting) {
      context.missing(_receiverIdMeta);
    }
    if (data.containsKey('receiver_name')) {
      context.handle(
          _receiverNameMeta,
          receiverName.isAcceptableOrUnknown(
              data['receiver_name']!, _receiverNameMeta));
    }
    if (data.containsKey('receiver_compressed_profile_image')) {
      context.handle(
          _receiverCompressedProfileImageMeta,
          receiverCompressedProfileImage.isAcceptableOrUnknown(
              data['receiver_compressed_profile_image']!,
              _receiverCompressedProfileImageMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('delivered_at')) {
      context.handle(
          _deliveredAtMeta,
          deliveredAt.isAcceptableOrUnknown(
              data['delivered_at']!, _deliveredAtMeta));
    }
    if (data.containsKey('seen_at')) {
      context.handle(_seenAtMeta,
          seenAt.isAcceptableOrUnknown(data['seen_at']!, _seenAtMeta));
    }
    if (data.containsKey('is_sent')) {
      context.handle(_isSentMeta,
          isSent.isAcceptableOrUnknown(data['is_sent']!, _isSentMeta));
    }
    if (data.containsKey('local_file_url')) {
      context.handle(
          _localFileUrlMeta,
          localFileUrl.isAcceptableOrUnknown(
              data['local_file_url']!, _localFileUrlMeta));
    }
    if (data.containsKey('network_file_url')) {
      context.handle(
          _networkFileUrlMeta,
          networkFileUrl.isAcceptableOrUnknown(
              data['network_file_url']!, _networkFileUrlMeta));
    }
    if (data.containsKey('blur_hash_image_url')) {
      context.handle(
          _blurHashImageUrlMeta,
          blurHashImageUrl.isAcceptableOrUnknown(
              data['blur_hash_image_url']!, _blurHashImageUrlMeta));
    }
    context.handle(_imageInfoMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessagesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessagesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      mongoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mongo_id'])!,
      msgContentType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}msg_content_type'])!,
      msgContent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}msg_content'])!,
      msgStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}msg_status'])!,
      senderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_id'])!,
      receiverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}receiver_id'])!,
      receiverName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}receiver_name']),
      receiverCompressedProfileImage: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}receiver_compressed_profile_image']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      deliveredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}delivered_at']),
      seenAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}seen_at']),
      isSent: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_sent'])!,
      localFileUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_file_url']),
      networkFileUrl: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}network_file_url']),
      blurHashImageUrl: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}blur_hash_image_url']),
      imageInfo: $MessagesTableTable.$converterimageInfon.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}image_info'])),
    );
  }

  @override
  $MessagesTableTable createAlias(String alias) {
    return $MessagesTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converterimageInfo =
      const ImageInfoConvertor();
  static TypeConverter<Map<String, dynamic>?, String?> $converterimageInfon =
      NullAwareTypeConverter.wrap($converterimageInfo);
}

class MessagesTableData extends DataClass
    implements Insertable<MessagesTableData> {
  final int id;
  final String mongoId;
  final String msgContentType;
  final String msgContent;
  final int msgStatus;
  final String senderId;
  final String receiverId;
  final String? receiverName;
  final String? receiverCompressedProfileImage;
  final int createdAt;
  final int? deliveredAt;
  final int? seenAt;
  final bool isSent;
  final String? localFileUrl;
  final String? networkFileUrl;
  final String? blurHashImageUrl;
  final Map<String, dynamic>? imageInfo;
  const MessagesTableData(
      {required this.id,
      required this.mongoId,
      required this.msgContentType,
      required this.msgContent,
      required this.msgStatus,
      required this.senderId,
      required this.receiverId,
      this.receiverName,
      this.receiverCompressedProfileImage,
      required this.createdAt,
      this.deliveredAt,
      this.seenAt,
      required this.isSent,
      this.localFileUrl,
      this.networkFileUrl,
      this.blurHashImageUrl,
      this.imageInfo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mongo_id'] = Variable<String>(mongoId);
    map['msg_content_type'] = Variable<String>(msgContentType);
    map['msg_content'] = Variable<String>(msgContent);
    map['msg_status'] = Variable<int>(msgStatus);
    map['sender_id'] = Variable<String>(senderId);
    map['receiver_id'] = Variable<String>(receiverId);
    if (!nullToAbsent || receiverName != null) {
      map['receiver_name'] = Variable<String>(receiverName);
    }
    if (!nullToAbsent || receiverCompressedProfileImage != null) {
      map['receiver_compressed_profile_image'] =
          Variable<String>(receiverCompressedProfileImage);
    }
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || deliveredAt != null) {
      map['delivered_at'] = Variable<int>(deliveredAt);
    }
    if (!nullToAbsent || seenAt != null) {
      map['seen_at'] = Variable<int>(seenAt);
    }
    map['is_sent'] = Variable<bool>(isSent);
    if (!nullToAbsent || localFileUrl != null) {
      map['local_file_url'] = Variable<String>(localFileUrl);
    }
    if (!nullToAbsent || networkFileUrl != null) {
      map['network_file_url'] = Variable<String>(networkFileUrl);
    }
    if (!nullToAbsent || blurHashImageUrl != null) {
      map['blur_hash_image_url'] = Variable<String>(blurHashImageUrl);
    }
    if (!nullToAbsent || imageInfo != null) {
      map['image_info'] = Variable<String>(
          $MessagesTableTable.$converterimageInfon.toSql(imageInfo));
    }
    return map;
  }

  MessagesTableCompanion toCompanion(bool nullToAbsent) {
    return MessagesTableCompanion(
      id: Value(id),
      mongoId: Value(mongoId),
      msgContentType: Value(msgContentType),
      msgContent: Value(msgContent),
      msgStatus: Value(msgStatus),
      senderId: Value(senderId),
      receiverId: Value(receiverId),
      receiverName: receiverName == null && nullToAbsent
          ? const Value.absent()
          : Value(receiverName),
      receiverCompressedProfileImage:
          receiverCompressedProfileImage == null && nullToAbsent
              ? const Value.absent()
              : Value(receiverCompressedProfileImage),
      createdAt: Value(createdAt),
      deliveredAt: deliveredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveredAt),
      seenAt:
          seenAt == null && nullToAbsent ? const Value.absent() : Value(seenAt),
      isSent: Value(isSent),
      localFileUrl: localFileUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(localFileUrl),
      networkFileUrl: networkFileUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(networkFileUrl),
      blurHashImageUrl: blurHashImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(blurHashImageUrl),
      imageInfo: imageInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(imageInfo),
    );
  }

  factory MessagesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessagesTableData(
      id: serializer.fromJson<int>(json['id']),
      mongoId: serializer.fromJson<String>(json['mongoId']),
      msgContentType: serializer.fromJson<String>(json['msgContentType']),
      msgContent: serializer.fromJson<String>(json['msgContent']),
      msgStatus: serializer.fromJson<int>(json['msgStatus']),
      senderId: serializer.fromJson<String>(json['senderId']),
      receiverId: serializer.fromJson<String>(json['receiverId']),
      receiverName: serializer.fromJson<String?>(json['receiverName']),
      receiverCompressedProfileImage:
          serializer.fromJson<String?>(json['receiverCompressedProfileImage']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      deliveredAt: serializer.fromJson<int?>(json['deliveredAt']),
      seenAt: serializer.fromJson<int?>(json['seenAt']),
      isSent: serializer.fromJson<bool>(json['isSent']),
      localFileUrl: serializer.fromJson<String?>(json['localFileUrl']),
      networkFileUrl: serializer.fromJson<String?>(json['networkFileUrl']),
      blurHashImageUrl: serializer.fromJson<String?>(json['blurHashImageUrl']),
      imageInfo: serializer.fromJson<Map<String, dynamic>?>(json['imageInfo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mongoId': serializer.toJson<String>(mongoId),
      'msgContentType': serializer.toJson<String>(msgContentType),
      'msgContent': serializer.toJson<String>(msgContent),
      'msgStatus': serializer.toJson<int>(msgStatus),
      'senderId': serializer.toJson<String>(senderId),
      'receiverId': serializer.toJson<String>(receiverId),
      'receiverName': serializer.toJson<String?>(receiverName),
      'receiverCompressedProfileImage':
          serializer.toJson<String?>(receiverCompressedProfileImage),
      'createdAt': serializer.toJson<int>(createdAt),
      'deliveredAt': serializer.toJson<int?>(deliveredAt),
      'seenAt': serializer.toJson<int?>(seenAt),
      'isSent': serializer.toJson<bool>(isSent),
      'localFileUrl': serializer.toJson<String?>(localFileUrl),
      'networkFileUrl': serializer.toJson<String?>(networkFileUrl),
      'blurHashImageUrl': serializer.toJson<String?>(blurHashImageUrl),
      'imageInfo': serializer.toJson<Map<String, dynamic>?>(imageInfo),
    };
  }

  MessagesTableData copyWith(
          {int? id,
          String? mongoId,
          String? msgContentType,
          String? msgContent,
          int? msgStatus,
          String? senderId,
          String? receiverId,
          Value<String?> receiverName = const Value.absent(),
          Value<String?> receiverCompressedProfileImage = const Value.absent(),
          int? createdAt,
          Value<int?> deliveredAt = const Value.absent(),
          Value<int?> seenAt = const Value.absent(),
          bool? isSent,
          Value<String?> localFileUrl = const Value.absent(),
          Value<String?> networkFileUrl = const Value.absent(),
          Value<String?> blurHashImageUrl = const Value.absent(),
          Value<Map<String, dynamic>?> imageInfo = const Value.absent()}) =>
      MessagesTableData(
        id: id ?? this.id,
        mongoId: mongoId ?? this.mongoId,
        msgContentType: msgContentType ?? this.msgContentType,
        msgContent: msgContent ?? this.msgContent,
        msgStatus: msgStatus ?? this.msgStatus,
        senderId: senderId ?? this.senderId,
        receiverId: receiverId ?? this.receiverId,
        receiverName:
            receiverName.present ? receiverName.value : this.receiverName,
        receiverCompressedProfileImage: receiverCompressedProfileImage.present
            ? receiverCompressedProfileImage.value
            : this.receiverCompressedProfileImage,
        createdAt: createdAt ?? this.createdAt,
        deliveredAt: deliveredAt.present ? deliveredAt.value : this.deliveredAt,
        seenAt: seenAt.present ? seenAt.value : this.seenAt,
        isSent: isSent ?? this.isSent,
        localFileUrl:
            localFileUrl.present ? localFileUrl.value : this.localFileUrl,
        networkFileUrl:
            networkFileUrl.present ? networkFileUrl.value : this.networkFileUrl,
        blurHashImageUrl: blurHashImageUrl.present
            ? blurHashImageUrl.value
            : this.blurHashImageUrl,
        imageInfo: imageInfo.present ? imageInfo.value : this.imageInfo,
      );
  @override
  String toString() {
    return (StringBuffer('MessagesTableData(')
          ..write('id: $id, ')
          ..write('mongoId: $mongoId, ')
          ..write('msgContentType: $msgContentType, ')
          ..write('msgContent: $msgContent, ')
          ..write('msgStatus: $msgStatus, ')
          ..write('senderId: $senderId, ')
          ..write('receiverId: $receiverId, ')
          ..write('receiverName: $receiverName, ')
          ..write(
              'receiverCompressedProfileImage: $receiverCompressedProfileImage, ')
          ..write('createdAt: $createdAt, ')
          ..write('deliveredAt: $deliveredAt, ')
          ..write('seenAt: $seenAt, ')
          ..write('isSent: $isSent, ')
          ..write('localFileUrl: $localFileUrl, ')
          ..write('networkFileUrl: $networkFileUrl, ')
          ..write('blurHashImageUrl: $blurHashImageUrl, ')
          ..write('imageInfo: $imageInfo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      mongoId,
      msgContentType,
      msgContent,
      msgStatus,
      senderId,
      receiverId,
      receiverName,
      receiverCompressedProfileImage,
      createdAt,
      deliveredAt,
      seenAt,
      isSent,
      localFileUrl,
      networkFileUrl,
      blurHashImageUrl,
      imageInfo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessagesTableData &&
          other.id == this.id &&
          other.mongoId == this.mongoId &&
          other.msgContentType == this.msgContentType &&
          other.msgContent == this.msgContent &&
          other.msgStatus == this.msgStatus &&
          other.senderId == this.senderId &&
          other.receiverId == this.receiverId &&
          other.receiverName == this.receiverName &&
          other.receiverCompressedProfileImage ==
              this.receiverCompressedProfileImage &&
          other.createdAt == this.createdAt &&
          other.deliveredAt == this.deliveredAt &&
          other.seenAt == this.seenAt &&
          other.isSent == this.isSent &&
          other.localFileUrl == this.localFileUrl &&
          other.networkFileUrl == this.networkFileUrl &&
          other.blurHashImageUrl == this.blurHashImageUrl &&
          other.imageInfo == this.imageInfo);
}

class MessagesTableCompanion extends UpdateCompanion<MessagesTableData> {
  final Value<int> id;
  final Value<String> mongoId;
  final Value<String> msgContentType;
  final Value<String> msgContent;
  final Value<int> msgStatus;
  final Value<String> senderId;
  final Value<String> receiverId;
  final Value<String?> receiverName;
  final Value<String?> receiverCompressedProfileImage;
  final Value<int> createdAt;
  final Value<int?> deliveredAt;
  final Value<int?> seenAt;
  final Value<bool> isSent;
  final Value<String?> localFileUrl;
  final Value<String?> networkFileUrl;
  final Value<String?> blurHashImageUrl;
  final Value<Map<String, dynamic>?> imageInfo;
  const MessagesTableCompanion({
    this.id = const Value.absent(),
    this.mongoId = const Value.absent(),
    this.msgContentType = const Value.absent(),
    this.msgContent = const Value.absent(),
    this.msgStatus = const Value.absent(),
    this.senderId = const Value.absent(),
    this.receiverId = const Value.absent(),
    this.receiverName = const Value.absent(),
    this.receiverCompressedProfileImage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deliveredAt = const Value.absent(),
    this.seenAt = const Value.absent(),
    this.isSent = const Value.absent(),
    this.localFileUrl = const Value.absent(),
    this.networkFileUrl = const Value.absent(),
    this.blurHashImageUrl = const Value.absent(),
    this.imageInfo = const Value.absent(),
  });
  MessagesTableCompanion.insert({
    this.id = const Value.absent(),
    required String mongoId,
    required String msgContentType,
    required String msgContent,
    required int msgStatus,
    required String senderId,
    required String receiverId,
    this.receiverName = const Value.absent(),
    this.receiverCompressedProfileImage = const Value.absent(),
    required int createdAt,
    this.deliveredAt = const Value.absent(),
    this.seenAt = const Value.absent(),
    this.isSent = const Value.absent(),
    this.localFileUrl = const Value.absent(),
    this.networkFileUrl = const Value.absent(),
    this.blurHashImageUrl = const Value.absent(),
    this.imageInfo = const Value.absent(),
  })  : mongoId = Value(mongoId),
        msgContentType = Value(msgContentType),
        msgContent = Value(msgContent),
        msgStatus = Value(msgStatus),
        senderId = Value(senderId),
        receiverId = Value(receiverId),
        createdAt = Value(createdAt);
  static Insertable<MessagesTableData> custom({
    Expression<int>? id,
    Expression<String>? mongoId,
    Expression<String>? msgContentType,
    Expression<String>? msgContent,
    Expression<int>? msgStatus,
    Expression<String>? senderId,
    Expression<String>? receiverId,
    Expression<String>? receiverName,
    Expression<String>? receiverCompressedProfileImage,
    Expression<int>? createdAt,
    Expression<int>? deliveredAt,
    Expression<int>? seenAt,
    Expression<bool>? isSent,
    Expression<String>? localFileUrl,
    Expression<String>? networkFileUrl,
    Expression<String>? blurHashImageUrl,
    Expression<String>? imageInfo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mongoId != null) 'mongo_id': mongoId,
      if (msgContentType != null) 'msg_content_type': msgContentType,
      if (msgContent != null) 'msg_content': msgContent,
      if (msgStatus != null) 'msg_status': msgStatus,
      if (senderId != null) 'sender_id': senderId,
      if (receiverId != null) 'receiver_id': receiverId,
      if (receiverName != null) 'receiver_name': receiverName,
      if (receiverCompressedProfileImage != null)
        'receiver_compressed_profile_image': receiverCompressedProfileImage,
      if (createdAt != null) 'created_at': createdAt,
      if (deliveredAt != null) 'delivered_at': deliveredAt,
      if (seenAt != null) 'seen_at': seenAt,
      if (isSent != null) 'is_sent': isSent,
      if (localFileUrl != null) 'local_file_url': localFileUrl,
      if (networkFileUrl != null) 'network_file_url': networkFileUrl,
      if (blurHashImageUrl != null) 'blur_hash_image_url': blurHashImageUrl,
      if (imageInfo != null) 'image_info': imageInfo,
    });
  }

  MessagesTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? mongoId,
      Value<String>? msgContentType,
      Value<String>? msgContent,
      Value<int>? msgStatus,
      Value<String>? senderId,
      Value<String>? receiverId,
      Value<String?>? receiverName,
      Value<String?>? receiverCompressedProfileImage,
      Value<int>? createdAt,
      Value<int?>? deliveredAt,
      Value<int?>? seenAt,
      Value<bool>? isSent,
      Value<String?>? localFileUrl,
      Value<String?>? networkFileUrl,
      Value<String?>? blurHashImageUrl,
      Value<Map<String, dynamic>?>? imageInfo}) {
    return MessagesTableCompanion(
      id: id ?? this.id,
      mongoId: mongoId ?? this.mongoId,
      msgContentType: msgContentType ?? this.msgContentType,
      msgContent: msgContent ?? this.msgContent,
      msgStatus: msgStatus ?? this.msgStatus,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      receiverCompressedProfileImage:
          receiverCompressedProfileImage ?? this.receiverCompressedProfileImage,
      createdAt: createdAt ?? this.createdAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      seenAt: seenAt ?? this.seenAt,
      isSent: isSent ?? this.isSent,
      localFileUrl: localFileUrl ?? this.localFileUrl,
      networkFileUrl: networkFileUrl ?? this.networkFileUrl,
      blurHashImageUrl: blurHashImageUrl ?? this.blurHashImageUrl,
      imageInfo: imageInfo ?? this.imageInfo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mongoId.present) {
      map['mongo_id'] = Variable<String>(mongoId.value);
    }
    if (msgContentType.present) {
      map['msg_content_type'] = Variable<String>(msgContentType.value);
    }
    if (msgContent.present) {
      map['msg_content'] = Variable<String>(msgContent.value);
    }
    if (msgStatus.present) {
      map['msg_status'] = Variable<int>(msgStatus.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (receiverId.present) {
      map['receiver_id'] = Variable<String>(receiverId.value);
    }
    if (receiverName.present) {
      map['receiver_name'] = Variable<String>(receiverName.value);
    }
    if (receiverCompressedProfileImage.present) {
      map['receiver_compressed_profile_image'] =
          Variable<String>(receiverCompressedProfileImage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (deliveredAt.present) {
      map['delivered_at'] = Variable<int>(deliveredAt.value);
    }
    if (seenAt.present) {
      map['seen_at'] = Variable<int>(seenAt.value);
    }
    if (isSent.present) {
      map['is_sent'] = Variable<bool>(isSent.value);
    }
    if (localFileUrl.present) {
      map['local_file_url'] = Variable<String>(localFileUrl.value);
    }
    if (networkFileUrl.present) {
      map['network_file_url'] = Variable<String>(networkFileUrl.value);
    }
    if (blurHashImageUrl.present) {
      map['blur_hash_image_url'] = Variable<String>(blurHashImageUrl.value);
    }
    if (imageInfo.present) {
      map['image_info'] = Variable<String>(
          $MessagesTableTable.$converterimageInfon.toSql(imageInfo.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesTableCompanion(')
          ..write('id: $id, ')
          ..write('mongoId: $mongoId, ')
          ..write('msgContentType: $msgContentType, ')
          ..write('msgContent: $msgContent, ')
          ..write('msgStatus: $msgStatus, ')
          ..write('senderId: $senderId, ')
          ..write('receiverId: $receiverId, ')
          ..write('receiverName: $receiverName, ')
          ..write(
              'receiverCompressedProfileImage: $receiverCompressedProfileImage, ')
          ..write('createdAt: $createdAt, ')
          ..write('deliveredAt: $deliveredAt, ')
          ..write('seenAt: $seenAt, ')
          ..write('isSent: $isSent, ')
          ..write('localFileUrl: $localFileUrl, ')
          ..write('networkFileUrl: $networkFileUrl, ')
          ..write('blurHashImageUrl: $blurHashImageUrl, ')
          ..write('imageInfo: $imageInfo')
          ..write(')'))
        .toString();
  }
}

class $RecentChatTableTable extends RecentChatTable
    with TableInfo<$RecentChatTableTable, RecentChatTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecentChatTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _user_nameMeta =
      const VerificationMeta('user_name');
  @override
  late final GeneratedColumn<String> user_name = GeneratedColumn<String>(
      'user_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _user_compressed_imageMeta =
      const VerificationMeta('user_compressed_image');
  @override
  late final GeneratedColumn<String> user_compressed_image =
      GeneratedColumn<String>('user_compressed_image', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _participantsMeta =
      const VerificationMeta('participants');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
      participants = GeneratedColumn<String>('participants', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>(
              $RecentChatTableTable.$converterparticipants);
  static const VerificationMeta _unread_msgMeta =
      const VerificationMeta('unread_msg');
  @override
  late final GeneratedColumn<int> unread_msg = GeneratedColumn<int>(
      'unread_msg', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _last_msg_timeMeta =
      const VerificationMeta('last_msg_time');
  @override
  late final GeneratedColumn<int> last_msg_time = GeneratedColumn<int>(
      'last_msg_time', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _last_msg_textMeta =
      const VerificationMeta('last_msg_text');
  @override
  late final GeneratedColumn<String> last_msg_text = GeneratedColumn<String>(
      'last_msg_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        user_name,
        user_compressed_image,
        participants,
        unread_msg,
        last_msg_time,
        last_msg_text
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recent_chat_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<RecentChatTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_name')) {
      context.handle(_user_nameMeta,
          user_name.isAcceptableOrUnknown(data['user_name']!, _user_nameMeta));
    } else if (isInserting) {
      context.missing(_user_nameMeta);
    }
    if (data.containsKey('user_compressed_image')) {
      context.handle(
          _user_compressed_imageMeta,
          user_compressed_image.isAcceptableOrUnknown(
              data['user_compressed_image']!, _user_compressed_imageMeta));
    }
    context.handle(_participantsMeta, const VerificationResult.success());
    if (data.containsKey('unread_msg')) {
      context.handle(
          _unread_msgMeta,
          unread_msg.isAcceptableOrUnknown(
              data['unread_msg']!, _unread_msgMeta));
    }
    if (data.containsKey('last_msg_time')) {
      context.handle(
          _last_msg_timeMeta,
          last_msg_time.isAcceptableOrUnknown(
              data['last_msg_time']!, _last_msg_timeMeta));
    }
    if (data.containsKey('last_msg_text')) {
      context.handle(
          _last_msg_textMeta,
          last_msg_text.isAcceptableOrUnknown(
              data['last_msg_text']!, _last_msg_textMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecentChatTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecentChatTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      user_name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_name'])!,
      user_compressed_image: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}user_compressed_image']),
      participants: $RecentChatTableTable.$converterparticipants.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}participants'])!),
      unread_msg: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unread_msg']),
      last_msg_time: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_msg_time']),
      last_msg_text: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_msg_text']),
    );
  }

  @override
  $RecentChatTableTable createAlias(String alias) {
    return $RecentChatTableTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterparticipants =
      const ParticipantListConvertor();
}

class RecentChatTableData extends DataClass
    implements Insertable<RecentChatTableData> {
  final String id;
  final String user_name;
  final String? user_compressed_image;
  final List<String> participants;
  final int? unread_msg;
  final int? last_msg_time;
  final String? last_msg_text;
  const RecentChatTableData(
      {required this.id,
      required this.user_name,
      this.user_compressed_image,
      required this.participants,
      this.unread_msg,
      this.last_msg_time,
      this.last_msg_text});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_name'] = Variable<String>(user_name);
    if (!nullToAbsent || user_compressed_image != null) {
      map['user_compressed_image'] = Variable<String>(user_compressed_image);
    }
    {
      map['participants'] = Variable<String>(
          $RecentChatTableTable.$converterparticipants.toSql(participants));
    }
    if (!nullToAbsent || unread_msg != null) {
      map['unread_msg'] = Variable<int>(unread_msg);
    }
    if (!nullToAbsent || last_msg_time != null) {
      map['last_msg_time'] = Variable<int>(last_msg_time);
    }
    if (!nullToAbsent || last_msg_text != null) {
      map['last_msg_text'] = Variable<String>(last_msg_text);
    }
    return map;
  }

  RecentChatTableCompanion toCompanion(bool nullToAbsent) {
    return RecentChatTableCompanion(
      id: Value(id),
      user_name: Value(user_name),
      user_compressed_image: user_compressed_image == null && nullToAbsent
          ? const Value.absent()
          : Value(user_compressed_image),
      participants: Value(participants),
      unread_msg: unread_msg == null && nullToAbsent
          ? const Value.absent()
          : Value(unread_msg),
      last_msg_time: last_msg_time == null && nullToAbsent
          ? const Value.absent()
          : Value(last_msg_time),
      last_msg_text: last_msg_text == null && nullToAbsent
          ? const Value.absent()
          : Value(last_msg_text),
    );
  }

  factory RecentChatTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecentChatTableData(
      id: serializer.fromJson<String>(json['id']),
      user_name: serializer.fromJson<String>(json['user_name']),
      user_compressed_image:
          serializer.fromJson<String?>(json['user_compressed_image']),
      participants: serializer.fromJson<List<String>>(json['participants']),
      unread_msg: serializer.fromJson<int?>(json['unread_msg']),
      last_msg_time: serializer.fromJson<int?>(json['last_msg_time']),
      last_msg_text: serializer.fromJson<String?>(json['last_msg_text']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'user_name': serializer.toJson<String>(user_name),
      'user_compressed_image':
          serializer.toJson<String?>(user_compressed_image),
      'participants': serializer.toJson<List<String>>(participants),
      'unread_msg': serializer.toJson<int?>(unread_msg),
      'last_msg_time': serializer.toJson<int?>(last_msg_time),
      'last_msg_text': serializer.toJson<String?>(last_msg_text),
    };
  }

  RecentChatTableData copyWith(
          {String? id,
          String? user_name,
          Value<String?> user_compressed_image = const Value.absent(),
          List<String>? participants,
          Value<int?> unread_msg = const Value.absent(),
          Value<int?> last_msg_time = const Value.absent(),
          Value<String?> last_msg_text = const Value.absent()}) =>
      RecentChatTableData(
        id: id ?? this.id,
        user_name: user_name ?? this.user_name,
        user_compressed_image: user_compressed_image.present
            ? user_compressed_image.value
            : this.user_compressed_image,
        participants: participants ?? this.participants,
        unread_msg: unread_msg.present ? unread_msg.value : this.unread_msg,
        last_msg_time:
            last_msg_time.present ? last_msg_time.value : this.last_msg_time,
        last_msg_text:
            last_msg_text.present ? last_msg_text.value : this.last_msg_text,
      );
  @override
  String toString() {
    return (StringBuffer('RecentChatTableData(')
          ..write('id: $id, ')
          ..write('user_name: $user_name, ')
          ..write('user_compressed_image: $user_compressed_image, ')
          ..write('participants: $participants, ')
          ..write('unread_msg: $unread_msg, ')
          ..write('last_msg_time: $last_msg_time, ')
          ..write('last_msg_text: $last_msg_text')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, user_name, user_compressed_image,
      participants, unread_msg, last_msg_time, last_msg_text);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecentChatTableData &&
          other.id == this.id &&
          other.user_name == this.user_name &&
          other.user_compressed_image == this.user_compressed_image &&
          other.participants == this.participants &&
          other.unread_msg == this.unread_msg &&
          other.last_msg_time == this.last_msg_time &&
          other.last_msg_text == this.last_msg_text);
}

class RecentChatTableCompanion extends UpdateCompanion<RecentChatTableData> {
  final Value<String> id;
  final Value<String> user_name;
  final Value<String?> user_compressed_image;
  final Value<List<String>> participants;
  final Value<int?> unread_msg;
  final Value<int?> last_msg_time;
  final Value<String?> last_msg_text;
  final Value<int> rowid;
  const RecentChatTableCompanion({
    this.id = const Value.absent(),
    this.user_name = const Value.absent(),
    this.user_compressed_image = const Value.absent(),
    this.participants = const Value.absent(),
    this.unread_msg = const Value.absent(),
    this.last_msg_time = const Value.absent(),
    this.last_msg_text = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecentChatTableCompanion.insert({
    required String id,
    required String user_name,
    this.user_compressed_image = const Value.absent(),
    required List<String> participants,
    this.unread_msg = const Value.absent(),
    this.last_msg_time = const Value.absent(),
    this.last_msg_text = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        user_name = Value(user_name),
        participants = Value(participants);
  static Insertable<RecentChatTableData> custom({
    Expression<String>? id,
    Expression<String>? user_name,
    Expression<String>? user_compressed_image,
    Expression<String>? participants,
    Expression<int>? unread_msg,
    Expression<int>? last_msg_time,
    Expression<String>? last_msg_text,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (user_name != null) 'user_name': user_name,
      if (user_compressed_image != null)
        'user_compressed_image': user_compressed_image,
      if (participants != null) 'participants': participants,
      if (unread_msg != null) 'unread_msg': unread_msg,
      if (last_msg_time != null) 'last_msg_time': last_msg_time,
      if (last_msg_text != null) 'last_msg_text': last_msg_text,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecentChatTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? user_name,
      Value<String?>? user_compressed_image,
      Value<List<String>>? participants,
      Value<int?>? unread_msg,
      Value<int?>? last_msg_time,
      Value<String?>? last_msg_text,
      Value<int>? rowid}) {
    return RecentChatTableCompanion(
      id: id ?? this.id,
      user_name: user_name ?? this.user_name,
      user_compressed_image:
          user_compressed_image ?? this.user_compressed_image,
      participants: participants ?? this.participants,
      unread_msg: unread_msg ?? this.unread_msg,
      last_msg_time: last_msg_time ?? this.last_msg_time,
      last_msg_text: last_msg_text ?? this.last_msg_text,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (user_name.present) {
      map['user_name'] = Variable<String>(user_name.value);
    }
    if (user_compressed_image.present) {
      map['user_compressed_image'] =
          Variable<String>(user_compressed_image.value);
    }
    if (participants.present) {
      map['participants'] = Variable<String>($RecentChatTableTable
          .$converterparticipants
          .toSql(participants.value));
    }
    if (unread_msg.present) {
      map['unread_msg'] = Variable<int>(unread_msg.value);
    }
    if (last_msg_time.present) {
      map['last_msg_time'] = Variable<int>(last_msg_time.value);
    }
    if (last_msg_text.present) {
      map['last_msg_text'] = Variable<String>(last_msg_text.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecentChatTableCompanion(')
          ..write('id: $id, ')
          ..write('user_name: $user_name, ')
          ..write('user_compressed_image: $user_compressed_image, ')
          ..write('participants: $participants, ')
          ..write('unread_msg: $unread_msg, ')
          ..write('last_msg_time: $last_msg_time, ')
          ..write('last_msg_text: $last_msg_text, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $MessagesTableTable messagesTable = $MessagesTableTable(this);
  late final $RecentChatTableTable recentChatTable =
      $RecentChatTableTable(this);
  late final MessageDao messageDao = MessageDao(this as AppDatabase);
  late final RecentChatDao recentChatDao = RecentChatDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [messagesTable, recentChatTable];
}
