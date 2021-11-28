import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:market_place_flutter/api/api_client.dart';
import 'package:market_place_flutter/models/base_model.dart';
import 'package:market_place_flutter/models/note.dart';
import 'package:market_place_flutter/utils/constants.dart';
import 'package:market_place_flutter/widgets/striketrough.dart';

class CatatanPage extends StatefulWidget {
  CatatanPage({Key? key}) : super(key: key);

  @override
  _CatatanPageState createState() => _CatatanPageState();
}

class _CatatanPageState extends State<CatatanPage> {
  List<Note> noteList = [];
  late Note note;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    //   print("init sahdjashd");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<BaseModel>(
        future: ApiClient(context).getNoteList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var listData = snapshot.data!.data;
            noteList = (listData['data'] as List)
                .map((json) => Note.fromJson(json))
                .toList();
            return noteList.isNotEmpty
                ? ListView.builder(
                    itemCount: noteList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _item(index);
                    },
                  )
                : Center(
                    //padding: EdgeInsets.all(20),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Icon(Icons.folder_open),
                        Text('Oops Catatan Kosong')
                      ]));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => openFormAddNote())
              .then((_) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _item(int index) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: Colors.white)),
        elevation: 10,
        color: Colors.grey[900],
        child: SwipeActionCell(
          key: ValueKey(noteList[index]),
          trailingActions: [
            SwipeAction(
                nestedAction: SwipeNestedAction(
                  content: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.red,
                    ),
                    width: 110,
                    height: 30,
                    child: OverflowBox(
                      maxWidth: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Text('Hapus ?',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
                color: Colors.transparent,
                content: _getIconButton(Colors.red, Icons.delete),
                onTap: (handler) async {
                  final res =
                      await ApiClient(context).destroyNote(noteList[index].id);
                  if (res.code == 0) {
                    setState(() {});
                    // print("item deleted");
                  }
                }),
            SwipeAction(
                content: _getIconButton(Colors.grey, Icons.edit),
                color: Colors.transparent,
                onTap: (handler) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, setState) {
                            String textNote = noteList[index].name;
                            return AlertDialog(
                              content: Container(
                                height: 200,
                                child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        RichText(
                                            text: TextSpan(children: [
                                          WidgetSpan(child: Icon(Icons.edit)),
                                          TextSpan(
                                              text: "Edit Catatan",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20)),
                                        ])),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                            child: TextFormField(
                                          initialValue: textNote,
                                          keyboardType: TextInputType.text,
                                          validator: (val) => val!.isEmpty
                                              ? "Masukkan catatan"
                                              : null,
                                          onChanged: (val) => textNote =
                                              val.isNotEmpty ? val : "",
                                          decoration:
                                              styleFloatingInputDecoration(
                                                  "Input catatan", null, null),
                                        )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: 300,
                                          child: ElevatedButton(
                                              child: Text("UPDATE"),
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  noteList[index].name =
                                                      textNote;
                                                  final res =
                                                      await ApiClient(context)
                                                          .updateNote(
                                                              noteList[index]
                                                                  .id,
                                                              noteList[index]);
                                                  if (res.code == 0) {
                                                    Navigator.of(context).pop();
                                                  }
                                                }
                                              }),
                                        )
                                      ],
                                    )),
                              ),
                            );
                          },
                        );
                      }).then((_) => setState(() {}));
                }),
          ],
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: noteList[index].isdone == 1
                ? GestureDetector(
                    child: StrikeThroughWidget(
                        child: Text("${index + 1}. ${noteList[index].name}",
                            style: TextStyle(fontSize: 18))),
                    onTap: () async {
                      noteList[index].isdone = 0;
                      final res = await ApiClient(context)
                          .updateNote(noteList[index].id, noteList[index]);
                      if (res.code == 0) {
                        setState(() {});
                      }
                    },
                  )
                : GestureDetector(
                    child: Text("${index + 1}. ${noteList[index].name}",
                        style: TextStyle(fontSize: 18)),
                    onTap: () async {
                      noteList[index].isdone = 1;
                      final res = await ApiClient(context)
                          .updateNote(noteList[index].id, noteList[index]);
                      if (res.code == 0) {
                        //print("Make done this");
                        setState(() {});
                      }
                    },
                  ),
          ),
        ));
  }

  Widget _getIconButton(color, icon) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  Widget CardItem(int index) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            noteList[index].isdone == 1
                ? GestureDetector(
                    child: StrikeThroughWidget(
                        child: Text(noteList[index].name,
                            style: TextStyle(fontSize: 18))),
                    onTap: () async {
                      noteList[index].isdone = 0;
                      final res = await ApiClient(context)
                          .updateNote(noteList[index].id, noteList[index]);
                      if (res.code == 0) {
                        setState(() {});
                      }
                    },
                  )
                : GestureDetector(
                    child: Text(noteList[index].name,
                        style: TextStyle(fontSize: 18)),
                    onTap: () async {
                      noteList[index].isdone = 1;
                      final res = await ApiClient(context)
                          .updateNote(noteList[index].id, noteList[index]);
                      if (res.code == 0) {
                        print("Make done this");
                        setState(() {});
                      }
                    },
                  ),
            IconButton(
                onPressed: () async {
                  final res =
                      await ApiClient(context).destroyNote(noteList[index].id);
                  if (res.code == 0) {
                    setState(() {});
                    // print("item deleted");
                  }
                },
                icon: Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}

class openFormAddNote extends StatefulWidget {
  openFormAddNote({Key? key}) : super(key: key);

  @override
  _openFormAddNoteState createState() => _openFormAddNoteState();
}

class _openFormAddNoteState extends State<openFormAddNote> {
  final _formKey = GlobalKey<FormState>();
  String textNote = "";
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SafeArea(
          child: Container(
        height: 230,
        padding: EdgeInsets.all(20),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                RichText(
                    text: TextSpan(children: [
                  WidgetSpan(child: Icon(Icons.note_add)),
                  TextSpan(
                      text: "Tambah Catatan",
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                ])),
                SizedBox(
                  height: 30,
                ),
                Container(
                    child: TextFormField(
                  initialValue: textNote,
                  keyboardType: TextInputType.text,
                  validator: (val) => val!.isEmpty ? "Masukkan catatan" : null,
                  onChanged: (val) => textNote = val.isNotEmpty ? val : "",
                  decoration:
                      styleFloatingInputDecoration("Input catatan", null, null),
                )),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 300,
                  child: ElevatedButton(
                      child: Text("SIMPAN"),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Map<String, String> queries = {"name": textNote};
                          final res =
                              await ApiClient(context).postNote(queries);
                          if (res.code == 0) {
                            Navigator.of(context).pop();
                            // final snackBar =
                            //     SnackBar(content: Text('Note saved'));
                            // ScaffoldMessenger.of(context)
                            //     .showSnackBar(snackBar);
                          }
                        }
                      }),
                )
              ],
            )),
      )),
    );
  }
}
