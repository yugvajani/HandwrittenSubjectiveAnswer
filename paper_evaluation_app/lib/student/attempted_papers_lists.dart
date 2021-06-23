import 'package:flutter/material.dart';
import 'package:paper_evaluation_app/student/student_db.dart';
import 'package:paper_evaluation_app/student/subject_list_screen.dart';

import 'attempted_papers_screen.dart';

class AttemptedPapersListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: StudentDB().getAttemptedPapers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            List<Map<String,String>> attemptedPapersLists = snapshot.data;
            return Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(60), topLeft: Radius.circular(60)), color: Colors.white),
              height: MediaQuery.of(context).size.height-235,
              child: Padding(
                padding: const EdgeInsets.only(top:50.0),
                child: ListView.builder(
                    itemCount: attemptedPapersLists.length,
                    padding: EdgeInsets.only(top:0),
                    itemBuilder: (context, index) {
                      return Container(
                        // elevation: 5,
                        child: Container(
                          height: 80,
                          child: Container(
                            child: ListTile(
                              leading: const Icon(Icons.auto_stories),
                              tileColor: Colors.white,
                              title: Text('${attemptedPapersLists[index]['name']}'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      AttemptedPapersScreen(attemptedPapersLists[index]['path'])),
                                );
                              },
                            ),  
                          ),
                        ),
                      );
                    }),
              ),
            );
          } else
            return Container();
        });
  }
}
