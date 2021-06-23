import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

class LoadAndViewCsvPage extends StatelessWidget {
  final String path;
  const LoadAndViewCsvPage({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Data'),
        backgroundColor:Color(0xFF6F35A5),
      ),
      body: FutureBuilder(
        future: _loadCsvData(),
        builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: snapshot.data
                    .map(
                      (row) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                // Name
                                row[0] == 'Name' ? Text(row[0],style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), ): Text(row[0]),
                                //Coach
                                row[1] == 'Marks' ? Text(row[1].toString(),style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),): Text(row[1].toString()),
                              ],
                            ),
                          ),
                    )
                    .toList(),
              ),
            );
          }

          return Center(
            child: Text('no data found !!!'),
          );
        },
      ),
    );
  }

  // load csv as string and transform to List<List<dynamic>>
  /*
  [
    ['Name', 'Coach', 'Players'],
    ['Name1', 'Coach1', '5'],
    etc
  ]
  */
  Future<List<List<dynamic>>> _loadCsvData() async {
    final file = new File(path).openRead();
    return await file
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
  }
}