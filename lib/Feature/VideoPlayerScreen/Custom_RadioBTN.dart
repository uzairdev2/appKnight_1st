import 'package:flutter/material.dart';

import '../../Core/Common SizedBoxes/custom_sizedbox.dart';

class RadioBTnRow extends StatelessWidget {
  RadioBTnRow({
    required this.value,
    required this.groupValue,
    required this.onChange,
    required this.text,
    super.key,
  });
  String text;
  var value;
  var groupValue;
  ValueChanged onChange;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: groupValue,
          onChanged: onChange,
        ),
        fixwidth3,
        Text(
          text,
          style: const TextStyle(
            color: Colors.grey,
            fontFamily: "MuseoSans-100",
          ),
        ),
      ],
    );
  }
}
