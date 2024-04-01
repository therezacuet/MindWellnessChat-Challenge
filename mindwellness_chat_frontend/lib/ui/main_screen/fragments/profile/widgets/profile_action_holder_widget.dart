import 'package:flutter/material.dart';
import 'package:mind_wellness_chat/config/size_config.dart';
import 'package:mind_wellness_chat/const/images.dart';
import 'package:mind_wellness_chat/const/strings.dart';
import 'package:mind_wellness_chat/ui/main_screen/fragments/profile/widgets/profile_action_holder_single_widget.dart';
import 'package:stacked/stacked.dart';
import '../profile_view_model.dart';

class ProfileActionHolderWidget extends ViewModelWidget<ProfileViewModel> {
  const ProfileActionHolderWidget({super.key});

  @override
  Widget build(BuildContext context, ProfileViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(
        top: 14.0,
        left: 8.horizontal(),
        right: 8.horizontal(),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 12, left: 26, right: 12),
          child: Column(
            children: [
              ProfileActionHolderSingleWidget(
                backgroundColor: const Color(0xff47AA5A),
                imagePath: Images.editProfile,
                title: Strings.editProfileMenuTitle,
                onTap: () {
                  viewModel.openEditProfileBottomSheet();
                },
              ),
              ProfileActionHolderSingleWidget(
                backgroundColor: const Color(0xffDEAC43),
                imagePath: Images.shareApp,
                title: Strings.shareAppMenuTitle,
                onTap: () {},
              ),
              ProfileActionHolderSingleWidget(
                backgroundColor: const Color(0xff0075FF),
                imagePath: Images.termsCondition,
                title: Strings.termsConditionMenuTitle,
                onTap: () {},
              ),
              ProfileActionHolderSingleWidget(
                backgroundColor: const Color(0xff54D0CB),
                imagePath: Images.helpSupport,
                title: Strings.helpSupportMenuTitle,
                onTap: () {},
              ),
              ProfileActionHolderSingleWidget(
                backgroundColor: const Color(0xff5EAA47),
                imagePath: Images.aboutUs,
                title: Strings.aboutUsMenuTitle,
                onTap: () {},
              ),
              ProfileActionHolderSingleWidget(
                backgroundColor: const Color(0xffE32929),
                imagePath: Images.logout,
                title: Strings.logoutMenuTitle,
                onTap: () {
                  viewModel.logoutUser();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
