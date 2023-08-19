import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Git(),
  ));
}

class Git extends StatefulWidget {
  const Git({Key? key}) : super(key: key);

  @override
  State<Git> createState() => GitState();
}

class GitState extends State<Git> {
  List<dynamic> userData = [];

  Future<void> getData() async {
    http.Response response = await http.get(Uri.parse("https://api.github.com/search/repositories?q=created:%3E2022-04-29&sort=stars&order=desc"));
    Map<String, dynamic> data = json.decode(response.body);
    setState(() {
      userData = data["items"];
    });
    debugPrint(userData.toString());
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Repository",
          style: TextStyle(fontSize: 20,color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black
      ),
      body: ListView.builder(
        itemCount: userData.length,
        itemBuilder: (context, index) {

        return Card(
          child: ListTile(
            leading:
            CircleAvatar(
              radius: 30.0,
              backgroundImage:
              NetworkImage(userData[index]["owner"]["avatar_url"],),
              backgroundColor: Colors.transparent,
            ),
            title:  Text(userData[index]["name"],style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text( 'Description: ${userData[index]["description"]}'),
            trailing: Column(
              children: [
                Icon(Icons.star, color: Colors.amber),
                Text('${userData[index]["stargazers_count"] }',style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        );

        },
      ),
    );
  }
}
