library my_prj.globals;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser {
  
  String _displayName;
  String _email;
  DateTime _finalLogin;
  String _photoUrl;
  String _uid;
  String _level;
  String _classof;
  String _phoneNumber;
  DocumentSnapshot db;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  String getDisplayName(){return _displayName;}
  String getEmail(){return _email;}
  DateTime getFinalLogin(){return _finalLogin;}
  String getphotoUrl(){return _photoUrl;}
  String getUid(){return _uid;}
  String getLevel(){return _level;}
  String getClass(){
    if(_classof != null || _classof == "") return _classof;
    else return "학번을 등록해 주세요";
  }
  String getPhoneNumber(){
    if(_phoneNumber != null || _phoneNumber == "") return _phoneNumber;
    else return "전화번호를 등록해 주세요";  
  }

  void setCurrentUser(
    displayName,
    email,
    finalLogin,
    photoUrl,
    uid
  )async{
    this._displayName = displayName;
    this._email = email;
    this._finalLogin = finalLogin;
    this._photoUrl = photoUrl;
    this._uid = uid;
    db = await Firestore.instance.collection('club').document('슬기짜기').collection('users').document(_uid).get();
    if(db.exists){
      setlevel();
      _init();
    }
    else {
      _level = "guest";
    }
  }

  void clear(){
    _displayName = null;
    _email = null;
    _finalLogin = null;
    _photoUrl = null;
    _uid = null;
    _classof = null;
    _phoneNumber = null;
    db = null;
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

  void setlevel() {
    _level = db.data['level'];
  }
  void setlevelDirect(String input) {
    _level = input;
  }
  void _init(){
    var classof = db.data['classof'];
    var phoneNumber = db.data['phoneNumber'];
    if(classof != null) _classof = classof;
    else _classof = "";
    if(phoneNumber != null)_phoneNumber = phoneNumber;
    else _phoneNumber = "";
  }
  void setClass(String input){
    _classof = input;
  }
  void setPhoneNumber(String input){
    _phoneNumber = input;
  }
}

CurrentUser currentUser = CurrentUser();
