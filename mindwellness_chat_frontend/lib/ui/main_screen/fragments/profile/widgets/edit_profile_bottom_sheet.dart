import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mind_wellness_chat/const/images.dart';
import 'package:mind_wellness_chat/const/strings.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../../app/routes/style_config.dart';
import '../../../../widgets/custom_button.dart';

class EditProfileBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const EditProfileBottomSheet({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: request.data['name']);
    TextEditingController statusController = TextEditingController(text: request.data['status']);
    var formKey = request.data['form_key'];

    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: (){
                    completer(SheetResponse(data: null));
                  },
                  child: SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(Images.close)),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              Strings.editProfileMenuTitle,
              style: h1Title.copyWith(
                  fontSize: 26, color: Colors.black87, letterSpacing: 0.8),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              Strings.editProfileHint,
              style: h5Title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 8),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            validator: (text) {
                              if (text == null || text.length < 2) {
                                return Strings.nameValidationMessage;
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                filled: true,
                                prefixIcon: Icon(Icons.person_outline),
                                fillColor: Color(0xffF2F2F2),
                                focusColor:  Color(0xffDEAC43),
                                hintText: Strings.nameInputHint,
                                contentPadding: EdgeInsets.only(
                                    left: 26.0, bottom: 20.0, top: 20.0),
                                border: InputBorder.none),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: statusController,
                            validator: (text) {
                              if (text == null || text.length < 2) {
                                return Strings.statusInvalidMessage;
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                filled: true,
                                prefixIcon: Icon(Icons.remember_me),
                                fillColor: Color(0xffF2F2F2),
                                hintText: Strings.statusInputHint,
                                contentPadding: EdgeInsets.only(
                                    left: 26.0, bottom: 20.0, top: 20.0),
                                border: InputBorder.none),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
              child: CustomButton(
                Strings.save,
                buttonPressed: () {
                  if(formKey.currentState!.validate()){
                    String name = nameController.value.text;
                    String status = statusController.value.text;

                    Map<String, String> dialogResult = {};
                    dialogResult.putIfAbsent("name", () => name);
                    dialogResult.putIfAbsent("status", () => status);

                    completer(SheetResponse(data: dialogResult));
                  }
                },
              ),
            ),
            const SizedBox(
              height: 18,
            ),
          ],
        ),
      ),
    );
  }
}
