import 'package:flutter/material.dart';
import 'package:rhythmbox/auth/login.dart';
import 'package:rhythmbox/screens/HomePage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: 'https://xjetxuzbqbeuukhultbk.supabase.co', anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhqZXR4dXpicWJldXVraHVsdGJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDEwODI0NDYsImV4cCI6MjA1NjY1ODQ0Nn0.xYjINqFAqZSbRfZTWXIFRG5K9Tg0xVuKbCCElbQZ_-M');
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GetStorage storage = GetStorage();
    String? loginStatus = storage.read('login');
    return GetMaterialApp(
      title: 'RhythmBox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple
      ),
      home: loginStatus == 'authenticated' ? HomePage() : Login(),
    );
  }
}