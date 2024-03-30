import 'dart:async';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../base/custom_base_view_model.dart';
import '../../../../models/user/user_basic_data_model.dart';
import '../../../../models/user/user_search_model.dart';
import '../../../../models/user/user_search_result_list.dart';
import '../../../../utils/api_utils/api_result/api_result.dart';
import '../../../../utils/api_utils/network_exceptions/network_exceptions.dart';

class SearchViewModel extends CustomBaseViewModel {
  List<UserDataBasicModel> searchResultList = [];
  String textForSearch = "";
  String? lastLoadedDocumentId;
  bool loadInitialDataComplete = false;
  bool reInitializePagingController = false;
  bool dataLoading = false;
  PagingController<int, UserDataBasicModel>? _pagingController;

  setPagingController(PagingController<int, UserDataBasicModel> inputPagingController){
    _pagingController = inputPagingController;
  }

  getPagingController(){
    if(_pagingController != null){
      return _pagingController;
    }else{
      PagingController<int, UserDataBasicModel> tempPagingController =  PagingController<int, UserDataBasicModel>(firstPageKey: 0);
      return tempPagingController;
    }
  }

  initializeVariables(){
    searchResultList = [];
     textForSearch = "";
     lastLoadedDocumentId;
     loadInitialDataComplete = false;
     reInitializePagingController = false;
     dataLoading = false;
  }

  textChange(String inputText){
    if(textForSearch != inputText) {
      lastLoadedDocumentId = null;
      textForSearch = inputText;
      dataLoading = true;
      reInitializePagingController = true;
      notifyListeners();
    }
  }

  Future<List<UserDataBasicModel>> loadSearchUserData() async {

    print("textForSearch : - " + textForSearch);
    List<UserDataBasicModel> returnList = [];
    if(textForSearch.isEmpty){
      returnList = [];
    }else{
      UserSearchModel _userSearchModel = UserSearchModel(
          searchFor: textForSearch, startAfterId: lastLoadedDocumentId);
      ApiResult<UserSearchResultList> _searchResult =
      await getDataManager().searchUsers(_userSearchModel);

      await _searchResult.when<FutureOr>(
        success: (UserSearchResultList userSearchResultList) {
          if (searchResultList != userSearchResultList.data) {
            searchResultList.addAll(userSearchResultList.data);
            if(userSearchResultList.data.isNotEmpty){
              lastLoadedDocumentId = searchResultList.last.id;
            }
            returnList = userSearchResultList.data;
          }else{
            returnList = [];
          }
        },
        failure: (NetworkExceptions e) {
          returnList = [];
        },
      );

    }
    // setBusy(false);
    dataLoading = false;
    reInitializePagingController = false;
    notifyListeners();
    return returnList;
  }

  Future<List<UserDataBasicModel>> loadMoreData() async {
    print("LOADING MORE DATA :- " + lastLoadedDocumentId.toString());

    UserSearchModel userSearchModel = UserSearchModel(
        searchFor: textForSearch, startAfterId: lastLoadedDocumentId);
    ApiResult<UserSearchResultList> searchResult =
        await getDataManager().searchUsers(userSearchModel);
    List<UserDataBasicModel> returnResult = [];

    returnResult = await searchResult.when<FutureOr>(
      success: (UserSearchResultList userSearchResultList) {
        if (searchResultList != userSearchResultList.data) {
          searchResultList.addAll(userSearchResultList.data);
          lastLoadedDocumentId = searchResultList.last.id;
          return userSearchResultList.data;
          // notifyListeners();
        }
      },
      failure: (NetworkExceptions e) {
        return [];
      },
    );

    return returnResult;
  }
}
