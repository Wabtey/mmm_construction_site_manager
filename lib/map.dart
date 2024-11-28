import 'package:flutter/material.dart';
import 'package:mmm_construction_site_manager/start_screen.dart'
    as start_screen;

/* ------------------------------ Second Route ------------------------------ */
class SideGame extends StatefulWidget {
  const SideGame({super.key});

  @override
  State<SideGame> createState() => _SideGameState();
}

class _SideGameState extends State<SideGame> {
  int _sites = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _sites without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _sites++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulation Game'),
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image(
                        image: AssetImage("assets/LibertyCity-GTACW-Map.png")),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const start_screen.StartScreenAnimation()),
                      );
                    },
                    child: const Text('Go back!'),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
