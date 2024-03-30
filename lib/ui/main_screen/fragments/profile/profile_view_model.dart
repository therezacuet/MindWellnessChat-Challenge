import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mind_wellness_chat/const/strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart';

import '../../../../app/routes/setup_routes.router.dart';
import '../../../../base/custom_base_view_model.dart';
import '../../../../const/app_const.dart';
import '../../../../const/enums/bottom_sheet_enums.dart';
import '../../../../const/enums/dialogs_enum.dart';
import '../../../../models/user/user_basic_data_offline_model.dart';
import '../../../../models/user/user_image_model.dart';
import '../../../../models/user/user_name_status_update_model.dart';
import '../../../../utils/api_utils/api_result/api_result.dart';
import '../../../../utils/api_utils/network_exceptions/network_exceptions.dart';

class ProfileViewModel extends CustomBaseViewModel {
  var formKeyForEditProfile = GlobalKey<FormState>();
  String userId = "";
  String userName = "";
  String userStatus = "";
  String? profileImage;

  getUserData() async {
    UserBasicDataOfflineModel? userBasicDataOfflineModel = await getDataManager().getUserBasicDataOfflineModel();
    if (userBasicDataOfflineModel != null) {
      userId = userBasicDataOfflineModel.id;
      userName = userBasicDataOfflineModel.name;
      userStatus = userBasicDataOfflineModel.statusLine;
      profileImage = userBasicDataOfflineModel.profileImage;
      notifyListeners();
    }
  }

  logoutUser() async {
    DialogResponse? dialogResponse = await getDialogService().showCustomDialog(
        title: Strings.logoutDialogTitle,
        description:Strings.logoutDialogMsg,
        variant: DialogEnum.confirmation);

    if (dialogResponse != null) {
      if (dialogResponse.confirmed) {
        showProgressBar();
        await getSocketService().disconnectFromSocket();
        await getAuthService().logOut();
        await getAppDatabase().deleteAllTables();
        bool result = await getDataManager().clearSharedPreference();
        if(result){
          stopProgressBar();
          getNavigationService().clearStackAndShow(Routes.authView);
        }
      }
    }
  }

  checkPermissionAndPickImage() async {
    final hasPermission = await requestPhotoPermission();
    if(hasPermission){
      changeProfilePicture();
    }
    else{
      showErrorDialog(description: Strings.permissionDeniedMessage);
    }
  }

  changeProfilePicture() async {
    File imageFile;
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      showProgressBar();
      imageFile = File(pickedFile.path);

      CroppedFile? croppedImage = await ImageCropper().cropImage(
          sourcePath: imageFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 5),
          cropStyle: CropStyle.circle);

