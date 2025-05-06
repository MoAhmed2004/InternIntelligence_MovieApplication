class User{
  static const String collectionName="User";
  String? id;
  String? name;
  String? email;
  int? age;
  User({this.id,this.name,this.email,this.age});

  User.fromFireStore(Map<String,dynamic>? data){
    id= data?["id"];
    name= data?["name"];
    email= data?["email"];
    age= data?["age"];
  }
  Map<String,dynamic>tofireStore(){
    return{
      "id":id,
      "name":name,
      "email":email,
      "age":age
    };
  }
}