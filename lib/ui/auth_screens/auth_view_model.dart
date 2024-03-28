import '../../app/locator.dart';
import '../../base/custom_base_view_model.dart';
import '../../base/custom_index_tracking_view_model.dart';

class AuthViewModel extends CustomIndexTrackingViewModel {
  String phoneNumber = "";
  String userName = "";
  String errorText = "";
  bool isSignUpScreen = true;
  String enteredOtp = "";
  int otpTimeoutSeconds = 60;
  var formKey;

  String selectedDialCode = "+91";
  String selectedIsoCode = "IN";

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
}
