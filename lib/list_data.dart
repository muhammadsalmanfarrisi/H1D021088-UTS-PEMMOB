import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crud_flutter/edit_data.dart';
import 'package:crud_flutter/side_menu.dart';
import 'package:crud_flutter/tambah_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListData extends StatefulWidget {
  const ListData({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  List<Map<String, String>> dataPekerjaan = [];
  String url = Platform.isAndroid
      ? 'http://10.0.2.2/api-flutter/index.php'
      : 'http://localhost/api-flutter/index.php';
  // String url = 'http://localhost/api-flutter/index.php';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dataPekerjaan = List<Map<String, String>>.from(data.map((item) {
          return {
            'pekerjaan': item['pekerjaan'] as String,
            'status_p': item['status_p'] as String,
            'id': item['id'] as String,
          };
        }));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse('$url?id=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data Pekerjaan'),
      ),
      drawer: const SideMenu(),
      body: Column(children: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TambahData(),
              ),
            );
          },
          child: const Text('Tambah Data Pekerjaan'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: dataPekerjaan.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(dataPekerjaan[index]['pekerjaan']!),
                subtitle: Text('status: ${dataPekerjaan[index]['status_p']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.visibility),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Detail Pekerjaan'),
                              content: SizedBox(
                                height: 50,
                                child: Column(
                                  children: [
                                    Text(
                                        'pekerjaan: ${dataPekerjaan[index]['pekerjaan']}'),
                                    Text(
                                        'status: ${dataPekerjaan[index]['status_p']}')
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // Add your code to handle the action when the user dismisses the alert.
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditData(
                                id: dataPekerjaan[index]['id'] as String,
                                pekerjaan:
                                    dataPekerjaan[index]['pekerjaan'] as String,
                                status_p: dataPekerjaan[index]['status_p']
                                    as String)));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteData(int.parse(dataPekerjaan[index]['id']!))
                            .then((result) {
                          if (result['pesan'] == 'berhasil') {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Data berhasil di hapus'),
                                    content: const Text('ok'),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ListData(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ]),
    );
  }
}
