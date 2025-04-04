import 'package:flutter/material.dart';
import 'package:mmm_construction_site_manager/start_screen.dart'
    as start_screen;
import 'package:mmm_construction_site_manager/api/endpoints/user.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class Location {
  final Offset coordinates;
  final String name;

  Location({required this.coordinates, required this.name});
}

class _MapState extends State<Map> {
  final List<Location> _locations = [];
  final GlobalKey _mapKey = GlobalKey();
  Size _previousSize = Size.zero;
  final UserApi _userApi = UserApi(baseUrl: 'http://localhost:8000');

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
      _locations.add(Location(
          coordinates: normalizedOffset -
              Offset(12 / imageSize.width, 22 / imageSize.height),
          name: "Location ${_locations.length + 1}")); // Adjusted offset
    });
  }

  /* ----------------------------- Action Buttons ----------------------------- */
  void _insertLocation(StateSetter listSetState) {
    _showLocationDialog(
      title: 'Insert Location',
      name: '',
      dx: '0.0',
      dy: '0.0',
      onSave: (name, dx, dy) {
        setState(() {
          _locations.add(Location(
            coordinates: Offset(double.parse(dx), double.parse(dy)),
            name: name.isEmpty ? "Location ${_locations.length + 1}" : name,
          ));
        });
        listSetState(() {}); // Update the list view
      },
    );
  }

  void _editLocation(int index, StateSetter listSetState) {
    final location = _locations[index];
    _showLocationDialog(
      title: 'Edit Location',
      name: location.name,
      dx: location.coordinates.dx.toString(),
      dy: location.coordinates.dy.toString(),
      onSave: (name, dx, dy) {
        setState(() {
          _locations[index] = Location(
            coordinates: Offset(double.parse(dx), double.parse(dy)),
            name: name.isEmpty ? "Location ${_locations.length}" : name,
          );
        });
        listSetState(() {}); // Update the list view
      },
    );
  }

  void _showLocationDialog({
    required String title,
    required String name,
    required String dx,
    required String dy,
    required void Function(String name, String dx, String dy) onSave,
  }) {
    final TextEditingController nameController =
        TextEditingController(text: name);
    final TextEditingController dxController = TextEditingController(text: dx);
    final TextEditingController dyController = TextEditingController(text: dy);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'name'),
                keyboardType: TextInputType.text,
              ),
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
                onSave(
                    nameController.text, dxController.text, dyController.text);
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
                  title: Text(location.name),
                  subtitle: Text(
                      '(${location.coordinates.dx.toStringAsFixed(2)}, ${location.coordinates.dy.toStringAsFixed(2)})'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _editLocation(index, setState);
                    },
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _locations.removeAt(index);
                        // update list
                        this.setState(() {});
                      });
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

  void _showUsers() async {
    try {
      final users = await _userApi.getAllUsers();
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('All Users'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user.username),
                    subtitle: Text('Role: ${user.role ?? 'N/A'}'),
                    trailing: Text('ID: ${user.id}'),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load users: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          title: const Text('Chinatown Sites'),
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
                        left: location.coordinates.dx * imageSize.width,
                        top: location.coordinates.dy * imageSize.height,
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
              heroTag: 'locationInsertBtn',
              onPressed: () => _insertLocation(setState),
              tooltip: 'Increment',
              child: Text(_locations.length.toString()),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'locationsListBtn',
              onPressed: _showLocationsList,
              tooltip: 'Show Locations',
              child: const Icon(Icons.list),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'usersListBtn',
              onPressed: _showUsers,
              tooltip: 'Show Users',
              child: const Icon(Icons.people),
            ),
          ],
        ),
      ),
    );
  }
}
