library my_prj.globals;
import 'package:google_sign_in/google_sign_in.dart';

class CurrentUser {
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  String uid;
  String photoUrl;
  String displayName;
  String email;
  bool anonymous;
  
  String getUid(){return uid;}
  String getPhoto(){return photoUrl;}
  String getName(){return displayName;}
  String getEmail(){return email;}

  setCurrentUser(String iuid,String iname,String iphoto, String iemail){
    uid = iuid;
    photoUrl = iphoto;
    displayName = iname;
    email = iemail;
    anonymous = false;
  }
  
  setAnonymous(String iuid){
    uid = iuid;
    anonymous = true;
  }

  bool getAnonymous(){return anonymous;}

  clear(){
    uid = "";
    photoUrl = "";
    displayName = "";
    email = "";
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
