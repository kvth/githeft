// This is a generated file - do not edit.
//
// Generated from githeft/v1/githeft.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use authTypeDescriptor instead')
const AuthType$json = {
  '1': 'AuthType',
  '2': [
    {'1': 'AUTH_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'AUTH_TYPE_NONE', '2': 1},
    {'1': 'AUTH_TYPE_SSH', '2': 2},
    {'1': 'AUTH_TYPE_HTTPS', '2': 3},
  ],
};

/// Descriptor for `AuthType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List authTypeDescriptor = $convert.base64Decode(
    'CghBdXRoVHlwZRIZChVBVVRIX1RZUEVfVU5TUEVDSUZJRUQQABISCg5BVVRIX1RZUEVfTk9ORR'
    'ABEhEKDUFVVEhfVFlQRV9TU0gQAhITCg9BVVRIX1RZUEVfSFRUUFMQAw==');

@$core.Deprecated('Use newNoteNameDescriptor instead')
const NewNoteName$json = {
  '1': 'NewNoteName',
  '2': [
    {'1': 'NEW_NOTE_NAME_UNSPECIFIED', '2': 0},
    {'1': 'NEW_NOTE_NAME_TITLE', '2': 1},
    {'1': 'NEW_NOTE_NAME_DATE_TIME', '2': 2},
  ],
};

/// Descriptor for `NewNoteName`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List newNoteNameDescriptor = $convert.base64Decode(
    'CgtOZXdOb3RlTmFtZRIdChlORVdfTk9URV9OQU1FX1VOU1BFQ0lGSUVEEAASFwoTTkVXX05PVE'
    'VfTkFNRV9USVRMRRABEhsKF05FV19OT1RFX05BTUVfREFURV9USU1FEAI=');

@$core.Deprecated('Use sshKeyTypeDescriptor instead')
const SshKeyType$json = {
  '1': 'SshKeyType',
  '2': [
    {'1': 'SSH_KEY_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'SSH_KEY_TYPE_ED25519', '2': 1},
    {'1': 'SSH_KEY_TYPE_RSA', '2': 2},
  ],
};

/// Descriptor for `SshKeyType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sshKeyTypeDescriptor = $convert.base64Decode(
    'CgpTc2hLZXlUeXBlEhwKGFNTSF9LRVlfVFlQRV9VTlNQRUNJRklFRBAAEhgKFFNTSF9LRVlfVF'
    'lQRV9FRDI1NTE5EAESFAoQU1NIX0tFWV9UWVBFX1JTQRAC');

@$core.Deprecated('Use noteTypeDescriptor instead')
const NoteType$json = {
  '1': 'NoteType',
  '2': [
    {'1': 'NOTE_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'NOTE_TYPE_MARKDOWN', '2': 1},
    {'1': 'NOTE_TYPE_CHECKLIST', '2': 2},
    {'1': 'NOTE_TYPE_JOURNAL', '2': 3},
  ],
};

/// Descriptor for `NoteType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List noteTypeDescriptor = $convert.base64Decode(
    'CghOb3RlVHlwZRIZChVOT1RFX1RZUEVfVU5TUEVDSUZJRUQQABIWChJOT1RFX1RZUEVfTUFSS0'
    'RPV04QARIXChNOT1RFX1RZUEVfQ0hFQ0tMSVNUEAISFQoRTk9URV9UWVBFX0pPVVJOQUwQAw==');

@$core.Deprecated('Use sortOrderDescriptor instead')
const SortOrder$json = {
  '1': 'SortOrder',
  '2': [
    {'1': 'SORT_ORDER_UNSPECIFIED', '2': 0},
    {'1': 'SORT_ORDER_MODIFIED_DESC', '2': 1},
    {'1': 'SORT_ORDER_CREATED_DESC', '2': 2},
    {'1': 'SORT_ORDER_TITLE_ASC', '2': 3},
    {'1': 'SORT_ORDER_PATH_ASC', '2': 4},
  ],
};

/// Descriptor for `SortOrder`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sortOrderDescriptor = $convert.base64Decode(
    'CglTb3J0T3JkZXISGgoWU09SVF9PUkRFUl9VTlNQRUNJRklFRBAAEhwKGFNPUlRfT1JERVJfTU'
    '9ESUZJRURfREVTQxABEhsKF1NPUlRfT1JERVJfQ1JFQVRFRF9ERVNDEAISGAoUU09SVF9PUkRF'
    'Ul9USVRMRV9BU0MQAxIXChNTT1JUX09SREVSX1BBVEhfQVNDEAQ=');

@$core.Deprecated('Use hostKindDescriptor instead')
const HostKind$json = {
  '1': 'HostKind',
  '2': [
    {'1': 'HOST_KIND_UNSPECIFIED', '2': 0},
    {'1': 'HOST_KIND_GITHUB', '2': 1},
    {'1': 'HOST_KIND_GITLAB', '2': 2},
    {'1': 'HOST_KIND_GITEA', '2': 3},
  ],
};

/// Descriptor for `HostKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List hostKindDescriptor = $convert.base64Decode(
    'CghIb3N0S2luZBIZChVIT1NUX0tJTkRfVU5TUEVDSUZJRUQQABIUChBIT1NUX0tJTkRfR0lUSF'
    'VCEAESFAoQSE9TVF9LSU5EX0dJVExBQhACEhMKD0hPU1RfS0lORF9HSVRFQRAD');

@$core.Deprecated('Use syncStateDescriptor instead')
const SyncState$json = {
  '1': 'SyncState',
  '2': [
    {'1': 'SYNC_STATE_UNSPECIFIED', '2': 0},
    {'1': 'SYNC_STATE_IDLE', '2': 1},
    {'1': 'SYNC_STATE_SYNCING', '2': 2},
    {'1': 'SYNC_STATE_ERROR', '2': 3},
    {'1': 'SYNC_STATE_LOCAL_ONLY', '2': 4},
  ],
};

/// Descriptor for `SyncState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List syncStateDescriptor = $convert.base64Decode(
    'CglTeW5jU3RhdGUSGgoWU1lOQ19TVEFURV9VTlNQRUNJRklFRBAAEhMKD1NZTkNfU1RBVEVfSU'
    'RMRRABEhYKElNZTkNfU1RBVEVfU1lOQ0lORxACEhQKEFNZTkNfU1RBVEVfRVJST1IQAxIZChVT'
    'WU5DX1NUQVRFX0xPQ0FMX09OTFkQBA==');

@$core.Deprecated('Use remoteDescriptor instead')
const Remote$json = {
  '1': 'Remote',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {
      '1': 'auth_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.githeft.v1.AuthType',
      '10': 'authType'
    },
    {'1': 'ssh_key_id', '3': 3, '4': 1, '5': 9, '10': 'sshKeyId'},
    {'1': 'username', '3': 4, '4': 1, '5': 9, '10': 'username'},
    {'1': 'password', '3': 5, '4': 1, '5': 9, '10': 'password'},
    {'1': 'password_stored', '3': 6, '4': 1, '5': 8, '10': 'passwordStored'},
    {'1': 'branch', '3': 7, '4': 1, '5': 9, '10': 'branch'},
  ],
};

