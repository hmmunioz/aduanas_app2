class PasswordModel{
  String _newPassword;
   String _repeatNewPassword;

   String get getNewPassword {
    return _newPassword;
  }

 void set setNewPassword(String newPasswords) {
    _newPassword = newPasswords;
  }

  
   String get getRepeatNewPassword {
    return _repeatNewPassword;
  }

  void set setRepeatNewPassword(String repeatNewPasswords) {
    _repeatNewPassword = repeatNewPasswords;
  }
  
 PasswordModel(this._newPassword, this._repeatNewPassword);
}