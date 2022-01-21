import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:market_place_flutter/api/api_client.dart';
import 'package:market_place_flutter/models/note.dart';
import 'package:market_place_flutter/utils/constants.dart';
import 'package:market_place_flutter/widgets/loadmore.dart';
import 'package:market_place_flutter/widgets/striketrough.dart';

class CatatanPage extends StatefulWidget {
  final String query;
  CatatanPage({Key? key, required String this.query}) : super(key: key);

  @override
  _CatatanPageState createState() => _CatatanPageState();
}

class _CatatanPageState extends State<CatatanPage> {
  int page = 1;
  int pageSize = 10;
  int get count => noteList.length;
  List<Note> noteList = [];
  List<Note> dataShow = [];

  //late Future<List<Note>> _future;
  //ScrollController _controller = ScrollController();
  late Note note;
  final _formKey = GlobalKey<FormState>();
  bool loadCompleted = false;
  bool isLoading = true;
  bool isEdit = false;

  @override
  void initState() {
    // _future = getNotes(page, pageSize);
    _refresh();
    super.initState();
    // _controller.addListener(() {
    //   if (_controller.offset >= _controller.position.maxScrollExtent &&
    //       !_controller.position.outOfRange) {
    //     print("scrolller...");
    //     if (!loadCompleted) {
    //       setState(() {
    //         _future = getNotes(page, pageSize);
    //       });
    //     }
    //   }
    // });
  }

  Future<List<Note>> getNotes(int pagex, int limit) async {
    var res = await ApiClient(context).getNoteList(pagex, limit);
    if (res.code == 0) {
      var listData = res.data;
      List<Note> items = (listData['data'] as List)
          .map((json) => Note.fromJson(json))
          .toList();
      if (items.length >= limit) {
        page++;
      } else {
        loadCompleted = true;
      }
      if (items.length > 0) {
        setState(() {
          noteList.addAll(items);
        });
      }
      return noteList;
    } else {
      return [];
    }
  }

