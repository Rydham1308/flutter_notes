class UserModel {
  String? name;
  String? email;
  String? pass;

  UserModel();

  UserModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        pass = json['pass'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': email,
        'pass': pass,
      };
}

class ToDoModel {
  String? description;
  String? title;
  int? id;
  bool? status;

  ToDoModel();

  ToDoModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        status = json['status'],
        title = json['title'],
        description = json['description'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'status': status,
        'title': title,
        'description': description,
      };
}
