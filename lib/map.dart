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
  final List<Offset> _locations = [];
  final GlobalKey _mapKey = GlobalKey();
  Size _previousSize = Size.zero;

  /* -------------------------------------------------------------------------- */
  /*                                    Logic                                   */
  /* -------------------------------------------------------------------------- */

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _previousSize = _mapKey.currentContext!.size!;
    });
  }

  // hot reload pin position
  void _onResize(Size newSize) {
    if (_previousSize != newSize) {
      setState(() {
        _previousSize = newSize;
      });
    }
  }

  /* ---------------------------- Tap to pin on map --------------------------- */
  void _handleMapClick(TapUpDetails details) {
    final RenderBox box =
        _mapKey.currentContext!.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    final Size imageSize = box.size;
    final Offset normalizedOffset = Offset(
      localOffset.dx / imageSize.width,
      localOffset.dy / imageSize.height,
    );
    setState(() {
      _locations.add(normalizedOffset -
          Offset(
              12 / imageSize.width, 22 / imageSize.height)); // Adjusted offset
    });
  }

  /* ----------------------------- Action Buttons ----------------------------- */
  void _insertLocation(StateSetter listSetState) {
    final TextEditingController dxController =
        TextEditingController(text: "0.0");
    final TextEditingController dyController =
        TextEditingController(text: "0.0");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dxController,
                decoration: const InputDecoration(labelText: 'dx'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: dyController,
                decoration: const InputDecoration(labelText: 'dy'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _locations.add(Offset(
                    double.parse(dxController.text),
                    double.parse(dyController.text),
                  ));
                });
                listSetState(() {}); // Update the list view
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showLocationsList() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ListView.builder(
              itemCount: _locations.length,
              itemBuilder: (context, index) {
                final location = _locations[index];
                return ListTile(
                  title: Text('Location ${index + 1}'),
                  subtitle: Text(
                      '(${location.dx.toStringAsFixed(2)}, ${location.dy.toStringAsFixed(2)})'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _editLocation(index, setState);
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _editLocation(int index, StateSetter listSetState) {
    final location = _locations[index];
    final TextEditingController dxController =
        TextEditingController(text: location.dx.toString());
    final TextEditingController dyController =
        TextEditingController(text: location.dy.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dxController,
                decoration: const InputDecoration(labelText: 'dx'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: dyController,
                decoration: const InputDecoration(labelText: 'dy'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _locations[index] = Offset(
                    double.parse(dxController.text),
                    double.parse(dyController.text),
                  );
                });
                listSetState(() {}); // Update the list view
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                                    Scene                                   */
  /* -------------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: _handleMapClick,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Simulation Game'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final newSize =
                    Size(constraints.maxWidth, constraints.maxHeight);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _onResize(newSize);
                });
                return Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          key: _mapKey,
                          padding: const EdgeInsets.all(8.0),
                          child: const Image(
                              image: AssetImage(
                                  "assets/LibertyCity-GTACW-Map.png")),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const start_screen
                                      .StartScreenAnimation()),
                            );
                          },
                          child: const Text('Go back!'),
                        ),
                      ],
                    ),
                    ..._locations.map((location) {
                      final RenderBox box = _mapKey.currentContext!
                          .findRenderObject() as RenderBox;
                      final Size imageSize = box.size;
                      return Positioned(
                        left: location.dx * imageSize.width,
                        top: location.dy * imageSize.height,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 24.0,
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => _insertLocation(setState),
              tooltip: 'Increment',
              child: Text(_locations.length.toString()),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              onPressed: _showLocationsList,
              tooltip: 'Show Locations',
              child: const Icon(Icons.list),
            ),
          ],
        ),
      ),
    );
  }
}
