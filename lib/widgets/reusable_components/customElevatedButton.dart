import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final void Function() onPress;
  String title;
   CustomElevatedButton({required this.onPress,required this.title});


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,

      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17,horizontal:20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,style:TextStyle(color: Colors.black),),
            Icon(Icons.arrow_forward_ios_outlined,color: Colors.black,),
          ],
        ),
      ),
    );
  }
}
