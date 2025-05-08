import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rhythmbox/auth/login.dart';
import 'package:get/get.dart';
import 'package:rhythmbox/screens/splashscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: 'https://xjetxuzbqbeuukhultbk.supabase.co', anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhqZXR4dXpicWJldXVraHVsdGJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDEwODI0NDYsImV4cCI6MjA1NjY1ODQ0Nn0.xYjINqFAqZSbRfZTWXIFRG5K9Tg0xVuKbCCElbQZ_-M');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Widget _initialScreen;
  bool isShown = false;
   @override
   void initState() {
    super.initState();
    final currentUser = Supabase.instance.client.auth.currentUser;
      print("Current user : ");
      print(currentUser);
    _initialScreen = currentUser == null ? const Login() : const SplashScreen();
  }


  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(

      title: 'RhythmBox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.ralewayTextTheme()
      ),
      home: _initialScreen,
    );
  }
}