/// Descriptor for `Remote`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List remoteDescriptor = $convert.base64Decode(
    'CgZSZW1vdGUSEAoDdXJsGAEgASgJUgN1cmwSMQoJYXV0aF90eXBlGAIgASgOMhQuZ2l0aGVmdC'
    '52MS5BdXRoVHlwZVIIYXV0aFR5cGUSHAoKc3NoX2tleV9pZBgDIAEoCVIIc3NoS2V5SWQSGgoI'
    'dXNlcm5hbWUYBCABKAlSCHVzZXJuYW1lEhoKCHBhc3N3b3JkGAUgASgJUghwYXNzd29yZBInCg'
    '9wYXNzd29yZF9zdG9yZWQYBiABKAhSDnBhc3N3b3JkU3RvcmVkEhYKBmJyYW5jaBgHIAEoCVIG'
    'YnJhbmNo');

@$core.Deprecated('Use authorDescriptor instead')
const Author$json = {
  '1': 'Author',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `Author`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authorDescriptor = $convert.base64Decode(
    'CgZBdXRob3ISEgoEbmFtZRgBIAEoCVIEbmFtZRIUCgVlbWFpbBgCIAEoCVIFZW1haWw=');

@$core.Deprecated('Use notebookDescriptor instead')
const Notebook$json = {
  '1': 'Notebook',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'path', '3': 3, '4': 1, '5': 9, '10': 'path'},
    {
      '1': 'remote',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.githeft.v1.Remote',
      '10': 'remote'
    },
    {
      '1': 'author',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.githeft.v1.Author',
      '10': 'author'
    },
    {'1': 'auto_sync', '3': 6, '4': 1, '5': 8, '10': 'autoSync'},
    {
      '1': 'new_note_name',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.githeft.v1.NewNoteName',
      '10': 'newNoteName'
    },
    {'1': 'default_folder', '3': 8, '4': 1, '5': 9, '10': 'defaultFolder'},
  ],
};

/// Descriptor for `Notebook`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notebookDescriptor = $convert.base64Decode(
    'CghOb3RlYm9vaxIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRISCgRwYXRoGA'
    'MgASgJUgRwYXRoEioKBnJlbW90ZRgEIAEoCzISLmdpdGhlZnQudjEuUmVtb3RlUgZyZW1vdGUS'
    'KgoGYXV0aG9yGAUgASgLMhIuZ2l0aGVmdC52MS5BdXRob3JSBmF1dGhvchIbCglhdXRvX3N5bm'
    'MYBiABKAhSCGF1dG9TeW5jEjsKDW5ld19ub3RlX25hbWUYByABKA4yFy5naXRoZWZ0LnYxLk5l'
    'd05vdGVOYW1lUgtuZXdOb3RlTmFtZRIlCg5kZWZhdWx0X2ZvbGRlchgIIAEoCVINZGVmYXVsdE'
    'ZvbGRlcg==');

@$core.Deprecated('Use listNotebooksRequestDescriptor instead')
const ListNotebooksRequest$json = {
  '1': 'ListNotebooksRequest',
};

/// Descriptor for `ListNotebooksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listNotebooksRequestDescriptor =
    $convert.base64Decode('ChRMaXN0Tm90ZWJvb2tzUmVxdWVzdA==');

@$core.Deprecated('Use listNotebooksResponseDescriptor instead')
const ListNotebooksResponse$json = {
  '1': 'ListNotebooksResponse',
  '2': [
    {
      '1': 'notebooks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.githeft.v1.Notebook',
      '10': 'notebooks'
    },
  ],
};

/// Descriptor for `ListNotebooksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listNotebooksResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0Tm90ZWJvb2tzUmVzcG9uc2USMgoJbm90ZWJvb2tzGAEgAygLMhQuZ2l0aGVmdC52MS'
    '5Ob3RlYm9va1IJbm90ZWJvb2tz');

@$core.Deprecated('Use createNotebookRequestDescriptor instead')
const CreateNotebookRequest$json = {
  '1': 'CreateNotebookRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'empty', '3': 2, '4': 1, '5': 8, '9': 0, '10': 'empty'},
    {
      '1': 'clone_remote',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.githeft.v1.Remote',
      '9': 0,
      '10': 'cloneRemote'
    },
    {
      '1': 'existing_path',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'existingPath'
    },
    {
      '1': 'author',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.githeft.v1.Author',
      '10': 'author'
    },
    {
      '1': 'remote',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.githeft.v1.Remote',
      '10': 'remote'
    },
    {'1': 'target_path', '3': 7, '4': 1, '5': 9, '10': 'targetPath'},
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `CreateNotebookRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createNotebookRequestDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVOb3RlYm9va1JlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZRIWCgVlbXB0eRgCIA'
    'EoCEgAUgVlbXB0eRI3CgxjbG9uZV9yZW1vdGUYAyABKAsyEi5naXRoZWZ0LnYxLlJlbW90ZUgA'
    'UgtjbG9uZVJlbW90ZRIlCg1leGlzdGluZ19wYXRoGAQgASgJSABSDGV4aXN0aW5nUGF0aBIqCg'
    'ZhdXRob3IYBSABKAsyEi5naXRoZWZ0LnYxLkF1dGhvclIGYXV0aG9yEioKBnJlbW90ZRgGIAEo'
    'CzISLmdpdGhlZnQudjEuUmVtb3RlUgZyZW1vdGUSHwoLdGFyZ2V0X3BhdGgYByABKAlSCnRhcm'
    'dldFBhdGhCCAoGc291cmNl');

@$core.Deprecated('Use updateNotebookRequestDescriptor instead')
const UpdateNotebookRequest$json = {
  '1': 'UpdateNotebookRequest',
  '2': [
    {
      '1': 'notebook',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.githeft.v1.Notebook',
      '10': 'notebook'
    },
  ],
};

/// Descriptor for `UpdateNotebookRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateNotebookRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVOb3RlYm9va1JlcXVlc3QSMAoIbm90ZWJvb2sYASABKAsyFC5naXRoZWZ0LnYxLk'
    '5vdGVib29rUghub3RlYm9vaw==');

@$core.Deprecated('Use deleteNotebookRequestDescriptor instead')
const DeleteNotebookRequest$json = {
  '1': 'DeleteNotebookRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'delete_files', '3': 2, '4': 1, '5': 8, '10': 'deleteFiles'},
  ],
};

/// Descriptor for `DeleteNotebookRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteNotebookRequestDescriptor = $convert.base64Decode(
    'ChVEZWxldGVOb3RlYm9va1JlcXVlc3QSDgoCaWQYASABKAlSAmlkEiEKDGRlbGV0ZV9maWxlcx'
    'gCIAEoCFILZGVsZXRlRmlsZXM=');

