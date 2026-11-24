import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grpc/service_api.dart' show CallOptions;
import 'package:grpc/grpc_or_grpcweb.dart' show GrpcError;
import 'package:shared_preferences/shared_preferences.dart';

import 'gen/githeft/v1/githeft.pbgrpc.dart';
import 'platform/platform.dart';

/// Turns errors from the core into something to show the user.
String errorText(Object e) {
  if (e is GrpcError) return e.message?.isNotEmpty == true ? e.message! : e.codeName;
  return e.toString();
}

/// App-wide state: the notebooks, the open one and its sync status. Screens
/// listen to it and reload their notes when [notesVersion] changes.
class AppState extends ChangeNotifier with WidgetsBindingObserver {
  AppState(this.api, this._prefs) {
    WidgetsBinding.instance.addObserver(this);
    themeMode = ThemeMode.values.firstWhere(
      (m) => m.name == _prefs.getString('themeMode'),
      orElse: () => ThemeMode.system,
    );
    backgroundSync = _prefs.getInt('backgroundSync') ?? 0;
  }

  final GitheftClient api;
  final SharedPreferences _prefs;

  List<Notebook> notebooks = [];
  Notebook? current;
  SyncStatus? status;
  bool syncing = false;
  late ThemeMode themeMode;

  /// Minutes between syncs while the app is closed; 0 is off.
  late int backgroundSync;

  /// Bumped whenever notes may have changed on disk.
  int notesVersion = 0;

  /// Something a sync wants the user to know, shown once by the notes list.
  String? notice;

  Timer? _syncSoon;
  Timer? _periodic;

  static const _longCall = Duration(minutes: 10);
  CallOptions get long => CallOptions(timeout: _longCall);

  Future<void> load() async {
    final res = await api.listNotebooks(ListNotebooksRequest());
    notebooks = res.notebooks;
    final last = _prefs.getString('notebook');
    current = notebooks.where((n) => n.id == last).firstOrNull ?? notebooks.firstOrNull;
    notifyListeners();
    if (current != null) {
      await _afterSwitch();
    }
    _periodic = Timer.periodic(const Duration(minutes: 10), (_) => _autoSync());
  }

  Future<void> reloadNotebooks() async {
    final res = await api.listNotebooks(ListNotebooksRequest());
    notebooks = res.notebooks;
    current = notebooks.where((n) => n.id == current?.id).firstOrNull ?? notebooks.firstOrNull;
    notifyListeners();
  }

  Future<void> select(Notebook nb) async {
    current = nb;
    status = null;
    await _prefs.setString('notebook', nb.id);
    notesVersion++;
    notifyListeners();
    await _afterSwitch();
  }

  Future<void> _afterSwitch() async {
    await refreshStatus();
    _autoSync();
  }

  Future<void> added(Notebook nb) async {
    await reloadNotebooks();
    await select(notebooks.firstWhere((n) => n.id == nb.id, orElse: () => nb));
  }

  void updated(Notebook nb) {
    notebooks = [for (final n in notebooks) n.id == nb.id ? nb : n];
    if (current?.id == nb.id) current = nb;
    notifyListeners();
  }

  Future<void> removed() async {
    await reloadNotebooks();
    if (current != null) {
      await select(current!);
    } else {
      status = null;
      notesVersion++;
      notifyListeners();
    }
  }

  Future<void> refreshStatus() async {
    final nb = current;
    if (nb == null) return;
    try {
      final st = await api.getSyncStatus(GetSyncStatusRequest(notebookId: nb.id));
      if (current?.id == nb.id) {
        status = st;
        notifyListeners();
      }
    } catch (_) {}
  }

  /// Something changed locally: sync a moment later, so several quick
  /// changes go out together.
  void changed() {
    notesVersion++;
    notifyListeners();
    if (current?.autoSync != true || !current!.hasRemote()) {
      unawaited(refreshStatus());
      return;
    }
    _syncSoon?.cancel();
    _syncSoon = Timer(const Duration(seconds: 3), () => sync());
  }

  void _autoSync() {
    if (current?.autoSync == true && current!.hasRemote()) unawaited(sync());
  }

  /// Syncs the open notebook. The result lands in [status]; errors are not
  /// thrown, the status says what went wrong.
  Future<SyncStatus?> sync() async {
    final nb = current;
    if (nb == null || syncing) return status;
    _syncSoon?.cancel();
    syncing = true;
    notifyListeners();
    try {
      final st = await api.sync(SyncRequest(notebookId: nb.id), options: long);
      if (current?.id == nb.id) {
        status = st;
        if (st.changedPaths.isNotEmpty) notesVersion++;
        if (st.conflicts.isNotEmpty) {
          notice =
              '${st.conflicts.length} note(s) were changed here and elsewhere in the same place. '
              'Your version stays; the other one is next to it, marked as a conflict copy.';
        }
      }
      return st;
    } catch (e) {
      if (current?.id == nb.id) {
        status = SyncStatus(state: SyncState.SYNC_STATE_ERROR, error: errorText(e));
      }
      return status;
    } finally {
      syncing = false;
      notifyListeners();
    }
  }

  Future<void> setBackgroundSync(int minutes) async {
    await Device.scheduleBackgroundSync(minutes);
    backgroundSync = minutes;
    await _prefs.setInt('backgroundSync', minutes);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    await _prefs.setString('themeMode', mode.name);
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      notesVersion++;
      notifyListeners();
      _autoSync();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _syncSoon?.cancel();
    _periodic?.cancel();
    super.dispose();
  }
}

/// Makes [AppState] available to the widget tree.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child}) : super(notifier: state);

  static AppState of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;

  /// Without listening, for callbacks.
  static AppState read(BuildContext context) => context.getInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
