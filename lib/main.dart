import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Api(),
    );
  }
}

class Api extends StatefulWidget {
  @override
  _ApiState createState() => _ApiState();
}

class _ApiState extends State<Api> {
  var response;
  var responseParsed;
  String title;
  String arama = "araba";
  List<String> gifs = List(8);
  TextEditingController text = TextEditingController();

  @override
  void initState() {
    Get();
    super.initState();
  }

  Future GetData() async {
    response = (await http.get(
            "https://g.tenor.com/v1/search?q=$arama&key=LIVDSRZULELA&limit=8"))
        .body;
    responseParsed = await jsonDecode(response);
    print(responseParsed["title"]);

    setState(() {
      for (int i = 0; i < gifs.length; i++) {
        gifs[i] = responseParsed["results"][i]["media"][0]["tinygif"]["url"];
        print("eklendi");
      }
    });
  }

  Future<void> Get() async {
    await GetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Gifs"),
          centerTitle: true,
        ),
        body: responseParsed == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: text,
                    ),
                    RaisedButton(
                      child: Text("Ara"),

                      onPressed: () {
                        setState(() {
                          arama = text.text;
                          Get();
                        });
                      },
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: ListView.builder(
                          itemCount: 8,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: Image.network(
                                "${gifs[index]}",
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        )),
                  ],
                ),
            ));
  }
}
