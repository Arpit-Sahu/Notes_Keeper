import 'package:flutter/material.dart';
import 'package:todo/Screens/NewNote.dart';
import 'package:todo/Screens/Notes.dart';
import 'package:todo/Screens/Trash.dart';
import 'package:animations/animations.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;
  final List<Widget> screens = [
    Notes(),
    Trash(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Notes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: OpenContainer(
        closedShape: CircleBorder(),
        transitionDuration: Duration(seconds: 1),
        openBuilder: (context, _) => NewNote(),
        closedBuilder: (context, openContainer) => FloatingActionButton(
          onPressed: openContainer,
          // onPressed: () {
          //   Navigator.push(context, MaterialPageRoute(builder: (context) {
          //     return NewNote();
          //   }));
          // },
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Notes();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list,
                            color: currentTab == 0 ? Colors.blue : Colors.grey),
                        Text(
                          'Notes',
                          style: TextStyle(
                              color:
                                  currentTab == 0 ? Colors.blue : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Trash();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete,
                            color: currentTab == 1 ? Colors.blue : Colors.grey),
                        Text(
                          'Trash',
                          style: TextStyle(
                              color:
                                  currentTab == 1 ? Colors.blue : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
