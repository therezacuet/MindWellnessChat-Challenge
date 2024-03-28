import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_search_bar/flutter_search_bar.dart';

import '../../config/color_config.dart';

class SearchAppBarWidget extends StatefulWidget {
  final Function(String val) onChange;
  final Function(String val) onDone;
  final Function() onCleared;
  final Function() onClose;

  const SearchAppBarWidget(
      {super.key,
        required this.onChange,
        required this.onDone,
        required this.onCleared,
        required this.onClose});

  @override
  State createState() {
    return _SearchBarDemoHomeState();
  }
}

class _SearchBarDemoHomeState extends State<SearchAppBarWidget> {
  late SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: ColorConfig.accentColor,
        title: Text("MindWellness Chat", style: TextStyle(color: ColorConfig.primaryColor, fontSize: 16, letterSpacing: 0.8, fontWeight: FontWeight.w600),),
        actions: [searchBar.getSearchAction(context)]);
  }

  _SearchBarDemoHomeState() {
    searchBar = SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onChanged: (String val) {
          widget.onChange(val);
        },
        onSubmitted: (String val) {
          widget.onDone(val);
        },
        onCleared: () {
          widget.onCleared();
        },
        onClosed: () {
          widget.onClose();
        });
  }

  @override
  Widget build(BuildContext context) {
    return searchBar.build(context);
  }
}