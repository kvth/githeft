// This is a generated file - do not edit.
//
// Generated from githeft/v1/githeft.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'githeft.pb.dart' as $0;

export 'githeft.pb.dart';

/// Githeft is the API between the Flutter app and the Go core. On Android and
/// Linux the core runs inside the app process and listens on a Unix socket in
/// the app's private directory; the web version talks gRPC-Web to `githeft
/// serve`.
@$pb.GrpcServiceName('githeft.v1.Githeft')
class GitheftClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  GitheftClient(super.channel, {super.options, super.interceptors});

  /// Notebooks: one git repository each.
  $grpc.ResponseFuture<$0.ListNotebooksResponse> listNotebooks(
    $0.ListNotebooksRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listNotebooks, request, options: options);
  }

  $grpc.ResponseFuture<$0.Notebook> createNotebook(
    $0.CreateNotebookRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createNotebook, request, options: options);
  }

  $grpc.ResponseFuture<$0.Notebook> updateNotebook(
    $0.UpdateNotebookRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateNotebook, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteNotebookResponse> deleteNotebook(
    $0.DeleteNotebookRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteNotebook, request, options: options);
  }

  /// Remotes and credentials.
  $grpc.ResponseFuture<$0.SshKey> generateSshKey(
    $0.GenerateSshKeyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$generateSshKey, request, options: options);
  }

  $grpc.ResponseFuture<$0.SshKey> importSshKey(
    $0.ImportSshKeyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$importSshKey, request, options: options);
  }

  $grpc.ResponseFuture<$0.SshKey> getSshKey(
    $0.GetSshKeyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSshKey, request, options: options);
  }

  /// Checks that the remote can be reached with the given credentials, the way
  /// `git ls-remote` does, before a clone or after changing the remote.
  $grpc.ResponseFuture<$0.TestRemoteResponse> testRemote(
    $0.TestRemoteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$testRemote, request, options: options);
  }

  /// Drops the remembered SSH host key of a host, after it legitimately changed.
  $grpc.ResponseFuture<$0.ForgetHostKeyResponse> forgetHostKey(
    $0.ForgetHostKeyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$forgetHostKey, request, options: options);
  }

  /// Notes and folders.
  $grpc.ResponseFuture<$0.ListNotesResponse> listNotes(
    $0.ListNotesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listNotes, request, options: options);
  }

  $grpc.ResponseFuture<$0.Note> getNote(
    $0.GetNoteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getNote, request, options: options);
  }

  $grpc.ResponseFuture<$0.SaveNoteResponse> saveNote(
    $0.SaveNoteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$saveNote, request, options: options);
  }

  $grpc.ResponseFuture<$0.Note> renameNote(
    $0.RenameNoteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$renameNote, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteNoteResponse> deleteNote(
    $0.DeleteNoteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteNote, request, options: options);
  }

  $grpc.ResponseFuture<$0.CreateFolderResponse> createFolder(
    $0.CreateFolderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createFolder, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListTagsResponse> listTags(
    $0.ListTagsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listTags, request, options: options);
  }

  /// Pins a note or changes its editor type, stored in the front matter like
  /// GitJournal does (pinned: true, type: Checklist).
  $grpc.ResponseFuture<$0.Note> updateNoteMeta(
    $0.UpdateNoteMetaRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateNoteMeta, request, options: options);
  }

  /// Images and other files next to the notes.
  $grpc.ResponseFuture<$0.AddAttachmentResponse> addAttachment(
    $0.AddAttachmentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addAttachment, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetFileResponse> getFile(
    $0.GetFileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getFile, request, options: options);
  }

  /// Links between notes: [[wiki links]] and relative Markdown links.
  $grpc.ResponseFuture<$0.ResolveLinkResponse> resolveLink(
    $0.ResolveLinkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resolveLink, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetBacklinksResponse> getBacklinks(
    $0.GetBacklinksRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getBacklinks, request, options: options);
  }

  /// Setting up a notebook on GitHub, GitLab or a Gitea/Forgejo host
  /// (Codeberg): sign in, pick or create a repository, add a deploy key.
  $grpc.ResponseFuture<$0.HostInfoResponse> hostInfo(
    $0.HostInfoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$hostInfo, request, options: options);
  }

  $grpc.ResponseFuture<$0.HostLoginStartResponse> hostLoginStart(
    $0.HostLoginStartRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$hostLoginStart, request, options: options);
  }

  $grpc.ResponseFuture<$0.HostLoginPollResponse> hostLoginPoll(
    $0.HostLoginPollRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$hostLoginPoll, request, options: options);
  }

  $grpc.ResponseFuture<$0.HostListReposResponse> hostListRepos(
    $0.HostListReposRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$hostListRepos, request, options: options);
  }

  $grpc.ResponseFuture<$0.HostRepo> hostCreateRepo(
    $0.HostCreateRepoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$hostCreateRepo, request, options: options);
  }

  $grpc.ResponseFuture<$0.HostAddDeployKeyResponse> hostAddDeployKey(
    $0.HostAddDeployKeyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$hostAddDeployKey, request, options: options);
  }

  /// Sync: commit, fetch, merge and push.
  $grpc.ResponseFuture<$0.SyncStatus> sync(
    $0.SyncRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sync, request, options: options);
  }

  $grpc.ResponseFuture<$0.SyncStatus> getSyncStatus(
    $0.GetSyncStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSyncStatus, request, options: options);
  }

  /// Syncs every notebook that has automatic sync on, as the background job
  /// does.
  $grpc.ResponseFuture<$0.SyncAllResponse> syncAll(
    $0.SyncAllRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$syncAll, request, options: options);
  }

  // method descriptors

  static final _$listNotebooks =
      $grpc.ClientMethod<$0.ListNotebooksRequest, $0.ListNotebooksResponse>(
          '/githeft.v1.Githeft/ListNotebooks',
          ($0.ListNotebooksRequest value) => value.writeToBuffer(),
          $0.ListNotebooksResponse.fromBuffer);
  static final _$createNotebook =
      $grpc.ClientMethod<$0.CreateNotebookRequest, $0.Notebook>(
          '/githeft.v1.Githeft/CreateNotebook',
          ($0.CreateNotebookRequest value) => value.writeToBuffer(),
          $0.Notebook.fromBuffer);
  static final _$updateNotebook =
      $grpc.ClientMethod<$0.UpdateNotebookRequest, $0.Notebook>(
          '/githeft.v1.Githeft/UpdateNotebook',
          ($0.UpdateNotebookRequest value) => value.writeToBuffer(),
          $0.Notebook.fromBuffer);
  static final _$deleteNotebook =
      $grpc.ClientMethod<$0.DeleteNotebookRequest, $0.DeleteNotebookResponse>(
          '/githeft.v1.Githeft/DeleteNotebook',
          ($0.DeleteNotebookRequest value) => value.writeToBuffer(),
          $0.DeleteNotebookResponse.fromBuffer);
  static final _$generateSshKey =
      $grpc.ClientMethod<$0.GenerateSshKeyRequest, $0.SshKey>(
          '/githeft.v1.Githeft/GenerateSshKey',
          ($0.GenerateSshKeyRequest value) => value.writeToBuffer(),
          $0.SshKey.fromBuffer);
  static final _$importSshKey =
      $grpc.ClientMethod<$0.ImportSshKeyRequest, $0.SshKey>(
          '/githeft.v1.Githeft/ImportSshKey',
          ($0.ImportSshKeyRequest value) => value.writeToBuffer(),
          $0.SshKey.fromBuffer);
  static final _$getSshKey = $grpc.ClientMethod<$0.GetSshKeyRequest, $0.SshKey>(
      '/githeft.v1.Githeft/GetSshKey',
      ($0.GetSshKeyRequest value) => value.writeToBuffer(),
      $0.SshKey.fromBuffer);
  static final _$testRemote =
      $grpc.ClientMethod<$0.TestRemoteRequest, $0.TestRemoteResponse>(
          '/githeft.v1.Githeft/TestRemote',
          ($0.TestRemoteRequest value) => value.writeToBuffer(),
          $0.TestRemoteResponse.fromBuffer);
  static final _$forgetHostKey =
      $grpc.ClientMethod<$0.ForgetHostKeyRequest, $0.ForgetHostKeyResponse>(
          '/githeft.v1.Githeft/ForgetHostKey',
          ($0.ForgetHostKeyRequest value) => value.writeToBuffer(),
          $0.ForgetHostKeyResponse.fromBuffer);
  static final _$listNotes =
      $grpc.ClientMethod<$0.ListNotesRequest, $0.ListNotesResponse>(
          '/githeft.v1.Githeft/ListNotes',
          ($0.ListNotesRequest value) => value.writeToBuffer(),
          $0.ListNotesResponse.fromBuffer);
  static final _$getNote = $grpc.ClientMethod<$0.GetNoteRequest, $0.Note>(
      '/githeft.v1.Githeft/GetNote',
      ($0.GetNoteRequest value) => value.writeToBuffer(),
      $0.Note.fromBuffer);
  static final _$saveNote =
      $grpc.ClientMethod<$0.SaveNoteRequest, $0.SaveNoteResponse>(
          '/githeft.v1.Githeft/SaveNote',
          ($0.SaveNoteRequest value) => value.writeToBuffer(),
          $0.SaveNoteResponse.fromBuffer);
  static final _$renameNote = $grpc.ClientMethod<$0.RenameNoteRequest, $0.Note>(
      '/githeft.v1.Githeft/RenameNote',
      ($0.RenameNoteRequest value) => value.writeToBuffer(),
      $0.Note.fromBuffer);
  static final _$deleteNote =
      $grpc.ClientMethod<$0.DeleteNoteRequest, $0.DeleteNoteResponse>(
          '/githeft.v1.Githeft/DeleteNote',
          ($0.DeleteNoteRequest value) => value.writeToBuffer(),
          $0.DeleteNoteResponse.fromBuffer);
  static final _$createFolder =
      $grpc.ClientMethod<$0.CreateFolderRequest, $0.CreateFolderResponse>(
          '/githeft.v1.Githeft/CreateFolder',
          ($0.CreateFolderRequest value) => value.writeToBuffer(),
          $0.CreateFolderResponse.fromBuffer);
  static final _$listTags =
      $grpc.ClientMethod<$0.ListTagsRequest, $0.ListTagsResponse>(
          '/githeft.v1.Githeft/ListTags',
          ($0.ListTagsRequest value) => value.writeToBuffer(),
          $0.ListTagsResponse.fromBuffer);
  static final _$updateNoteMeta =
      $grpc.ClientMethod<$0.UpdateNoteMetaRequest, $0.Note>(
          '/githeft.v1.Githeft/UpdateNoteMeta',
          ($0.UpdateNoteMetaRequest value) => value.writeToBuffer(),
          $0.Note.fromBuffer);
  static final _$addAttachment =
      $grpc.ClientMethod<$0.AddAttachmentRequest, $0.AddAttachmentResponse>(
          '/githeft.v1.Githeft/AddAttachment',
          ($0.AddAttachmentRequest value) => value.writeToBuffer(),
          $0.AddAttachmentResponse.fromBuffer);
  static final _$getFile =
      $grpc.ClientMethod<$0.GetFileRequest, $0.GetFileResponse>(
          '/githeft.v1.Githeft/GetFile',
          ($0.GetFileRequest value) => value.writeToBuffer(),
          $0.GetFileResponse.fromBuffer);
  static final _$resolveLink =
      $grpc.ClientMethod<$0.ResolveLinkRequest, $0.ResolveLinkResponse>(
          '/githeft.v1.Githeft/ResolveLink',
          ($0.ResolveLinkRequest value) => value.writeToBuffer(),
          $0.ResolveLinkResponse.fromBuffer);
  static final _$getBacklinks =
      $grpc.ClientMethod<$0.GetBacklinksRequest, $0.GetBacklinksResponse>(
          '/githeft.v1.Githeft/GetBacklinks',
          ($0.GetBacklinksRequest value) => value.writeToBuffer(),
          $0.GetBacklinksResponse.fromBuffer);
  static final _$hostInfo =
      $grpc.ClientMethod<$0.HostInfoRequest, $0.HostInfoResponse>(
          '/githeft.v1.Githeft/HostInfo',
          ($0.HostInfoRequest value) => value.writeToBuffer(),
          $0.HostInfoResponse.fromBuffer);
  static final _$hostLoginStart =
      $grpc.ClientMethod<$0.HostLoginStartRequest, $0.HostLoginStartResponse>(
          '/githeft.v1.Githeft/HostLoginStart',
          ($0.HostLoginStartRequest value) => value.writeToBuffer(),
          $0.HostLoginStartResponse.fromBuffer);
  static final _$hostLoginPoll =
      $grpc.ClientMethod<$0.HostLoginPollRequest, $0.HostLoginPollResponse>(
          '/githeft.v1.Githeft/HostLoginPoll',
          ($0.HostLoginPollRequest value) => value.writeToBuffer(),
          $0.HostLoginPollResponse.fromBuffer);
  static final _$hostListRepos =
      $grpc.ClientMethod<$0.HostListReposRequest, $0.HostListReposResponse>(
          '/githeft.v1.Githeft/HostListRepos',
          ($0.HostListReposRequest value) => value.writeToBuffer(),
          $0.HostListReposResponse.fromBuffer);
  static final _$hostCreateRepo =
      $grpc.ClientMethod<$0.HostCreateRepoRequest, $0.HostRepo>(
          '/githeft.v1.Githeft/HostCreateRepo',
          ($0.HostCreateRepoRequest value) => value.writeToBuffer(),
          $0.HostRepo.fromBuffer);
  static final _$hostAddDeployKey = $grpc.ClientMethod<
          $0.HostAddDeployKeyRequest, $0.HostAddDeployKeyResponse>(
      '/githeft.v1.Githeft/HostAddDeployKey',
      ($0.HostAddDeployKeyRequest value) => value.writeToBuffer(),
      $0.HostAddDeployKeyResponse.fromBuffer);
  static final _$sync = $grpc.ClientMethod<$0.SyncRequest, $0.SyncStatus>(
      '/githeft.v1.Githeft/Sync',
      ($0.SyncRequest value) => value.writeToBuffer(),
      $0.SyncStatus.fromBuffer);
  static final _$getSyncStatus =
      $grpc.ClientMethod<$0.GetSyncStatusRequest, $0.SyncStatus>(
          '/githeft.v1.Githeft/GetSyncStatus',
          ($0.GetSyncStatusRequest value) => value.writeToBuffer(),
          $0.SyncStatus.fromBuffer);
  static final _$syncAll =
      $grpc.ClientMethod<$0.SyncAllRequest, $0.SyncAllResponse>(
          '/githeft.v1.Githeft/SyncAll',
          ($0.SyncAllRequest value) => value.writeToBuffer(),
          $0.SyncAllResponse.fromBuffer);
}