@$core.Deprecated('Use deleteNotebookResponseDescriptor instead')
const DeleteNotebookResponse$json = {
  '1': 'DeleteNotebookResponse',
};

/// Descriptor for `DeleteNotebookResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteNotebookResponseDescriptor =
    $convert.base64Decode('ChZEZWxldGVOb3RlYm9va1Jlc3BvbnNl');

@$core.Deprecated('Use sshKeyDescriptor instead')
const SshKey$json = {
  '1': 'SshKey',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.githeft.v1.SshKeyType',
      '10': 'type'
    },
    {'1': 'public_key', '3': 3, '4': 1, '5': 9, '10': 'publicKey'},
    {'1': 'fingerprint', '3': 4, '4': 1, '5': 9, '10': 'fingerprint'},
  ],
};

/// Descriptor for `SshKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sshKeyDescriptor = $convert.base64Decode(
    'CgZTc2hLZXkSDgoCaWQYASABKAlSAmlkEioKBHR5cGUYAiABKA4yFi5naXRoZWZ0LnYxLlNzaE'
    'tleVR5cGVSBHR5cGUSHQoKcHVibGljX2tleRgDIAEoCVIJcHVibGljS2V5EiAKC2ZpbmdlcnBy'
    'aW50GAQgASgJUgtmaW5nZXJwcmludA==');

@$core.Deprecated('Use generateSshKeyRequestDescriptor instead')
const GenerateSshKeyRequest$json = {
  '1': 'GenerateSshKeyRequest',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.githeft.v1.SshKeyType',
      '10': 'type'
    },
    {'1': 'comment', '3': 2, '4': 1, '5': 9, '10': 'comment'},
  ],
};

/// Descriptor for `GenerateSshKeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateSshKeyRequestDescriptor = $convert.base64Decode(
    'ChVHZW5lcmF0ZVNzaEtleVJlcXVlc3QSKgoEdHlwZRgBIAEoDjIWLmdpdGhlZnQudjEuU3NoS2'
    'V5VHlwZVIEdHlwZRIYCgdjb21tZW50GAIgASgJUgdjb21tZW50');

@$core.Deprecated('Use importSshKeyRequestDescriptor instead')
const ImportSshKeyRequest$json = {
  '1': 'ImportSshKeyRequest',
  '2': [
    {'1': 'private_key', '3': 1, '4': 1, '5': 9, '10': 'privateKey'},
    {'1': 'passphrase', '3': 2, '4': 1, '5': 9, '10': 'passphrase'},
  ],
};

/// Descriptor for `ImportSshKeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importSshKeyRequestDescriptor = $convert.base64Decode(
    'ChNJbXBvcnRTc2hLZXlSZXF1ZXN0Eh8KC3ByaXZhdGVfa2V5GAEgASgJUgpwcml2YXRlS2V5Eh'
    '4KCnBhc3NwaHJhc2UYAiABKAlSCnBhc3NwaHJhc2U=');

@$core.Deprecated('Use getSshKeyRequestDescriptor instead')
const GetSshKeyRequest$json = {
  '1': 'GetSshKeyRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetSshKeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSshKeyRequestDescriptor =
    $convert.base64Decode('ChBHZXRTc2hLZXlSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use testRemoteRequestDescriptor instead')
const TestRemoteRequest$json = {
  '1': 'TestRemoteRequest',
  '2': [
    {
      '1': 'remote',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.githeft.v1.Remote',
      '10': 'remote'
    },
    {'1': 'notebook_id', '3': 2, '4': 1, '5': 9, '10': 'notebookId'},
  ],
};

/// Descriptor for `TestRemoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List testRemoteRequestDescriptor = $convert.base64Decode(
    'ChFUZXN0UmVtb3RlUmVxdWVzdBIqCgZyZW1vdGUYASABKAsyEi5naXRoZWZ0LnYxLlJlbW90ZV'
    'IGcmVtb3RlEh8KC25vdGVib29rX2lkGAIgASgJUgpub3RlYm9va0lk');

@$core.Deprecated('Use testRemoteResponseDescriptor instead')
const TestRemoteResponse$json = {
  '1': 'TestRemoteResponse',
  '2': [
    {'1': 'branches', '3': 1, '4': 3, '5': 9, '10': 'branches'},
    {'1': 'default_branch', '3': 2, '4': 1, '5': 9, '10': 'defaultBranch'},
  ],
};

/// Descriptor for `TestRemoteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List testRemoteResponseDescriptor = $convert.base64Decode(
    'ChJUZXN0UmVtb3RlUmVzcG9uc2USGgoIYnJhbmNoZXMYASADKAlSCGJyYW5jaGVzEiUKDmRlZm'
    'F1bHRfYnJhbmNoGAIgASgJUg1kZWZhdWx0QnJhbmNo');

@$core.Deprecated('Use forgetHostKeyRequestDescriptor instead')
const ForgetHostKeyRequest$json = {
  '1': 'ForgetHostKeyRequest',
  '2': [
    {'1': 'host', '3': 1, '4': 1, '5': 9, '10': 'host'},
  ],
};

/// Descriptor for `ForgetHostKeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List forgetHostKeyRequestDescriptor = $convert
    .base64Decode('ChRGb3JnZXRIb3N0S2V5UmVxdWVzdBISCgRob3N0GAEgASgJUgRob3N0');

@$core.Deprecated('Use forgetHostKeyResponseDescriptor instead')
const ForgetHostKeyResponse$json = {
  '1': 'ForgetHostKeyResponse',
};

/// Descriptor for `ForgetHostKeyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List forgetHostKeyResponseDescriptor =
    $convert.base64Decode('ChVGb3JnZXRIb3N0S2V5UmVzcG9uc2U=');

@$core.Deprecated('Use noteSummaryDescriptor instead')
const NoteSummary$json = {
  '1': 'NoteSummary',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'excerpt', '3': 3, '4': 1, '5': 9, '10': 'excerpt'},
    {'1': 'tags', '3': 4, '4': 3, '5': 9, '10': 'tags'},
    {'1': 'created', '3': 5, '4': 1, '5': 3, '10': 'created'},
    {'1': 'modified', '3': 6, '4': 1, '5': 3, '10': 'modified'},
    {'1': 'conflict', '3': 7, '4': 1, '5': 8, '10': 'conflict'},
    {'1': 'pinned', '3': 8, '4': 1, '5': 8, '10': 'pinned'},
    {
      '1': 'type',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.githeft.v1.NoteType',
      '10': 'type'
    },
  ],
};

/// Descriptor for `NoteSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List noteSummaryDescriptor = $convert.base64Decode(
    'CgtOb3RlU3VtbWFyeRISCgRwYXRoGAEgASgJUgRwYXRoEhQKBXRpdGxlGAIgASgJUgV0aXRsZR'
    'IYCgdleGNlcnB0GAMgASgJUgdleGNlcnB0EhIKBHRhZ3MYBCADKAlSBHRhZ3MSGAoHY3JlYXRl'
    'ZBgFIAEoA1IHY3JlYXRlZBIaCghtb2RpZmllZBgGIAEoA1IIbW9kaWZpZWQSGgoIY29uZmxpY3'
    'QYByABKAhSCGNvbmZsaWN0EhYKBnBpbm5lZBgIIAEoCFIGcGlubmVkEigKBHR5cGUYCSABKA4y'
    'FC5naXRoZWZ0LnYxLk5vdGVUeXBlUgR0eXBl');

