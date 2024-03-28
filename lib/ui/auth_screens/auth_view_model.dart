import 'package:firebase_auth/firebase_auth.dart';

import '../../app/locator.dart';
import '../../app/routes/setup_routes.router.dart';
import '../../base/custom_base_view_model.dart';
import '../../base/custom_index_tracking_view_model.dart';

class AuthViewModel extends CustomIndexTrackingViewModel {
  String phoneNumber = "";
  String userName = "";
  String errorText = "";
  bool isSignUpScreen = true;
  String enteredOtp = "";
  int otpTimeoutSeconds = 60;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var formKey;

  String selectedDialCode = "+880";
  String selectedIsoCode = "BD";

  String previousNumber = "";

  String verificationId = "";
  int resendToken = -1;
  bool isResendCode = false;
  final CustomBaseViewModel _customBaseViewModel = locator<CustomBaseViewModel>();

  setPhoneNumber(String inputPhoneNumber) {
    phoneNumber = inputPhoneNumber;
  }

  setUserName(String inputName) {
    userName = inputName;
  }

  setErrorText(String inputError) {
    errorText = inputError;
    notifyListeners();
  }

  toggleSignUpScreen() {
    isSignUpScreen = !isSignUpScreen;
    notifyListeners();
  }

  setCountryAndDialCode(String inputIsoCode, String inputDialCode) {
    selectedDialCode = inputDialCode;
    selectedIsoCode = inputIsoCode;
  }

  setOtp(String inputOtp) {
    enteredOtp = inputOtp;
  }

  setKeyForForm(var inputKey) {
    formKey = inputKey;
  }

  resendOtp() async {
    _customBaseViewModel.showProgressBar();

    if (resendToken == -1) {
      await _customBaseViewModel.showErrorDialog(
          description: "Please Try again");
      return;
    }

    isResendCode = true;
    await _auth.verifyPhoneNumber(
      phoneNumber: previousNumber,
      timeout: Duration(seconds: otpTimeoutSeconds),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      forceResendingToken: resendToken,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  sendOtp() async {
    errorText = "";
    notifyListeners();

    if (phoneNumber == previousNumber) {
      _customBaseViewModel.showProgressBar();
      errorText = "";
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: Duration(seconds: otpTimeoutSeconds),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
          forceResendingToken: resendToken);
    } else {
      _customBaseViewModel.showProgressBar();

      previousNumber = phoneNumber.trim();
      errorText = "";

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: otpTimeoutSeconds),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    }
    return true;
  }

  void codeAutoRetrievalTimeout(String verificationId) {}

  void codeSent(String inputVerificationId, [int? code]) {
    if (code != null) {
      resendToken = code;
    }

    if (isResendCode) {
      otpTimeoutSeconds = 60;
      notifyListeners();
    }
    verificationId = inputVerificationId;
    _customBaseViewModel.stopProgressBar();
    setIndex(1);
  }

  verificationFailed(FirebaseAuthException error) async {
    if (error.code == "invalid-phone-number") {
      await _customBaseViewModel.showErrorDialog(
          description: "Please enter valid phone number");
    } else if (error.code == "too-many-requests") {
      await _customBaseViewModel.showErrorDialog(
          description: "You can't request otp more than three times per day");
    } else {
      await _customBaseViewModel.showErrorDialog(
          description: error.code.toString());
    }
  }

  submitOtp() async {
    _customBaseViewModel.showProgressBar();
    String smsCode = enteredOtp.trim();

    String isSuccess =
    await _customBaseViewModel.getAuthService().signInWithOTP(smsCode,verificationId);

    if (isSuccess == "noError") {
      phoneNumberVerified();
    } else {
      _customBaseViewModel.stopProgressBar();
      if (isSuccess.contains(
          "The sms verification code used to create the phone auth credential is invalid")) {
        _customBaseViewModel.showErrorDialog(
            title: "Invalid OTP",
            description: "Please Use Valid OTP to continue",
            isDismissible: false);
      } else {
        await _customBaseViewModel.showErrorDialog(description: isSuccess);
      }
    }
  }

  verificationCompleted(AuthCredential phoneAuthCredential) async {

    if (currentIndex == 1) {
      _customBaseViewModel.showProgressBar();
      await Future.delayed(
        const Duration(seconds: 1),
            () async {
          String isSuccess = await _customBaseViewModel
              .getAuthService()
              .signIn(phoneAuthCredential);
          if (isSuccess == "noError") {
            phoneNumberVerified();
          } else {
            _customBaseViewModel.stopProgressBar();
            _customBaseViewModel.showErrorDialog(
                description: isSuccess, isDismissible: false);
          }
        },
      );
    }
  }

  phoneNumberVerified() async {
    signInWithFirebaseAndGoToMainScreen('');
  }

  signInWithFirebaseAndGoToMainScreen(String id) async {
    print("sign in/ sign up success");
  }
}
