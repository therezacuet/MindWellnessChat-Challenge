import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mind_wellness_chat/ui/main_screen/fragments/search/widgets/start_searching_widget.dart';
import 'package:stacked/stacked.dart';

import '../../../../../models/user/user_basic_data_model.dart';
import '../../../../widgets/single_chat_widget.dart';
import '../search_view_model.dart';
import 'no_search_result_found_widget.dart';

class SearchResultDisplayList extends ViewModelWidget<SearchViewModel> {
  static const _pageSize = 14; //declared this in server

  PagingController<int, UserDataBasicModel> _pagingController;

  SearchResultDisplayList(this._pagingController, {Key? key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, SearchViewModel viewModel) {
    if (viewModel.reInitializePagingController) {
      _pagingController.removeListener(() {});
      _pagingController.removePageRequestListener((pageKey) {});
      _pagingController.removeStatusListener((status) {});
      _pagingController.refresh();

      _pagingController = PagingController(firstPageKey: 0);
      _pagingController.addPageRequestListener(
            (pageKey) async {
          List<UserDataBasicModel> searchResultData = await viewModel.loadSearchUserData();
          final isLastPage = searchResultData.length < _pageSize;
          if (isLastPage) {
            _pagingController.appendLastPage(searchResultData);
          } else {
            final nextPageKey = pageKey + searchResultData.length;
            _pagingController.appendPage(searchResultData, nextPageKey);
          }
          viewModel.setPagingController(_pagingController);
        },
      );
    }
    return Flexible(
      child: viewModel.textForSearch == "" || viewModel.textForSearch.length < 2 ? const SingleChildScrollView(child: StartSearchingWidget()) : PagedListView<int, UserDataBasicModel>.separated(
        pagingController: _pagingController,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        key: const PageStorageKey('listview-maintain-state-key'),
        physics: const AlwaysScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 0,
        ),
        builderDelegate: PagedChildBuilderDelegate<UserDataBasicModel>(
          itemBuilder: (context, UserDataBasicModel userBasicModel, index) {
            return SingleChatWidget(
              chatClickCallback: () {
                viewModel.gotoChatScreen(userBasicModel);
              },
              name: userBasicModel.name,
              description: userBasicModel.statusLine,
              compressedProfileImage:
              userBasicModel.compressedProfileImage,
            );
          },
          noItemsFoundIndicatorBuilder: (_) => const SingleChildScrollView(
            child: NoSearchResultFoundWidget(),
          ),
        ),
      ),
    );
  }
}