@$core.Deprecated('Use folderDescriptor instead')
const Folder$json = {
  '1': 'Folder',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'note_count', '3': 2, '4': 1, '5': 5, '10': 'noteCount'},
  ],
};

/// Descriptor for `Folder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List folderDescriptor = $convert.base64Decode(
    'CgZGb2xkZXISEgoEcGF0aBgBIAEoCVIEcGF0aBIdCgpub3RlX2NvdW50GAIgASgFUglub3RlQ2'
    '91bnQ=');

@$core.Deprecated('Use listNotesRequestDescriptor instead')
const ListNotesRequest$json = {
  '1': 'ListNotesRequest',
  '2': [
    {'1': 'notebook_id', '3': 1, '4': 1, '5': 9, '10': 'notebookId'},
    {'1': 'folder', '3': 2, '4': 1, '5': 9, '10': 'folder'},
    {'1': 'recursive', '3': 3, '4': 1, '5': 8, '10': 'recursive'},
    {'1': 'query', '3': 4, '4': 1, '5': 9, '10': 'query'},
    {'1': 'tag', '3': 5, '4': 1, '5': 9, '10': 'tag'},
    {
      '1': 'sort',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.githeft.v1.SortOrder',
      '10': 'sort'
    },
  ],
};

/// Descriptor for `ListNotesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listNotesRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0Tm90ZXNSZXF1ZXN0Eh8KC25vdGVib29rX2lkGAEgASgJUgpub3RlYm9va0lkEhYKBm'
    'ZvbGRlchgCIAEoCVIGZm9sZGVyEhwKCXJlY3Vyc2l2ZRgDIAEoCFIJcmVjdXJzaXZlEhQKBXF1'
    'ZXJ5GAQgASgJUgVxdWVyeRIQCgN0YWcYBSABKAlSA3RhZxIpCgRzb3J0GAYgASgOMhUuZ2l0aG'
    'VmdC52MS5Tb3J0T3JkZXJSBHNvcnQ=');

@$core.Deprecated('Use listNotesResponseDescriptor instead')
const ListNotesResponse$json = {
  '1': 'ListNotesResponse',
  '2': [
    {
      '1': 'notes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.githeft.v1.NoteSummary',
      '10': 'notes'
    },
    {
      '1': 'folders',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.githeft.v1.Folder',
      '10': 'folders'
    },
  ],
};

/// Descriptor for `ListNotesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listNotesResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0Tm90ZXNSZXNwb25zZRItCgVub3RlcxgBIAMoCzIXLmdpdGhlZnQudjEuTm90ZVN1bW'
    '1hcnlSBW5vdGVzEiwKB2ZvbGRlcnMYAiADKAsyEi5naXRoZWZ0LnYxLkZvbGRlclIHZm9sZGVy'
    'cw==');

@$core.Deprecated('Use noteDescriptor instead')
const Note$json = {
  '1': 'Note',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.githeft.v1.NoteSummary',
      '10': 'summary'
    },
    {'1': 'body', '3': 2, '4': 1, '5': 9, '10': 'body'},
    {'1': 'raw', '3': 3, '4': 1, '5': 9, '10': 'raw'},
    {'1': 'revision', '3': 4, '4': 1, '5': 9, '10': 'revision'},
  ],
};

/// Descriptor for `Note`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List noteDescriptor = $convert.base64Decode(
    'CgROb3RlEjEKB3N1bW1hcnkYASABKAsyFy5naXRoZWZ0LnYxLk5vdGVTdW1tYXJ5UgdzdW1tYX'
    'J5EhIKBGJvZHkYAiABKAlSBGJvZHkSEAoDcmF3GAMgASgJUgNyYXcSGgoIcmV2aXNpb24YBCAB'
    'KAlSCHJldmlzaW9u');