      if (croppedImage != null) {
        final dir = await getTemporaryDirectory();
        final targetPath = "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}${basename(croppedImage.path)}";

        File? compressedImage = await compressFile(File(croppedImage.path), targetPath);

        if (compressedImage != null) {
          List<File> imagesFile = [File(croppedImage.path), compressedImage];
          List<String> listOfUrl = await uploadFiles(imagesFile);
          if (listOfUrl.isNotEmpty) {
            UserImageModel userImageModel = UserImageModel(
                id: userId,
                profileImage: listOfUrl[0],
                compressedProfileImage: listOfUrl[1]
            );
            ApiResult<bool> uploadImageResult = await getDataManager().updateImageOfUser(userImageModel);
            await uploadImageResult.when<FutureOr>(
                success: (bool result) async {
                  UserBasicDataOfflineModel? userBasicDataOfflineModel = await getDataManager().getUserBasicDataOfflineModel();
                  if (userBasicDataOfflineModel != null) {
                    userBasicDataOfflineModel.profileImage = userImageModel.profileImage;
                    userBasicDataOfflineModel.compressedProfileImage = userImageModel.compressedProfileImage;
                    await getDataManager().saveUserBasicDataOfflineModel(userBasicDataOfflineModel);
                    profileImage = userImageModel.profileImage;
                    notifyListeners();
                  }
                }, failure: (NetworkExceptions e) {
              showErrorDialog(
                  description: NetworkExceptions.getErrorMessage(e));
            });

            stopProgressBar();
          }
        } else {
          stopProgressBar();
          showErrorDialog(
              description: Strings.compressingErrorMessage);
        }
      } else {
        stopProgressBar();
        showErrorDialog(
            description: Strings.croppingErrorMessage);
      }
    }
  }

  Future<List<String>> uploadFiles(List<File> images) async {
    if (kDebugMode) {
      print("image uploading :- ${images.length}");
    }

    List<String> downloadedUrlList = [];

    FirebaseStorage storage = FirebaseStorage.instance;

    Reference profilePictureRef = storage.ref().child(
        AppConst.profilePictureStoragePath +
            DateTime.now().millisecondsSinceEpoch.toString() +
            basename(images[0].path));

    Reference compressedProfilePictureRef = storage.ref().child(
        AppConst.compressedProfilePictureStoragePath +
            DateTime.now().millisecondsSinceEpoch.toString() +
            basename(images[1].path));

    UploadTask uploadTask;

    try {
      for (int i = 0; i < 2; i++) {
        if (i == 0) {
          uploadTask = profilePictureRef.putFile(images[0]);
          await uploadTask.whenComplete(() async {
            String downloadUrl = await profilePictureRef.getDownloadURL();
            downloadedUrlList.add(downloadUrl);
          });
        } else {
          uploadTask = compressedProfilePictureRef.putFile(images[1]);
          await uploadTask.whenComplete(() async {
            String downloadUrl =
            await compressedProfilePictureRef.getDownloadURL();
            downloadedUrlList.add(downloadUrl);
          });
        }
      }
      return downloadedUrlList;
    } catch (e) {
      stopProgressBar();
      showErrorDialog(description: Strings.uploadingErrorMessage);
      return [];
    }
  }

  Future<File?> compressFile(File file, String targetPath) async {
    final filePath = file.absolute.path;

    XFile? result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      targetPath,
      quality: 50,
    );

    return File(result!.path);
  }

  openEditProfileBottomSheet() async {
    UserBasicDataOfflineModel? userBasicDataOfflineModel = await getSharedPreferenceService().getUserBasicDataOfflineModel();

    Map<String, dynamic> dialogData = {};

    if (userBasicDataOfflineModel != null) {
      dialogData.putIfAbsent("name", () => userBasicDataOfflineModel.name);
      dialogData.putIfAbsent("status", () => userBasicDataOfflineModel.statusLine);
    } else {
      dialogData.putIfAbsent("name", () => "");
      dialogData.putIfAbsent("status", () => "");
    }

    dialogData.putIfAbsent("form_key", () => formKeyForEditProfile);

    SheetResponse? sheetResponse = await getBottomSheetService()
        .showCustomSheet(
            data: dialogData,
            variant: BottomSheetEnum.editProfile,
            barrierDismissible: true);

    if (sheetResponse != null && sheetResponse.data != null) {
      print("_sheetResponse :- " + sheetResponse.data.toString());

      String name = sheetResponse.data['name'];
      String status = sheetResponse.data['status'];

      UserNameStatusUpdateModel userNameStatusUpdateModel = UserNameStatusUpdateModel(id: userId, statusLine: status, name: name);

      showProgressBar();
      ApiResult<bool> nameStatusUpdateResult = await getDataManager().updateNameStatusUser(userNameStatusUpdateModel);

      nameStatusUpdateResult.when(success: (bool result) async {
        stopProgressBar();

        UserBasicDataOfflineModel? userBasicDataOfflineModel0 = await getDataManager().getUserBasicDataOfflineModel();
        if (userBasicDataOfflineModel0 != null) {
          userBasicDataOfflineModel0.name = name;
          userBasicDataOfflineModel0.statusLine = status;

          await getDataManager().saveUserBasicDataOfflineModel(userBasicDataOfflineModel0);
          getDialogService().showCustomDialog(variant: DialogEnum.success);

          userName = userNameStatusUpdateModel.name;
          userStatus = userNameStatusUpdateModel.statusLine;
          notifyListeners();
        } else {
          showErrorDialog();
        }
      }, failure: (NetworkExceptions e) {
        stopProgressBar();
        showErrorDialog(description: NetworkExceptions.getErrorMessage(e));
      });
    }
  }
}
