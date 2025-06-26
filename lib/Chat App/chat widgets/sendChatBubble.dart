import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:flutter/material.dart';

class Sendchatbubble extends StatefulWidget {
  const Sendchatbubble({super.key});

  @override
  State<Sendchatbubble> createState() => _SendchatbubbleState();
}

class _SendchatbubbleState extends State<Sendchatbubble> {
  @override
  Widget build(BuildContext context) {
      return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width / 1.4,
        ),
        decoration: BoxDecoration(
          color: CRMColors.darkGrey,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: CustomText(text: 'Hello, how are youcsdasdfcsdcvsdcv gasyudg audgyd guqduwqdqdyuqd'),
      ),
    );
  
  }
}