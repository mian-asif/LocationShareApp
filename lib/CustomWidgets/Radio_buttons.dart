import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyRadioListTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String leading;
  final Widget? title;
  final ValueChanged<T?> onChanged;

  const MyRadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.leading,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return InkWell(
      onTap: () => onChanged(value),
      child: SizedBox(
        height: 60,
        width:MediaQuery.of(context).size.width*0.19,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: _customRadioButton,
            ),
            const SizedBox(width: 0),
            if (title != null) title,
          ],
        ),
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Color(0XFF378C5C) : Color(0XFFACB1BB),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? Color(0XFF378C5C) : Color(0XFFACB1BB)!,
          width: 2,
        ),
      ),
      child: SizedBox(
        height: 48,
          width: 48,
          child: Padding(
            padding:  const EdgeInsets.all(8.0),
            child: Image.asset(leading,height: 10,width: 10,),
          )
      ),
    );
  }
}