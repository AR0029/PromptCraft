import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);
final selectedCategoryProvider = StateProvider<String>((ref) => 'Writing');
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
