// available color scheme names
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

final shadThemeColors = [
  'blue',
  'gray',
  'green',
  'neutral',
  'orange',
  'red',
  'rose',
  'slate',
  'stone',
  'violet',
  'yellow',
  'zinc',
];

final lightColorScheme = ShadColorScheme.fromName('blue');
final darkColorScheme =
    ShadColorScheme.fromName('green', brightness: Brightness.dark);
