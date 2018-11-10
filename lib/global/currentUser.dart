library my_prj.globals;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  FirebaseUser user;

  setCurrentUser(FirebaseUser input){
    this.user = input;
  }
  clear(){
    this.user = null;
  }
  googleLogIn(){
    _googleSignIn.signIn();
  }
  googleLogOut(){
    _googleSignIn.signOut();
    clear();
  }
  GoogleSignIn getGoogleLogIn(){
    return _googleSignIn;
  }
}

CurrentUser currentUser = CurrentUser();
