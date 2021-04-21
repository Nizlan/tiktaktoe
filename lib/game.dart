import 'package:flutter/material.dart';

import 'models/field.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  int fieldsNumber = 3;
  List fields = <Field>[];
  String player = 'cross';
  int crossRow = 0;
  int zeroRow = 0;
  int crossColumn = 0;
  int zeroColumn = 0;
  int crossDiag = 0;
  int zeroDiag = 0;
  int crossDiag2 = 0;
  int zeroDiag2 = 0;

  void toStart() {
    setState(() {
      List f = [];
      for (var i = 0; i < fieldsNumber * fieldsNumber; i++) {
        f.add(Field(i ~/ fieldsNumber, i % fieldsNumber, 'ы', true));
      }
      fields = f;
      setState(() {
        crossRow = 0;
        zeroRow = 0;
        crossColumn = 0;
        zeroColumn = 0;
        zeroDiag = 0;
        crossDiag = 0;
        zeroDiag2 = 0;
        crossDiag2 = 0;
      });
    });
  }

  isOver() async {
    for (int i = 0; i < fieldsNumber; i++) {
      for (int j = 0; i + j < (fieldsNumber * fieldsNumber); j++) {
        if ((i + j) ~/ 3 == i) {
          if (fields[i + j].state == 'X') {
            setState(() {
              crossRow += 1;
            });
            if (crossRow == fieldsNumber) {
              player = 'cross';
              return await _showMyDialog();
            }
          } else if (fields[i + j].state == 'O') {
            setState(() {
              zeroRow += 1;
            });
            if (zeroRow == fieldsNumber) {
              player = 'cross';
              return await _showMyDialog();
            }
          }
        }
        if ((i + j) % 3 == i) {
          if (fields[i + j].state == 'X') {
            setState(() {
              crossColumn += 1;
            });
            if (crossColumn == fieldsNumber) {
              player = 'cross';
              return await _showMyDialog();
            }
          } else if (fields[i + j].state == 'O') {
            setState(() {
              zeroColumn += 1;
            });
            if (zeroColumn == fieldsNumber) {
              player = 'cross';
              return await _showMyDialog();
            }
          }
        }
        if ((i + j) % 3 == (i + j) ~/ 3 && (i + j) % 3 == i) {
          if (fields[i + j].state == 'X') {
            setState(() {
              crossDiag += 1;
            });
            if (crossDiag == fieldsNumber) {
              return await _showMyDialog();
            }
          } else if (fields[i + j].state == 'O') {
            setState(() {
              zeroDiag += 1;
            });
            if (zeroDiag == fieldsNumber) {
              return await _showMyDialog();
            }
          }
        }
        if (((i + j) ~/ 3 + i == (i + j) % 3 + fieldsNumber - 1 - i) &&
            (i + j) % 3 == i) {
          if (fields[i + j].state == 'X') {
            setState(() {
              crossDiag2 += 1;
            });
            if (crossDiag2 == fieldsNumber) {
              player = 'cross';
              return await _showMyDialog();
            }
          } else if (fields[i + j].state == 'O') {
            setState(() {
              zeroDiag2 += 1;
            });
            if (zeroDiag2 == fieldsNumber) {
              player = 'cross';
              return await _showMyDialog();
            }
          }
        }
      }
      setState(() {
        crossRow = 0;
        zeroRow = 0;
        crossColumn = 0;
        zeroColumn = 0;
      });
    }
    setState(() {
      crossDiag = 0;
      zeroDiag = 0;
      zeroDiag2 = 0;
      crossDiag2 = 0;
    });

    return 1;
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Игра окончена'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                (crossRow == fieldsNumber ||
                        crossColumn == fieldsNumber ||
                        crossDiag == fieldsNumber ||
                        crossDiag2 == fieldsNumber)
                    ? Text('Победил крестик')
                    : Text('Победил нолик')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ага'),
              onPressed: () {
                toStart();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    for (var i = 0; i < fieldsNumber * fieldsNumber; i++) {
      fields.add(Field(i ~/ fieldsNumber, i % fieldsNumber, 'ы', true));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: 600,
            height: 600,
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(
                9,
                (index) {
                  return Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.height / 3,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Center(
                      child: GestureDetector(
                          onTap: () => setState(() {
                                if (fields[index].isEditable) {
                                  fields[index].isEditable = false;
                                  if (player == 'cross') {
                                    fields[index].state = 'X';
                                    player = 'zero';
                                  } else {
                                    fields[index].state = 'O';
                                    player = 'cross';
                                  }
                                }
                                isOver();
                              }),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Text(
                              '${fields[index].state}',
                              style: TextStyle(fontSize: 60),
                            ),
                          )),
                    ),
                  );
                },
              ),
            ),
          ),
          TextButton(onPressed: toStart, child: Text('Обнулить')),
        ],
      ),
    );
  }
}
