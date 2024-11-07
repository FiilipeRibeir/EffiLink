import 'package:flutter/material.dart';
import 'package:saas_crm/index.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://khkkdipmkgfwzeksbwkx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtoa2tkaXBta2dmd3pla3Nid2t4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg0Mjc4NDQsImV4cCI6MjA0NDAwMzg0NH0.Uyrpf8z3Bi-w3BD5CZXz9EhcA--T3Hfa1oON5ye90i0',
  );

  runApp(const AppPage());
}