  Future<List<Note>> getSearchNotes(Map<String, dynamic> params) async {
    var res = await ApiClient(context).getNoteSearch(params);
    if (res.code == 0) {
      var listData = res.data;
      List<Note> items = (listData['data'] as List)
          .map((json) => Note.fromJson(json))
          .toList();
      if (items.length > 0) {
        noteList.clear();
        setState(() {
          noteList.addAll(items);
        });
      }
      return noteList;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> params = {"q": widget.query, "all": 1};
    return Scaffold(
      body: Container(
        child: widget.query.length > 0
            ? RefreshIndicator(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : FutureBuilder(
                        future: ApiClient(context).getNoteSearch(params),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(child: Text("Error"));
                          }
                          if (!snapshot.hasData) {
                            return Center(child: Text("Error"));
                          }
                          var listdinamic = snapshot.data!.data;

                          List<Note> items = (listdinamic['data'] as List)
                              .map((e) => Note.fromJson(e))
                              .toList();
                          if (items.length > 0) {
                            //noteList.clear();
                            return ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _item(items, index);
                              },
                            );
                          } else {
                            return Center(
                                //padding: EdgeInsets.all(20),
                                child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  Icon(Icons.hourglass_empty),
                                  Text('Oops Tidak ditemukan')
                                ]));
                          }
                        },
                      ),
                onRefresh: _refresh)
            : RefreshIndicator(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : LoadMore(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return count != 0
                                ? _item(noteList, index)
                                : Center(
                                    //padding: EdgeInsets.all(20),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                        Icon(Icons.folder_open),
                                        Text('Oops Catatan Kosong')
                                      ]));
                          },
                          itemCount: count,
                        ),
                        onLoadMore: _loadMore,
                        whenEmptyLoad: false,
                        delegate: DefaultLoadMoreDelegate(),
                        textBuilder: DefaultLoadMoreTextBuilder.english,
                        isFinish: loadCompleted),
                onRefresh: _refresh),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                isEdit = false;
                return showEditOrAddForm(context, null, null);
              }).then((_) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    page = 1;
    loadCompleted = false;
    widget.query == "";
    noteList.clear();
    await getNotes(page, pageSize);
    isLoading = false;
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    await getNotes(page, pageSize);
    return true;
  }

  StatefulBuilder showEditOrAddForm(
      BuildContext context, List<Note>? noteResult, int? index) {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        String textNote = isEdit ? noteResult![index!].name : "";
        return AlertDialog(
          content: Container(
            height: 200,
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      WidgetSpan(child: Icon(isEdit ? Icons.edit : Icons.add)),
                      TextSpan(
                          text: isEdit ? "Edit Catatan" : "Tambah Catatan",
                          style: TextStyle(color: Colors.black, fontSize: 20)),
                    ])),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                        child: TextFormField(
                      initialValue: textNote,
                      keyboardType: TextInputType.text,
                      validator: (val) =>
                          val!.isEmpty ? "Masukkan catatan" : null,
                      onChanged: (val) => textNote = val.isNotEmpty ? val : "",
                      decoration: styleFloatingInputDecoration(
                          "Input catatan", null, null),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 300,
                      child: ElevatedButton(
                          child: isEdit ? Text("UPDATE") : Text("TAMBAH"),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (isEdit) {
                                noteResult![index!].name = textNote;
                                final res = await ApiClient(context).updateNote(
                                    noteResult[index].id, noteResult[index]);
                                if (res.code == 0) {
                                  Navigator.of(context).pop();
                                }
                              } else {
                                Map<String, String> queries = {
                                  "name": textNote
                                };
                                final res =
                                    await ApiClient(context).postNote(queries);

                                if (res.code == 0) {
                                  Note note = Note.fromJson(res.data);
                                  setState(() {
                                    noteList.add(note);
                                  });

                                  Navigator.of(context).pop();
                                }
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
  }

  Widget _item(List<Note> noteResult, int index) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: Colors.white)),
        elevation: 10,
        color: Colors.grey[900],
        child: SwipeActionCell(
          key: ValueKey(noteResult[index]),
          trailingActions: [
            SwipeAction(
                performsFirstActionWithFullSwipe: true,
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
                  final res = await ApiClient(context)
                      .destroyNote(noteResult[index].id);
                  if (res.code == 0) {
                    setState(() {
                      print("item deleted " + index.toString());
                      noteResult.removeAt(index);
                    });
                    //
                  }
                }),
            SwipeAction(
                content: _getIconButton(Colors.grey, Icons.edit),
                color: Colors.transparent,
                onTap: (_) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        isEdit = true;
                        return showEditOrAddForm(context, noteResult, index);
                      }).then((_) => setState(() {}));
                }),
          ],
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: noteResult[index].isdone == 1
                ? GestureDetector(
                    child: StrikeThroughWidget(
                        child: Text("${index + 1}. ${noteResult[index].name}",
                            style: TextStyle(fontSize: 18))),
                    onTap: () async {
                      noteResult[index].isdone = 0;
                      final res = await ApiClient(context)
                          .updateNote(noteResult[index].id, noteResult[index]);
                      if (res.code == 0) {
                        setState(() {});
                      }
                    },
                  )
                : GestureDetector(
                    child: Text("${index + 1}. ${noteResult[index].name}",
                        style: TextStyle(fontSize: 18)),
                    onTap: () async {
                      noteResult[index].isdone = 1;
                      final res = await ApiClient(context)
                          .updateNote(noteResult[index].id, noteResult[index]);
                      if (res.code == 0) {
                        //print("Make done this");
                        setState(() {});
                      }
                    },
                  ),
          ),
        ));
  }

  // Widget _item(int index) {
  //   return Card(
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(15.0),
  //           side: BorderSide(color: Colors.white)),
  //       elevation: 10,
  //       color: Colors.grey[900],
  //       child: SwipeActionCell(
  //         key: ValueKey(noteList[index]),
  //         trailingActions: [
  //           SwipeAction(
  //               performsFirstActionWithFullSwipe: true,
  //               nestedAction: SwipeNestedAction(
  //                 content: Container(
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(15),
  //                     color: Colors.red,
  //                   ),
  //                   width: 110,
  //                   height: 30,
  //                   child: OverflowBox(
  //                     maxWidth: double.infinity,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Icon(
  //                           Icons.delete,
  //                           color: Colors.white,
  //                         ),
  //                         Text('Hapus ?',
  //                             style:
  //                                 TextStyle(color: Colors.white, fontSize: 16)),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               color: Colors.transparent,
  //               content: _getIconButton(Colors.red, Icons.delete),
  //               onTap: (handler) async {
  //                 final res =
  //                     await ApiClient(context).destroyNote(noteList[index].id);
  //                 if (res.code == 0) {
  //                   setState(() {
  //                     print("item deleted " + index.toString());
  //                     noteList.removeAt(index);
  //                   });
  //                   //
  //                 }
  //               }),
  //           SwipeAction(
  //               content: _getIconButton(Colors.grey, Icons.edit),
  //               color: Colors.transparent,
  //               onTap: (_) {
  //                 showDialog(
  //                     context: context,
  //                     builder: (context) {
  //                       isEdit = true;
  //                       return showEditOrAddForm(context, index);
  //                     }).then((_) => setState(() {}));
  //               }),
  //         ],
  //         child: Padding(
  //           padding: const EdgeInsets.all(15.0),
  //           child: noteList[index].isdone == 1
  //               ? GestureDetector(
  //                   child: StrikeThroughWidget(
  //                       child: Text("${index + 1}. ${noteList[index].name}",
  //                           style: TextStyle(fontSize: 18))),
  //                   onTap: () async {
  //                     noteList[index].isdone = 0;
  //                     final res = await ApiClient(context)
  //                         .updateNote(noteList[index].id, noteList[index]);
  //                     if (res.code == 0) {
  //                       setState(() {});
  //                     }
  //                   },
  //                 )
  //               : GestureDetector(
  //                   child: Text("${index + 1}. ${noteList[index].name}",
  //                       style: TextStyle(fontSize: 18)),
  //                   onTap: () async {
  //                     noteList[index].isdone = 1;
  //                     final res = await ApiClient(context)
  //                         .updateNote(noteList[index].id, noteList[index]);
  //                     if (res.code == 0) {
  //                       //print("Make done this");
  //                       setState(() {});
  //                     }
  //                   },
  //                 ),
  //         ),
  //       ));
  // }

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