@$core.Deprecated('Use getNoteRequestDescriptor instead')
const GetNoteRequest$json = {
  '1': 'GetNoteRequest',
  '2': [
    {'1': 'notebook_id', '3': 1, '4': 1, '5': 9, '10': 'notebookId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `GetNoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNoteRequestDescriptor = $convert.base64Decode(
    'Cg5HZXROb3RlUmVxdWVzdBIfCgtub3RlYm9va19pZBgBIAEoCVIKbm90ZWJvb2tJZBISCgRwYX'
    'RoGAIgASgJUgRwYXRo');

@$core.Deprecated('Use saveNoteRequestDescriptor instead')
const SaveNoteRequest$json = {
  '1': 'SaveNoteRequest',
  '2': [
    {'1': 'notebook_id', '3': 1, '4': 1, '5': 9, '10': 'notebookId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {'1': 'folder', '3': 3, '4': 1, '5': 9, '10': 'folder'},
    {'1': 'content', '3': 4, '4': 1, '5': 9, '10': 'content'},
    {'1': 'raw', '3': 5, '4': 1, '5': 8, '10': 'raw'},
    {'1': 'base_revision', '3': 6, '4': 1, '5': 9, '10': 'baseRevision'},
    {'1': 'base_content', '3': 7, '4': 1, '5': 9, '10': 'baseContent'},
    {
      '1': 'tags',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.githeft.v1.TagList',
      '10': 'tags'
    },
    {
      '1': 'type',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.githeft.v1.NoteType',
      '10': 'type'
    },
  ],
};

/// Descriptor for `SaveNoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveNoteRequestDescriptor = $convert.base64Decode(
    'Cg9TYXZlTm90ZVJlcXVlc3QSHwoLbm90ZWJvb2tfaWQYASABKAlSCm5vdGVib29rSWQSEgoEcG'
    'F0aBgCIAEoCVIEcGF0aBIWCgZmb2xkZXIYAyABKAlSBmZvbGRlchIYCgdjb250ZW50GAQgASgJ'
    'Ugdjb250ZW50EhAKA3JhdxgFIAEoCFIDcmF3EiMKDWJhc2VfcmV2aXNpb24YBiABKAlSDGJhc2'
    'VSZXZpc2lvbhIhCgxiYXNlX2NvbnRlbnQYByABKAlSC2Jhc2VDb250ZW50EicKBHRhZ3MYCCAB'
    'KAsyEy5naXRoZWZ0LnYxLlRhZ0xpc3RSBHRhZ3MSKAoEdHlwZRgJIAEoDjIULmdpdGhlZnQudj'
    'EuTm90ZVR5cGVSBHR5cGU=');

@$core.Deprecated('Use updateNoteMetaRequestDescriptor instead')
const UpdateNoteMetaRequest$json = {
  '1': 'UpdateNoteMetaRequest',
  '2': [
    {'1': 'notebook_id', '3': 1, '4': 1, '5': 9, '10': 'notebookId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {'1': 'pinned', '3': 3, '4': 1, '5': 8, '9': 0, '10': 'pinned', '17': true},
    {
      '1': 'type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.githeft.v1.NoteType',
      '9': 1,
      '10': 'type',
      '17': true
    },
  ],
  '8': [
    {'1': '_pinned'},
    {'1': '_type'},
  ],
};

/// Descriptor for `UpdateNoteMetaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateNoteMetaRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVOb3RlTWV0YVJlcXVlc3QSHwoLbm90ZWJvb2tfaWQYASABKAlSCm5vdGVib29rSW'
    'QSEgoEcGF0aBgCIAEoCVIEcGF0aBIbCgZwaW5uZWQYAyABKAhIAFIGcGlubmVkiAEBEi0KBHR5'
    'cGUYBCABKA4yFC5naXRoZWZ0LnYxLk5vdGVUeXBlSAFSBHR5cGWIAQFCCQoHX3Bpbm5lZEIHCg'
    'VfdHlwZQ==');

@$core.Deprecated('Use addAttachmentRequestDescriptor instead')
const AddAttachmentRequest$json = {
  '1': 'AddAttachmentRequest',
  '2': [
    {'1': 'notebook_id', '3': 1, '4': 1, '5': 9, '10': 'notebookId'},
    {'1': 'note_path', '3': 2, '4': 1, '5': 9, '10': 'notePath'},
    {'1': 'folder', '3': 3, '4': 1, '5': 9, '10': 'folder'},
    {'1': 'file_name', '3': 4, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'data', '3': 5, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `AddAttachmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addAttachmentRequestDescriptor = $convert.base64Decode(
    'ChRBZGRBdHRhY2htZW50UmVxdWVzdBIfCgtub3RlYm9va19pZBgBIAEoCVIKbm90ZWJvb2tJZB'
    'IbCglub3RlX3BhdGgYAiABKAlSCG5vdGVQYXRoEhYKBmZvbGRlchgDIAEoCVIGZm9sZGVyEhsK'
    'CWZpbGVfbmFtZRgEIAEoCVIIZmlsZU5hbWUSEgoEZGF0YRgFIAEoDFIEZGF0YQ==');

@$core.Deprecated('Use addAttachmentResponseDescriptor instead')
const AddAttachmentResponse$json = {
  '1': 'AddAttachmentResponse',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'markdown', '3': 2, '4': 1, '5': 9, '10': 'markdown'},
  ],
};

/// Descriptor for `AddAttachmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addAttachmentResponseDescriptor = $convert.base64Decode(
    'ChVBZGRBdHRhY2htZW50UmVzcG9uc2USEgoEcGF0aBgBIAEoCVIEcGF0aBIaCghtYXJrZG93bh'
    'gCIAEoCVIIbWFya2Rvd24=');

@$core.Deprecated('Use getFileRequestDescriptor instead')
const GetFileRequest$json = {
  '1': 'GetFileRequest',
  '2': [
    {'1': 'notebook_id', '3': 1, '4': 1, '5': 9, '10': 'notebookId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `GetFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFileRequestDescriptor = $convert.base64Decode(
    'Cg5HZXRGaWxlUmVxdWVzdBIfCgtub3RlYm9va19pZBgBIAEoCVIKbm90ZWJvb2tJZBISCgRwYX'
    'RoGAIgASgJUgRwYXRo');

@$core.Deprecated('Use getFileResponseDescriptor instead')
const GetFileResponse$json = {
  '1': 'GetFileResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
    {'1': 'mime_type', '3': 2, '4': 1, '5': 9, '10': 'mimeType'},
  ],
};

/// Descriptor for `GetFileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFileResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRGaWxlUmVzcG9uc2USEgoEZGF0YRgBIAEoDFIEZGF0YRIbCgltaW1lX3R5cGUYAiABKA'
    'lSCG1pbWVUeXBl');

@$core.Deprecated('Use resolveLinkRequestDescriptor instead')
const ResolveLinkRequest$json = {
  '1': 'ResolveLinkRequest',
  '2': [
    {'1': 'notebook_id', '3': 1, '4': 1, '5': 9, '10': 'notebookId'},
    {'1': 'from_path', '3': 2, '4': 1, '5': 9, '10': 'fromPath'},
    {'1': 'target', '3': 3, '4': 1, '5': 9, '10': 'target'},
  ],
};

/// Descriptor for `ResolveLinkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveLinkRequestDescriptor = $convert.base64Decode(
    'ChJSZXNvbHZlTGlua1JlcXVlc3QSHwoLbm90ZWJvb2tfaWQYASABKAlSCm5vdGVib29rSWQSGw'
    'oJZnJvbV9wYXRoGAIgASgJUghmcm9tUGF0aBIWCgZ0YXJnZXQYAyABKAlSBnRhcmdldA==');

@$core.Deprecated('Use resolveLinkResponseDescriptor instead')
const ResolveLinkResponse$json = {
  '1': 'ResolveLinkResponse',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `ResolveLinkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveLinkResponseDescriptor = $convert
    .base64Decode('ChNSZXNvbHZlTGlua1Jlc3BvbnNlEhIKBHBhdGgYASABKAlSBHBhdGg=');

@$core.Deprecated('Use getBacklinksRequestDescriptor instead')
const GetBacklinksRequest$json = {
  '1': 'GetBacklinksRequest',
  '2': [
    {'1': 'notebook_id', '3': 1, '4': 1, '5': 9, '10': 'notebookId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `GetBacklinksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBacklinksRequestDescriptor = $convert.base64Decode(
    'ChNHZXRCYWNrbGlua3NSZXF1ZXN0Eh8KC25vdGVib29rX2lkGAEgASgJUgpub3RlYm9va0lkEh'
    'IKBHBhdGgYAiABKAlSBHBhdGg=');

@$core.Deprecated('Use getBacklinksResponseDescriptor instead')
const GetBacklinksResponse$json = {
  '1': 'GetBacklinksResponse',
  '2': [
    {
      '1': 'notes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.githeft.v1.NoteSummary',
      '10': 'notes'
    },
  ],
};

/// Descriptor for `GetBacklinksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBacklinksResponseDescriptor = $convert.base64Decode(
    'ChRHZXRCYWNrbGlua3NSZXNwb25zZRItCgVub3RlcxgBIAMoCzIXLmdpdGhlZnQudjEuTm90ZV'
    'N1bW1hcnlSBW5vdGVz');

@$core.Deprecated('Use hostAccountDescriptor instead')
const HostAccount$json = {
  '1': 'HostAccount',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.githeft.v1.HostKind',
      '10': 'kind'
    },
    {'1': 'base_url', '3': 2, '4': 1, '5': 9, '10': 'baseUrl'},
    {'1': 'token', '3': 3, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `HostAccount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hostAccountDescriptor = $convert.base64Decode(
    'CgtIb3N0QWNjb3VudBIoCgRraW5kGAEgASgOMhQuZ2l0aGVmdC52MS5Ib3N0S2luZFIEa2luZB'
    'IZCghiYXNlX3VybBgCIAEoCVIHYmFzZVVybBIUCgV0b2tlbhgDIAEoCVIFdG9rZW4=');

@$core.Deprecated('Use hostRepoDescriptor instead')
const HostRepo$json = {
  '1': 'HostRepo',
  '2': [
    {'1': 'full_name', '3': 1, '4': 1, '5': 9, '10': 'fullName'},
    {'1': 'ssh_url', '3': 2, '4': 1, '5': 9, '10': 'sshUrl'},
    {'1': 'https_url', '3': 3, '4': 1, '5': 9, '10': 'httpsUrl'},
    {'1': 'private', '3': 4, '4': 1, '5': 8, '10': 'private'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {'1': 'updated', '3': 6, '4': 1, '5': 3, '10': 'updated'},
  ],
};

/// Descriptor for `HostRepo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hostRepoDescriptor = $convert.base64Decode(
    'CghIb3N0UmVwbxIbCglmdWxsX25hbWUYASABKAlSCGZ1bGxOYW1lEhcKB3NzaF91cmwYAiABKA'
    'lSBnNzaFVybBIbCglodHRwc191cmwYAyABKAlSCGh0dHBzVXJsEhgKB3ByaXZhdGUYBCABKAhS'
    'B3ByaXZhdGUSIAoLZGVzY3JpcHRpb24YBSABKAlSC2Rlc2NyaXB0aW9uEhgKB3VwZGF0ZWQYBi'
    'ABKANSB3VwZGF0ZWQ=');

@$core.Deprecated('Use hostInfoRequestDescriptor instead')
const HostInfoRequest$json = {
  '1': 'HostInfoRequest',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.githeft.v1.HostKind',
      '10': 'kind'
    },
    {'1': 'base_url', '3': 2, '4': 1, '5': 9, '10': 'baseUrl'},
  ],
};

/// Descriptor for `HostInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hostInfoRequestDescriptor = $convert.base64Decode(
    'Cg9Ib3N0SW5mb1JlcXVlc3QSKAoEa2luZBgBIAEoDjIULmdpdGhlZnQudjEuSG9zdEtpbmRSBG'
    'tpbmQSGQoIYmFzZV91cmwYAiABKAlSB2Jhc2VVcmw=');

@$core.Deprecated('Use hostInfoResponseDescriptor instead')
const HostInfoResponse$json = {
  '1': 'HostInfoResponse',
  '2': [
    {'1': 'device_login', '3': 1, '4': 1, '5': 8, '10': 'deviceLogin'},
    {'1': 'token_url', '3': 2, '4': 1, '5': 9, '10': 'tokenUrl'},
    {'1': 'token_hint', '3': 3, '4': 1, '5': 9, '10': 'tokenHint'},
  ],
};

/// Descriptor for `HostInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hostInfoResponseDescriptor = $convert.base64Decode(
    'ChBIb3N0SW5mb1Jlc3BvbnNlEiEKDGRldmljZV9sb2dpbhgBIAEoCFILZGV2aWNlTG9naW4SGw'
    'oJdG9rZW5fdXJsGAIgASgJUgh0b2tlblVybBIdCgp0b2tlbl9oaW50GAMgASgJUgl0b2tlbkhp'
    'bnQ=');

@$core.Deprecated('Use hostLoginStartRequestDescriptor instead')
const HostLoginStartRequest$json = {
  '1': 'HostLoginStartRequest',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.githeft.v1.HostKind',
      '10': 'kind'
    },
    {'1': 'base_url', '3': 2, '4': 1, '5': 9, '10': 'baseUrl'},
  ],
};

