import 'package:flutter/material.dart';
import 'package:lakbay_pinas/widgets/text_widget.dart';

class EmptyTextWidget extends StatelessWidget {
  String? caption;

  EmptyTextWidget({this.caption = 'No available data'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextWidget(
        text: caption ?? '',
        fontSize: 12,
        fontFamily: 'Regular',
        color: Colors.grey,
      ),
    );
  }
}
