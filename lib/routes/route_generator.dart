// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:page_transition/page_transition.dart';

// Project imports:
import 'package:safenotes/authwall.dart';
import 'package:safenotes/main.dart';
import 'package:safenotes/models/safenote.dart';
import 'package:safenotes/models/session.dart';
import 'package:safenotes/views/add_edit_note.dart';
import 'package:safenotes/views/authentication/login.dart';
import 'package:safenotes/views/authentication/set_passphrase.dart';
import 'package:safenotes/views/change_passphrase.dart';
import 'package:safenotes/views/home.dart';
import 'package:safenotes/views/note_view.dart';
import 'package:safenotes/views/settings/backup_setting.dart';
import 'package:safenotes/views/settings/inactivity_setting.dart';
import 'package:safenotes/views/settings/notes_color_setting.dart';
import 'package:safenotes/views/settings/secure_display_setting.dart';
import 'package:safenotes/views/settings/settings.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    var args = settings.arguments;
    final String? routeName = settings.name;
    final transitionDuration = 300;
    final transitionType = PageTransitionType.leftToRight;

    switch (routeName) {
      case '/':
        return PageTransition(
          child: SafeNotesApp(),
          duration: Duration(milliseconds: transitionDuration),
          type: transitionType,
        );

      case '/login':
        if (args is SessionArguments) {
          return PageTransition(
            child: EncryptionPhraseLoginPage(
              sessionStream: args.sessionStream,
              isKeyboardFocused: args.isKeyboardFocused,
            ),
            duration: Duration(milliseconds: transitionDuration),
            type: transitionType,
          );
        }
        return _errorRoute(
            route: routeName, argsType: 'StreamController<SessionState>');

      case '/signup':
        if (args is SessionArguments) {
          return PageTransition(
            child: SetEncryptionPhrasePage(
              sessionStream: args.sessionStream,
              isKeyboardFocused: args.isKeyboardFocused,
            ),
            duration: Duration(milliseconds: transitionDuration),
            type: transitionType,
          );
        }
        return _errorRoute(
            route: routeName, argsType: 'StreamController<SessionState>');

      case '/authwall':
        if (args is SessionArguments) {
          return PageTransition(
            child: AuthWall(
              sessionStateStream: args.sessionStream,
              isKeyboardFocused: args.isKeyboardFocused,
            ),
            duration: Duration(milliseconds: transitionDuration),
            type: transitionType,
          );
        }
        return _errorRoute(
            route: routeName, argsType: 'StreamController<SessionState>');

      case '/home':
        if (args is StreamController<SessionState>) {
          return PageTransition(
            child: HomePage(sessionStateStream: args),
            duration: Duration(milliseconds: transitionDuration),
            type: transitionType,
          );
        }
        return _errorRoute(
            route: routeName, argsType: 'StreamController<SessionState>');

      case '/viewnote':
        if (args is SafeNote) {
          SafeNote note = args;
          return PageTransition(
            child: NoteDetailPage(noteId: note.id!),
            duration: Duration(milliseconds: transitionDuration),
            type: transitionType,
          );
        }
        return _errorRoute(route: routeName, argsType: 'SafeNotes');

      case '/addnote':
        return PageTransition(
          child: AddEditNotePage(),
          duration: Duration(milliseconds: transitionDuration),
          type: transitionType,
        );

      case '/editnote':
        if (args is SafeNote) {
          SafeNote note = args;
          return PageTransition(
            child: AddEditNotePage(note: note),
            duration: Duration(milliseconds: transitionDuration),
            type: transitionType,
          );
        }
        return _errorRoute(route: routeName, argsType: 'SafeNotes');

      case '/backup':
        return PageTransition(
          child: BackupSetting(),
          duration: Duration(milliseconds: transitionDuration),
          type: transitionType,
        );

      case '/changepassphrase':
        return PageTransition(
          child: ChangePassphrase(),
          duration: Duration(milliseconds: transitionDuration),
          type: transitionType,
        );

      case '/settings':
        if (args is StreamController<SessionState>) {
          return PageTransition(
            child: SettingsScreen(sessionStateStream: args),
            duration: Duration(milliseconds: transitionDuration),
            type: transitionType,
          );
        }
        return _errorRoute(
            route: routeName, argsType: 'StreamController<SessionState>');

      case '/chooseColorSettings':
        return PageTransition(
          child: ColorPallet(),
          duration: Duration(milliseconds: transitionDuration),
          type: transitionType,
        );

      case '/inactivityTimerSettings':
        return PageTransition(
          child: InactivityTimerSetting(),
          duration: Duration(milliseconds: transitionDuration),
          type: transitionType,
        );

      case '/secureDisplaySetting':
        return PageTransition(
          child: SecureDisplaySetting(),
          duration: Duration(milliseconds: transitionDuration),
          type: transitionType,
        );
      default:
        return _errorRoute(route: routeName);
    }
  }

  static Route<dynamic> _errorRoute(
      {required String? route, String? argsType}) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text('Route Error'.tr())),
        body: Center(
          child: argsType == null
              ? Text('noSuchRoute'.tr(namedArgs: {'route': route.toString()}))
              : Text(
                  'argsMismatchForRoute'.tr(namedArgs: {
                    'argsType': argsType,
                    'route': route.toString()
                  }),
                ),
        ),
      );
    });
  }
}
