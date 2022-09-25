import 'package:flutter/material.dart';

import '../globals/globals.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTT Platforms"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Center(
                    child: Text(
                  'All Bookmarks',
                )),
                content: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.75,
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: ListView.builder(
                    itemCount: Global.bookMarkList.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                          Global.currentSite = Global.bookMarkList[i];
                          Navigator.of(context).pushNamed("site_page");
                        },
                        onLongPress: () {
                          setState(() {
                            Global.bookMarkList.removeAt(i);
                          });
                        },
                        title: Text(
                          Global.bookMarkList[i],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.blueAccent),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.bookmark),
      ),
      body: ListView.builder(
        itemCount: Global.ottPlatforms.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              Global.currentSite = Global.ottPlatforms[i];
              Navigator.of(context).pushNamed('site_page');
            },
            child: Container(
              height: 120,
              margin: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(Global.ottPlatforms[i]['color']),
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 45,
                    backgroundImage:
                        NetworkImage("${Global.ottPlatforms[i]['image']}"),
                  ),
                  const SizedBox(width: 18),
                  Text(
                    "${Global.ottPlatforms[i]['name']}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Color(Global.ottPlatforms[i]['color']),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
