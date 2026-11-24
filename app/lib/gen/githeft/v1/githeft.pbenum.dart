// This is a generated file - do not edit.
//
// Generated from githeft/v1/githeft.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AuthType extends $pb.ProtobufEnum {
  static const AuthType AUTH_TYPE_UNSPECIFIED =
      AuthType._(0, _omitEnumNames ? '' : 'AUTH_TYPE_UNSPECIFIED');
  static const AuthType AUTH_TYPE_NONE =
      AuthType._(1, _omitEnumNames ? '' : 'AUTH_TYPE_NONE');
  static const AuthType AUTH_TYPE_SSH =
      AuthType._(2, _omitEnumNames ? '' : 'AUTH_TYPE_SSH');
  static const AuthType AUTH_TYPE_HTTPS =
      AuthType._(3, _omitEnumNames ? '' : 'AUTH_TYPE_HTTPS');

  static const $core.List<AuthType> values = <AuthType>[
    AUTH_TYPE_UNSPECIFIED,
    AUTH_TYPE_NONE,
    AUTH_TYPE_SSH,
    AUTH_TYPE_HTTPS,
  ];

  static final $core.List<AuthType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static AuthType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AuthType._(super.value, super.name);
}

class NewNoteName extends $pb.ProtobufEnum {
  static const NewNoteName NEW_NOTE_NAME_UNSPECIFIED =
      NewNoteName._(0, _omitEnumNames ? '' : 'NEW_NOTE_NAME_UNSPECIFIED');

  /// From the first heading or line, falling back to the date.
  static const NewNoteName NEW_NOTE_NAME_TITLE =
      NewNoteName._(1, _omitEnumNames ? '' : 'NEW_NOTE_NAME_TITLE');

  /// 20260826T192720.md
  static const NewNoteName NEW_NOTE_NAME_DATE_TIME =
      NewNoteName._(2, _omitEnumNames ? '' : 'NEW_NOTE_NAME_DATE_TIME');

  static const $core.List<NewNoteName> values = <NewNoteName>[
    NEW_NOTE_NAME_UNSPECIFIED,
    NEW_NOTE_NAME_TITLE,
    NEW_NOTE_NAME_DATE_TIME,
  ];

  static final $core.List<NewNoteName?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static NewNoteName? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const NewNoteName._(super.value, super.name);
}

class SshKeyType extends $pb.ProtobufEnum {
  static const SshKeyType SSH_KEY_TYPE_UNSPECIFIED =
      SshKeyType._(0, _omitEnumNames ? '' : 'SSH_KEY_TYPE_UNSPECIFIED');
  static const SshKeyType SSH_KEY_TYPE_ED25519 =
      SshKeyType._(1, _omitEnumNames ? '' : 'SSH_KEY_TYPE_ED25519');
  static const SshKeyType SSH_KEY_TYPE_RSA =
      SshKeyType._(2, _omitEnumNames ? '' : 'SSH_KEY_TYPE_RSA');

  static const $core.List<SshKeyType> values = <SshKeyType>[
    SSH_KEY_TYPE_UNSPECIFIED,
    SSH_KEY_TYPE_ED25519,
    SSH_KEY_TYPE_RSA,
  ];

  static final $core.List<SshKeyType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static SshKeyType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SshKeyType._(super.value, super.name);
}

/// Which editor a note opens in; front matter "type: Checklist" or
/// "type: Journal", as GitJournal writes it.
class NoteType extends $pb.ProtobufEnum {
  static const NoteType NOTE_TYPE_UNSPECIFIED =
      NoteType._(0, _omitEnumNames ? '' : 'NOTE_TYPE_UNSPECIFIED');
  static const NoteType NOTE_TYPE_MARKDOWN =
      NoteType._(1, _omitEnumNames ? '' : 'NOTE_TYPE_MARKDOWN');
  static const NoteType NOTE_TYPE_CHECKLIST =
      NoteType._(2, _omitEnumNames ? '' : 'NOTE_TYPE_CHECKLIST');

  /// Dated entry without a title, named by date and time.
  static const NoteType NOTE_TYPE_JOURNAL =
      NoteType._(3, _omitEnumNames ? '' : 'NOTE_TYPE_JOURNAL');

