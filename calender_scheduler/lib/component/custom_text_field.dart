import 'package:calender_scheduler/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final bool isTime;
  final FormFieldSetter<String> onSaved;

  const CustomTextField({
    required this.initialValue,
    required this.onSaved,
    required this.isTime,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.w600),
        ),
        if (isTime) renderTextField(),
        if (!isTime) Expanded(child: renderTextField()),
      ],
    );
  }

  Widget renderTextField() {
    return TextFormField(
      onSaved: onSaved,
      validator: (String? val) {
        //null이 return되면 에러가 없다
        //에러가 있으면 에러를 String 값으로 리턴

        // return '테스트';
        if (val == null || val.isEmpty) {
          return "값을 입력해주세요";
        }

        if (isTime) {
          int time = int.parse(val!);

          if (time < 0) {
            return '0 이상의 숫자를 입력해주세요';
          }
          if (time > 24) {
            return '24 이하의 숫자를 입력해주세요';
          }
        } else {
          if (val.length > 500) return '500자 이하의 글자를 입력해주세요';
        }
        return null;
      },
      expands: !isTime,
      maxLength: 500,
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      maxLines: isTime ? 1 : null,
      inputFormatters: isTime ? [FilteringTextInputFormatter.digitsOnly] : [],
      initialValue: initialValue,
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
        suffixText: isTime ? '시' : null,
      ),
      cursorColor: Colors.grey,
    );
  }
}
