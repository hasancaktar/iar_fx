import 'package:flutter/material.dart';
import 'package:web_socket_client/web_socket_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final socket = WebSocket(Uri.parse("wss://demo.piesocket.com/v3/channel_123?api_key=VCXCEuvhGcBDP7XhiJJUDvR1e1D3eiVjgZ9VRiaV&notify_self"));
  String guncelFiyat = "0";
  String alisFiyati = "0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenServer();
  }

  listenServer() {
    socket.connection.listen((event) {print("Bağlandı: " + event.toString());});

    socket.messages.listen((message) {
      print("Güncel Fiyat: " + message);
      guncelFiyat = message;
    });

  }

  void serverAmesajGonder() {
    socket.send(alisFiyati);
    print("Alış fiyatı server'a gönderildi"+alisFiyati);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Iar Fx"))),
      body: Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Card(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Güncel Fiyat",
                      style: TextStyle(fontSize: 15),
                    ),
                    StreamBuilder(
                        stream: socket.connection,
                        builder: (context, snapshot) {
                          return Text(
                             guncelFiyat,
                            style: TextStyle(fontSize: 25),
                          );
                        }),
                  ]),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Card(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Alış Fiyatı",
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      alisFiyati,
                      style: TextStyle(fontSize: 25),
                    )
                  ]),
            ),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.4,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      alisFiyati = guncelFiyat;
                      serverAmesajGonder();

                    });
                  },
                  child: Text(
                    "Al",
                    style: TextStyle(fontSize: 25),
                  )))
        ]),
      ),
    );
  }
}