/// Descriptor for `HostLoginStartRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hostLoginStartRequestDescriptor = $convert.base64Decode(
    'ChVIb3N0TG9naW5TdGFydFJlcXVlc3QSKAoEa2luZBgBIAEoDjIULmdpdGhlZnQudjEuSG9zdE'
    'tpbmRSBGtpbmQSGQoIYmFzZV91cmwYAiABKAlSB2Jhc2VVcmw=');

@$core.Deprecated('Use hostLoginStartResponseDescriptor instead')
const HostLoginStartResponse$json = {
  '1': 'HostLoginStartResponse',
  '2': [
    {'1': 'device_code', '3': 1, '4': 1, '5': 9, '10': 'deviceCode'},
    {'1': 'user_code', '3': 2, '4': 1, '5': 9, '10': 'userCode'},
    {'1': 'verification_url', '3': 3, '4': 1, '5': 9, '10': 'verificationUrl'},
    {'1': 'interval', '3': 4, '4': 1, '5': 5, '10': 'interval'},
    {'1': 'expires_in', '3': 5, '4': 1, '5': 5, '10': 'expiresIn'},
  ],
};

/// Descriptor for `HostLoginStartResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hostLoginStartResponseDescriptor = $convert.base64Decode(
    'ChZIb3N0TG9naW5TdGFydFJlc3BvbnNlEh8KC2RldmljZV9jb2RlGAEgASgJUgpkZXZpY2VDb2'
    'RlEhsKCXVzZXJfY29kZRgCIAEoCVIIdXNlckNvZGUSKQoQdmVyaWZpY2F0aW9uX3VybBgDIAEo'
    'CVIPdmVyaWZpY2F0aW9uVXJsEhoKCGludGVydmFsGAQgASgFUghpbnRlcnZhbBIdCgpleHBpcm'
    'VzX2luGAUgASgFUglleHBpcmVzSW4=');

@$core.Deprecated('Use hostLoginPollRequestDescriptor instead')
const HostLoginPollRequest$json = {
  '1': 'HostLoginPollRequest',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.githeft.v1.HostKind',
      '10': 'kind'
    },
    {'1': 'base_url', '3': 2, '4': 1, '5': 9, '10': 'baseUrl'},
    {'1': 'device_code', '3': 3, '4': 1, '5': 9, '10': 'deviceCode'},
  ],
};

/// Descriptor for `HostLoginPollRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hostLoginPollRequestDescriptor = $convert.base64Decode(
    'ChRIb3N0TG9naW5Qb2xsUmVxdWVzdBIoCgRraW5kGAEgASgOMhQuZ2l0aGVmdC52MS5Ib3N0S2'
    'luZFIEa2luZBIZCghiYXNlX3VybBgCIAEoCVIHYmFzZVVybBIfCgtkZXZpY2VfY29kZRgDIAEo'
    'CVIKZGV2aWNlQ29kZQ==');

@$core.Deprecated('Use hostLoginPollResponseDescriptor instead')
const HostLoginPollResponse$json = {
  '1': 'HostLoginPollResponse',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {'1': 'pending', '3': 2, '4': 1, '5': 8, '10': 'pending'},
    {'1': 'interval', '3': 3, '4': 1, '5': 5, '10': 'interval'},
  ],
};

