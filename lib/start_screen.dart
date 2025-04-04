import 'package:flutter/material.dart';
import 'package:mmm_construction_site_manager/map.dart' as map;

/* -------------------------------------------------------------------------- */
/*                                Actual Screen                               */
/* -------------------------------------------------------------------------- */

class StartScreen extends StatefulWidget {
  const StartScreen({super.key, required this.title});

  final String title;

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: StartScreenAnimation(),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                  Animation                                 */
/* -------------------------------------------------------------------------- */

class StartScreenAnimation extends StatefulWidget {
  const StartScreenAnimation({super.key});

  @override
  State<StartScreenAnimation> createState() => _StartScreenAnimationState();
}

class _StartScreenAnimationState extends State<StartScreenAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  bool _showText = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(.0, 1.5),
      end: const Offset(.0, -.2),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Update the state to show the text after animation finishes
        setState(() {
          _showText = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // NOTE: we're using a scroll view to allow the overflow but we want to lock it
      // TOTEST: the scroll seems to be locked
      physics: const NeverScrollableScrollPhysics(),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SlideTransition(
              position: _offsetAnimation,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Image(image: AssetImage("assets/Buildings_shape.png")),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: _showText
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome to the Construction Site Manager!',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 50),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const map.SideGame(),
                            ),
                          );
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  )
                : const SizedBox(height: 65),
          ),
        ],
      ),
    );
  }
}
