import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import './mutations/addNote.dart' as mutations;
import './queries/readNotes.dart' as queries;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ValueNotifier<Client> client = ValueNotifier(
      Client(
        endPoint: 'https://us1.prisma.sh/kryounger-ec2d13/mrsfeasley/dev',
        cache: InMemoryCache(),
        // apiToken: '<YOUR_GITHUB_PERSONAL_ACCESS_TOKEN>',
      ),
    );

    return GraphqlProvider(
      client: client,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Notes'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Query(
        queries.readNotes,
        pollInterval: 1,
        builder: ({
          bool loading,
          Map data,
          Exception error,
        }) {
          if (error != null) {
            return Text(error.toString());
          }

          if (loading) {
            return Text('Loading');
          }

          // it can be either Map or List
          List notes = data['viewer']['notes'];

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final repository = notes[index];

              return Mutation(
                mutations.addNote,
                builder: (
                  addStar, {
                  bool loading,
                  Map data,
                  Exception error,
                }) {
                  if (data.isNotEmpty) {
                    repository['viewerHasStarred'] =
                        data['addNote']['noteable']['viewerHasStarred'];
                  }

                  return ListTile(
                    leading: repository['viewerHasStarred']
                        ? const Icon(Icons.star, color: Colors.amber)
                        : const Icon(Icons.star_border),
                    title: Text(repository['name']),
                    // NOTE: optimistic ui updates are not implemented yet, therefore changes may take upto 1 second to show.
                    onTap: () {
                      // addNote({
                      //   'noteableId': repository['id'],
                      // });
                    },
                  );
                },
                onCompleted: (Map<String, dynamic> data) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Thanks for your star!'),
                        actions: <Widget>[
                          SimpleDialogOption(
                            child: Text('Dismiss'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