/// Descriptor for `HostLoginPollResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hostLoginPollResponseDescriptor = $convert.base64Decode(
    'ChVIb3N0TG9naW5Qb2xsUmVzcG9uc2USFAoFdG9rZW4YASABKAlSBXRva2VuEhgKB3BlbmRpbm'
    'cYAiABKAhSB3BlbmRpbmcSGgoIaW50ZXJ2YWwYAyABKAVSCGludGVydmFs');

@$core.Deprecated('Use hostListReposRequestDescriptor instead')
const HostListReposRequest$json = {
  '1': 'HostListReposRequest',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.githeft.v1.HostAccount',
      '10': 'account'
    },
  ],
};

/// Descriptor for `HostListReposRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hostListReposRequestDescriptor = $convert.base64Decode(
    'ChRIb3N0TGlzdFJlcG9zUmVxdWVzdBIxCgdhY2NvdW50GAEgASgLMhcuZ2l0aGVmdC52MS5Ib3'
    'N0QWNjb3VudFIHYWNjb3VudA==');

@$core.Deprecated('Use hostListReposResponseDescriptor instead')
const HostListReposResponse$json = {
  '1': 'HostListReposResponse',
  '2': [
    {
      '1': 'repos',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.githeft.v1.HostRepo',
      '10': 'repos'
    },
    {'1': 'user', '3': 2, '4': 1, '5': 9, '10': 'user'},
  ],
};

/// Descriptor for `HostListReposResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hostListReposResponseDescriptor = $convert.base64Decode(
    'ChVIb3N0TGlzdFJlcG9zUmVzcG9uc2USKgoFcmVwb3MYASADKAsyFC5naXRoZWZ0LnYxLkhvc3'
    'RSZXBvUgVyZXBvcxISCgR1c2VyGAIgASgJUgR1c2Vy');

@$core.Deprecated('Use hostCreateRepoRequestDescriptor instead')
const HostCreateRepoRequest$json = {
  '1': 'HostCreateRepoRequest',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.githeft.v1.HostAccount',
      '10': 'account'
    },
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'private', '3': 3, '4': 1, '5': 8, '10': 'private'},
  ],
};

/// Descriptor for `HostCreateRepoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hostCreateRepoRequestDescriptor = $convert.base64Decode(
    'ChVIb3N0Q3JlYXRlUmVwb1JlcXVlc3QSMQoHYWNjb3VudBgBIAEoCzIXLmdpdGhlZnQudjEuSG'
    '9zdEFjY291bnRSB2FjY291bnQSEgoEbmFtZRgCIAEoCVIEbmFtZRIYCgdwcml2YXRlGAMgASgI'
    'Ugdwcml2YXRl');

@$core.Deprecated('Use hostAddDeployKeyRequestDescriptor instead')
const HostAddDeployKeyRequest$json = {
  '1': 'HostAddDeployKeyRequest',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.githeft.v1.HostAccount',
      '10': 'account'
    },
    {'1': 'full_name', '3': 2, '4': 1, '5': 9, '10': 'fullName'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'public_key', '3': 4, '4': 1, '5': 9, '10': 'publicKey'},
  ],
};

/// Descriptor for `HostAddDeployKeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hostAddDeployKeyRequestDescriptor = $convert.base64Decode(
    'ChdIb3N0QWRkRGVwbG95S2V5UmVxdWVzdBIxCgdhY2NvdW50GAEgASgLMhcuZ2l0aGVmdC52MS'
    '5Ib3N0QWNjb3VudFIHYWNjb3VudBIbCglmdWxsX25hbWUYAiABKAlSCGZ1bGxOYW1lEhQKBXRp'
    'dGxlGAMgASgJUgV0aXRsZRIdCgpwdWJsaWNfa2V5GAQgASgJUglwdWJsaWNLZXk=');

@$core.Deprecated('Use hostAddDeployKeyResponseDescriptor instead')
const HostAddDeployKeyResponse$json = {
  '1': 'HostAddDeployKeyResponse',
};

/// Descriptor for `HostAddDeployKeyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hostAddDeployKeyResponseDescriptor =
    $convert.base64Decode('ChhIb3N0QWRkRGVwbG95S2V5UmVzcG9uc2U=');

@$core.Deprecated('Use tagListDescriptor instead')
const TagList$json = {
  '1': 'TagList',
  '2': [
    {'1': 'tags', '3': 1, '4': 3, '5': 9, '10': 'tags'},
  ],
};

/// Descriptor for `TagList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tagListDescriptor =
    $convert.base64Decode('CgdUYWdMaXN0EhIKBHRhZ3MYASADKAlSBHRhZ3M=');

@$core.Deprecated('Use saveNoteResponseDescriptor instead')
const SaveNoteResponse$json = {
  '1': 'SaveNoteResponse',
  '2': [
    {
      '1': 'note',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.githeft.v1.Note',
      '10': 'note'
    },
    {'1': 'conflict_copy', '3': 2, '4': 1, '5': 9, '10': 'conflictCopy'},
  ],
};

/// Descriptor for `SaveNoteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveNoteResponseDescriptor = $convert.base64Decode(
    'ChBTYXZlTm90ZVJlc3BvbnNlEiQKBG5vdGUYASABKAsyEC5naXRoZWZ0LnYxLk5vdGVSBG5vdG'
    'USIwoNY29uZmxpY3RfY29weRgCIAEoCVIMY29uZmxpY3RDb3B5');

@$core.Deprecated('Use renameNoteRequestDescriptor instead')
const RenameNoteRequest$json = {
  '1': 'RenameNoteRequest',
  '2': [
    {'1': 'notebook_id', '3': 1, '4': 1, '5': 9, '10': 'notebookId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {'1': 'new_path', '3': 3, '4': 1, '5': 9, '10': 'newPath'},
  ],
};

/// Descriptor for `RenameNoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List renameNoteRequestDescriptor = $convert.base64Decode(
    'ChFSZW5hbWVOb3RlUmVxdWVzdBIfCgtub3RlYm9va19pZBgBIAEoCVIKbm90ZWJvb2tJZBISCg'
    'RwYXRoGAIgASgJUgRwYXRoEhkKCG5ld19wYXRoGAMgASgJUgduZXdQYXRo');

