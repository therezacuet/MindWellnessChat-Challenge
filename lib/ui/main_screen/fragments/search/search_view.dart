import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mind_wellness_chat/config/size_config.dart';
import 'package:mind_wellness_chat/ui/main_screen/fragments/search/search_view_model.dart';
import 'package:mind_wellness_chat/ui/main_screen/fragments/search/widgets/search_result_display_list.dart';
import 'package:stacked/stacked.dart';

import '../../../../app/locator.dart';
import '../../../../config/color_config.dart';
import '../../../../const/strings.dart';
import '../../../../models/user/user_basic_data_model.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    late PagingController<int, UserDataBasicModel> pagingController;
    return Scaffold(
      body: ViewModelBuilder<SearchViewModel>.nonReactive(
        disposeViewModel: false,
        onViewModelReady: (SearchViewModel viewModel) {
          pagingController = viewModel.getPagingController();
        },
        builder: (context, model, child) {
          TextEditingController searchController = TextEditingController(text: model.textForSearch);
          searchController.addListener(() {
              String inputText = searchController.text;
              model.textChange(inputText);
            },
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100.horizontal(),
                color: ColorConfig.accentColor,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, top: 48, right: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        Strings.searchHeaderTitle,
                        style: TextStyle(
                            fontSize: 24,
                            letterSpacing: 0.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      const Text(
                        Strings.searchHeaderSubtitleTitle,
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 0.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: ColorConfig.greyColor6,
                          prefixIcon: const Icon(Icons.search),
                          hintText: Strings.searchHint,
                          contentPadding: const EdgeInsets.only(
                              left: 26.0, bottom: 16.0, top: 18.0
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Flexible(child: SearchResultDisplayList(pagingController))
            ],
          );
        },
        viewModelBuilder: () => locator<SearchViewModel>(),
      ),
    );
  }
}