import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mind_wellness_chat/const/strings.dart';

import '../../app/locator.dart';
import '../../app/routes/setup_routes.router.dart';
import '../../base/custom_base_view_model.dart';
import '../../base/custom_index_tracking_view_model.dart';
import '../../models/backup_found_model.dart';
import '../../models/user/user_basic_data_offline_model.dart';
import '../../models/user/user_create_model.dart';
import '../../models/user/user_firebase_token_model.dart';
import '../../utils/api_utils/api_result/api_result.dart';
import '../../utils/api_utils/network_exceptions/network_exceptions.dart';

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
          description: Strings.otpSentErrorMessage);
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
          description: Strings.invalidPhoneErrorMessage);
    } else if (error.code == "too-many-requests") {
      await _customBaseViewModel.showErrorDialog(
          description: Strings.tooManyRequestErrorMessage);
    } else {
      await _customBaseViewModel.showErrorDialog(
          description: error.code.toString());
    }
  }

  submitOtp() async {
    _customBaseViewModel.showProgressBar();
    String smsCode = enteredOtp.trim();
    String isSuccess = await _customBaseViewModel.getAuthService().signInWithOTP(smsCode,verificationId);
    if (isSuccess == "noError") {
      phoneNumberVerified();
    } else {
      _customBaseViewModel.stopProgressBar();
      if (isSuccess.contains(Strings.invalidOTPCodeErrorMessage)) {
        _customBaseViewModel.showErrorDialog(
            title: Strings.invalidOTPErrorTitle,
            description: Strings.invalidOTPErrorMessage,
            isDismissible: false);
      } else {
        await _customBaseViewModel.showErrorDialog(description: isSuccess);
      }
    }
  }

  verificationCompleted(AuthCredential phoneAuthCredential) async {
    if (currentIndex == 1) {
      _customBaseViewModel.showProgressBar();
      await Future.delayed(const Duration(seconds: 1), () async {
          String isSuccess = await _customBaseViewModel.getAuthService().signIn(phoneAuthCredential);
          if (isSuccess == "noError") {
            phoneNumberVerified();
          } else {
            _customBaseViewModel.stopProgressBar();
            _customBaseViewModel.showErrorDialog(description: isSuccess, isDismissible: false);
          }
        },
      );
    }
  }

  phoneNumberVerified() async {
    String tokenId = await _customBaseViewModel.getFirebasePushNotificationService().getFcmToken();
    String? id = await _customBaseViewModel.getAuthService().getUserid();
    if (id == null) {
      _customBaseViewModel.stopProgressBar();
      await _customBaseViewModel.showErrorDialog(description: Strings.tryAgainMessage);
      return;
    }

    if (isSignUpScreen) {
      UserCreateModel userCreateModel = UserCreateModel(
          name: userName,
          id: id,
          firebaseTokenId: tokenId,
          phoneNumber: phoneNumber,
          statusLine: Strings.defaultStatusOfUser);

      ApiResult<bool> result = await _customBaseViewModel.getDataManager().createUser(userCreateModel);

      result.when(success: (bool result) async {
        await signInWithFirebaseAndGoToMainScreen(id);
      }, failure: (NetworkExceptions e) async {
        _customBaseViewModel.stopProgressBar();
        if (kDebugMode) {
          print(NetworkExceptions.getDioException(e));
        }
        if(NetworkExceptions.getDioException(e) ==  const NetworkExceptions.conflict()){
          await _customBaseViewModel.showErrorDialog(description: Strings.userExistMessage);
        }else{
          await _customBaseViewModel.showErrorDialog(description: NetworkExceptions.getErrorMessage(e));
        }
      });
    } else {
      UserFirebaseTokenUpdateModel userFirebaseTokenUpdateModel = UserFirebaseTokenUpdateModel(id: id, firebaseTokenId: tokenId);

      ApiResult<bool> result = await _customBaseViewModel.getDataManager().updateFirebaseToken(userFirebaseTokenUpdateModel);
      result.when(success: (bool result) async {
        await signInWithFirebaseAndGoToMainScreen(id);
      }, failure: (NetworkExceptions e) async {
        _customBaseViewModel.stopProgressBar();
        if (kDebugMode) {
          print(NetworkExceptions.getDioException(e));
        }
        if (e == const NetworkExceptions.notFound()) {
          await _customBaseViewModel.showErrorDialog(title: Strings.accountInvalidErrorTitle, description: Strings.accountInvalidErrorMessage);
        } else {
          await _customBaseViewModel.showErrorDialog(description: NetworkExceptions.getErrorMessage(e));
        }
      });
    }
  }

  signInWithFirebaseAndGoToMainScreen(String id) async {
    if (isSignUpScreen) {
      UserBasicDataOfflineModel userBasicDataOfflineModel = UserBasicDataOfflineModel(
          name: userName,
          statusLine: Strings.defaultStatusOfUser,
          profileImage: null,
          compressedProfileImage: null,
          id: id
      );
      bool resultOfSavingData = await _customBaseViewModel.getDataManager().saveUserBasicDataOfflineModel(userBasicDataOfflineModel);
      _customBaseViewModel.stopProgressBar();
      if (resultOfSavingData) {
        //check for backup
        String? userId = await _customBaseViewModel.getAuthService().getUserid();
        ApiResult<BackUpFoundModel> userBackUpDetails = await _customBaseViewModel.getDataManager().getUserBackupDetail(userId!);
        userBackUpDetails.when(success: (BackUpFoundModel model){
          if(model.isBackUpFound){
            _customBaseViewModel.stopProgressBar();
            _customBaseViewModel.getNavigationService().clearStackAndShow(Routes.backUpFoundScreen);
          }else{
            _customBaseViewModel.stopProgressBar();
            _customBaseViewModel.getNavigationService().clearStackAndShow(Routes.mainScreenView);
          }
        }, failure: (NetworkExceptions e){
          _customBaseViewModel.stopProgressBar();
          _customBaseViewModel.showErrorDialog(description: Strings.backupErrorMessage);
        });
      } else {
        _customBaseViewModel.showErrorDialog(description: Strings.savingErrorMessage);
      }
    } else {
      ApiResult<UserBasicDataOfflineModel> userBasicDataOfflineModel0 =
      await _customBaseViewModel.getDataManager().getUserData(id);

      userBasicDataOfflineModel0.when(
        success: (UserBasicDataOfflineModel model) async {
          bool resultOfSavingData = await _customBaseViewModel.getDataManager().saveUserBasicDataOfflineModel(model);
          if (resultOfSavingData) {
            //check for backup
            String? userId = await _customBaseViewModel.getAuthService().getUserid();
            ApiResult<BackUpFoundModel> userBackUpDetails = await _customBaseViewModel.getDataManager().getUserBackupDetail(userId!);
            userBackUpDetails.when(success: (BackUpFoundModel model){
              if(model.isBackUpFound){
                _customBaseViewModel.stopProgressBar();
                _customBaseViewModel.getNavigationService().clearStackAndShow(Routes.backUpFoundScreen);
              }else{
                _customBaseViewModel.stopProgressBar();
                _customBaseViewModel.getNavigationService().clearStackAndShow(Routes.mainScreenView);
              }
            }, failure: (NetworkExceptions e){
              _customBaseViewModel.stopProgressBar();
              _customBaseViewModel.showErrorDialog(description: Strings.backupErrorMessage);
            });
          } else {
            _customBaseViewModel.showErrorDialog(description: Strings.savingErrorMessage);
          }
        },
        failure: (NetworkExceptions e) {
          _customBaseViewModel.stopProgressBar();
          _customBaseViewModel.showErrorDialog(description: NetworkExceptions.getErrorMessage(e));
        },
      );
    }
  }
}