@$core.Deprecated('Use deleteNoteRequestDescriptor instead')
const DeleteNoteRequest$json = {
  '1': 'DeleteNoteRequest',
  '2': [
    {'1': 'notebook_id', '3': 1, '4': 1, '5': 9, '10': 'notebookId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `DeleteNoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteNoteRequestDescriptor = $convert.base64Decode(
    'ChFEZWxldGVOb3RlUmVxdWVzdBIfCgtub3RlYm9va19pZBgBIAEoCVIKbm90ZWJvb2tJZBISCg'
    'RwYXRoGAIgASgJUgRwYXRo');

@$core.Deprecated('Use deleteNoteResponseDescriptor instead')
const DeleteNoteResponse$json = {
  '1': 'DeleteNoteResponse',
};

/// Descriptor for `DeleteNoteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteNoteResponseDescriptor =
    $convert.base64Decode('ChJEZWxldGVOb3RlUmVzcG9uc2U=');

@$core.Deprecated('Use createFolderRequestDescriptor instead')
const CreateFolderRequest$json = {
  '1': 'CreateFolderRequest',
  '2': [
    {'1': 'notebook_id', '3': 1, '4': 1, '5': 9, '10': 'notebookId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `CreateFolderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createFolderRequestDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVGb2xkZXJSZXF1ZXN0Eh8KC25vdGVib29rX2lkGAEgASgJUgpub3RlYm9va0lkEh'
    'IKBHBhdGgYAiABKAlSBHBhdGg=');

@$core.Deprecated('Use createFolderResponseDescriptor instead')
const CreateFolderResponse$json = {
  '1': 'CreateFolderResponse',
};

/// Descriptor for `CreateFolderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createFolderResponseDescriptor =
    $convert.base64Decode('ChRDcmVhdGVGb2xkZXJSZXNwb25zZQ==');

@$core.Deprecated('Use listTagsRequestDescriptor instead')
const ListTagsRequest$json = {
  '1': 'ListTagsRequest',
  '2': [
    {'1': 'notebook_id', '3': 1, '4': 1, '5': 9, '10': 'notebookId'},
  ],
};

/// Descriptor for `ListTagsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTagsRequestDescriptor = $convert.base64Decode(
    'Cg9MaXN0VGFnc1JlcXVlc3QSHwoLbm90ZWJvb2tfaWQYASABKAlSCm5vdGVib29rSWQ=');

@$core.Deprecated('Use tagDescriptor instead')
const Tag$json = {
  '1': 'Tag',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'note_count', '3': 2, '4': 1, '5': 5, '10': 'noteCount'},
  ],
};

/// Descriptor for `Tag`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tagDescriptor = $convert.base64Decode(
    'CgNUYWcSEgoEbmFtZRgBIAEoCVIEbmFtZRIdCgpub3RlX2NvdW50GAIgASgFUglub3RlQ291bn'
    'Q=');

@$core.Deprecated('Use listTagsResponseDescriptor instead')
const ListTagsResponse$json = {
  '1': 'ListTagsResponse',
  '2': [
    {
      '1': 'tags',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.githeft.v1.Tag',
      '10': 'tags'
    },
  ],
};

/// Descriptor for `ListTagsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTagsResponseDescriptor = $convert.base64Decode(
    'ChBMaXN0VGFnc1Jlc3BvbnNlEiMKBHRhZ3MYASADKAsyDy5naXRoZWZ0LnYxLlRhZ1IEdGFncw'
    '==');

@$core.Deprecated('Use syncRequestDescriptor instead')
const SyncRequest$json = {
  '1': 'SyncRequest',
  '2': [
    {'1': 'notebook_id', '3': 1, '4': 1, '5': 9, '10': 'notebookId'},
  ],
};

/// Descriptor for `SyncRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncRequestDescriptor = $convert.base64Decode(
    'CgtTeW5jUmVxdWVzdBIfCgtub3RlYm9va19pZBgBIAEoCVIKbm90ZWJvb2tJZA==');

@$core.Deprecated('Use syncAllRequestDescriptor instead')
const SyncAllRequest$json = {
  '1': 'SyncAllRequest',
};

/// Descriptor for `SyncAllRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncAllRequestDescriptor =
    $convert.base64Decode('Cg5TeW5jQWxsUmVxdWVzdA==');

@$core.Deprecated('Use syncAllResponseDescriptor instead')
const SyncAllResponse$json = {
  '1': 'SyncAllResponse',
  '2': [
    {
      '1': 'statuses',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.githeft.v1.SyncAllResponse.StatusesEntry',
      '10': 'statuses'
    },
  ],
  '3': [SyncAllResponse_StatusesEntry$json],
};

@$core.Deprecated('Use syncAllResponseDescriptor instead')
const SyncAllResponse_StatusesEntry$json = {
  '1': 'StatusesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.githeft.v1.SyncStatus',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `SyncAllResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncAllResponseDescriptor = $convert.base64Decode(
    'Cg9TeW5jQWxsUmVzcG9uc2USRQoIc3RhdHVzZXMYASADKAsyKS5naXRoZWZ0LnYxLlN5bmNBbG'
    'xSZXNwb25zZS5TdGF0dXNlc0VudHJ5UghzdGF0dXNlcxpTCg1TdGF0dXNlc0VudHJ5EhAKA2tl'
    'eRgBIAEoCVIDa2V5EiwKBXZhbHVlGAIgASgLMhYuZ2l0aGVmdC52MS5TeW5jU3RhdHVzUgV2YW'
    'x1ZToCOAE=');

@$core.Deprecated('Use getSyncStatusRequestDescriptor instead')
const GetSyncStatusRequest$json = {
  '1': 'GetSyncStatusRequest',
  '2': [
    {'1': 'notebook_id', '3': 1, '4': 1, '5': 9, '10': 'notebookId'},
  ],
};

/// Descriptor for `GetSyncStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSyncStatusRequestDescriptor = $convert.base64Decode(
    'ChRHZXRTeW5jU3RhdHVzUmVxdWVzdBIfCgtub3RlYm9va19pZBgBIAEoCVIKbm90ZWJvb2tJZA'
    '==');

@$core.Deprecated('Use syncStatusDescriptor instead')
const SyncStatus$json = {
  '1': 'SyncStatus',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.githeft.v1.SyncState',
      '10': 'state'
    },
    {'1': 'last_sync', '3': 2, '4': 1, '5': 3, '10': 'lastSync'},
    {'1': 'error', '3': 3, '4': 1, '5': 9, '10': 'error'},
    {'1': 'ahead', '3': 4, '4': 1, '5': 5, '10': 'ahead'},
    {'1': 'pending_changes', '3': 5, '4': 1, '5': 5, '10': 'pendingChanges'},
    {'1': 'changed_paths', '3': 6, '4': 3, '5': 9, '10': 'changedPaths'},
    {'1': 'conflicts', '3': 7, '4': 3, '5': 9, '10': 'conflicts'},
  ],
};

/// Descriptor for `SyncStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncStatusDescriptor = $convert.base64Decode(
    'CgpTeW5jU3RhdHVzEisKBXN0YXRlGAEgASgOMhUuZ2l0aGVmdC52MS5TeW5jU3RhdGVSBXN0YX'
    'RlEhsKCWxhc3Rfc3luYxgCIAEoA1IIbGFzdFN5bmMSFAoFZXJyb3IYAyABKAlSBWVycm9yEhQK'
    'BWFoZWFkGAQgASgFUgVhaGVhZBInCg9wZW5kaW5nX2NoYW5nZXMYBSABKAVSDnBlbmRpbmdDaG'
    'FuZ2VzEiMKDWNoYW5nZWRfcGF0aHMYBiADKAlSDGNoYW5nZWRQYXRocxIcCgljb25mbGljdHMY'
    'ByADKAlSCWNvbmZsaWN0cw==');
