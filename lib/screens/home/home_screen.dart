import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Polls/data/rest_ds.dart';
import 'package:Polls/auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BuildContext _ctx;
  RestDatasource api = new RestDatasource();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Polls from Maldives"),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: new Container(
          margin: new EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: new FutureBuilder<List>(
              future: api.getPolls(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return new ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, int position) {
                        var item = snapshot.data[position];
                        return new ExpansionTile(
                            leading: (item['pollIcon'].toString().isEmpty
                                ? new CircleAvatar(
                                    backgroundColor: Colors.lightBlueAccent,
                                    child: new Text(item['question'][0]
                                        .toString()
                                        .toUpperCase()),
                                  )
                                : new CircleAvatar(
                                    backgroundColor: Colors.lightBlueAccent,
                                    backgroundImage:
                                        new NetworkImage(item['pollIcon']),
                                  )),
                            title: new Text(item['question']),
                            children: this.generatePolls(item));
                      });
                }
                return new Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ));
  }

  List<Widget> generatePolls(Map item) {
    List<Widget> widgets = [];
    widgets.add(new ListTile(
        title: new Text(
      item['description'],
      textAlign: TextAlign.justify,
      style: new TextStyle(fontSize: 15.0),
    )));

    for (int x = 1; x < 10; x++) {
      if (item['ans' + x.toString()] != null) {
        Widget tile = new ListTile(
            leading: (item['ansPic' + x.toString()] != null)
                ? new CircleAvatar(
                    backgroundColor: Colors.lightBlue,
                    backgroundImage:
                        new NetworkImage(item['ansPic' + x.toString()]))
                : null,
            trailing: new FlatButton.icon(
                onPressed: () => this.doVote(item['id'], x),
                icon: new Icon(Icons.arrow_forward),
                label: new Text('Vote')),
            subtitle: new Text(item['score' + x.toString()].toString() + ' %'),
            title: new Text(item['ans' + x.toString()]));
        widgets.add(tile);
      }
    }
    return widgets;
  }

  doVote(int pollId, int answerId) async {
    String currState = await getAuthState();
    if (currState == "logged_out") {
      Navigator.of(_ctx).pushReplacementNamed("/login");
    } else {
      String accessToken = await getAccessToken();
      if (accessToken == '') {
        Navigator.of(_ctx).pushReplacementNamed("/login");
      } else {
        api.vote(accessToken, pollId, answerId);
      }
    }
  }

  checkLoggedIn() async {
    String currState = await getAuthState();
    if (currState != "logged_out") {
      Navigator.of(_ctx).pushReplacementNamed("/home");
    }
  }
}
