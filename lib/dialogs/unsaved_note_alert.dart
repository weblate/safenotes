// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

// Project imports:
import 'package:safenotes/models/editor_state.dart';
import 'package:safenotes/utils/styles.dart';

class UnsavedAlert extends StatefulWidget {
  @override
  _UnsavedAlertState createState() => _UnsavedAlertState();
}

class _UnsavedAlertState extends State<UnsavedAlert> {
  @override
  Widget build(BuildContext context) {
    final double paddingAllAround = 10.0;
    final double dialogRadius = 10.0;

    return BackdropFilter(
      filter: ImageFilter.blur(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dialogRadius),
        ),
        child: Padding(
          padding: EdgeInsets.all(paddingAllAround),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _title(context, paddingAllAround),
              _body(context, paddingAllAround),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context, double padding) {
    final String title = 'Are you sure?'.tr();
    final double topSpacing = 10.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding:
            EdgeInsets.only(top: topSpacing, left: padding), //, right: 100),
        child: Text(
          title,
          style: dialogHeadTextStyle,
        ),
      ),
    );
  }

  Widget _body(BuildContext context, double padding) {
    final String cautionMessage = 'Do you want to discard changes.'.tr();
    final double topSpacing = 15.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding:
            EdgeInsets.only(top: topSpacing, left: padding, bottom: padding),
        child: Text(
          cautionMessage,
          //textAlign: TextAlign.center,
          style: dialogBodyTextStyle,
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final double paddingAroundLR = 15.0;
    final double paddingAroundTB = 10.0;
    final double buttonSeparation = 25.0;
    final double buttonTextFontSize = 15.0;
    final String yesButtonText = 'Yes'.tr();
    final String noButtonText = 'No'.tr();

    return Container(
      padding: EdgeInsets.fromLTRB(
          paddingAroundLR, paddingAroundTB, paddingAroundLR, paddingAroundTB),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(NordColors.aurora.red),
            ),
            child: _buttonText(yesButtonText, buttonTextFontSize),
            onPressed: () {
              // User was warned about unsaved change, and user choose to
              // discard the changes hence the NoteEditorState().handleUngracefulExit() won't save the notes
              NoteEditorState.setSaveAttempted(true);
              Navigator.of(context).pop(true);
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: buttonSeparation),
            child: ElevatedButton(
              child: _buttonText(noButtonText, buttonTextFontSize),
              onPressed: () => Navigator.of(context).pop(false),
              // return false to dialog caller
            ),
          )
        ],
      ),
    );
  }

  Widget _buttonText(String text, double fontSize) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }
}
