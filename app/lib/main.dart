import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/backend.dart';
import 'gen/githeft/v1/githeft.pbgrpc.dart';
import 'platform/platform.dart';
import 'screens/editor_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/setup_screen.dart';
import 'state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GitheftApp());
}

const _seed = Color(0xFF2E6B5E);

class GitheftApp extends StatefulWidget {
  const GitheftApp({super.key});

  @override
  State<GitheftApp> createState() => _GitheftAppState();
}

class _GitheftAppState extends State<GitheftApp> {
  AppState? _state;
  Object? _error;
  final _navigator = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      final api = await connectBackend();
      final state = AppState(api, await SharedPreferences.getInstance());
      await state.load();
      setState(() => _state = state);
      Device.onShared(_openShare);
      final share = await Device.takeShare();
      if (share != null) WidgetsBinding.instance.addPostFrameCallback((_) => _openShare(share));
    } catch (e) {
      setState(() => _error = e);
    }
  }

  /// Text, links and images shared from another app become a new note in
  /// the open notebook.
  void _openShare(SharedContent share) {
    final state = _state;
    final nav = _navigator.currentState;
    if (share.isEmpty || state == null || nav == null) return;
    final nb = state.current;
    if (nb == null) {
      ScaffoldMessenger.maybeOf(
        nav.context,
      )?.showSnackBar(const SnackBar(content: Text('Set up a notebook first, then share again.')));
      return;
    }
    final text = [
      if (share.subject.trim().isNotEmpty) '# ${share.subject.trim()}\n',
      if (share.text.trim().isNotEmpty) '${share.text.trim()}\n',
    ].join('\n');
    nav
        .push<bool>(
          MaterialPageRoute(
            builder: (_) => EditorScreen(
              notebook: nb,
              folder: nb.defaultFolder,
              type: NoteType.NOTE_TYPE_MARKDOWN,
              initialText: text,
              initialFiles: share.files,
            ),
          ),
        )
        .then((changed) {
          if (changed == true) state.changed();
        });
  }

  @override
  Widget build(BuildContext context) {
    final state = _state;
    Widget home;
    if (state != null) {
      home = const _Home();
    } else if (_error != null) {
      home = Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Githeft could not start:\n\n${errorText(_error!)}'),
          ),
        ),
      );
    } else {
      home = const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final app = ListenableBuilder(
      listenable: state ?? ValueNotifier(0),
      builder: (context, _) => MaterialApp(
        title: 'Githeft',
        navigatorKey: _navigator,
        debugShowCheckedModeBanner: false,
        themeMode: state?.themeMode ?? ThemeMode.system,
        theme: ThemeData(colorSchemeSeed: _seed, useMaterial3: true),
        darkTheme: ThemeData(colorSchemeSeed: _seed, brightness: Brightness.dark, useMaterial3: true),
        home: home,
      ),
    );
    return state == null ? app : AppScope(state: state, child: app);
  }
}

/// The notes of the open notebook, or the setup when there is none yet.
class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    if (state.current == null) return const SetupScreen(first: true);
    return const NotesScreen();
  }
}
