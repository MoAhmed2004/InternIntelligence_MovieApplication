import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DialogUtils{
  static void ShowLoading(BuildContext context){
  showDialog(context: context, builder: (context) =>AlertDialog(
  content: SizedBox(
  height: MediaQuery.of(context).size.height*0.1,
  child: const Center(
  child: CircularProgressIndicator(),
  ),
  ),
  ) ,);
}

static void ShowMessage(
    BuildContext context,
    {required String message,
      String? OKButton,
      void Function()? onOKPressed,
      String? NoButton,
      void Function()? onNoPressed,
    }){
  showDialog(context: context, builder:(context) => AlertDialog(
    content: Text(message),
    actions: [
      if(OKButton!=null)
      TextButton(
          onPressed:onOKPressed,
          child: Text(OKButton)),
      if(NoButton!=null)
        TextButton(
            onPressed:onNoPressed,
            child: Text(NoButton))
    ],
  ),);
}
static void showToast(String message){
    Fluttertoast.showToast(
        msg:message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
}
}