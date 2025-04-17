
import 'package:supabase_flutter/supabase_flutter.dart';

class Authentication {
  String? email;
  String? password;
  String? name;
  Future<int> signUpUser(String email, String password, String name) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.auth.signUp(
      data: { 
        'name': name
      },
      email: email,
      password: password
    );
    if(response.user != null){
      print("sign up sucessfull: ${response}");
      return 200;
    }else{
      print("Signup failed");
      return 500;
    }
  }
  Future<int> loginUser(String email, String password) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password
    );
    if(response.user != null){
      print("Login sucessfull: ${response}");
      return 200;
    }else{
      print("Login failed");
      return 500;
    }
  }
  Future<int> logOutUser() async {
    await Supabase.instance.client.auth.signOut();
    print("User Signed Out");
    return 200;
  }
}