@$pb.GrpcServiceName('githeft.v1.Githeft')
abstract class GitheftServiceBase extends $grpc.Service {
  $core.String get $name => 'githeft.v1.Githeft';

  GitheftServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.ListNotebooksRequest, $0.ListNotebooksResponse>(
            'ListNotebooks',
            listNotebooks_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListNotebooksRequest.fromBuffer(value),
            ($0.ListNotebooksResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateNotebookRequest, $0.Notebook>(
        'CreateNotebook',
        createNotebook_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateNotebookRequest.fromBuffer(value),
        ($0.Notebook value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateNotebookRequest, $0.Notebook>(
        'UpdateNotebook',
        updateNotebook_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateNotebookRequest.fromBuffer(value),
        ($0.Notebook value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteNotebookRequest,
            $0.DeleteNotebookResponse>(
        'DeleteNotebook',
        deleteNotebook_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteNotebookRequest.fromBuffer(value),
        ($0.DeleteNotebookResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GenerateSshKeyRequest, $0.SshKey>(
        'GenerateSshKey',
        generateSshKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GenerateSshKeyRequest.fromBuffer(value),
        ($0.SshKey value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ImportSshKeyRequest, $0.SshKey>(
        'ImportSshKey',
        importSshKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ImportSshKeyRequest.fromBuffer(value),
        ($0.SshKey value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetSshKeyRequest, $0.SshKey>(
        'GetSshKey',
        getSshKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetSshKeyRequest.fromBuffer(value),
        ($0.SshKey value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TestRemoteRequest, $0.TestRemoteResponse>(
        'TestRemote',
        testRemote_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.TestRemoteRequest.fromBuffer(value),
        ($0.TestRemoteResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ForgetHostKeyRequest, $0.ForgetHostKeyResponse>(
            'ForgetHostKey',
            forgetHostKey_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ForgetHostKeyRequest.fromBuffer(value),
            ($0.ForgetHostKeyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListNotesRequest, $0.ListNotesResponse>(
        'ListNotes',
        listNotes_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListNotesRequest.fromBuffer(value),
        ($0.ListNotesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetNoteRequest, $0.Note>(
        'GetNote',
        getNote_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetNoteRequest.fromBuffer(value),
        ($0.Note value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SaveNoteRequest, $0.SaveNoteResponse>(
        'SaveNote',
        saveNote_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SaveNoteRequest.fromBuffer(value),
        ($0.SaveNoteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RenameNoteRequest, $0.Note>(
        'RenameNote',
        renameNote_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RenameNoteRequest.fromBuffer(value),
        ($0.Note value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteNoteRequest, $0.DeleteNoteResponse>(
        'DeleteNote',
        deleteNote_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteNoteRequest.fromBuffer(value),
        ($0.DeleteNoteResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CreateFolderRequest, $0.CreateFolderResponse>(
            'CreateFolder',
            createFolder_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CreateFolderRequest.fromBuffer(value),
            ($0.CreateFolderResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListTagsRequest, $0.ListTagsResponse>(
        'ListTags',
        listTags_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListTagsRequest.fromBuffer(value),
        ($0.ListTagsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateNoteMetaRequest, $0.Note>(
        'UpdateNoteMeta',
        updateNoteMeta_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateNoteMetaRequest.fromBuffer(value),
        ($0.Note value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.AddAttachmentRequest, $0.AddAttachmentResponse>(
            'AddAttachment',
            addAttachment_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.AddAttachmentRequest.fromBuffer(value),
            ($0.AddAttachmentResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetFileRequest, $0.GetFileResponse>(
        'GetFile',
        getFile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetFileRequest.fromBuffer(value),
        ($0.GetFileResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ResolveLinkRequest, $0.ResolveLinkResponse>(
            'ResolveLink',
            resolveLink_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ResolveLinkRequest.fromBuffer(value),
            ($0.ResolveLinkResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetBacklinksRequest, $0.GetBacklinksResponse>(
            'GetBacklinks',
            getBacklinks_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetBacklinksRequest.fromBuffer(value),
            ($0.GetBacklinksResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.HostInfoRequest, $0.HostInfoResponse>(
        'HostInfo',
        hostInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.HostInfoRequest.fromBuffer(value),
        ($0.HostInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.HostLoginStartRequest,
            $0.HostLoginStartResponse>(
        'HostLoginStart',
        hostLoginStart_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.HostLoginStartRequest.fromBuffer(value),
        ($0.HostLoginStartResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.HostLoginPollRequest, $0.HostLoginPollResponse>(
            'HostLoginPoll',
            hostLoginPoll_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.HostLoginPollRequest.fromBuffer(value),
            ($0.HostLoginPollResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.HostListReposRequest, $0.HostListReposResponse>(
            'HostListRepos',
            hostListRepos_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.HostListReposRequest.fromBuffer(value),
            ($0.HostListReposResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.HostCreateRepoRequest, $0.HostRepo>(
        'HostCreateRepo',
        hostCreateRepo_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.HostCreateRepoRequest.fromBuffer(value),
        ($0.HostRepo value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.HostAddDeployKeyRequest,
            $0.HostAddDeployKeyResponse>(
        'HostAddDeployKey',
        hostAddDeployKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.HostAddDeployKeyRequest.fromBuffer(value),
        ($0.HostAddDeployKeyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SyncRequest, $0.SyncStatus>(
        'Sync',
        sync_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SyncRequest.fromBuffer(value),
        ($0.SyncStatus value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetSyncStatusRequest, $0.SyncStatus>(
        'GetSyncStatus',
        getSyncStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetSyncStatusRequest.fromBuffer(value),
        ($0.SyncStatus value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SyncAllRequest, $0.SyncAllResponse>(
        'SyncAll',
        syncAll_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SyncAllRequest.fromBuffer(value),
        ($0.SyncAllResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListNotebooksResponse> listNotebooks_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListNotebooksRequest> $request) async {
    return listNotebooks($call, await $request);
  }

  $async.Future<$0.ListNotebooksResponse> listNotebooks(
      $grpc.ServiceCall call, $0.ListNotebooksRequest request);

  $async.Future<$0.Notebook> createNotebook_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateNotebookRequest> $request) async {
    return createNotebook($call, await $request);
  }

  $async.Future<$0.Notebook> createNotebook(
      $grpc.ServiceCall call, $0.CreateNotebookRequest request);

  $async.Future<$0.Notebook> updateNotebook_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateNotebookRequest> $request) async {
    return updateNotebook($call, await $request);
  }

  $async.Future<$0.Notebook> updateNotebook(
      $grpc.ServiceCall call, $0.UpdateNotebookRequest request);

  $async.Future<$0.DeleteNotebookResponse> deleteNotebook_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteNotebookRequest> $request) async {
    return deleteNotebook($call, await $request);
  }

  $async.Future<$0.DeleteNotebookResponse> deleteNotebook(
      $grpc.ServiceCall call, $0.DeleteNotebookRequest request);

  $async.Future<$0.SshKey> generateSshKey_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GenerateSshKeyRequest> $request) async {
    return generateSshKey($call, await $request);
  }

  $async.Future<$0.SshKey> generateSshKey(
      $grpc.ServiceCall call, $0.GenerateSshKeyRequest request);

  $async.Future<$0.SshKey> importSshKey_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ImportSshKeyRequest> $request) async {
    return importSshKey($call, await $request);
  }

  $async.Future<$0.SshKey> importSshKey(
      $grpc.ServiceCall call, $0.ImportSshKeyRequest request);

  $async.Future<$0.SshKey> getSshKey_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetSshKeyRequest> $request) async {
    return getSshKey($call, await $request);
  }

  $async.Future<$0.SshKey> getSshKey(
      $grpc.ServiceCall call, $0.GetSshKeyRequest request);

  $async.Future<$0.TestRemoteResponse> testRemote_Pre($grpc.ServiceCall $call,
      $async.Future<$0.TestRemoteRequest> $request) async {
    return testRemote($call, await $request);
  }

  $async.Future<$0.TestRemoteResponse> testRemote(
      $grpc.ServiceCall call, $0.TestRemoteRequest request);

  $async.Future<$0.ForgetHostKeyResponse> forgetHostKey_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ForgetHostKeyRequest> $request) async {
    return forgetHostKey($call, await $request);
  }

  $async.Future<$0.ForgetHostKeyResponse> forgetHostKey(
      $grpc.ServiceCall call, $0.ForgetHostKeyRequest request);

  $async.Future<$0.ListNotesResponse> listNotes_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListNotesRequest> $request) async {
    return listNotes($call, await $request);
  }

  $async.Future<$0.ListNotesResponse> listNotes(
      $grpc.ServiceCall call, $0.ListNotesRequest request);

  $async.Future<$0.Note> getNote_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetNoteRequest> $request) async {
    return getNote($call, await $request);
  }

  $async.Future<$0.Note> getNote(
      $grpc.ServiceCall call, $0.GetNoteRequest request);

  $async.Future<$0.SaveNoteResponse> saveNote_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SaveNoteRequest> $request) async {
    return saveNote($call, await $request);
  }

  $async.Future<$0.SaveNoteResponse> saveNote(
      $grpc.ServiceCall call, $0.SaveNoteRequest request);

  $async.Future<$0.Note> renameNote_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RenameNoteRequest> $request) async {
    return renameNote($call, await $request);
  }

  $async.Future<$0.Note> renameNote(
      $grpc.ServiceCall call, $0.RenameNoteRequest request);

  $async.Future<$0.DeleteNoteResponse> deleteNote_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteNoteRequest> $request) async {
    return deleteNote($call, await $request);
  }

  $async.Future<$0.DeleteNoteResponse> deleteNote(
      $grpc.ServiceCall call, $0.DeleteNoteRequest request);

  $async.Future<$0.CreateFolderResponse> createFolder_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreateFolderRequest> $request) async {
    return createFolder($call, await $request);
  }

  $async.Future<$0.CreateFolderResponse> createFolder(
      $grpc.ServiceCall call, $0.CreateFolderRequest request);

  $async.Future<$0.ListTagsResponse> listTags_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListTagsRequest> $request) async {
    return listTags($call, await $request);
  }

  $async.Future<$0.ListTagsResponse> listTags(
      $grpc.ServiceCall call, $0.ListTagsRequest request);

  $async.Future<$0.Note> updateNoteMeta_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateNoteMetaRequest> $request) async {
    return updateNoteMeta($call, await $request);
  }

  $async.Future<$0.Note> updateNoteMeta(
      $grpc.ServiceCall call, $0.UpdateNoteMetaRequest request);

  $async.Future<$0.AddAttachmentResponse> addAttachment_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AddAttachmentRequest> $request) async {
    return addAttachment($call, await $request);
  }

  $async.Future<$0.AddAttachmentResponse> addAttachment(
      $grpc.ServiceCall call, $0.AddAttachmentRequest request);

  $async.Future<$0.GetFileResponse> getFile_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetFileRequest> $request) async {
    return getFile($call, await $request);
  }

  $async.Future<$0.GetFileResponse> getFile(
      $grpc.ServiceCall call, $0.GetFileRequest request);

  $async.Future<$0.ResolveLinkResponse> resolveLink_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ResolveLinkRequest> $request) async {
    return resolveLink($call, await $request);
  }

  $async.Future<$0.ResolveLinkResponse> resolveLink(
      $grpc.ServiceCall call, $0.ResolveLinkRequest request);

  $async.Future<$0.GetBacklinksResponse> getBacklinks_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetBacklinksRequest> $request) async {
    return getBacklinks($call, await $request);
  }

  $async.Future<$0.GetBacklinksResponse> getBacklinks(
      $grpc.ServiceCall call, $0.GetBacklinksRequest request);

  $async.Future<$0.HostInfoResponse> hostInfo_Pre($grpc.ServiceCall $call,
      $async.Future<$0.HostInfoRequest> $request) async {
    return hostInfo($call, await $request);
  }

  $async.Future<$0.HostInfoResponse> hostInfo(
      $grpc.ServiceCall call, $0.HostInfoRequest request);

  $async.Future<$0.HostLoginStartResponse> hostLoginStart_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.HostLoginStartRequest> $request) async {
    return hostLoginStart($call, await $request);
  }

  $async.Future<$0.HostLoginStartResponse> hostLoginStart(
      $grpc.ServiceCall call, $0.HostLoginStartRequest request);

  $async.Future<$0.HostLoginPollResponse> hostLoginPoll_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.HostLoginPollRequest> $request) async {
    return hostLoginPoll($call, await $request);
  }

  $async.Future<$0.HostLoginPollResponse> hostLoginPoll(
      $grpc.ServiceCall call, $0.HostLoginPollRequest request);

  $async.Future<$0.HostListReposResponse> hostListRepos_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.HostListReposRequest> $request) async {
    return hostListRepos($call, await $request);
  }

  $async.Future<$0.HostListReposResponse> hostListRepos(
      $grpc.ServiceCall call, $0.HostListReposRequest request);

  $async.Future<$0.HostRepo> hostCreateRepo_Pre($grpc.ServiceCall $call,
      $async.Future<$0.HostCreateRepoRequest> $request) async {
    return hostCreateRepo($call, await $request);
  }

  $async.Future<$0.HostRepo> hostCreateRepo(
      $grpc.ServiceCall call, $0.HostCreateRepoRequest request);

  $async.Future<$0.HostAddDeployKeyResponse> hostAddDeployKey_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.HostAddDeployKeyRequest> $request) async {
    return hostAddDeployKey($call, await $request);
  }

  $async.Future<$0.HostAddDeployKeyResponse> hostAddDeployKey(
      $grpc.ServiceCall call, $0.HostAddDeployKeyRequest request);

  $async.Future<$0.SyncStatus> sync_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.SyncRequest> $request) async {
    return sync($call, await $request);
  }

  $async.Future<$0.SyncStatus> sync(
      $grpc.ServiceCall call, $0.SyncRequest request);

  $async.Future<$0.SyncStatus> getSyncStatus_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetSyncStatusRequest> $request) async {
    return getSyncStatus($call, await $request);
  }

  $async.Future<$0.SyncStatus> getSyncStatus(
      $grpc.ServiceCall call, $0.GetSyncStatusRequest request);

  $async.Future<$0.SyncAllResponse> syncAll_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SyncAllRequest> $request) async {
    return syncAll($call, await $request);
  }

  $async.Future<$0.SyncAllResponse> syncAll(
      $grpc.ServiceCall call, $0.SyncAllRequest request);
}
