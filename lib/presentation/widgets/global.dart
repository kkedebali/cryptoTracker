import 'package:cryptotrack/core/theme/themeConstants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget cardBackgroundContainer() {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: ThemeConstants.horPads,
      vertical: ThemeConstants.vertPads,
    ),
    decoration: BoxDecoration(
      color: ThemeConstants.containerBack.withAlpha(50),
      borderRadius: BorderRadius.all(
        Radius.circular(ThemeConstants.containerBorder),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                secText('Toplam Bakiye'),
                SizedBox(width: 10),
                changesContainer(),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        mainText('₺22.433'),
      ],
    ),
  );
}

Widget changesContainer() {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: ThemeConstants.horPads - 5,
      vertical: ThemeConstants.vertPads - 8,
    ),
    decoration: BoxDecoration(
      color: Colors.greenAccent,
      borderRadius: BorderRadius.all(
        Radius.circular(ThemeConstants.containerBorder),
      ),
    ),
    child: buttonText(null, '+5%'),
  );
}

Widget mainText(String txt) {
  return Text(
    txt,
    textAlign: TextAlign.start,
    style: TextStyle(
      fontSize: ThemeConstants.fontSizeMain,
      color: ThemeConstants.textMain,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget highLightSecText(String txt) {
  return Text(
    txt,
    textAlign: TextAlign.start,
    style: TextStyle(
      fontSize: ThemeConstants.fontSizeSec,
      color: ThemeConstants.textMain,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget secText(String txt) {
  return Text(
    txt,
    textAlign: TextAlign.start,
    style: TextStyle(
      fontSize: ThemeConstants.fontSizeSec,
      color: ThemeConstants.textSec,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget changeText(String txt, double price) {
  return Text(
    txt,
    textAlign: TextAlign.start,
    style: TextStyle(
      fontSize: ThemeConstants.fontSizeSec,
      color: price >= 0 ? Colors.greenAccent : Colors.redAccent ,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget buttonText(Color? clr, String txt) {
  return Text(
    txt,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: ThemeConstants.fontSizeSec,
      color: clr ?? Colors.black,
      fontWeight: FontWeight.w400,
    ),
  );
}

Widget buttonUI(Color color, String txt, Color? txtColor) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(ThemeConstants.containerBorder),
    ),
    child: buttonText(txtColor, txt),
  );
}

Widget cryptosUI(
  String? image,
  String? txt,
  String? code,
  double? price,
  double? change,
) {
  txt = txt ?? 'Bitcoin';
  code = code ?? 'BTC';
  change = change ?? 5.35;
  price = price ?? 100000;

  final formatter = NumberFormat('#,##0.00', 'en_US');
  final cleanPrice = formatter.format(price);
  final cleanChange = formatter.format(change);

  return Container(
    height: 80,
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    margin: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: ThemeConstants.containerBack.withAlpha(30),
      borderRadius: BorderRadius.circular(ThemeConstants.containerBorder),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(image.toString())),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [highLightSecText(txt), secText(code)],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [highLightSecText(cleanPrice), changeText('$cleanChange%',change)],
        ),
      ],
    ),
  );
}

Widget loadingSkeleton(){
  return Container(
    height: 80,
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    margin: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: ThemeConstants.containerBack.withAlpha(150),
      borderRadius: BorderRadius.circular(ThemeConstants.containerBorder),
    ),
  );
}