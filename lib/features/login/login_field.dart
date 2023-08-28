import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class LoginField extends StatelessWidget {
  final String hintText;
  final String? errorText;
  final bool isPassword, isPasswordField;
  final Widget? suffixIcon;
  final TextEditingController? txt;
  final String? emptyMessage;
  final ValueChanged<String>? onChanged;

  const LoginField(this.hintText,
      {super.key,
        this.isPassword = false, this.isPasswordField = false,
        this.txt,
        this.emptyMessage,
        this.onChanged,
        this.errorText,
        this.suffixIcon});

  @override
  Widget build(BuildContext context) => TextFormField(
    onChanged: onChanged,
    controller: txt,
    key: Key(hintText),
    obscureText: isPassword,
    initialValue: null,
    validator: (value) =>
    ((value == null || value.isEmpty) && emptyMessage != null)
        ? emptyMessage
        : null,
    style: TextStyle(
        fontSize: Resizable.font(context, 15), color: Colors.grey.shade900),
    decoration: InputDecoration(
      fillColor: const Color(0xffF4F6FD),
      filled: true,
      hintText: hintText,
      hintStyle: TextStyle(
        fontWeight: FontWeight.w400, fontSize: Resizable.font(context, 15), color: const Color(0xFF461220).withOpacity(0.5)
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: Resizable.padding(context, 20),
      ),
      constraints: BoxConstraints(
        maxHeight: Resizable.size(context, 30)
      ),
      prefixIcon: Row(mainAxisSize: MainAxisSize.min,
      children: [
        Container(padding: EdgeInsets.only(left: Resizable.padding(context, 10)), child: Image.asset('assets/images/ic_${isPasswordField?'lock':'person'}.png', width: Resizable.size(context, 12))),
        Container(
          margin: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 5), vertical: Resizable.padding(context, 8)),
          width: Resizable.size(context, 0.5), color: Colors.black,
        )
      ],
    ),
      labelStyle: TextStyle(
          fontSize: Resizable.font(context, 18),
          color: Colors.grey.shade900),
      errorText: errorText,
      errorMaxLines: 2,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(1000),
        borderSide: const BorderSide(color: Colors.black, width: 0.7),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 0.7),
        borderRadius: BorderRadius.circular(1000),
      ),
      suffixIcon: suffixIcon,
    ),
  );
}

class PasswordField extends StatelessWidget {
  final String? errorText;
  final TextEditingController? txt;
  final String? title;
  final PasswordVisibleCubit _passwordVisibleCubit = PasswordVisibleCubit();
  final ValueChanged<bool>? onFocusChange;

  PasswordField({this.errorText, this.txt, super.key, this.title,this.onFocusChange});

  @override
  Widget build(BuildContext context) => BlocBuilder<PasswordVisibleCubit, bool>(
    bloc: _passwordVisibleCubit,
    builder: (BuildContext context, isVisible) =>
        Focus(
          onFocusChange: onFocusChange,
          child: LoginField(
            AppText.txtHintPassword.text,
            errorText: errorText,
            txt : txt,
            isPassword: !isVisible,
            isPasswordField: true,
            suffixIcon: IconButton(
              onPressed: _passwordVisibleCubit.change, splashRadius: Resizable.size(context, 15),
              icon: Icon(!isVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
            ),
          ),
        ),
  );
}
class PasswordVisibleCubit extends Cubit<bool> {
  PasswordVisibleCubit() : super(false);

  change() {
    emit(!state);
  }
}