import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final connexionSupabaseProvider = StreamProvider<bool>((ref) async* {
  while (true) {
    bool estConnecte = false;
    try {
      // Test simple : résolution DNS + connexion TCP vers Supabase
      final result = await InternetAddress.lookup(
        'tecxhiqeyuwmspxqrjmz.supabase.co'
      ).timeout(const Duration(seconds: 5));
      
      estConnecte = result.isNotEmpty && 
                    result.first.rawAddress.isNotEmpty;
    } on SocketException {
      estConnecte = false;
    } on TimeoutException {
      estConnecte = false;
    } catch (e) {
      estConnecte = false;
    }
    
    yield estConnecte;
    await Future.delayed(const Duration(seconds: 10));
  }
});
