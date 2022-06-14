import 'package:flutter/material.dart';import 'package:fw_manager/core/theme/app_css.dart';class CommonMergeCard extends StatefulWidget {  final String? person;  final String? personData;  final String? shortNo;  final String? address;  final String? items;  const CommonMergeCard({    Key? key,    this.person,    this.personData,    this.shortNo,    this.address,    this.items,  }) : super(key: key);  @override  State<CommonMergeCard> createState() => _CommonMergeCardState();}class _CommonMergeCardState extends State<CommonMergeCard> {  @override  Widget build(BuildContext context) {    return Card(      elevation: 1,      shape: RoundedRectangleBorder(        borderRadius: const BorderRadius.all(          Radius.circular(8),        ),        side: BorderSide(          color: Colors.blue.shade400,          width: 1,        ),      ),      child: Padding(        padding: const EdgeInsets.symmetric(horizontal: 15, vertical:10),        child: Column(          mainAxisSize: MainAxisSize.min,          crossAxisAlignment: CrossAxisAlignment.start,          children: [            Row(              mainAxisAlignment: MainAxisAlignment.spaceBetween,              crossAxisAlignment: CrossAxisAlignment.start,              children: [                Expanded(                  child: Column(                    crossAxisAlignment: CrossAxisAlignment.start,                    children: [                      RichText(                        overflow: TextOverflow.clip,                        textAlign: TextAlign.end,                        textDirection: TextDirection.rtl,                        softWrap: true,                        maxLines: 1,                        textScaleFactor: 1,                        text: TextSpan(                          text: widget.person ?? '',                          style: AppCss.h3.copyWith(color: Colors.black),                          children: <TextSpan>[                            TextSpan(                              text: "(" + widget.personData.toString() + ")",                              style: DefaultTextStyle.of(context).style,                            ),                          ],                        ),                      ),                      const SizedBox(height: 5),                      Text(                        widget.address ?? "",                        style: AppCss.caption,                        textAlign: TextAlign.start,                      ),                    ],                  ),                ),                Column(                  crossAxisAlignment: CrossAxisAlignment.end,                  children: [                    RichText(                      overflow: TextOverflow.clip,                      textAlign: TextAlign.end,                      textDirection: TextDirection.rtl,                      softWrap: true,                      maxLines: 1,                      textScaleFactor: 1,                      text: TextSpan(                        text: "Short : ",                        style: AppCss.h3.copyWith(color: Colors.black),                        children: <TextSpan>[                          TextSpan(                            text: widget.shortNo ?? "",                            style: AppCss.h3,                          ),                        ],                      ),                    ),                    const SizedBox(height: 5),                    Text(                      widget.items ?? "",                      style: AppCss.h3.copyWith(color: Colors.blue),                    ),                  ],                ),              ],            ),          ],        ),      ),    );  }}