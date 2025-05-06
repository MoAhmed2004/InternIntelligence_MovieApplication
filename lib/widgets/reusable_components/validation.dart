class Validation{
  static String? nameValidator(String? value,String message){
    if(value==null || value.isEmpty){
      return message;
    }
    return null;
  }

  static String? emailValidator(String? value){
    String? result = nameValidator(value, "Please Enter Your Email");
    if(result==null){
      if(!validEmail(value!)){
        result = "Please Enter a valid Email";
      }
    }
    return result;
  }
  static validEmail(String email){
    final bool emailValid =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email);
    return emailValid;
  }
}