import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import '../../constants/sp_keys.dart';
import '../../models/user_model.dart';

class AddSheet extends StatefulWidget {
  const AddSheet(
    this.titleValue,
    this.descValue,
    this.editId, {
    super.key,
  });

  final int? editId;
  final String? titleValue;
  final String? descValue;

  @override
  State<AddSheet> createState() => AddSheetState();
}

class AddSheetState extends State<AddSheet> {
  GlobalKey<FormState> formAddKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();
  static const String nameKey = 'nameKey';
  static const String nameListKey = 'nameListKey';
  bool isEditBtn = false;
  bool isAvailable = false;
  ToDoModel toDoModel = ToDoModel();
  Random random = Random();
  int editId = 0;
  int editIdIndex =0;
  @override
  void didChangeDependencies() {
    final getOldName = widget.titleValue;
    final getOldDesc = widget.descValue;
    final getOldId = widget.editId;
    if (getOldName is String) {
      title.text = getOldName;
      desc.text = getOldDesc ?? '';
      editId = getOldId ?? 0;
      isEditBtn = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 23, top: 20),
            alignment: Alignment.centerLeft,
            child: Image.asset('assets/images/wired.gif',
                scale: 4, color: Colors.black),
          ),
          Container(
            margin: const EdgeInsets.only(left: 23, bottom: 15, top: 20),
            alignment: Alignment.centerLeft,
            child: !isEditBtn
                ? const Text(
                    "Add Note",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  )
                : const Text(
                    "Update Note",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
          ),
          Form(
            key: formAddKey,
            child: Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.only(right: 23, left: 23, bottom: 10),
                  child: TextField(
                    controller: title,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(right: 23, left: 23, bottom: 20),
                  child: TextField(
                    maxLines: 6,
                    controller: desc,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'Description',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 23, bottom: 15),
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () async {
                final sp = await SharedPreferences.getInstance();
                if (isEditBtn) {
                  final jsonString = sp.getString(AppKeys.json);
                  final json = jsonDecode(jsonString!);
                  List<dynamic> userDataList =
                      json[sp.getString(AppKeys.currentUserKey)];
                  List<ToDoModel> dataList =
                      userDataList.map((e) => ToDoModel.fromJson((e))).toList();
                  for (int i = 0; i < dataList.length; i++) {
                    if (dataList[i].id == editId) {
                      dataList[i].title = title.text.trim();
                      dataList[i].description = desc.text.trim();
                      print(dataList[i]);
                      break;
                    }
                  }
                  // sp.setString(AppKeys.editData, jsonEncode(dataList[editindex]));
                  // json[sp.getString(AppKeys.currentUserKey)] = dataList;
                  // sp.setString(AppKeys.json, jsonEncode(json));
                  isEditBtn = false;
                } else {
                  toDoModel.title = title.text.trim();
                  toDoModel.description = desc.text.trim();
                  toDoModel.status = false;
                  toDoModel.id = random.nextInt(1000000);
                  await dataAdd();
                }

                Future.delayed(Duration.zero)
                    .then((value) => Navigator.pop(context, true));
              },
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                backgroundColor: Colors.black,
                elevation: 0,
                shape: const StadiumBorder(),
                minimumSize: const Size(150, 40),
              ),
              child: !isEditBtn
                  ? const Text(
                      "Add",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: Colors.blue,
                      ),
                    )
                  : const Text(
                      "Update",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: Colors.blue,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> dataAdd() async {
    final sp = await SharedPreferences.getInstance();
    final current = sp.getString(AppKeys.currentUserKey) ?? '';

    //#region try
    final dataObject = toDoModel.toJson();
    final jsonString = sp.getString(AppKeys.json) ?? '';
    final json = jsonDecode(jsonString);
    if (json.containsKey(current)) {
      List<dynamic> dataStringList = json[current];
      if (dataStringList.isEmpty) {
        dataStringList = [dataObject];
      } else {
        dataStringList.add(dataObject);
      }
      json[current] = dataStringList;
      // Map<String, dynamic> dataJson = {current: dataStringList};
      sp.setString(AppKeys.json, jsonEncode(json));
    } else {
      List<dynamic> dataStringList = [];
      if (dataStringList.isEmpty) {
        dataStringList = [dataObject];
      } else {
        dataStringList.add(dataObject);
      }
      json[current] = dataStringList;
      // Map<String, dynamic> dataJson = {current: dataStringList};
      sp.setString(AppKeys.json, jsonEncode(json));
    }

    print(sp.getString(AppKeys.json));
    //endregion
  }
}
