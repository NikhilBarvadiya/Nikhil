import 'package:flutter/material.dart';import 'package:fw_manager/core/theme/index.dart';import 'package:get/get.dart';class SearchableListView extends StatefulWidget {  const SearchableListView({    Key? key,    this.onSelect,    required this.itemList,    this.bindText,    this.bindValue,    this.fetchApi,    required this.isLive,    this.labelText,    this.hintText,    this.isOnSearch,    this.id,  }) : super(key: key);  final List itemList;  final String? bindText;  final String? bindValue;  final Function? onSelect;  final Function? fetchApi;  final bool isLive;  final String? labelText;  final String? hintText;  final String? id;  final bool? isOnSearch;  @override  State<SearchableListView> createState() => _SearchableListViewState();}class _SearchableListViewState extends State<SearchableListView> {  @override  void initState() {    itemList = widget.itemList;    resultList = widget.itemList;    super.initState();  }  List itemList = [];  List resultList = [];  int i=0;  void _runFilter(String enteredKeyword) {    List results = [];    if (enteredKeyword.isEmpty) {      results = itemList;    } else {      results = itemList.where((record) => record[widget.bindText].toLowerCase().contains(enteredKeyword.toLowerCase())).toList();    }    setState(() {      resultList = results;    });  }  @override  Widget build(BuildContext context) {    return widget.isOnSearch!        ? Column(            mainAxisSize: MainAxisSize.min,            children: [              TextFormField(                onChanged: (search) async {                  if (widget.isLive && widget.fetchApi != null) {                    resultList = await widget.fetchApi!(search);                  } else {                    if (widget.bindText != null) {                      _runFilter(search);                    }                  }                  setState(() {});                },                decoration: InputDecoration(                  fillColor: Colors.grey[200],                  labelText: widget.labelText ?? '',                  hintText: widget.hintText ?? '',                  suffixIcon: SizedBox(                    height: 50,                    width: 50,                    child: Row(                      children: [                        VerticalDivider(                          thickness: 1.5,                          indent: 5,                          endIndent: 5,                          color: Theme.of(context).primaryColor.withOpacity(0.5),                        ),                        Icon(                          Icons.search,                          color: Theme.of(context).primaryColor,                        ),                      ],                    ),                  ),                  hintStyle: const TextStyle(fontSize: 15),                  labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),                  filled: true,                  focusedBorder: UnderlineInputBorder(                    borderSide: BorderSide(                      color: Theme.of(context).primaryColor,                      width: 2,                    ),                  ),                ),              ),              Expanded(child: _buildMe()),            ],          )        : _buildMe();  }  Widget _buildMe() {    return ListView(      shrinkWrap: true,      children: [        ...resultList.map(          (e) {            return ListTile(              onTap: () {                if (widget.bindValue != null && widget.bindText != null) {                  widget.onSelect!(e[widget.bindValue], e[widget.bindText]);                } else if (widget.bindValue != null) {                  widget.onSelect!(e[widget.bindValue]);                } else {                  widget.onSelect!(e);                }              },              title: Container(                padding: const EdgeInsets.only(bottom: 5),                decoration: const BoxDecoration(                  border: Border(                    bottom: BorderSide(                      width: 1,                      color: Color(0xFF001F40),                    ),                  ),                ),                child: Row(                  mainAxisAlignment: MainAxisAlignment.start,                  children: [                    Card(                      elevation: 4,                      child: Center(                        child: Text(                          i.toString(),                          style: AppCss.h3,                        ).paddingAll(5),                      ),                    ),                    const SizedBox(width: 10),                    Expanded(                      child: Text(                        widget.bindText != null ? e[widget.bindText] : e,                        style: AppCss.body1,                      ),                    ),                  ],                ),              ),            );          },        ),      ],    );  }}