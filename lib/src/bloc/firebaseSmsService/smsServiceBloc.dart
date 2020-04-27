import 'package:aduanas_app/src/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:aduanas_app/src/bloc/recovercode/recoverCodeBloc.dart';
import 'package:aduanas_app/src/bloc/recoveremail/recoveEmailBloc.dart';
import 'package:aduanas_app/src/bloc/utils/utilsBloc.dart';
import 'package:aduanas_app/src/validators/validators.dart';
import 'package:aduanas_app/src/models/password_model.dart';
import 'package:aduanas_app/src/services/dialog_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SmsServiceBloc with Validators{
 RecoverEmailBloc blocEmailRecover;
   RecoverCodeBloc blocCodeRecover;
    UtilsBloc blocSpinnerRecover ;
      SmsServiceBloc({this.blocEmailRecover, this.blocCodeRecover, this.blocSpinnerRecover});
    ///FirebaseMessagin Service
     String phoneNumber="";
     String smsCode;
     String verificationId;
/*      BuildContext context; */
     TextEditingController phoneController = TextEditingController(text: "");
     TextEditingController smsCodeController = TextEditingController(text: "");
    
    void openDialog(BuildContext context, String contentError) async {
                     final action =
                       await Dialogs.yesAbortDialog(context, "Error", contentError, true, false);
                        if (action == DialogAction.yes) 
                        {
                          print("yesss");
                        } else 
                        {    
                            print("noffff");  
                        }
                      }

    Future<void> submit(BuildContext context) async {
    blocSpinnerRecover.changeSpinnerState(true);
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) { 
          verificationId = verId;
       };    
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) { verificationId = verId;};
    

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential authCredential) {      
        blocSpinnerRecover.changeSpinnerState(false);
       Navigator.of(context).pushNamed("/recoverpasscode");
    };

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
         blocSpinnerRecover.changeSpinnerState(false);
         var errorText = exception.code + ": " + exception.message;
          openDialog(context, errorText);      
    };
    var phoneNumber =blocEmailRecover.getDataEmailRecover();
    print("phoneNumber ----------------------- $phoneNumber");
    await FirebaseAuth.instance.verifyPhoneNumber(   
        phoneNumber: "+593${phoneNumber.substring(1)}",
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout:  Duration(seconds: ConstantsApp.of(context).appConfig.timeout),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed);        
  }

    signIn(BuildContext context) {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: blocCodeRecover.getDataCodeRecover(),
    );
    FirebaseAuth.instance.signInWithCredential(credential).then((user) {  
     blocSpinnerRecover.changeSpinnerState(false);
      Navigator.pushNamed(context, "/changePassword");   
    }).catchError((e) {
      blocSpinnerRecover.changeSpinnerState(false);
      openDialog(context, e.toString());
    });
  }
}