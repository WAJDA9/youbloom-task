import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youbloom/blocs/login_bloc/login_bloc.dart';
import 'package:youbloom/const/colors.dart';
import 'package:youbloom/const/text.dart';


class TextFieldWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  const TextFieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        
      },
      builder: (context, state) {
        return TextField(
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            filled: true,
            fillColor: AppColors.fieldsColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            hintText: widget.hintText,
            hintStyle: AppTextStyle.infoText,
          ),
        );
      },
    );
  }
}