  static const $core.List<NoteType> values = <NoteType>[
    NOTE_TYPE_UNSPECIFIED,
    NOTE_TYPE_MARKDOWN,
    NOTE_TYPE_CHECKLIST,
    NOTE_TYPE_JOURNAL,
  ];

  static final $core.List<NoteType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static NoteType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const NoteType._(super.value, super.name);
}

class SortOrder extends $pb.ProtobufEnum {
  static const SortOrder SORT_ORDER_UNSPECIFIED =
      SortOrder._(0, _omitEnumNames ? '' : 'SORT_ORDER_UNSPECIFIED');
  static const SortOrder SORT_ORDER_MODIFIED_DESC =
      SortOrder._(1, _omitEnumNames ? '' : 'SORT_ORDER_MODIFIED_DESC');
  static const SortOrder SORT_ORDER_CREATED_DESC =
      SortOrder._(2, _omitEnumNames ? '' : 'SORT_ORDER_CREATED_DESC');
  static const SortOrder SORT_ORDER_TITLE_ASC =
      SortOrder._(3, _omitEnumNames ? '' : 'SORT_ORDER_TITLE_ASC');
  static const SortOrder SORT_ORDER_PATH_ASC =
      SortOrder._(4, _omitEnumNames ? '' : 'SORT_ORDER_PATH_ASC');

  static const $core.List<SortOrder> values = <SortOrder>[
    SORT_ORDER_UNSPECIFIED,
    SORT_ORDER_MODIFIED_DESC,
    SORT_ORDER_CREATED_DESC,
    SORT_ORDER_TITLE_ASC,
    SORT_ORDER_PATH_ASC,
  ];

  static final $core.List<SortOrder?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static SortOrder? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SortOrder._(super.value, super.name);
}

class HostKind extends $pb.ProtobufEnum {
  static const HostKind HOST_KIND_UNSPECIFIED =
      HostKind._(0, _omitEnumNames ? '' : 'HOST_KIND_UNSPECIFIED');
  static const HostKind HOST_KIND_GITHUB =
      HostKind._(1, _omitEnumNames ? '' : 'HOST_KIND_GITHUB');
  static const HostKind HOST_KIND_GITLAB =
      HostKind._(2, _omitEnumNames ? '' : 'HOST_KIND_GITLAB');

  /// Gitea and Forgejo, e.g. codeberg.org.
  static const HostKind HOST_KIND_GITEA =
      HostKind._(3, _omitEnumNames ? '' : 'HOST_KIND_GITEA');

  static const $core.List<HostKind> values = <HostKind>[
    HOST_KIND_UNSPECIFIED,
    HOST_KIND_GITHUB,
    HOST_KIND_GITLAB,
    HOST_KIND_GITEA,
  ];

  static final $core.List<HostKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static HostKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const HostKind._(super.value, super.name);
}

class SyncState extends $pb.ProtobufEnum {
  static const SyncState SYNC_STATE_UNSPECIFIED =
      SyncState._(0, _omitEnumNames ? '' : 'SYNC_STATE_UNSPECIFIED');
  static const SyncState SYNC_STATE_IDLE =
      SyncState._(1, _omitEnumNames ? '' : 'SYNC_STATE_IDLE');
  static const SyncState SYNC_STATE_SYNCING =
      SyncState._(2, _omitEnumNames ? '' : 'SYNC_STATE_SYNCING');
  static const SyncState SYNC_STATE_ERROR =
      SyncState._(3, _omitEnumNames ? '' : 'SYNC_STATE_ERROR');

  /// No remote configured.
  static const SyncState SYNC_STATE_LOCAL_ONLY =
      SyncState._(4, _omitEnumNames ? '' : 'SYNC_STATE_LOCAL_ONLY');

  static const $core.List<SyncState> values = <SyncState>[
    SYNC_STATE_UNSPECIFIED,
    SYNC_STATE_IDLE,
    SYNC_STATE_SYNCING,
    SYNC_STATE_ERROR,
    SYNC_STATE_LOCAL_ONLY,
  ];

  static final $core.List<SyncState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static SyncState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SyncState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
