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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'githeft.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'githeft.pbenum.dart';

class Remote extends $pb.GeneratedMessage {
  factory Remote({
    $core.String? url,
    AuthType? authType,
    $core.String? sshKeyId,
    $core.String? username,
    $core.String? password,
    $core.bool? passwordStored,
    $core.String? branch,
  }) {
    final result = Remote._();
    if (url != null) result.url = url;
    if (authType != null) result.authType = authType;
    if (sshKeyId != null) result.sshKeyId = sshKeyId;
    if (username != null) result.username = username;
    if (password != null) result.password = password;
    if (passwordStored != null) result.passwordStored = passwordStored;
    if (branch != null) result.branch = branch;
    return result;
  }

  Remote._();

  factory Remote.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Remote()..mergeFromBuffer(data, registry);
  factory Remote.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Remote()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Remote',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: Remote.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aE<AuthType>(2, _omitFieldNames ? '' : 'authType',
        enumValues: AuthType.values)
    ..aOS(3, _omitFieldNames ? '' : 'sshKeyId')
    ..aOS(4, _omitFieldNames ? '' : 'username')
    ..aOS(5, _omitFieldNames ? '' : 'password')
    ..aOB(6, _omitFieldNames ? '' : 'passwordStored')
    ..aOS(7, _omitFieldNames ? '' : 'branch')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Remote clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Remote copyWith(void Function(Remote) updates) =>
      super.copyWith((message) => updates(message as Remote)) as Remote;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Remote() / Remote.new instead')
  static Remote create() => Remote._();
  static $pb.GeneratedMessage $_createMessage() => Remote._();
  @$core.override
  Remote createEmptyInstance() => Remote._();
  @$core.pragma('dart2js:noInline')
  static Remote getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Remote>(Remote.$_createMessage);
  static Remote? _defaultInstance;

  /// Clone URL: https://host/user/repo.git, git@host:user/repo.git,
  /// ssh://git@host:port/user/repo.git or file:///path.
  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  AuthType get authType => $_getN(1);
  @$pb.TagNumber(2)
  set authType(AuthType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAuthType() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthType() => $_clearField(2);

  /// AUTH_TYPE_SSH: the key from GenerateSshKey or ImportSshKey.
  @$pb.TagNumber(3)
  $core.String get sshKeyId => $_getSZ(2);
  @$pb.TagNumber(3)
  set sshKeyId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSshKeyId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSshKeyId() => $_clearField(3);

  /// AUTH_TYPE_HTTPS: user name and password or access token. Responses
  /// never contain the password; password_stored tells whether one is stored.
  @$pb.TagNumber(4)
  $core.String get username => $_getSZ(3);
  @$pb.TagNumber(4)
  set username($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUsername() => $_has(3);
  @$pb.TagNumber(4)
  void clearUsername() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get password => $_getSZ(4);
  @$pb.TagNumber(5)
  set password($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPassword() => $_has(4);
  @$pb.TagNumber(5)
  void clearPassword() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get passwordStored => $_getBF(5);
  @$pb.TagNumber(6)
  set passwordStored($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPasswordStored() => $_has(5);
  @$pb.TagNumber(6)
  void clearPasswordStored() => $_clearField(6);

  /// Branch to sync; empty means the remote's default branch.
  @$pb.TagNumber(7)
  $core.String get branch => $_getSZ(6);
  @$pb.TagNumber(7)
  set branch($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBranch() => $_has(6);
  @$pb.TagNumber(7)
  void clearBranch() => $_clearField(7);
}

class Author extends $pb.GeneratedMessage {
  factory Author({
    $core.String? name,
    $core.String? email,
  }) {
    final result = Author._();
    if (name != null) result.name = name;
    if (email != null) result.email = email;
    return result;
  }

  Author._();

  factory Author.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Author()..mergeFromBuffer(data, registry);
  factory Author.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Author()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Author',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: Author.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Author clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Author copyWith(void Function(Author) updates) =>
      super.copyWith((message) => updates(message as Author)) as Author;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Author() / Author.new instead')
  static Author create() => Author._();
  static $pb.GeneratedMessage $_createMessage() => Author._();
  @$core.override
  Author createEmptyInstance() => Author._();
  @$core.pragma('dart2js:noInline')
  static Author getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Author>(Author.$_createMessage);
  static Author? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => $_clearField(2);
}

class Notebook extends $pb.GeneratedMessage {
  factory Notebook({
    $core.String? id,
    $core.String? name,
    $core.String? path,
    Remote? remote,
    Author? author,
    $core.bool? autoSync,
    NewNoteName? newNoteName,
    $core.String? defaultFolder,
  }) {
    final result = Notebook._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (path != null) result.path = path;
    if (remote != null) result.remote = remote;
    if (author != null) result.author = author;
    if (autoSync != null) result.autoSync = autoSync;
    if (newNoteName != null) result.newNoteName = newNoteName;
    if (defaultFolder != null) result.defaultFolder = defaultFolder;
    return result;
  }

  Notebook._();

  factory Notebook.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Notebook()..mergeFromBuffer(data, registry);
  factory Notebook.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Notebook()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Notebook',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: Notebook.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'path')
    ..aOM<Remote>(4, _omitFieldNames ? '' : 'remote',
        subBuilder: Remote.$_createMessage)
    ..aOM<Author>(5, _omitFieldNames ? '' : 'author',
        subBuilder: Author.$_createMessage)
    ..aOB(6, _omitFieldNames ? '' : 'autoSync')
    ..aE<NewNoteName>(7, _omitFieldNames ? '' : 'newNoteName',
        enumValues: NewNoteName.values)
    ..aOS(8, _omitFieldNames ? '' : 'defaultFolder')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notebook clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notebook copyWith(void Function(Notebook) updates) =>
      super.copyWith((message) => updates(message as Notebook)) as Notebook;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Notebook() / Notebook.new instead')
  static Notebook create() => Notebook._();
  static $pb.GeneratedMessage $_createMessage() => Notebook._();
  @$core.override
  Notebook createEmptyInstance() => Notebook._();
  @$core.pragma('dart2js:noInline')
  static Notebook getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Notebook>(Notebook.$_createMessage);
  static Notebook? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// Absolute path of the working tree.
  @$pb.TagNumber(3)
  $core.String get path => $_getSZ(2);
  @$pb.TagNumber(3)
  set path($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPath() => $_has(2);
  @$pb.TagNumber(3)
  void clearPath() => $_clearField(3);

  /// Unset for a notebook that only lives on this device.
  @$pb.TagNumber(4)
  Remote get remote => $_getN(3);
  @$pb.TagNumber(4)
  set remote(Remote value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRemote() => $_has(3);
  @$pb.TagNumber(4)
  void clearRemote() => $_clearField(4);
  @$pb.TagNumber(4)
  Remote ensureRemote() => $_ensure(3);

  @$pb.TagNumber(5)
  Author get author => $_getN(4);
  @$pb.TagNumber(5)
  set author(Author value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAuthor() => $_has(4);
  @$pb.TagNumber(5)
  void clearAuthor() => $_clearField(5);
  @$pb.TagNumber(5)
  Author ensureAuthor() => $_ensure(4);

  /// Sync after every change and when the app starts.
  @$pb.TagNumber(6)
  $core.bool get autoSync => $_getBF(5);
  @$pb.TagNumber(6)
  set autoSync($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAutoSync() => $_has(5);
  @$pb.TagNumber(6)
  void clearAutoSync() => $_clearField(6);

  /// File name for new notes: NEW_NOTE_NAME_*.
  @$pb.TagNumber(7)
  NewNoteName get newNoteName => $_getN(6);
  @$pb.TagNumber(7)
  set newNoteName(NewNoteName value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasNewNoteName() => $_has(6);
  @$pb.TagNumber(7)
  void clearNewNoteName() => $_clearField(7);

  /// Folder new notes go into, relative to the notebook root.
  @$pb.TagNumber(8)
  $core.String get defaultFolder => $_getSZ(7);
  @$pb.TagNumber(8)
  set defaultFolder($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDefaultFolder() => $_has(7);
  @$pb.TagNumber(8)
  void clearDefaultFolder() => $_clearField(8);
}

class ListNotebooksRequest extends $pb.GeneratedMessage {
  factory ListNotebooksRequest() => ListNotebooksRequest._();

  ListNotebooksRequest._();

  factory ListNotebooksRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListNotebooksRequest()..mergeFromBuffer(data, registry);
  factory ListNotebooksRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListNotebooksRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListNotebooksRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: ListNotebooksRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotebooksRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotebooksRequest copyWith(void Function(ListNotebooksRequest) updates) =>
      super.copyWith((message) => updates(message as ListNotebooksRequest))
          as ListNotebooksRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListNotebooksRequest() / ListNotebooksRequest.new instead')
  static ListNotebooksRequest create() => ListNotebooksRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListNotebooksRequest._();
  @$core.override
  ListNotebooksRequest createEmptyInstance() => ListNotebooksRequest._();
  @$core.pragma('dart2js:noInline')
  static ListNotebooksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListNotebooksRequest>(
          ListNotebooksRequest.$_createMessage);
  static ListNotebooksRequest? _defaultInstance;
}

class ListNotebooksResponse extends $pb.GeneratedMessage {
  factory ListNotebooksResponse({
    $core.Iterable<Notebook>? notebooks,
  }) {
    final result = ListNotebooksResponse._();
    if (notebooks != null) result.notebooks.addAll(notebooks);
    return result;
  }

  ListNotebooksResponse._();

  factory ListNotebooksResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListNotebooksResponse()..mergeFromBuffer(data, registry);
  factory ListNotebooksResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListNotebooksResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListNotebooksResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: ListNotebooksResponse.$_createMessage)
    ..pPM<Notebook>(1, _omitFieldNames ? '' : 'notebooks',
        subBuilder: Notebook.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotebooksResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotebooksResponse copyWith(
          void Function(ListNotebooksResponse) updates) =>
      super.copyWith((message) => updates(message as ListNotebooksResponse))
          as ListNotebooksResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListNotebooksResponse() / ListNotebooksResponse.new instead')
  static ListNotebooksResponse create() => ListNotebooksResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListNotebooksResponse._();
  @$core.override
  ListNotebooksResponse createEmptyInstance() => ListNotebooksResponse._();
  @$core.pragma('dart2js:noInline')
  static ListNotebooksResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListNotebooksResponse>(
          ListNotebooksResponse.$_createMessage);
  static ListNotebooksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Notebook> get notebooks => $_getList(0);
}

enum CreateNotebookRequest_Source { empty, cloneRemote, existingPath, notSet }

class CreateNotebookRequest extends $pb.GeneratedMessage {
  factory CreateNotebookRequest({
    $core.String? name,
    $core.bool? empty,
    Remote? cloneRemote,
    $core.String? existingPath,
    Author? author,
    Remote? remote,
    $core.String? targetPath,
  }) {
    final result = CreateNotebookRequest._();
    if (name != null) result.name = name;
    if (empty != null) result.empty = empty;
    if (cloneRemote != null) result.cloneRemote = cloneRemote;
    if (existingPath != null) result.existingPath = existingPath;
    if (author != null) result.author = author;
    if (remote != null) result.remote = remote;
    if (targetPath != null) result.targetPath = targetPath;
    return result;
  }

  CreateNotebookRequest._();

  factory CreateNotebookRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateNotebookRequest()..mergeFromBuffer(data, registry);
  factory CreateNotebookRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateNotebookRequest()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, CreateNotebookRequest_Source>
      _CreateNotebookRequest_SourceByTag = {
    2: CreateNotebookRequest_Source.empty,
    3: CreateNotebookRequest_Source.cloneRemote,
    4: CreateNotebookRequest_Source.existingPath,
    0: CreateNotebookRequest_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateNotebookRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: CreateNotebookRequest.$_createMessage)
    ..oo(0, [2, 3, 4])
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOB(2, _omitFieldNames ? '' : 'empty')
    ..aOM<Remote>(3, _omitFieldNames ? '' : 'cloneRemote',
        subBuilder: Remote.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'existingPath')
    ..aOM<Author>(5, _omitFieldNames ? '' : 'author',
        subBuilder: Author.$_createMessage)
    ..aOM<Remote>(6, _omitFieldNames ? '' : 'remote',
        subBuilder: Remote.$_createMessage)
    ..aOS(7, _omitFieldNames ? '' : 'targetPath')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateNotebookRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateNotebookRequest copyWith(
          void Function(CreateNotebookRequest) updates) =>
      super.copyWith((message) => updates(message as CreateNotebookRequest))
          as CreateNotebookRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateNotebookRequest() / CreateNotebookRequest.new instead')
  static CreateNotebookRequest create() => CreateNotebookRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateNotebookRequest._();
  @$core.override
  CreateNotebookRequest createEmptyInstance() => CreateNotebookRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateNotebookRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateNotebookRequest>(
          CreateNotebookRequest.$_createMessage);
  static CreateNotebookRequest? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  CreateNotebookRequest_Source whichSource() =>
      _CreateNotebookRequest_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// An empty repository in the app's storage, optionally with a remote to
  /// push to later.
  @$pb.TagNumber(2)
  $core.bool get empty => $_getBF(1);
  @$pb.TagNumber(2)
  set empty($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmpty() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmpty() => $_clearField(2);

  /// Clone this remote into the app's storage.
  @$pb.TagNumber(3)
  Remote get cloneRemote => $_getN(2);
  @$pb.TagNumber(3)
  set cloneRemote(Remote value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCloneRemote() => $_has(2);
  @$pb.TagNumber(3)
  void clearCloneRemote() => $_clearField(3);
  @$pb.TagNumber(3)
  Remote ensureCloneRemote() => $_ensure(2);

  /// Use an existing git working tree, e.g. in Android's shared storage
  /// (needs the all-files permission there).
  @$pb.TagNumber(4)
  $core.String get existingPath => $_getSZ(3);
  @$pb.TagNumber(4)
  set existingPath($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExistingPath() => $_has(3);
  @$pb.TagNumber(4)
  void clearExistingPath() => $_clearField(4);

  @$pb.TagNumber(5)
  Author get author => $_getN(4);
  @$pb.TagNumber(5)
  set author(Author value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAuthor() => $_has(4);
  @$pb.TagNumber(5)
  void clearAuthor() => $_clearField(5);
  @$pb.TagNumber(5)
  Author ensureAuthor() => $_ensure(4);

  /// Remote for an empty notebook.
  @$pb.TagNumber(6)
  Remote get remote => $_getN(5);
  @$pb.TagNumber(6)
  set remote(Remote value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRemote() => $_has(5);
  @$pb.TagNumber(6)
  void clearRemote() => $_clearField(6);
  @$pb.TagNumber(6)
  Remote ensureRemote() => $_ensure(5);

  /// For empty and cloned notebooks: put the working tree here instead of the
  /// app's storage, e.g. /storage/emulated/0/Documents/Notes. It must not
  /// exist yet or be empty.
  @$pb.TagNumber(7)
  $core.String get targetPath => $_getSZ(6);
  @$pb.TagNumber(7)
  set targetPath($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTargetPath() => $_has(6);
  @$pb.TagNumber(7)
  void clearTargetPath() => $_clearField(7);
}

class UpdateNotebookRequest extends $pb.GeneratedMessage {
  factory UpdateNotebookRequest({
    Notebook? notebook,
  }) {
    final result = UpdateNotebookRequest._();
    if (notebook != null) result.notebook = notebook;
    return result;
  }

  UpdateNotebookRequest._();

  factory UpdateNotebookRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateNotebookRequest()..mergeFromBuffer(data, registry);
  factory UpdateNotebookRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateNotebookRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateNotebookRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: UpdateNotebookRequest.$_createMessage)
    ..aOM<Notebook>(1, _omitFieldNames ? '' : 'notebook',
        subBuilder: Notebook.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateNotebookRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateNotebookRequest copyWith(
          void Function(UpdateNotebookRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateNotebookRequest))
          as UpdateNotebookRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateNotebookRequest() / UpdateNotebookRequest.new instead')
  static UpdateNotebookRequest create() => UpdateNotebookRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateNotebookRequest._();
  @$core.override
  UpdateNotebookRequest createEmptyInstance() => UpdateNotebookRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateNotebookRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateNotebookRequest>(
          UpdateNotebookRequest.$_createMessage);
  static UpdateNotebookRequest? _defaultInstance;

  /// Fields of notebook replace the stored ones, except that an empty
  /// remote.password keeps the stored password.
  @$pb.TagNumber(1)
  Notebook get notebook => $_getN(0);
  @$pb.TagNumber(1)
  set notebook(Notebook value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNotebook() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotebook() => $_clearField(1);
  @$pb.TagNumber(1)
  Notebook ensureNotebook() => $_ensure(0);
}

class DeleteNotebookRequest extends $pb.GeneratedMessage {
  factory DeleteNotebookRequest({
    $core.String? id,
    $core.bool? deleteFiles,
  }) {
    final result = DeleteNotebookRequest._();
    if (id != null) result.id = id;
    if (deleteFiles != null) result.deleteFiles = deleteFiles;
    return result;
  }

  DeleteNotebookRequest._();

  factory DeleteNotebookRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteNotebookRequest()..mergeFromBuffer(data, registry);
  factory DeleteNotebookRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteNotebookRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteNotebookRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: DeleteNotebookRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOB(2, _omitFieldNames ? '' : 'deleteFiles')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteNotebookRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteNotebookRequest copyWith(
          void Function(DeleteNotebookRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteNotebookRequest))
          as DeleteNotebookRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteNotebookRequest() / DeleteNotebookRequest.new instead')
  static DeleteNotebookRequest create() => DeleteNotebookRequest._();
  static $pb.GeneratedMessage $_createMessage() => DeleteNotebookRequest._();
  @$core.override
  DeleteNotebookRequest createEmptyInstance() => DeleteNotebookRequest._();
  @$core.pragma('dart2js:noInline')
  static DeleteNotebookRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteNotebookRequest>(
          DeleteNotebookRequest.$_createMessage);
  static DeleteNotebookRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// Also delete the working tree. Only done for notebooks in the app's own
  /// storage; an existing folder that was opened is never deleted.
  @$pb.TagNumber(2)
  $core.bool get deleteFiles => $_getBF(1);
  @$pb.TagNumber(2)
  set deleteFiles($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeleteFiles() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeleteFiles() => $_clearField(2);
}

class DeleteNotebookResponse extends $pb.GeneratedMessage {
  factory DeleteNotebookResponse() => DeleteNotebookResponse._();

  DeleteNotebookResponse._();

  factory DeleteNotebookResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteNotebookResponse()..mergeFromBuffer(data, registry);
  factory DeleteNotebookResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteNotebookResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteNotebookResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: DeleteNotebookResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteNotebookResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteNotebookResponse copyWith(
          void Function(DeleteNotebookResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteNotebookResponse))
          as DeleteNotebookResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteNotebookResponse() / DeleteNotebookResponse.new instead')
  static DeleteNotebookResponse create() => DeleteNotebookResponse._();
  static $pb.GeneratedMessage $_createMessage() => DeleteNotebookResponse._();
  @$core.override
  DeleteNotebookResponse createEmptyInstance() => DeleteNotebookResponse._();
  @$core.pragma('dart2js:noInline')
  static DeleteNotebookResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteNotebookResponse>(
          DeleteNotebookResponse.$_createMessage);
  static DeleteNotebookResponse? _defaultInstance;
}

class SshKey extends $pb.GeneratedMessage {
  factory SshKey({
    $core.String? id,
    SshKeyType? type,
    $core.String? publicKey,
    $core.String? fingerprint,
  }) {
    final result = SshKey._();
    if (id != null) result.id = id;
    if (type != null) result.type = type;
    if (publicKey != null) result.publicKey = publicKey;
    if (fingerprint != null) result.fingerprint = fingerprint;
    return result;
  }

  SshKey._();

  factory SshKey.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SshKey()..mergeFromBuffer(data, registry);
  factory SshKey.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SshKey()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SshKey',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: SshKey.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aE<SshKeyType>(2, _omitFieldNames ? '' : 'type',
        enumValues: SshKeyType.values)
    ..aOS(3, _omitFieldNames ? '' : 'publicKey')
    ..aOS(4, _omitFieldNames ? '' : 'fingerprint')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SshKey clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SshKey copyWith(void Function(SshKey) updates) =>
      super.copyWith((message) => updates(message as SshKey)) as SshKey;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SshKey() / SshKey.new instead')
  static SshKey create() => SshKey._();
  static $pb.GeneratedMessage $_createMessage() => SshKey._();
  @$core.override
  SshKey createEmptyInstance() => SshKey._();
  @$core.pragma('dart2js:noInline')
  static SshKey getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SshKey>(SshKey.$_createMessage);
  static SshKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  SshKeyType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(SshKeyType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  /// OpenSSH authorized_keys line, to add as a deploy key on the git host.
  @$pb.TagNumber(3)
  $core.String get publicKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set publicKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPublicKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearPublicKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get fingerprint => $_getSZ(3);
  @$pb.TagNumber(4)
  set fingerprint($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFingerprint() => $_has(3);
  @$pb.TagNumber(4)
  void clearFingerprint() => $_clearField(4);
}

class GenerateSshKeyRequest extends $pb.GeneratedMessage {
  factory GenerateSshKeyRequest({
    SshKeyType? type,
    $core.String? comment,
  }) {
    final result = GenerateSshKeyRequest._();
    if (type != null) result.type = type;
    if (comment != null) result.comment = comment;
    return result;
  }

  GenerateSshKeyRequest._();

  factory GenerateSshKeyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GenerateSshKeyRequest()..mergeFromBuffer(data, registry);
  factory GenerateSshKeyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GenerateSshKeyRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GenerateSshKeyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: GenerateSshKeyRequest.$_createMessage)
    ..aE<SshKeyType>(1, _omitFieldNames ? '' : 'type',
        enumValues: SshKeyType.values)
    ..aOS(2, _omitFieldNames ? '' : 'comment')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenerateSshKeyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenerateSshKeyRequest copyWith(
          void Function(GenerateSshKeyRequest) updates) =>
      super.copyWith((message) => updates(message as GenerateSshKeyRequest))
          as GenerateSshKeyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GenerateSshKeyRequest() / GenerateSshKeyRequest.new instead')
  static GenerateSshKeyRequest create() => GenerateSshKeyRequest._();
  static $pb.GeneratedMessage $_createMessage() => GenerateSshKeyRequest._();
  @$core.override
  GenerateSshKeyRequest createEmptyInstance() => GenerateSshKeyRequest._();
  @$core.pragma('dart2js:noInline')
  static GenerateSshKeyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GenerateSshKeyRequest>(
          GenerateSshKeyRequest.$_createMessage);
  static GenerateSshKeyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  SshKeyType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(SshKeyType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  /// Ends up as the comment of the public key, e.g. "githeft@phone".
  @$pb.TagNumber(2)
  $core.String get comment => $_getSZ(1);
  @$pb.TagNumber(2)
  set comment($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasComment() => $_has(1);
  @$pb.TagNumber(2)
  void clearComment() => $_clearField(2);
}

class ImportSshKeyRequest extends $pb.GeneratedMessage {
  factory ImportSshKeyRequest({
    $core.String? privateKey,
    $core.String? passphrase,
  }) {
    final result = ImportSshKeyRequest._();
    if (privateKey != null) result.privateKey = privateKey;
    if (passphrase != null) result.passphrase = passphrase;
    return result;
  }

  ImportSshKeyRequest._();

  factory ImportSshKeyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImportSshKeyRequest()..mergeFromBuffer(data, registry);
  factory ImportSshKeyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImportSshKeyRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImportSshKeyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: ImportSshKeyRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'privateKey')
    ..aOS(2, _omitFieldNames ? '' : 'passphrase')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportSshKeyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportSshKeyRequest copyWith(void Function(ImportSshKeyRequest) updates) =>
      super.copyWith((message) => updates(message as ImportSshKeyRequest))
          as ImportSshKeyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ImportSshKeyRequest() / ImportSshKeyRequest.new instead')
  static ImportSshKeyRequest create() => ImportSshKeyRequest._();
  static $pb.GeneratedMessage $_createMessage() => ImportSshKeyRequest._();
  @$core.override
  ImportSshKeyRequest createEmptyInstance() => ImportSshKeyRequest._();
  @$core.pragma('dart2js:noInline')
  static ImportSshKeyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ImportSshKeyRequest>(
          ImportSshKeyRequest.$_createMessage);
  static ImportSshKeyRequest? _defaultInstance;

  /// PEM or OpenSSH private key.
  @$pb.TagNumber(1)
  $core.String get privateKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set privateKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrivateKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrivateKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get passphrase => $_getSZ(1);
  @$pb.TagNumber(2)
  set passphrase($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassphrase() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassphrase() => $_clearField(2);
}

class GetSshKeyRequest extends $pb.GeneratedMessage {
  factory GetSshKeyRequest({
    $core.String? id,
  }) {
    final result = GetSshKeyRequest._();
    if (id != null) result.id = id;
    return result;
  }

  GetSshKeyRequest._();

  factory GetSshKeyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSshKeyRequest()..mergeFromBuffer(data, registry);
  factory GetSshKeyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSshKeyRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSshKeyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: GetSshKeyRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSshKeyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSshKeyRequest copyWith(void Function(GetSshKeyRequest) updates) =>
      super.copyWith((message) => updates(message as GetSshKeyRequest))
          as GetSshKeyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetSshKeyRequest() / GetSshKeyRequest.new instead')
  static GetSshKeyRequest create() => GetSshKeyRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetSshKeyRequest._();
  @$core.override
  GetSshKeyRequest createEmptyInstance() => GetSshKeyRequest._();
  @$core.pragma('dart2js:noInline')
  static GetSshKeyRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSshKeyRequest>(
          GetSshKeyRequest.$_createMessage);
  static GetSshKeyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class TestRemoteRequest extends $pb.GeneratedMessage {
  factory TestRemoteRequest({
    Remote? remote,
    $core.String? notebookId,
  }) {
    final result = TestRemoteRequest._();
    if (remote != null) result.remote = remote;
    if (notebookId != null) result.notebookId = notebookId;
    return result;
  }

  TestRemoteRequest._();

  factory TestRemoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TestRemoteRequest()..mergeFromBuffer(data, registry);
  factory TestRemoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TestRemoteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TestRemoteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: TestRemoteRequest.$_createMessage)
    ..aOM<Remote>(1, _omitFieldNames ? '' : 'remote',
        subBuilder: Remote.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'notebookId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestRemoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestRemoteRequest copyWith(void Function(TestRemoteRequest) updates) =>
      super.copyWith((message) => updates(message as TestRemoteRequest))
          as TestRemoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TestRemoteRequest() / TestRemoteRequest.new instead')
  static TestRemoteRequest create() => TestRemoteRequest._();
  static $pb.GeneratedMessage $_createMessage() => TestRemoteRequest._();
  @$core.override
  TestRemoteRequest createEmptyInstance() => TestRemoteRequest._();
  @$core.pragma('dart2js:noInline')
  static TestRemoteRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TestRemoteRequest>(
          TestRemoteRequest.$_createMessage);
  static TestRemoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Remote get remote => $_getN(0);
  @$pb.TagNumber(1)
  set remote(Remote value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRemote() => $_has(0);
  @$pb.TagNumber(1)
  void clearRemote() => $_clearField(1);
  @$pb.TagNumber(1)
  Remote ensureRemote() => $_ensure(0);

  /// Notebook whose stored password to use when remote.password is empty.
  @$pb.TagNumber(2)
  $core.String get notebookId => $_getSZ(1);
  @$pb.TagNumber(2)
  set notebookId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNotebookId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNotebookId() => $_clearField(2);
}

class TestRemoteResponse extends $pb.GeneratedMessage {
  factory TestRemoteResponse({
    $core.Iterable<$core.String>? branches,
    $core.String? defaultBranch,
  }) {
    final result = TestRemoteResponse._();
    if (branches != null) result.branches.addAll(branches);
    if (defaultBranch != null) result.defaultBranch = defaultBranch;
    return result;
  }

  TestRemoteResponse._();

  factory TestRemoteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TestRemoteResponse()..mergeFromBuffer(data, registry);
  factory TestRemoteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TestRemoteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TestRemoteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: TestRemoteResponse.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'branches')
    ..aOS(2, _omitFieldNames ? '' : 'defaultBranch')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestRemoteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestRemoteResponse copyWith(void Function(TestRemoteResponse) updates) =>
      super.copyWith((message) => updates(message as TestRemoteResponse))
          as TestRemoteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TestRemoteResponse() / TestRemoteResponse.new instead')
  static TestRemoteResponse create() => TestRemoteResponse._();
  static $pb.GeneratedMessage $_createMessage() => TestRemoteResponse._();
  @$core.override
  TestRemoteResponse createEmptyInstance() => TestRemoteResponse._();
  @$core.pragma('dart2js:noInline')
  static TestRemoteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TestRemoteResponse>(
          TestRemoteResponse.$_createMessage);
  static TestRemoteResponse? _defaultInstance;

  /// Branches on the remote; empty for an empty repository.
  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get branches => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get defaultBranch => $_getSZ(1);
  @$pb.TagNumber(2)
  set defaultBranch($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDefaultBranch() => $_has(1);
  @$pb.TagNumber(2)
  void clearDefaultBranch() => $_clearField(2);
}

class ForgetHostKeyRequest extends $pb.GeneratedMessage {
  factory ForgetHostKeyRequest({
    $core.String? host,
  }) {
    final result = ForgetHostKeyRequest._();
    if (host != null) result.host = host;
    return result;
  }

  ForgetHostKeyRequest._();

  factory ForgetHostKeyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ForgetHostKeyRequest()..mergeFromBuffer(data, registry);
  factory ForgetHostKeyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ForgetHostKeyRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ForgetHostKeyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: ForgetHostKeyRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'host')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForgetHostKeyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForgetHostKeyRequest copyWith(void Function(ForgetHostKeyRequest) updates) =>
      super.copyWith((message) => updates(message as ForgetHostKeyRequest))
          as ForgetHostKeyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ForgetHostKeyRequest() / ForgetHostKeyRequest.new instead')
  static ForgetHostKeyRequest create() => ForgetHostKeyRequest._();
  static $pb.GeneratedMessage $_createMessage() => ForgetHostKeyRequest._();
  @$core.override
  ForgetHostKeyRequest createEmptyInstance() => ForgetHostKeyRequest._();
  @$core.pragma('dart2js:noInline')
  static ForgetHostKeyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ForgetHostKeyRequest>(
          ForgetHostKeyRequest.$_createMessage);
  static ForgetHostKeyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get host => $_getSZ(0);
  @$pb.TagNumber(1)
  set host($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHost() => $_has(0);
  @$pb.TagNumber(1)
  void clearHost() => $_clearField(1);
}

class ForgetHostKeyResponse extends $pb.GeneratedMessage {
  factory ForgetHostKeyResponse() => ForgetHostKeyResponse._();

  ForgetHostKeyResponse._();

  factory ForgetHostKeyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ForgetHostKeyResponse()..mergeFromBuffer(data, registry);
  factory ForgetHostKeyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ForgetHostKeyResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ForgetHostKeyResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: ForgetHostKeyResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForgetHostKeyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForgetHostKeyResponse copyWith(
          void Function(ForgetHostKeyResponse) updates) =>
      super.copyWith((message) => updates(message as ForgetHostKeyResponse))
          as ForgetHostKeyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ForgetHostKeyResponse() / ForgetHostKeyResponse.new instead')
  static ForgetHostKeyResponse create() => ForgetHostKeyResponse._();
  static $pb.GeneratedMessage $_createMessage() => ForgetHostKeyResponse._();
  @$core.override
  ForgetHostKeyResponse createEmptyInstance() => ForgetHostKeyResponse._();
  @$core.pragma('dart2js:noInline')
  static ForgetHostKeyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ForgetHostKeyResponse>(
          ForgetHostKeyResponse.$_createMessage);
  static ForgetHostKeyResponse? _defaultInstance;
}

class NoteSummary extends $pb.GeneratedMessage {
  factory NoteSummary({
    $core.String? path,
    $core.String? title,
    $core.String? excerpt,
    $core.Iterable<$core.String>? tags,
    $fixnum.Int64? created,
    $fixnum.Int64? modified,
    $core.bool? conflict,
    $core.bool? pinned,
    NoteType? type,
  }) {
    final result = NoteSummary._();
    if (path != null) result.path = path;
    if (title != null) result.title = title;
    if (excerpt != null) result.excerpt = excerpt;
    if (tags != null) result.tags.addAll(tags);
    if (created != null) result.created = created;
    if (modified != null) result.modified = modified;
    if (conflict != null) result.conflict = conflict;
    if (pinned != null) result.pinned = pinned;
    if (type != null) result.type = type;
    return result;
  }

  NoteSummary._();

  factory NoteSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NoteSummary()..mergeFromBuffer(data, registry);
  factory NoteSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NoteSummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NoteSummary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: NoteSummary.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'excerpt')
    ..pPS(4, _omitFieldNames ? '' : 'tags')
    ..aInt64(5, _omitFieldNames ? '' : 'created')
    ..aInt64(6, _omitFieldNames ? '' : 'modified')
    ..aOB(7, _omitFieldNames ? '' : 'conflict')
    ..aOB(8, _omitFieldNames ? '' : 'pinned')
    ..aE<NoteType>(9, _omitFieldNames ? '' : 'type',
        enumValues: NoteType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NoteSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NoteSummary copyWith(void Function(NoteSummary) updates) =>
      super.copyWith((message) => updates(message as NoteSummary))
          as NoteSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use NoteSummary() / NoteSummary.new instead')
  static NoteSummary create() => NoteSummary._();
  static $pb.GeneratedMessage $_createMessage() => NoteSummary._();
  @$core.override
  NoteSummary createEmptyInstance() => NoteSummary._();
  @$core.pragma('dart2js:noInline')
  static NoteSummary getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NoteSummary>(
          NoteSummary.$_createMessage);
  static NoteSummary? _defaultInstance;

  /// Path relative to the notebook root, with forward slashes.
  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  /// Start of the body, for the list.
  @$pb.TagNumber(3)
  $core.String get excerpt => $_getSZ(2);
  @$pb.TagNumber(3)
  set excerpt($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExcerpt() => $_has(2);
  @$pb.TagNumber(3)
  void clearExcerpt() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get tags => $_getList(3);

  /// Unix seconds, from the front matter or else the file's modification time.
  @$pb.TagNumber(5)
  $fixnum.Int64 get created => $_getI64(4);
  @$pb.TagNumber(5)
  set created($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreated() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreated() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get modified => $_getI64(5);
  @$pb.TagNumber(6)
  set modified($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasModified() => $_has(5);
  @$pb.TagNumber(6)
  void clearModified() => $_clearField(6);

  /// The file still has git conflict markers or is a conflict copy.
  @$pb.TagNumber(7)
  $core.bool get conflict => $_getBF(6);
  @$pb.TagNumber(7)
  set conflict($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasConflict() => $_has(6);
  @$pb.TagNumber(7)
  void clearConflict() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get pinned => $_getBF(7);
  @$pb.TagNumber(8)
  set pinned($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPinned() => $_has(7);
  @$pb.TagNumber(8)
  void clearPinned() => $_clearField(8);

  @$pb.TagNumber(9)
  NoteType get type => $_getN(8);
  @$pb.TagNumber(9)
  set type(NoteType value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasType() => $_has(8);
  @$pb.TagNumber(9)
  void clearType() => $_clearField(9);
}

class Folder extends $pb.GeneratedMessage {
  factory Folder({
    $core.String? path,
    $core.int? noteCount,
  }) {
    final result = Folder._();
    if (path != null) result.path = path;
    if (noteCount != null) result.noteCount = noteCount;
    return result;
  }

  Folder._();

  factory Folder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Folder()..mergeFromBuffer(data, registry);
  factory Folder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Folder()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Folder',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: Folder.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aI(2, _omitFieldNames ? '' : 'noteCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Folder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Folder copyWith(void Function(Folder) updates) =>
      super.copyWith((message) => updates(message as Folder)) as Folder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Folder() / Folder.new instead')
  static Folder create() => Folder._();
  static $pb.GeneratedMessage $_createMessage() => Folder._();
  @$core.override
  Folder createEmptyInstance() => Folder._();
  @$core.pragma('dart2js:noInline')
  static Folder getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Folder>(Folder.$_createMessage);
  static Folder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get noteCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set noteCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNoteCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearNoteCount() => $_clearField(2);
}

class ListNotesRequest extends $pb.GeneratedMessage {
  factory ListNotesRequest({
    $core.String? notebookId,
    $core.String? folder,
    $core.bool? recursive,
    $core.String? query,
    $core.String? tag,
    SortOrder? sort,
  }) {
    final result = ListNotesRequest._();
    if (notebookId != null) result.notebookId = notebookId;
    if (folder != null) result.folder = folder;
    if (recursive != null) result.recursive = recursive;
    if (query != null) result.query = query;
    if (tag != null) result.tag = tag;
    if (sort != null) result.sort = sort;
    return result;
  }

  ListNotesRequest._();

  factory ListNotesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListNotesRequest()..mergeFromBuffer(data, registry);
  factory ListNotesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListNotesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListNotesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: ListNotesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'notebookId')
    ..aOS(2, _omitFieldNames ? '' : 'folder')
    ..aOB(3, _omitFieldNames ? '' : 'recursive')
    ..aOS(4, _omitFieldNames ? '' : 'query')
    ..aOS(5, _omitFieldNames ? '' : 'tag')
    ..aE<SortOrder>(6, _omitFieldNames ? '' : 'sort',
        enumValues: SortOrder.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotesRequest copyWith(void Function(ListNotesRequest) updates) =>
      super.copyWith((message) => updates(message as ListNotesRequest))
          as ListNotesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListNotesRequest() / ListNotesRequest.new instead')
  static ListNotesRequest create() => ListNotesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListNotesRequest._();
  @$core.override
  ListNotesRequest createEmptyInstance() => ListNotesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListNotesRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListNotesRequest>(
          ListNotesRequest.$_createMessage);
  static ListNotesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notebookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notebookId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotebookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotebookId() => $_clearField(1);

  /// Only notes in this folder ("" is the root).
  @$pb.TagNumber(2)
  $core.String get folder => $_getSZ(1);
  @$pb.TagNumber(2)
  set folder($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFolder() => $_has(1);
  @$pb.TagNumber(2)
  void clearFolder() => $_clearField(2);

  /// Include notes in subfolders.
  @$pb.TagNumber(3)
  $core.bool get recursive => $_getBF(2);
  @$pb.TagNumber(3)
  set recursive($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecursive() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecursive() => $_clearField(3);

  /// Case-insensitive search in titles, paths and bodies.
  @$pb.TagNumber(4)
  $core.String get query => $_getSZ(3);
  @$pb.TagNumber(4)
  set query($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuery() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuery() => $_clearField(4);

  /// Only notes with this tag.
  @$pb.TagNumber(5)
  $core.String get tag => $_getSZ(4);
  @$pb.TagNumber(5)
  set tag($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTag() => $_has(4);
  @$pb.TagNumber(5)
  void clearTag() => $_clearField(5);

  @$pb.TagNumber(6)
  SortOrder get sort => $_getN(5);
  @$pb.TagNumber(6)
  set sort(SortOrder value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSort() => $_has(5);
  @$pb.TagNumber(6)
  void clearSort() => $_clearField(6);
}

class ListNotesResponse extends $pb.GeneratedMessage {
  factory ListNotesResponse({
    $core.Iterable<NoteSummary>? notes,
    $core.Iterable<Folder>? folders,
  }) {
    final result = ListNotesResponse._();
    if (notes != null) result.notes.addAll(notes);
    if (folders != null) result.folders.addAll(folders);
    return result;
  }

  ListNotesResponse._();

  factory ListNotesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListNotesResponse()..mergeFromBuffer(data, registry);
  factory ListNotesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListNotesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListNotesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: ListNotesResponse.$_createMessage)
    ..pPM<NoteSummary>(1, _omitFieldNames ? '' : 'notes',
        subBuilder: NoteSummary.$_createMessage)
    ..pPM<Folder>(2, _omitFieldNames ? '' : 'folders',
        subBuilder: Folder.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotesResponse copyWith(void Function(ListNotesResponse) updates) =>
      super.copyWith((message) => updates(message as ListNotesResponse))
          as ListNotesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListNotesResponse() / ListNotesResponse.new instead')
  static ListNotesResponse create() => ListNotesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListNotesResponse._();
  @$core.override
  ListNotesResponse createEmptyInstance() => ListNotesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListNotesResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListNotesResponse>(
          ListNotesResponse.$_createMessage);
  static ListNotesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<NoteSummary> get notes => $_getList(0);

  /// Direct subfolders of the folder, or every folder when recursive.
  @$pb.TagNumber(2)
  $pb.PbList<Folder> get folders => $_getList(1);
}

class Note extends $pb.GeneratedMessage {
  factory Note({
    NoteSummary? summary,
    $core.String? body,
    $core.String? raw,
    $core.String? revision,
  }) {
    final result = Note._();
    if (summary != null) result.summary = summary;
    if (body != null) result.body = body;
    if (raw != null) result.raw = raw;
    if (revision != null) result.revision = revision;
    return result;
  }

  Note._();

  factory Note.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Note()..mergeFromBuffer(data, registry);
  factory Note.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Note()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Note',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: Note.$_createMessage)
    ..aOM<NoteSummary>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: NoteSummary.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'body')
    ..aOS(3, _omitFieldNames ? '' : 'raw')
    ..aOS(4, _omitFieldNames ? '' : 'revision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Note clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Note copyWith(void Function(Note) updates) =>
      super.copyWith((message) => updates(message as Note)) as Note;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Note() / Note.new instead')
  static Note create() => Note._();
  static $pb.GeneratedMessage $_createMessage() => Note._();
  @$core.override
  Note createEmptyInstance() => Note._();
  @$core.pragma('dart2js:noInline')
  static Note getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Note>(Note.$_createMessage);
  static Note? _defaultInstance;

  @$pb.TagNumber(1)
  NoteSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(NoteSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  NoteSummary ensureSummary() => $_ensure(0);

  /// The text below the front matter.
  @$pb.TagNumber(2)
  $core.String get body => $_getSZ(1);
  @$pb.TagNumber(2)
  set body($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBody() => $_has(1);
  @$pb.TagNumber(2)
  void clearBody() => $_clearField(2);

  /// The whole file, front matter included.
  @$pb.TagNumber(3)
  $core.String get raw => $_getSZ(2);
  @$pb.TagNumber(3)
  set raw($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRaw() => $_has(2);
  @$pb.TagNumber(3)
  void clearRaw() => $_clearField(3);

  /// Changes whenever the file changes, to detect edits from a sync while
  /// the note was open.
  @$pb.TagNumber(4)
  $core.String get revision => $_getSZ(3);
  @$pb.TagNumber(4)
  set revision($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevision() => $_clearField(4);
}

class GetNoteRequest extends $pb.GeneratedMessage {
  factory GetNoteRequest({
    $core.String? notebookId,
    $core.String? path,
  }) {
    final result = GetNoteRequest._();
    if (notebookId != null) result.notebookId = notebookId;
    if (path != null) result.path = path;
    return result;
  }

  GetNoteRequest._();

  factory GetNoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetNoteRequest()..mergeFromBuffer(data, registry);
  factory GetNoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetNoteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetNoteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: GetNoteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'notebookId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetNoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetNoteRequest copyWith(void Function(GetNoteRequest) updates) =>
      super.copyWith((message) => updates(message as GetNoteRequest))
          as GetNoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetNoteRequest() / GetNoteRequest.new instead')
  static GetNoteRequest create() => GetNoteRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetNoteRequest._();
  @$core.override
  GetNoteRequest createEmptyInstance() => GetNoteRequest._();
  @$core.pragma('dart2js:noInline')
  static GetNoteRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetNoteRequest>(
          GetNoteRequest.$_createMessage);
  static GetNoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notebookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notebookId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotebookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotebookId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);
}

class SaveNoteRequest extends $pb.GeneratedMessage {
  factory SaveNoteRequest({
    $core.String? notebookId,
    $core.String? path,
    $core.String? folder,
    $core.String? content,
    $core.bool? raw,
    $core.String? baseRevision,
    $core.String? baseContent,
    TagList? tags,
    NoteType? type,
  }) {
    final result = SaveNoteRequest._();
    if (notebookId != null) result.notebookId = notebookId;
    if (path != null) result.path = path;
    if (folder != null) result.folder = folder;
    if (content != null) result.content = content;
    if (raw != null) result.raw = raw;
    if (baseRevision != null) result.baseRevision = baseRevision;
    if (baseContent != null) result.baseContent = baseContent;
    if (tags != null) result.tags = tags;
    if (type != null) result.type = type;
    return result;
  }

  SaveNoteRequest._();

  factory SaveNoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SaveNoteRequest()..mergeFromBuffer(data, registry);
  factory SaveNoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SaveNoteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SaveNoteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: SaveNoteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'notebookId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..aOS(3, _omitFieldNames ? '' : 'folder')
    ..aOS(4, _omitFieldNames ? '' : 'content')
    ..aOB(5, _omitFieldNames ? '' : 'raw')
    ..aOS(6, _omitFieldNames ? '' : 'baseRevision')
    ..aOS(7, _omitFieldNames ? '' : 'baseContent')
    ..aOM<TagList>(8, _omitFieldNames ? '' : 'tags',
        subBuilder: TagList.$_createMessage)
    ..aE<NoteType>(9, _omitFieldNames ? '' : 'type',
        enumValues: NoteType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveNoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveNoteRequest copyWith(void Function(SaveNoteRequest) updates) =>
      super.copyWith((message) => updates(message as SaveNoteRequest))
          as SaveNoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SaveNoteRequest() / SaveNoteRequest.new instead')
  static SaveNoteRequest create() => SaveNoteRequest._();
  static $pb.GeneratedMessage $_createMessage() => SaveNoteRequest._();
  @$core.override
  SaveNoteRequest createEmptyInstance() => SaveNoteRequest._();
  @$core.pragma('dart2js:noInline')
  static SaveNoteRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SaveNoteRequest>(
          SaveNoteRequest.$_createMessage);
  static SaveNoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notebookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notebookId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotebookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotebookId() => $_clearField(1);

  /// Empty for a new note; the core picks a name in folder.
  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get folder => $_getSZ(2);
  @$pb.TagNumber(3)
  set folder($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFolder() => $_has(2);
  @$pb.TagNumber(3)
  void clearFolder() => $_clearField(3);

  /// New body, or with raw set the whole file.
  @$pb.TagNumber(4)
  $core.String get content => $_getSZ(3);
  @$pb.TagNumber(4)
  set content($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContent() => $_has(3);
  @$pb.TagNumber(4)
  void clearContent() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get raw => $_getBF(4);
  @$pb.TagNumber(5)
  set raw($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRaw() => $_has(4);
  @$pb.TagNumber(5)
  void clearRaw() => $_clearField(5);

  /// For an existing note: the revision and body the editor started from.
  /// When the file changed in between, the core merges both edits.
  @$pb.TagNumber(6)
  $core.String get baseRevision => $_getSZ(5);
  @$pb.TagNumber(6)
  set baseRevision($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBaseRevision() => $_has(5);
  @$pb.TagNumber(6)
  void clearBaseRevision() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get baseContent => $_getSZ(6);
  @$pb.TagNumber(7)
  set baseContent($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBaseContent() => $_has(6);
  @$pb.TagNumber(7)
  void clearBaseContent() => $_clearField(7);

  /// Replaces the tags in the front matter when set.
  @$pb.TagNumber(8)
  TagList get tags => $_getN(7);
  @$pb.TagNumber(8)
  set tags(TagList value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasTags() => $_has(7);
  @$pb.TagNumber(8)
  void clearTags() => $_clearField(8);
  @$pb.TagNumber(8)
  TagList ensureTags() => $_ensure(7);

  /// For a new note: its editor type. Journal entries are always named by
  /// date and time.
  @$pb.TagNumber(9)
  NoteType get type => $_getN(8);
  @$pb.TagNumber(9)
  set type(NoteType value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasType() => $_has(8);
  @$pb.TagNumber(9)
  void clearType() => $_clearField(9);
}

class UpdateNoteMetaRequest extends $pb.GeneratedMessage {
  factory UpdateNoteMetaRequest({
    $core.String? notebookId,
    $core.String? path,
    $core.bool? pinned,
    NoteType? type,
  }) {
    final result = UpdateNoteMetaRequest._();
    if (notebookId != null) result.notebookId = notebookId;
    if (path != null) result.path = path;
    if (pinned != null) result.pinned = pinned;
    if (type != null) result.type = type;
    return result;
  }

  UpdateNoteMetaRequest._();

  factory UpdateNoteMetaRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateNoteMetaRequest()..mergeFromBuffer(data, registry);
  factory UpdateNoteMetaRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateNoteMetaRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateNoteMetaRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: UpdateNoteMetaRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'notebookId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..aOB(3, _omitFieldNames ? '' : 'pinned')
    ..aE<NoteType>(4, _omitFieldNames ? '' : 'type',
        enumValues: NoteType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateNoteMetaRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateNoteMetaRequest copyWith(
          void Function(UpdateNoteMetaRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateNoteMetaRequest))
          as UpdateNoteMetaRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateNoteMetaRequest() / UpdateNoteMetaRequest.new instead')
  static UpdateNoteMetaRequest create() => UpdateNoteMetaRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateNoteMetaRequest._();
  @$core.override
  UpdateNoteMetaRequest createEmptyInstance() => UpdateNoteMetaRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateNoteMetaRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateNoteMetaRequest>(
          UpdateNoteMetaRequest.$_createMessage);
  static UpdateNoteMetaRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notebookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notebookId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotebookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotebookId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get pinned => $_getBF(2);
  @$pb.TagNumber(3)
  set pinned($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPinned() => $_has(2);
  @$pb.TagNumber(3)
  void clearPinned() => $_clearField(3);

  @$pb.TagNumber(4)
  NoteType get type => $_getN(3);
  @$pb.TagNumber(4)
  set type(NoteType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => $_clearField(4);
}

class AddAttachmentRequest extends $pb.GeneratedMessage {
  factory AddAttachmentRequest({
    $core.String? notebookId,
    $core.String? notePath,
    $core.String? folder,
    $core.String? fileName,
    $core.List<$core.int>? data,
  }) {
    final result = AddAttachmentRequest._();
    if (notebookId != null) result.notebookId = notebookId;
    if (notePath != null) result.notePath = notePath;
    if (folder != null) result.folder = folder;
    if (fileName != null) result.fileName = fileName;
    if (data != null) result.data = data;
    return result;
  }

  AddAttachmentRequest._();

  factory AddAttachmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddAttachmentRequest()..mergeFromBuffer(data, registry);
  factory AddAttachmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddAttachmentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddAttachmentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: AddAttachmentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'notebookId')
    ..aOS(2, _omitFieldNames ? '' : 'notePath')
    ..aOS(3, _omitFieldNames ? '' : 'folder')
    ..aOS(4, _omitFieldNames ? '' : 'fileName')
    ..a<$core.List<$core.int>>(
        5, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAttachmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAttachmentRequest copyWith(void Function(AddAttachmentRequest) updates) =>
      super.copyWith((message) => updates(message as AddAttachmentRequest))
          as AddAttachmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AddAttachmentRequest() / AddAttachmentRequest.new instead')
  static AddAttachmentRequest create() => AddAttachmentRequest._();
  static $pb.GeneratedMessage $_createMessage() => AddAttachmentRequest._();
  @$core.override
  AddAttachmentRequest createEmptyInstance() => AddAttachmentRequest._();
  @$core.pragma('dart2js:noInline')
  static AddAttachmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddAttachmentRequest>(
          AddAttachmentRequest.$_createMessage);
  static AddAttachmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notebookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notebookId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotebookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotebookId() => $_clearField(1);

  /// The note the file is for; it goes into the note's folder. For a note
  /// that is not saved yet, give its folder instead.
  @$pb.TagNumber(2)
  $core.String get notePath => $_getSZ(1);
  @$pb.TagNumber(2)
  set notePath($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNotePath() => $_has(1);
  @$pb.TagNumber(2)
  void clearNotePath() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get folder => $_getSZ(2);
  @$pb.TagNumber(3)
  set folder($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFolder() => $_has(2);
  @$pb.TagNumber(3)
  void clearFolder() => $_clearField(3);

  /// Original name, for the extension; the stored name gets a date.
  @$pb.TagNumber(4)
  $core.String get fileName => $_getSZ(3);
  @$pb.TagNumber(4)
  set fileName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFileName() => $_has(3);
  @$pb.TagNumber(4)
  void clearFileName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get data => $_getN(4);
  @$pb.TagNumber(5)
  set data($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasData() => $_has(4);
  @$pb.TagNumber(5)
  void clearData() => $_clearField(5);
}

class AddAttachmentResponse extends $pb.GeneratedMessage {
  factory AddAttachmentResponse({
    $core.String? path,
    $core.String? markdown,
  }) {
    final result = AddAttachmentResponse._();
    if (path != null) result.path = path;
    if (markdown != null) result.markdown = markdown;
    return result;
  }

  AddAttachmentResponse._();

  factory AddAttachmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddAttachmentResponse()..mergeFromBuffer(data, registry);
  factory AddAttachmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddAttachmentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddAttachmentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: AddAttachmentResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOS(2, _omitFieldNames ? '' : 'markdown')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAttachmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAttachmentResponse copyWith(
          void Function(AddAttachmentResponse) updates) =>
      super.copyWith((message) => updates(message as AddAttachmentResponse))
          as AddAttachmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AddAttachmentResponse() / AddAttachmentResponse.new instead')
  static AddAttachmentResponse create() => AddAttachmentResponse._();
  static $pb.GeneratedMessage $_createMessage() => AddAttachmentResponse._();
  @$core.override
  AddAttachmentResponse createEmptyInstance() => AddAttachmentResponse._();
  @$core.pragma('dart2js:noInline')
  static AddAttachmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddAttachmentResponse>(
          AddAttachmentResponse.$_createMessage);
  static AddAttachmentResponse? _defaultInstance;

  /// Path in the notebook.
  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);

  /// Markdown to insert into the note: ![Image](./name.jpg)
  @$pb.TagNumber(2)
  $core.String get markdown => $_getSZ(1);
  @$pb.TagNumber(2)
  set markdown($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMarkdown() => $_has(1);
  @$pb.TagNumber(2)
  void clearMarkdown() => $_clearField(2);
}

class GetFileRequest extends $pb.GeneratedMessage {
  factory GetFileRequest({
    $core.String? notebookId,
    $core.String? path,
  }) {
    final result = GetFileRequest._();
    if (notebookId != null) result.notebookId = notebookId;
    if (path != null) result.path = path;
    return result;
  }

  GetFileRequest._();

  factory GetFileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFileRequest()..mergeFromBuffer(data, registry);
  factory GetFileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFileRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFileRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: GetFileRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'notebookId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFileRequest copyWith(void Function(GetFileRequest) updates) =>
      super.copyWith((message) => updates(message as GetFileRequest))
          as GetFileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetFileRequest() / GetFileRequest.new instead')
  static GetFileRequest create() => GetFileRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetFileRequest._();
  @$core.override
  GetFileRequest createEmptyInstance() => GetFileRequest._();
  @$core.pragma('dart2js:noInline')
  static GetFileRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetFileRequest>(
          GetFileRequest.$_createMessage);
  static GetFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notebookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notebookId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotebookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotebookId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);
}

class GetFileResponse extends $pb.GeneratedMessage {
  factory GetFileResponse({
    $core.List<$core.int>? data,
    $core.String? mimeType,
  }) {
    final result = GetFileResponse._();
    if (data != null) result.data = data;
    if (mimeType != null) result.mimeType = mimeType;
    return result;
  }

  GetFileResponse._();

  factory GetFileResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFileResponse()..mergeFromBuffer(data, registry);
  factory GetFileResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFileResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFileResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: GetFileResponse.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'mimeType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFileResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFileResponse copyWith(void Function(GetFileResponse) updates) =>
      super.copyWith((message) => updates(message as GetFileResponse))
          as GetFileResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetFileResponse() / GetFileResponse.new instead')
  static GetFileResponse create() => GetFileResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetFileResponse._();
  @$core.override
  GetFileResponse createEmptyInstance() => GetFileResponse._();
  @$core.pragma('dart2js:noInline')
  static GetFileResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetFileResponse>(
          GetFileResponse.$_createMessage);
  static GetFileResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mimeType => $_getSZ(1);
  @$pb.TagNumber(2)
  set mimeType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMimeType() => $_has(1);
  @$pb.TagNumber(2)
  void clearMimeType() => $_clearField(2);
}

class ResolveLinkRequest extends $pb.GeneratedMessage {
  factory ResolveLinkRequest({
    $core.String? notebookId,
    $core.String? fromPath,
    $core.String? target,
  }) {
    final result = ResolveLinkRequest._();
    if (notebookId != null) result.notebookId = notebookId;
    if (fromPath != null) result.fromPath = fromPath;
    if (target != null) result.target = target;
    return result;
  }

  ResolveLinkRequest._();

  factory ResolveLinkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResolveLinkRequest()..mergeFromBuffer(data, registry);
  factory ResolveLinkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResolveLinkRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveLinkRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: ResolveLinkRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'notebookId')
    ..aOS(2, _omitFieldNames ? '' : 'fromPath')
    ..aOS(3, _omitFieldNames ? '' : 'target')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveLinkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveLinkRequest copyWith(void Function(ResolveLinkRequest) updates) =>
      super.copyWith((message) => updates(message as ResolveLinkRequest))
          as ResolveLinkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ResolveLinkRequest() / ResolveLinkRequest.new instead')
  static ResolveLinkRequest create() => ResolveLinkRequest._();
  static $pb.GeneratedMessage $_createMessage() => ResolveLinkRequest._();
  @$core.override
  ResolveLinkRequest createEmptyInstance() => ResolveLinkRequest._();
  @$core.pragma('dart2js:noInline')
  static ResolveLinkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveLinkRequest>(
          ResolveLinkRequest.$_createMessage);
  static ResolveLinkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notebookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notebookId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotebookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotebookId() => $_clearField(1);

  /// The note the link is in.
  @$pb.TagNumber(2)
  $core.String get fromPath => $_getSZ(1);
  @$pb.TagNumber(2)
  set fromPath($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFromPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromPath() => $_clearField(2);

  /// "[[target]]" without brackets, or the href of a Markdown link.
  @$pb.TagNumber(3)
  $core.String get target => $_getSZ(2);
  @$pb.TagNumber(3)
  set target($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTarget() => $_has(2);
  @$pb.TagNumber(3)
  void clearTarget() => $_clearField(3);
}

class ResolveLinkResponse extends $pb.GeneratedMessage {
  factory ResolveLinkResponse({
    $core.String? path,
  }) {
    final result = ResolveLinkResponse._();
    if (path != null) result.path = path;
    return result;
  }

  ResolveLinkResponse._();

  factory ResolveLinkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResolveLinkResponse()..mergeFromBuffer(data, registry);
  factory ResolveLinkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResolveLinkResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveLinkResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: ResolveLinkResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveLinkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveLinkResponse copyWith(void Function(ResolveLinkResponse) updates) =>
      super.copyWith((message) => updates(message as ResolveLinkResponse))
          as ResolveLinkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ResolveLinkResponse() / ResolveLinkResponse.new instead')
  static ResolveLinkResponse create() => ResolveLinkResponse._();
  static $pb.GeneratedMessage $_createMessage() => ResolveLinkResponse._();
  @$core.override
  ResolveLinkResponse createEmptyInstance() => ResolveLinkResponse._();
  @$core.pragma('dart2js:noInline')
  static ResolveLinkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveLinkResponse>(
          ResolveLinkResponse.$_createMessage);
  static ResolveLinkResponse? _defaultInstance;

  /// Empty when no note matches.
  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);
}

class GetBacklinksRequest extends $pb.GeneratedMessage {
  factory GetBacklinksRequest({
    $core.String? notebookId,
    $core.String? path,
  }) {
    final result = GetBacklinksRequest._();
    if (notebookId != null) result.notebookId = notebookId;
    if (path != null) result.path = path;
    return result;
  }

  GetBacklinksRequest._();

  factory GetBacklinksRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetBacklinksRequest()..mergeFromBuffer(data, registry);
  factory GetBacklinksRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetBacklinksRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBacklinksRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: GetBacklinksRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'notebookId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBacklinksRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBacklinksRequest copyWith(void Function(GetBacklinksRequest) updates) =>
      super.copyWith((message) => updates(message as GetBacklinksRequest))
          as GetBacklinksRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetBacklinksRequest() / GetBacklinksRequest.new instead')
  static GetBacklinksRequest create() => GetBacklinksRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetBacklinksRequest._();
  @$core.override
  GetBacklinksRequest createEmptyInstance() => GetBacklinksRequest._();
  @$core.pragma('dart2js:noInline')
  static GetBacklinksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBacklinksRequest>(
          GetBacklinksRequest.$_createMessage);
  static GetBacklinksRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notebookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notebookId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotebookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotebookId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);
}

class GetBacklinksResponse extends $pb.GeneratedMessage {
  factory GetBacklinksResponse({
    $core.Iterable<NoteSummary>? notes,
  }) {
    final result = GetBacklinksResponse._();
    if (notes != null) result.notes.addAll(notes);
    return result;
  }

  GetBacklinksResponse._();

  factory GetBacklinksResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetBacklinksResponse()..mergeFromBuffer(data, registry);
  factory GetBacklinksResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetBacklinksResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBacklinksResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: GetBacklinksResponse.$_createMessage)
    ..pPM<NoteSummary>(1, _omitFieldNames ? '' : 'notes',
        subBuilder: NoteSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBacklinksResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBacklinksResponse copyWith(void Function(GetBacklinksResponse) updates) =>
      super.copyWith((message) => updates(message as GetBacklinksResponse))
          as GetBacklinksResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetBacklinksResponse() / GetBacklinksResponse.new instead')
  static GetBacklinksResponse create() => GetBacklinksResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetBacklinksResponse._();
  @$core.override
  GetBacklinksResponse createEmptyInstance() => GetBacklinksResponse._();
  @$core.pragma('dart2js:noInline')
  static GetBacklinksResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBacklinksResponse>(
          GetBacklinksResponse.$_createMessage);
  static GetBacklinksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<NoteSummary> get notes => $_getList(0);
}

class HostAccount extends $pb.GeneratedMessage {
  factory HostAccount({
    HostKind? kind,
    $core.String? baseUrl,
    $core.String? token,
  }) {
    final result = HostAccount._();
    if (kind != null) result.kind = kind;
    if (baseUrl != null) result.baseUrl = baseUrl;
    if (token != null) result.token = token;
    return result;
  }

  HostAccount._();

  factory HostAccount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostAccount()..mergeFromBuffer(data, registry);
  factory HostAccount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostAccount()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HostAccount',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: HostAccount.$_createMessage)
    ..aE<HostKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: HostKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'baseUrl')
    ..aOS(3, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostAccount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostAccount copyWith(void Function(HostAccount) updates) =>
      super.copyWith((message) => updates(message as HostAccount))
          as HostAccount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use HostAccount() / HostAccount.new instead')
  static HostAccount create() => HostAccount._();
  static $pb.GeneratedMessage $_createMessage() => HostAccount._();
  @$core.override
  HostAccount createEmptyInstance() => HostAccount._();
  @$core.pragma('dart2js:noInline')
  static HostAccount getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HostAccount>(
          HostAccount.$_createMessage);
  static HostAccount? _defaultInstance;

  @$pb.TagNumber(1)
  HostKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(HostKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  /// Web address of the host; empty for github.com, gitlab.com and
  /// codeberg.org.
  @$pb.TagNumber(2)
  $core.String get baseUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set baseUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBaseUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseUrl() => $_clearField(2);

  /// Access token, from HostLoginPoll or created by the user.
  @$pb.TagNumber(3)
  $core.String get token => $_getSZ(2);
  @$pb.TagNumber(3)
  set token($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearToken() => $_clearField(3);
}

class HostRepo extends $pb.GeneratedMessage {
  factory HostRepo({
    $core.String? fullName,
    $core.String? sshUrl,
    $core.String? httpsUrl,
    $core.bool? private,
    $core.String? description,
    $fixnum.Int64? updated,
  }) {
    final result = HostRepo._();
    if (fullName != null) result.fullName = fullName;
    if (sshUrl != null) result.sshUrl = sshUrl;
    if (httpsUrl != null) result.httpsUrl = httpsUrl;
    if (private != null) result.private = private;
    if (description != null) result.description = description;
    if (updated != null) result.updated = updated;
    return result;
  }

  HostRepo._();

  factory HostRepo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostRepo()..mergeFromBuffer(data, registry);
  factory HostRepo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostRepo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HostRepo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: HostRepo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'fullName')
    ..aOS(2, _omitFieldNames ? '' : 'sshUrl')
    ..aOS(3, _omitFieldNames ? '' : 'httpsUrl')
    ..aOB(4, _omitFieldNames ? '' : 'private')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aInt64(6, _omitFieldNames ? '' : 'updated')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostRepo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostRepo copyWith(void Function(HostRepo) updates) =>
      super.copyWith((message) => updates(message as HostRepo)) as HostRepo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use HostRepo() / HostRepo.new instead')
  static HostRepo create() => HostRepo._();
  static $pb.GeneratedMessage $_createMessage() => HostRepo._();
  @$core.override
  HostRepo createEmptyInstance() => HostRepo._();
  @$core.pragma('dart2js:noInline')
  static HostRepo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HostRepo>(HostRepo.$_createMessage);
  static HostRepo? _defaultInstance;

  /// owner/name
  @$pb.TagNumber(1)
  $core.String get fullName => $_getSZ(0);
  @$pb.TagNumber(1)
  set fullName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFullName() => $_has(0);
  @$pb.TagNumber(1)
  void clearFullName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sshUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set sshUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSshUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearSshUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get httpsUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set httpsUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHttpsUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearHttpsUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get private => $_getBF(3);
  @$pb.TagNumber(4)
  set private($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPrivate() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrivate() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  /// Unix seconds.
  @$pb.TagNumber(6)
  $fixnum.Int64 get updated => $_getI64(5);
  @$pb.TagNumber(6)
  set updated($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUpdated() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpdated() => $_clearField(6);
}

class HostInfoRequest extends $pb.GeneratedMessage {
  factory HostInfoRequest({
    HostKind? kind,
    $core.String? baseUrl,
  }) {
    final result = HostInfoRequest._();
    if (kind != null) result.kind = kind;
    if (baseUrl != null) result.baseUrl = baseUrl;
    return result;
  }

  HostInfoRequest._();

  factory HostInfoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostInfoRequest()..mergeFromBuffer(data, registry);
  factory HostInfoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostInfoRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HostInfoRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: HostInfoRequest.$_createMessage)
    ..aE<HostKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: HostKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'baseUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostInfoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostInfoRequest copyWith(void Function(HostInfoRequest) updates) =>
      super.copyWith((message) => updates(message as HostInfoRequest))
          as HostInfoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use HostInfoRequest() / HostInfoRequest.new instead')
  static HostInfoRequest create() => HostInfoRequest._();
  static $pb.GeneratedMessage $_createMessage() => HostInfoRequest._();
  @$core.override
  HostInfoRequest createEmptyInstance() => HostInfoRequest._();
  @$core.pragma('dart2js:noInline')
  static HostInfoRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HostInfoRequest>(
          HostInfoRequest.$_createMessage);
  static HostInfoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  HostKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(HostKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get baseUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set baseUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBaseUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseUrl() => $_clearField(2);
}

class HostInfoResponse extends $pb.GeneratedMessage {
  factory HostInfoResponse({
    $core.bool? deviceLogin,
    $core.String? tokenUrl,
    $core.String? tokenHint,
  }) {
    final result = HostInfoResponse._();
    if (deviceLogin != null) result.deviceLogin = deviceLogin;
    if (tokenUrl != null) result.tokenUrl = tokenUrl;
    if (tokenHint != null) result.tokenHint = tokenHint;
    return result;
  }

  HostInfoResponse._();

  factory HostInfoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostInfoResponse()..mergeFromBuffer(data, registry);
  factory HostInfoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostInfoResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HostInfoResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: HostInfoResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'deviceLogin')
    ..aOS(2, _omitFieldNames ? '' : 'tokenUrl')
    ..aOS(3, _omitFieldNames ? '' : 'tokenHint')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostInfoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostInfoResponse copyWith(void Function(HostInfoResponse) updates) =>
      super.copyWith((message) => updates(message as HostInfoResponse))
          as HostInfoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use HostInfoResponse() / HostInfoResponse.new instead')
  static HostInfoResponse create() => HostInfoResponse._();
  static $pb.GeneratedMessage $_createMessage() => HostInfoResponse._();
  @$core.override
  HostInfoResponse createEmptyInstance() => HostInfoResponse._();
  @$core.pragma('dart2js:noInline')
  static HostInfoResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HostInfoResponse>(
          HostInfoResponse.$_createMessage);
  static HostInfoResponse? _defaultInstance;

  /// Signing in with a code in the browser works (an OAuth app is set up for
  /// this host); otherwise the user creates a token.
  @$pb.TagNumber(1)
  $core.bool get deviceLogin => $_getBF(0);
  @$pb.TagNumber(1)
  set deviceLogin($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceLogin() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceLogin() => $_clearField(1);

  /// Where to create an access token, with the needed scopes preselected.
  @$pb.TagNumber(2)
  $core.String get tokenUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set tokenUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTokenUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearTokenUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get tokenHint => $_getSZ(2);
  @$pb.TagNumber(3)
  set tokenHint($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTokenHint() => $_has(2);
  @$pb.TagNumber(3)
  void clearTokenHint() => $_clearField(3);
}

class HostLoginStartRequest extends $pb.GeneratedMessage {
  factory HostLoginStartRequest({
    HostKind? kind,
    $core.String? baseUrl,
  }) {
    final result = HostLoginStartRequest._();
    if (kind != null) result.kind = kind;
    if (baseUrl != null) result.baseUrl = baseUrl;
    return result;
  }

  HostLoginStartRequest._();

  factory HostLoginStartRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostLoginStartRequest()..mergeFromBuffer(data, registry);
  factory HostLoginStartRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostLoginStartRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HostLoginStartRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: HostLoginStartRequest.$_createMessage)
    ..aE<HostKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: HostKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'baseUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostLoginStartRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostLoginStartRequest copyWith(
          void Function(HostLoginStartRequest) updates) =>
      super.copyWith((message) => updates(message as HostLoginStartRequest))
          as HostLoginStartRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use HostLoginStartRequest() / HostLoginStartRequest.new instead')
  static HostLoginStartRequest create() => HostLoginStartRequest._();
  static $pb.GeneratedMessage $_createMessage() => HostLoginStartRequest._();
  @$core.override
  HostLoginStartRequest createEmptyInstance() => HostLoginStartRequest._();
  @$core.pragma('dart2js:noInline')
  static HostLoginStartRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HostLoginStartRequest>(
          HostLoginStartRequest.$_createMessage);
  static HostLoginStartRequest? _defaultInstance;

  @$pb.TagNumber(1)
  HostKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(HostKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get baseUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set baseUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBaseUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseUrl() => $_clearField(2);
}

class HostLoginStartResponse extends $pb.GeneratedMessage {
  factory HostLoginStartResponse({
    $core.String? deviceCode,
    $core.String? userCode,
    $core.String? verificationUrl,
    $core.int? interval,
    $core.int? expiresIn,
  }) {
    final result = HostLoginStartResponse._();
    if (deviceCode != null) result.deviceCode = deviceCode;
    if (userCode != null) result.userCode = userCode;
    if (verificationUrl != null) result.verificationUrl = verificationUrl;
    if (interval != null) result.interval = interval;
    if (expiresIn != null) result.expiresIn = expiresIn;
    return result;
  }

  HostLoginStartResponse._();

  factory HostLoginStartResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostLoginStartResponse()..mergeFromBuffer(data, registry);
  factory HostLoginStartResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostLoginStartResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HostLoginStartResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: HostLoginStartResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'deviceCode')
    ..aOS(2, _omitFieldNames ? '' : 'userCode')
    ..aOS(3, _omitFieldNames ? '' : 'verificationUrl')
    ..aI(4, _omitFieldNames ? '' : 'interval')
    ..aI(5, _omitFieldNames ? '' : 'expiresIn')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostLoginStartResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostLoginStartResponse copyWith(
          void Function(HostLoginStartResponse) updates) =>
      super.copyWith((message) => updates(message as HostLoginStartResponse))
          as HostLoginStartResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use HostLoginStartResponse() / HostLoginStartResponse.new instead')
  static HostLoginStartResponse create() => HostLoginStartResponse._();
  static $pb.GeneratedMessage $_createMessage() => HostLoginStartResponse._();
  @$core.override
  HostLoginStartResponse createEmptyInstance() => HostLoginStartResponse._();
  @$core.pragma('dart2js:noInline')
  static HostLoginStartResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HostLoginStartResponse>(
          HostLoginStartResponse.$_createMessage);
  static HostLoginStartResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceCode() => $_clearField(1);

  /// Code the user enters at verification_url.
  @$pb.TagNumber(2)
  $core.String get userCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set userCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get verificationUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set verificationUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVerificationUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearVerificationUrl() => $_clearField(3);

  /// Seconds between polls.
  @$pb.TagNumber(4)
  $core.int get interval => $_getIZ(3);
  @$pb.TagNumber(4)
  set interval($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInterval() => $_has(3);
  @$pb.TagNumber(4)
  void clearInterval() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get expiresIn => $_getIZ(4);
  @$pb.TagNumber(5)
  set expiresIn($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExpiresIn() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiresIn() => $_clearField(5);
}

class HostLoginPollRequest extends $pb.GeneratedMessage {
  factory HostLoginPollRequest({
    HostKind? kind,
    $core.String? baseUrl,
    $core.String? deviceCode,
  }) {
    final result = HostLoginPollRequest._();
    if (kind != null) result.kind = kind;
    if (baseUrl != null) result.baseUrl = baseUrl;
    if (deviceCode != null) result.deviceCode = deviceCode;
    return result;
  }

  HostLoginPollRequest._();

  factory HostLoginPollRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostLoginPollRequest()..mergeFromBuffer(data, registry);
  factory HostLoginPollRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostLoginPollRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HostLoginPollRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: HostLoginPollRequest.$_createMessage)
    ..aE<HostKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: HostKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'baseUrl')
    ..aOS(3, _omitFieldNames ? '' : 'deviceCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostLoginPollRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostLoginPollRequest copyWith(void Function(HostLoginPollRequest) updates) =>
      super.copyWith((message) => updates(message as HostLoginPollRequest))
          as HostLoginPollRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use HostLoginPollRequest() / HostLoginPollRequest.new instead')
  static HostLoginPollRequest create() => HostLoginPollRequest._();
  static $pb.GeneratedMessage $_createMessage() => HostLoginPollRequest._();
  @$core.override
  HostLoginPollRequest createEmptyInstance() => HostLoginPollRequest._();
  @$core.pragma('dart2js:noInline')
  static HostLoginPollRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HostLoginPollRequest>(
          HostLoginPollRequest.$_createMessage);
  static HostLoginPollRequest? _defaultInstance;

  @$pb.TagNumber(1)
  HostKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(HostKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get baseUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set baseUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBaseUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get deviceCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set deviceCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeviceCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeviceCode() => $_clearField(3);
}

class HostLoginPollResponse extends $pb.GeneratedMessage {
  factory HostLoginPollResponse({
    $core.String? token,
    $core.bool? pending,
    $core.int? interval,
  }) {
    final result = HostLoginPollResponse._();
    if (token != null) result.token = token;
    if (pending != null) result.pending = pending;
    if (interval != null) result.interval = interval;
    return result;
  }

  HostLoginPollResponse._();

  factory HostLoginPollResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostLoginPollResponse()..mergeFromBuffer(data, registry);
  factory HostLoginPollResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostLoginPollResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HostLoginPollResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: HostLoginPollResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..aOB(2, _omitFieldNames ? '' : 'pending')
    ..aI(3, _omitFieldNames ? '' : 'interval')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostLoginPollResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostLoginPollResponse copyWith(
          void Function(HostLoginPollResponse) updates) =>
      super.copyWith((message) => updates(message as HostLoginPollResponse))
          as HostLoginPollResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use HostLoginPollResponse() / HostLoginPollResponse.new instead')
  static HostLoginPollResponse create() => HostLoginPollResponse._();
  static $pb.GeneratedMessage $_createMessage() => HostLoginPollResponse._();
  @$core.override
  HostLoginPollResponse createEmptyInstance() => HostLoginPollResponse._();
  @$core.pragma('dart2js:noInline')
  static HostLoginPollResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HostLoginPollResponse>(
          HostLoginPollResponse.$_createMessage);
  static HostLoginPollResponse? _defaultInstance;

  /// Set once the user approved.
  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);

  /// Still waiting for the user; poll again after interval seconds.
  @$pb.TagNumber(2)
  $core.bool get pending => $_getBF(1);
  @$pb.TagNumber(2)
  set pending($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPending() => $_has(1);
  @$pb.TagNumber(2)
  void clearPending() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get interval => $_getIZ(2);
  @$pb.TagNumber(3)
  set interval($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInterval() => $_has(2);
  @$pb.TagNumber(3)
  void clearInterval() => $_clearField(3);
}

class HostListReposRequest extends $pb.GeneratedMessage {
  factory HostListReposRequest({
    HostAccount? account,
  }) {
    final result = HostListReposRequest._();
    if (account != null) result.account = account;
    return result;
  }

  HostListReposRequest._();

  factory HostListReposRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostListReposRequest()..mergeFromBuffer(data, registry);
  factory HostListReposRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostListReposRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HostListReposRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: HostListReposRequest.$_createMessage)
    ..aOM<HostAccount>(1, _omitFieldNames ? '' : 'account',
        subBuilder: HostAccount.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostListReposRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostListReposRequest copyWith(void Function(HostListReposRequest) updates) =>
      super.copyWith((message) => updates(message as HostListReposRequest))
          as HostListReposRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use HostListReposRequest() / HostListReposRequest.new instead')
  static HostListReposRequest create() => HostListReposRequest._();
  static $pb.GeneratedMessage $_createMessage() => HostListReposRequest._();
  @$core.override
  HostListReposRequest createEmptyInstance() => HostListReposRequest._();
  @$core.pragma('dart2js:noInline')
  static HostListReposRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HostListReposRequest>(
          HostListReposRequest.$_createMessage);
  static HostListReposRequest? _defaultInstance;

  @$pb.TagNumber(1)
  HostAccount get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(HostAccount value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  HostAccount ensureAccount() => $_ensure(0);
}

class HostListReposResponse extends $pb.GeneratedMessage {
  factory HostListReposResponse({
    $core.Iterable<HostRepo>? repos,
    $core.String? user,
  }) {
    final result = HostListReposResponse._();
    if (repos != null) result.repos.addAll(repos);
    if (user != null) result.user = user;
    return result;
  }

  HostListReposResponse._();

  factory HostListReposResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostListReposResponse()..mergeFromBuffer(data, registry);
  factory HostListReposResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostListReposResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HostListReposResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: HostListReposResponse.$_createMessage)
    ..pPM<HostRepo>(1, _omitFieldNames ? '' : 'repos',
        subBuilder: HostRepo.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'user')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostListReposResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostListReposResponse copyWith(
          void Function(HostListReposResponse) updates) =>
      super.copyWith((message) => updates(message as HostListReposResponse))
          as HostListReposResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use HostListReposResponse() / HostListReposResponse.new instead')
  static HostListReposResponse create() => HostListReposResponse._();
  static $pb.GeneratedMessage $_createMessage() => HostListReposResponse._();
  @$core.override
  HostListReposResponse createEmptyInstance() => HostListReposResponse._();
  @$core.pragma('dart2js:noInline')
  static HostListReposResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HostListReposResponse>(
          HostListReposResponse.$_createMessage);
  static HostListReposResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<HostRepo> get repos => $_getList(0);

  /// The signed-in user.
  @$pb.TagNumber(2)
  $core.String get user => $_getSZ(1);
  @$pb.TagNumber(2)
  set user($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => $_clearField(2);
}

class HostCreateRepoRequest extends $pb.GeneratedMessage {
  factory HostCreateRepoRequest({
    HostAccount? account,
    $core.String? name,
    $core.bool? private,
  }) {
    final result = HostCreateRepoRequest._();
    if (account != null) result.account = account;
    if (name != null) result.name = name;
    if (private != null) result.private = private;
    return result;
  }

  HostCreateRepoRequest._();

  factory HostCreateRepoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostCreateRepoRequest()..mergeFromBuffer(data, registry);
  factory HostCreateRepoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostCreateRepoRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HostCreateRepoRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: HostCreateRepoRequest.$_createMessage)
    ..aOM<HostAccount>(1, _omitFieldNames ? '' : 'account',
        subBuilder: HostAccount.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOB(3, _omitFieldNames ? '' : 'private')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostCreateRepoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostCreateRepoRequest copyWith(
          void Function(HostCreateRepoRequest) updates) =>
      super.copyWith((message) => updates(message as HostCreateRepoRequest))
          as HostCreateRepoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use HostCreateRepoRequest() / HostCreateRepoRequest.new instead')
  static HostCreateRepoRequest create() => HostCreateRepoRequest._();
  static $pb.GeneratedMessage $_createMessage() => HostCreateRepoRequest._();
  @$core.override
  HostCreateRepoRequest createEmptyInstance() => HostCreateRepoRequest._();
  @$core.pragma('dart2js:noInline')
  static HostCreateRepoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HostCreateRepoRequest>(
          HostCreateRepoRequest.$_createMessage);
  static HostCreateRepoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  HostAccount get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(HostAccount value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  HostAccount ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get private => $_getBF(2);
  @$pb.TagNumber(3)
  set private($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrivate() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrivate() => $_clearField(3);
}

class HostAddDeployKeyRequest extends $pb.GeneratedMessage {
  factory HostAddDeployKeyRequest({
    HostAccount? account,
    $core.String? fullName,
    $core.String? title,
    $core.String? publicKey,
  }) {
    final result = HostAddDeployKeyRequest._();
    if (account != null) result.account = account;
    if (fullName != null) result.fullName = fullName;
    if (title != null) result.title = title;
    if (publicKey != null) result.publicKey = publicKey;
    return result;
  }

  HostAddDeployKeyRequest._();

  factory HostAddDeployKeyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostAddDeployKeyRequest()..mergeFromBuffer(data, registry);
  factory HostAddDeployKeyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostAddDeployKeyRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HostAddDeployKeyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: HostAddDeployKeyRequest.$_createMessage)
    ..aOM<HostAccount>(1, _omitFieldNames ? '' : 'account',
        subBuilder: HostAccount.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'fullName')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'publicKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostAddDeployKeyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostAddDeployKeyRequest copyWith(
          void Function(HostAddDeployKeyRequest) updates) =>
      super.copyWith((message) => updates(message as HostAddDeployKeyRequest))
          as HostAddDeployKeyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use HostAddDeployKeyRequest() / HostAddDeployKeyRequest.new instead')
  static HostAddDeployKeyRequest create() => HostAddDeployKeyRequest._();
  static $pb.GeneratedMessage $_createMessage() => HostAddDeployKeyRequest._();
  @$core.override
  HostAddDeployKeyRequest createEmptyInstance() => HostAddDeployKeyRequest._();
  @$core.pragma('dart2js:noInline')
  static HostAddDeployKeyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HostAddDeployKeyRequest>(
          HostAddDeployKeyRequest.$_createMessage);
  static HostAddDeployKeyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  HostAccount get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(HostAccount value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  HostAccount ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get fullName => $_getSZ(1);
  @$pb.TagNumber(2)
  set fullName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFullName() => $_has(1);
  @$pb.TagNumber(2)
  void clearFullName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get publicKey => $_getSZ(3);
  @$pb.TagNumber(4)
  set publicKey($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPublicKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearPublicKey() => $_clearField(4);
}

class HostAddDeployKeyResponse extends $pb.GeneratedMessage {
  factory HostAddDeployKeyResponse() => HostAddDeployKeyResponse._();

  HostAddDeployKeyResponse._();

  factory HostAddDeployKeyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostAddDeployKeyResponse()..mergeFromBuffer(data, registry);
  factory HostAddDeployKeyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostAddDeployKeyResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HostAddDeployKeyResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: HostAddDeployKeyResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostAddDeployKeyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostAddDeployKeyResponse copyWith(
          void Function(HostAddDeployKeyResponse) updates) =>
      super.copyWith((message) => updates(message as HostAddDeployKeyResponse))
          as HostAddDeployKeyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use HostAddDeployKeyResponse() / HostAddDeployKeyResponse.new instead')
  static HostAddDeployKeyResponse create() => HostAddDeployKeyResponse._();
  static $pb.GeneratedMessage $_createMessage() => HostAddDeployKeyResponse._();
  @$core.override
  HostAddDeployKeyResponse createEmptyInstance() =>
      HostAddDeployKeyResponse._();
  @$core.pragma('dart2js:noInline')
  static HostAddDeployKeyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HostAddDeployKeyResponse>(
          HostAddDeployKeyResponse.$_createMessage);
  static HostAddDeployKeyResponse? _defaultInstance;
}

class TagList extends $pb.GeneratedMessage {
  factory TagList({
    $core.Iterable<$core.String>? tags,
  }) {
    final result = TagList._();
    if (tags != null) result.tags.addAll(tags);
    return result;
  }

  TagList._();

  factory TagList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TagList()..mergeFromBuffer(data, registry);
  factory TagList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TagList()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TagList',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: TagList.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'tags')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TagList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TagList copyWith(void Function(TagList) updates) =>
      super.copyWith((message) => updates(message as TagList)) as TagList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TagList() / TagList.new instead')
  static TagList create() => TagList._();
  static $pb.GeneratedMessage $_createMessage() => TagList._();
  @$core.override
  TagList createEmptyInstance() => TagList._();
  @$core.pragma('dart2js:noInline')
  static TagList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TagList>(TagList.$_createMessage);
  static TagList? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get tags => $_getList(0);
}

class SaveNoteResponse extends $pb.GeneratedMessage {
  factory SaveNoteResponse({
    Note? note,
    $core.String? conflictCopy,
  }) {
    final result = SaveNoteResponse._();
    if (note != null) result.note = note;
    if (conflictCopy != null) result.conflictCopy = conflictCopy;
    return result;
  }

  SaveNoteResponse._();

  factory SaveNoteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SaveNoteResponse()..mergeFromBuffer(data, registry);
  factory SaveNoteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SaveNoteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SaveNoteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: SaveNoteResponse.$_createMessage)
    ..aOM<Note>(1, _omitFieldNames ? '' : 'note',
        subBuilder: Note.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'conflictCopy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveNoteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveNoteResponse copyWith(void Function(SaveNoteResponse) updates) =>
      super.copyWith((message) => updates(message as SaveNoteResponse))
          as SaveNoteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SaveNoteResponse() / SaveNoteResponse.new instead')
  static SaveNoteResponse create() => SaveNoteResponse._();
  static $pb.GeneratedMessage $_createMessage() => SaveNoteResponse._();
  @$core.override
  SaveNoteResponse createEmptyInstance() => SaveNoteResponse._();
  @$core.pragma('dart2js:noInline')
  static SaveNoteResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SaveNoteResponse>(
          SaveNoteResponse.$_createMessage);
  static SaveNoteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Note get note => $_getN(0);
  @$pb.TagNumber(1)
  set note(Note value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNote() => $_has(0);
  @$pb.TagNumber(1)
  void clearNote() => $_clearField(1);
  @$pb.TagNumber(1)
  Note ensureNote() => $_ensure(0);

  /// The file had changed and the edits could not be merged line by line; the
  /// other version was saved as conflict_copy next to it.
  @$pb.TagNumber(2)
  $core.String get conflictCopy => $_getSZ(1);
  @$pb.TagNumber(2)
  set conflictCopy($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConflictCopy() => $_has(1);
  @$pb.TagNumber(2)
  void clearConflictCopy() => $_clearField(2);
}

class RenameNoteRequest extends $pb.GeneratedMessage {
  factory RenameNoteRequest({
    $core.String? notebookId,
    $core.String? path,
    $core.String? newPath,
  }) {
    final result = RenameNoteRequest._();
    if (notebookId != null) result.notebookId = notebookId;
    if (path != null) result.path = path;
    if (newPath != null) result.newPath = newPath;
    return result;
  }

  RenameNoteRequest._();

  factory RenameNoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RenameNoteRequest()..mergeFromBuffer(data, registry);
  factory RenameNoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RenameNoteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RenameNoteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: RenameNoteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'notebookId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..aOS(3, _omitFieldNames ? '' : 'newPath')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenameNoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenameNoteRequest copyWith(void Function(RenameNoteRequest) updates) =>
      super.copyWith((message) => updates(message as RenameNoteRequest))
          as RenameNoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RenameNoteRequest() / RenameNoteRequest.new instead')
  static RenameNoteRequest create() => RenameNoteRequest._();
  static $pb.GeneratedMessage $_createMessage() => RenameNoteRequest._();
  @$core.override
  RenameNoteRequest createEmptyInstance() => RenameNoteRequest._();
  @$core.pragma('dart2js:noInline')
  static RenameNoteRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RenameNoteRequest>(
          RenameNoteRequest.$_createMessage);
  static RenameNoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notebookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notebookId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotebookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotebookId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);

  /// New path relative to the notebook root; moves between folders too.
  @$pb.TagNumber(3)
  $core.String get newPath => $_getSZ(2);
  @$pb.TagNumber(3)
  set newPath($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewPath() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewPath() => $_clearField(3);
}

class DeleteNoteRequest extends $pb.GeneratedMessage {
  factory DeleteNoteRequest({
    $core.String? notebookId,
    $core.String? path,
  }) {
    final result = DeleteNoteRequest._();
    if (notebookId != null) result.notebookId = notebookId;
    if (path != null) result.path = path;
    return result;
  }

  DeleteNoteRequest._();

  factory DeleteNoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteNoteRequest()..mergeFromBuffer(data, registry);
  factory DeleteNoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteNoteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteNoteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: DeleteNoteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'notebookId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteNoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteNoteRequest copyWith(void Function(DeleteNoteRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteNoteRequest))
          as DeleteNoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DeleteNoteRequest() / DeleteNoteRequest.new instead')
  static DeleteNoteRequest create() => DeleteNoteRequest._();
  static $pb.GeneratedMessage $_createMessage() => DeleteNoteRequest._();
  @$core.override
  DeleteNoteRequest createEmptyInstance() => DeleteNoteRequest._();
  @$core.pragma('dart2js:noInline')
  static DeleteNoteRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteNoteRequest>(
          DeleteNoteRequest.$_createMessage);
  static DeleteNoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notebookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notebookId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotebookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotebookId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);
}

class DeleteNoteResponse extends $pb.GeneratedMessage {
  factory DeleteNoteResponse() => DeleteNoteResponse._();

  DeleteNoteResponse._();

  factory DeleteNoteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteNoteResponse()..mergeFromBuffer(data, registry);
  factory DeleteNoteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteNoteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteNoteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: DeleteNoteResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteNoteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteNoteResponse copyWith(void Function(DeleteNoteResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteNoteResponse))
          as DeleteNoteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DeleteNoteResponse() / DeleteNoteResponse.new instead')
  static DeleteNoteResponse create() => DeleteNoteResponse._();
  static $pb.GeneratedMessage $_createMessage() => DeleteNoteResponse._();
  @$core.override
  DeleteNoteResponse createEmptyInstance() => DeleteNoteResponse._();
  @$core.pragma('dart2js:noInline')
  static DeleteNoteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteNoteResponse>(
          DeleteNoteResponse.$_createMessage);
  static DeleteNoteResponse? _defaultInstance;
}

class CreateFolderRequest extends $pb.GeneratedMessage {
  factory CreateFolderRequest({
    $core.String? notebookId,
    $core.String? path,
  }) {
    final result = CreateFolderRequest._();
    if (notebookId != null) result.notebookId = notebookId;
    if (path != null) result.path = path;
    return result;
  }

  CreateFolderRequest._();

  factory CreateFolderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateFolderRequest()..mergeFromBuffer(data, registry);
  factory CreateFolderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateFolderRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateFolderRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: CreateFolderRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'notebookId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFolderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFolderRequest copyWith(void Function(CreateFolderRequest) updates) =>
      super.copyWith((message) => updates(message as CreateFolderRequest))
          as CreateFolderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use CreateFolderRequest() / CreateFolderRequest.new instead')
  static CreateFolderRequest create() => CreateFolderRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateFolderRequest._();
  @$core.override
  CreateFolderRequest createEmptyInstance() => CreateFolderRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateFolderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateFolderRequest>(
          CreateFolderRequest.$_createMessage);
  static CreateFolderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notebookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notebookId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotebookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotebookId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);
}

class CreateFolderResponse extends $pb.GeneratedMessage {
  factory CreateFolderResponse() => CreateFolderResponse._();

  CreateFolderResponse._();

  factory CreateFolderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateFolderResponse()..mergeFromBuffer(data, registry);
  factory CreateFolderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateFolderResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateFolderResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: CreateFolderResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFolderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFolderResponse copyWith(void Function(CreateFolderResponse) updates) =>
      super.copyWith((message) => updates(message as CreateFolderResponse))
          as CreateFolderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateFolderResponse() / CreateFolderResponse.new instead')
  static CreateFolderResponse create() => CreateFolderResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateFolderResponse._();
  @$core.override
  CreateFolderResponse createEmptyInstance() => CreateFolderResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateFolderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateFolderResponse>(
          CreateFolderResponse.$_createMessage);
  static CreateFolderResponse? _defaultInstance;
}

class ListTagsRequest extends $pb.GeneratedMessage {
  factory ListTagsRequest({
    $core.String? notebookId,
  }) {
    final result = ListTagsRequest._();
    if (notebookId != null) result.notebookId = notebookId;
    return result;
  }

  ListTagsRequest._();

  factory ListTagsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListTagsRequest()..mergeFromBuffer(data, registry);
  factory ListTagsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListTagsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTagsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: ListTagsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'notebookId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTagsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTagsRequest copyWith(void Function(ListTagsRequest) updates) =>
      super.copyWith((message) => updates(message as ListTagsRequest))
          as ListTagsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListTagsRequest() / ListTagsRequest.new instead')
  static ListTagsRequest create() => ListTagsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListTagsRequest._();
  @$core.override
  ListTagsRequest createEmptyInstance() => ListTagsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListTagsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListTagsRequest>(
          ListTagsRequest.$_createMessage);
  static ListTagsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notebookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notebookId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotebookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotebookId() => $_clearField(1);
}

class Tag extends $pb.GeneratedMessage {
  factory Tag({
    $core.String? name,
    $core.int? noteCount,
  }) {
    final result = Tag._();
    if (name != null) result.name = name;
    if (noteCount != null) result.noteCount = noteCount;
    return result;
  }

  Tag._();

  factory Tag.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Tag()..mergeFromBuffer(data, registry);
  factory Tag.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Tag()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Tag',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: Tag.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aI(2, _omitFieldNames ? '' : 'noteCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tag clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tag copyWith(void Function(Tag) updates) =>
      super.copyWith((message) => updates(message as Tag)) as Tag;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Tag() / Tag.new instead')
  static Tag create() => Tag._();
  static $pb.GeneratedMessage $_createMessage() => Tag._();
  @$core.override
  Tag createEmptyInstance() => Tag._();
  @$core.pragma('dart2js:noInline')
  static Tag getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Tag>(Tag.$_createMessage);
  static Tag? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get noteCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set noteCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNoteCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearNoteCount() => $_clearField(2);
}

class ListTagsResponse extends $pb.GeneratedMessage {
  factory ListTagsResponse({
    $core.Iterable<Tag>? tags,
  }) {
    final result = ListTagsResponse._();
    if (tags != null) result.tags.addAll(tags);
    return result;
  }

  ListTagsResponse._();

  factory ListTagsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListTagsResponse()..mergeFromBuffer(data, registry);
  factory ListTagsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListTagsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTagsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: ListTagsResponse.$_createMessage)
    ..pPM<Tag>(1, _omitFieldNames ? '' : 'tags',
        subBuilder: Tag.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTagsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTagsResponse copyWith(void Function(ListTagsResponse) updates) =>
      super.copyWith((message) => updates(message as ListTagsResponse))
          as ListTagsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListTagsResponse() / ListTagsResponse.new instead')
  static ListTagsResponse create() => ListTagsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListTagsResponse._();
  @$core.override
  ListTagsResponse createEmptyInstance() => ListTagsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListTagsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListTagsResponse>(
          ListTagsResponse.$_createMessage);
  static ListTagsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Tag> get tags => $_getList(0);
}

class SyncRequest extends $pb.GeneratedMessage {
  factory SyncRequest({
    $core.String? notebookId,
  }) {
    final result = SyncRequest._();
    if (notebookId != null) result.notebookId = notebookId;
    return result;
  }

  SyncRequest._();

  factory SyncRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SyncRequest()..mergeFromBuffer(data, registry);
  factory SyncRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SyncRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: SyncRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'notebookId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncRequest copyWith(void Function(SyncRequest) updates) =>
      super.copyWith((message) => updates(message as SyncRequest))
          as SyncRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SyncRequest() / SyncRequest.new instead')
  static SyncRequest create() => SyncRequest._();
  static $pb.GeneratedMessage $_createMessage() => SyncRequest._();
  @$core.override
  SyncRequest createEmptyInstance() => SyncRequest._();
  @$core.pragma('dart2js:noInline')
  static SyncRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncRequest>(
          SyncRequest.$_createMessage);
  static SyncRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notebookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notebookId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotebookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotebookId() => $_clearField(1);
}

class SyncAllRequest extends $pb.GeneratedMessage {
  factory SyncAllRequest() => SyncAllRequest._();

  SyncAllRequest._();

  factory SyncAllRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SyncAllRequest()..mergeFromBuffer(data, registry);
  factory SyncAllRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SyncAllRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncAllRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: SyncAllRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncAllRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncAllRequest copyWith(void Function(SyncAllRequest) updates) =>
      super.copyWith((message) => updates(message as SyncAllRequest))
          as SyncAllRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SyncAllRequest() / SyncAllRequest.new instead')
  static SyncAllRequest create() => SyncAllRequest._();
  static $pb.GeneratedMessage $_createMessage() => SyncAllRequest._();
  @$core.override
  SyncAllRequest createEmptyInstance() => SyncAllRequest._();
  @$core.pragma('dart2js:noInline')
  static SyncAllRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncAllRequest>(
          SyncAllRequest.$_createMessage);
  static SyncAllRequest? _defaultInstance;
}

class SyncAllResponse extends $pb.GeneratedMessage {
  factory SyncAllResponse({
    $core.Iterable<$core.MapEntry<$core.String, SyncStatus>>? statuses,
  }) {
    final result = SyncAllResponse._();
    if (statuses != null) result.statuses.addEntries(statuses);
    return result;
  }

  SyncAllResponse._();

  factory SyncAllResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SyncAllResponse()..mergeFromBuffer(data, registry);
  factory SyncAllResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SyncAllResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncAllResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: SyncAllResponse.$_createMessage)
    ..m<$core.String, SyncStatus>(1, _omitFieldNames ? '' : 'statuses',
        entryClassName: 'SyncAllResponse.StatusesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: SyncStatus.$_createMessage,
        valueDefaultOrMaker: SyncStatus.getDefault,
        packageName: const $pb.PackageName('githeft.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncAllResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncAllResponse copyWith(void Function(SyncAllResponse) updates) =>
      super.copyWith((message) => updates(message as SyncAllResponse))
          as SyncAllResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SyncAllResponse() / SyncAllResponse.new instead')
  static SyncAllResponse create() => SyncAllResponse._();
  static $pb.GeneratedMessage $_createMessage() => SyncAllResponse._();
  @$core.override
  SyncAllResponse createEmptyInstance() => SyncAllResponse._();
  @$core.pragma('dart2js:noInline')
  static SyncAllResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncAllResponse>(
          SyncAllResponse.$_createMessage);
  static SyncAllResponse? _defaultInstance;

  /// Notebook id to its status after the sync.
  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, SyncStatus> get statuses => $_getMap(0);
}

class GetSyncStatusRequest extends $pb.GeneratedMessage {
  factory GetSyncStatusRequest({
    $core.String? notebookId,
  }) {
    final result = GetSyncStatusRequest._();
    if (notebookId != null) result.notebookId = notebookId;
    return result;
  }

  GetSyncStatusRequest._();

  factory GetSyncStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSyncStatusRequest()..mergeFromBuffer(data, registry);
  factory GetSyncStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSyncStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSyncStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: GetSyncStatusRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'notebookId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSyncStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSyncStatusRequest copyWith(void Function(GetSyncStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetSyncStatusRequest))
          as GetSyncStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetSyncStatusRequest() / GetSyncStatusRequest.new instead')
  static GetSyncStatusRequest create() => GetSyncStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetSyncStatusRequest._();
  @$core.override
  GetSyncStatusRequest createEmptyInstance() => GetSyncStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static GetSyncStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSyncStatusRequest>(
          GetSyncStatusRequest.$_createMessage);
  static GetSyncStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notebookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notebookId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotebookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotebookId() => $_clearField(1);
}

class SyncStatus extends $pb.GeneratedMessage {
  factory SyncStatus({
    SyncState? state,
    $fixnum.Int64? lastSync,
    $core.String? error,
    $core.int? ahead,
    $core.int? pendingChanges,
    $core.Iterable<$core.String>? changedPaths,
    $core.Iterable<$core.String>? conflicts,
  }) {
    final result = SyncStatus._();
    if (state != null) result.state = state;
    if (lastSync != null) result.lastSync = lastSync;
    if (error != null) result.error = error;
    if (ahead != null) result.ahead = ahead;
    if (pendingChanges != null) result.pendingChanges = pendingChanges;
    if (changedPaths != null) result.changedPaths.addAll(changedPaths);
    if (conflicts != null) result.conflicts.addAll(conflicts);
    return result;
  }

  SyncStatus._();

  factory SyncStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SyncStatus()..mergeFromBuffer(data, registry);
  factory SyncStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SyncStatus()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'githeft.v1'),
      createEmptyInstance: SyncStatus.$_createMessage)
    ..aE<SyncState>(1, _omitFieldNames ? '' : 'state',
        enumValues: SyncState.values)
    ..aInt64(2, _omitFieldNames ? '' : 'lastSync')
    ..aOS(3, _omitFieldNames ? '' : 'error')
    ..aI(4, _omitFieldNames ? '' : 'ahead')
    ..aI(5, _omitFieldNames ? '' : 'pendingChanges')
    ..pPS(6, _omitFieldNames ? '' : 'changedPaths')
    ..pPS(7, _omitFieldNames ? '' : 'conflicts')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncStatus copyWith(void Function(SyncStatus) updates) =>
      super.copyWith((message) => updates(message as SyncStatus)) as SyncStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SyncStatus() / SyncStatus.new instead')
  static SyncStatus create() => SyncStatus._();
  static $pb.GeneratedMessage $_createMessage() => SyncStatus._();
  @$core.override
  SyncStatus createEmptyInstance() => SyncStatus._();
  @$core.pragma('dart2js:noInline')
  static SyncStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SyncStatus>(SyncStatus.$_createMessage);
  static SyncStatus? _defaultInstance;

  @$pb.TagNumber(1)
  SyncState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(SyncState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  /// Unix seconds of the last successful sync; 0 when never synced.
  @$pb.TagNumber(2)
  $fixnum.Int64 get lastSync => $_getI64(1);
  @$pb.TagNumber(2)
  set lastSync($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLastSync() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastSync() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get error => $_getSZ(2);
  @$pb.TagNumber(3)
  set error($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => $_clearField(3);

  /// Local commits not pushed yet.
  @$pb.TagNumber(4)
  $core.int get ahead => $_getIZ(3);
  @$pb.TagNumber(4)
  set ahead($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAhead() => $_has(3);
  @$pb.TagNumber(4)
  void clearAhead() => $_clearField(4);

  /// Files with uncommitted changes.
  @$pb.TagNumber(5)
  $core.int get pendingChanges => $_getIZ(4);
  @$pb.TagNumber(5)
  set pendingChanges($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPendingChanges() => $_has(4);
  @$pb.TagNumber(5)
  void clearPendingChanges() => $_clearField(5);

  /// Notes that changed in the last sync, so the app can refresh them.
  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get changedPaths => $_getList(5);

  /// Conflict copies the last sync created.
  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get conflicts => $_getList(6);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
