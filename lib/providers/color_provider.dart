import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kButtonColorKey = 'button_color';
// Couleur par défaut : violet du bouton "Nouveau client"
const int _kDefaultButtonColor = 0xFF5E54A4;

/// Provider pour la couleur des boutons (stockée en shared_preferences)
final buttonColorProvider = AsyncNotifierProvider<ButtonColorNotifier, Color>(() {
  return ButtonColorNotifier();
});

class ButtonColorNotifier extends AsyncNotifier<Color> {
  @override
  Future<Color> build() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(_kButtonColorKey) ?? _kDefaultButtonColor;
    return Color(colorValue);
  }

  Future<void> setColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kButtonColorKey, color.value);
    state = AsyncData(color);
  }
}

/// Liste des couleurs disponibles dans la palette
const List<Map<String, dynamic>> kAvailableColors = [
  {'label': 'Violet (défaut)', 'color': Color(0xFF5E54A4)},
  {'label': 'Bleu royal', 'color': Color(0xFF2563EB)},
  {'label': 'Bleu ciel', 'color': Color(0xFF0EA5E9)},
  {'label': 'Vert', 'color': Color(0xFF16A34A)},
  {'label': 'Turquoise', 'color': Color(0xFF0D9488)},
  {'label': 'Orange', 'color': Color(0xFFEA580C)},
  {'label': 'Rouge', 'color': Color(0xFFDC2626)},
  {'label': 'Rose', 'color': Color(0xFFDB2777)},
  {'label': 'Anthracite', 'color': Color(0xFF334155)},
  {'label': 'Or/Brun', 'color': Color(0xFFB45309)},
];
