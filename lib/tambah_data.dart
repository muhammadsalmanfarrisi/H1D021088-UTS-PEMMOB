import 'dart:convert';
import 'dart:io';

import 'package:crud_flutter/list_data.dart';
import 'package:crud_flutter/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahData extends StatefulWidget {
  const TambahData({Key? key}) : super(key: key);

  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final pekerjaanController = TextEditingController();
  final status_pController = TextEditingController();

  Future postData(String pekerjaan, String status_p) async {
    // print(pekerjaan);
    String url = Platform.isAndroid
        ? 'http://10.0.2.2/api-flutter/index.php'
        : 'http://localhost/api-flutter/index.php';
    // String url = 'http://localhost/api-flutter/index.php';

    // String url = 'http://127.0.0.1/apiTrash/prosesLoginDriver.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody = '{"pekerjaan": "$pekerjaan", "status_p": "$status_p"}';
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Pekerjaan'),
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
                hintText: 'Isikan Pekerjaan',
              ),
            ),
            TextField(
              controller: status_pController,
              decoration: const InputDecoration(
                hintText: 'Isikan Status',
              ),
            ),
            ElevatedButton(
              child: const Text('Tambah Pekerjaan'),
              onPressed: () {
                String pekerjaan = pekerjaanController.text;
                String status_p = status_pController.text;
                // print(pekerjaan);
                postData(pekerjaan, status_p).then((result) {
                  //print(result['pesan']);
                  if (result['pesan'] == 'berhasil') {
                    showDialog(
                        context: context,
                        builder: (context) {
                          //var pekerjaanuser2 = pekerjaanuser;
                          return AlertDialog(
                            title: const Text('Data berhasil di tambah'),
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
