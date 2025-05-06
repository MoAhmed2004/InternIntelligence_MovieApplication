import 'package:flutter/material.dart';
typedef validation = String? Function(String?);
class Customformfield extends StatefulWidget {
  final String label;
  final TextInputType keyboard;
  final TextEditingController controller;
  final bool isPassword;
  final validation validator;
  final int? maxlines;

  const Customformfield({required this.label,
    required this.keyboard,
    required this.controller,
    this.isPassword = false,
    required this.validator,
    this.maxlines = 1,
  });

  @override
  State<Customformfield> createState() => _CustomformfieldState();
}

class _CustomformfieldState extends State<Customformfield> {
bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator:widget.validator ,
      obscureText: widget.isPassword
          ?isVisible
          :false,
      maxLines: widget.maxlines,
      obscuringCharacter: '*',
      keyboardType: widget.keyboard,
      controller:widget.controller,
      style: Theme.of(context).textTheme.titleSmall,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword? IconButton(
            onPressed: (){

              setState(() {
                isVisible = !isVisible;
              });

            },
            icon: Icon(
              isVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color:Theme.of(context).colorScheme.primary ,
            )
        )
            :null,
        labelText:widget.label,
        labelStyle: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
