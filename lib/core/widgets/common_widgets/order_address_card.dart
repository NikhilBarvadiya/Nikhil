import 'package:flutter/material.dart';import 'package:fw_manager/core/theme/index.dart';class OrderAddressCard extends StatefulWidget {  final String? addressHeder;  final String? addressDate;  final String? personName;  final String? address;  final String? vendor;  final String? vendorName;  final Color? cardColors;  final Color? deleteIconColor;  final IconData? deleteIcon;  final void Function()? onTap;  const OrderAddressCard({    Key? key,    this.addressHeder,    this.addressDate,    this.personName,    this.address,    this.vendor,    this.vendorName,    this.onTap,    this.cardColors,    this.deleteIcon,    this.deleteIconColor,  }) : super(key: key);  @override  State<OrderAddressCard> createState() => _OrderAddressCardState();}class _OrderAddressCardState extends State<OrderAddressCard> {  @override  Widget build(BuildContext context) {    return Card(      elevation: 1,      shape: RoundedRectangleBorder(        borderRadius: const BorderRadius.all(          Radius.circular(8),        ),        side: BorderSide(          color: Colors.blue.shade400,          width: 1,        ),      ),      color: widget.cardColors ?? Colors.white,      child: Padding(        padding: const EdgeInsets.symmetric(horizontal: 15, vertical:5),        child: Column(          mainAxisSize: MainAxisSize.min,          crossAxisAlignment: CrossAxisAlignment.start,          children: [            Row(              mainAxisAlignment: MainAxisAlignment.spaceBetween,              children: [                Text(                  widget.addressHeder ?? '',                  style: AppCss.h1,                ),                GestureDetector(                  onTap: widget.onTap,                  child: AnimatedContainer(                    duration: const Duration(milliseconds: 100),                    alignment: Alignment.center,                    padding: const EdgeInsets.symmetric(horizontal:2, vertical:2),                    decoration: BoxDecoration(                      color: widget.deleteIconColor,                      borderRadius: const BorderRadius.all(                        Radius.circular(8),                      ),                    ),                    child: Icon(                      widget.deleteIcon,                      color: Colors.white,                    ),                  ),                ),              ],            ),            const SizedBox(height: 5),            Text(              widget.personName ?? '',              style: AppCss.h3,            ),            const SizedBox(height: 5),            RichText(              overflow: TextOverflow.clip,              textAlign: TextAlign.end,              textDirection: TextDirection.rtl,              softWrap: true,              maxLines: 1,              textScaleFactor: 1,              text: TextSpan(                text: widget.vendor ?? '',                style: DefaultTextStyle.of(context).style,                children: <TextSpan>[                  TextSpan(                    text: widget.vendorName ?? '',                    style: AppCss.h3.copyWith(color: Colors.black),                  ),                ],              ),            ),          ],        ),      ),    );  }}