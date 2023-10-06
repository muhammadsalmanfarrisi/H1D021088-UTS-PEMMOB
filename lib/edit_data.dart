import 'package:crud_flutter/list_data.dart';
import 'package:crud_flutter/side_menu.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class EditData extends StatefulWidget {
  const EditData(
      {Key? key,
      required this.pekerjaan,
      required this.status_p,
      required this.id})
      : super(key: key);
  final String pekerjaan;
  final String status_p;
  final String id;
  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  final pekerjaanController = TextEditingController();
  final status_pController = TextEditingController();

  Future updateData(String pekerjaan, String status_p) async {
    String url = Platform.isAndroid
        ? 'http://10.0.2.2/api-flutter/index.php'
        : 'http://localhost/api-flutter/index.php';
    // String url = 'http://localhost/api-flutter/index.php';

    //String url = 'http://127.0.0.1/apiTrash/prosesLoginDriver.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody =
        '{"id": "${widget.id}","pekerjaan": "$pekerjaan", "status_p": "$status_p"}';
    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update data');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pekerjaanController.text = widget.pekerjaan;
    status_pController.text = widget.status_p;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Pekerjaan'),
      ),
      drawer: const SideMenu(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: pekerjaanController,
              decoration: const InputDecoration(
                hintText: 'pekerjaan Pekerjaan',
              ),
            ),
            TextField(
              controller: status_pController,
              decoration: const InputDecoration(
                hintText: 'status_p',
              ),
            ),
            ElevatedButton(
              child: const Text('Update Pekerjaan'),
              onPressed: () {
                String pekerjaan = pekerjaanController.text;
                String status_p = status_pController.text;
                // print(pekerjaan);
                updateData(pekerjaan, status_p).then((result) {
                  //print(result['pesan']);
                  if (result['pesan'] == 'berhasil') {
                    showDialog(
                        context: context,
                        builder: (context) {
                          //var pekerjaanuser2 = pekerjaanuser;
                          return AlertDialog(
                            title: const Text('Data berhasil di update'),
                            content: const Text('ok'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ListData(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        });
                  }
                  setState(() {});
                });
              },
            ),
          ],
        ),

        //     ],
        //   ),
        // ),
      ),
    );
  }
}
