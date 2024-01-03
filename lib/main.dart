import 'package:flutter/material.dart';
import 'package:popping_toggle_button/components/popping_toggle_button.dart';

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
      title: 'Popping Toggle Button',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Popping Toggle Button'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _count = 0;
  bool _isTapped = false;
  bool _isDefault = true;
  double _buttonSize = 60;
  double _particleSize = 30;
  double _endRadius = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PoppingToggleButton(
                  firstButton: Icon(
                    Icons.favorite_border_rounded,
                    size: _buttonSize,
                    color: Colors.red,
                  ),
                  secondButton: Icon(
                    Icons.favorite_rounded,
                    size: _buttonSize,
                    color: Colors.red,
                  ),
                  onTap: () {
                    setState(() {
                      if (!_isTapped) {
                        _count += 1;
                      }
                      _isTapped = !_isTapped;
                    });
                  },
                  customParticle: _isDefault
                      ? null
                      : Icon(
                          Icons.favorite_rounded,
                          size: _particleSize,
                          color: Colors.purpleAccent,
                        ),
                  particleSize: _particleSize,
                  endRadius: _endRadius,
                  milliseconds: 1000,
                ),
                Text("$_count likes"),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Slider(
                    value: _buttonSize,
                    onChanged: (buttonSize) {
                      setState(() {
                        _buttonSize = buttonSize;
                      });
                    },
                    min: 20,
                    max: 100,
                  ),
                ),
                Text("Button Size: ${_buttonSize.toStringAsFixed(2)}"),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Slider(
                    value: _particleSize,
                    onChanged: (particleSize) {
                      setState(() {
                        _particleSize = particleSize;
                      });
                    },
                    min: 10,
                    max: 50,
                  ),
                ),
                Text("Particle Size: ${_particleSize.toStringAsFixed(2)}"),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Slider(
                    value: _endRadius,
                    onChanged: (endRadius) {
                      setState(() {
                        _endRadius = endRadius;
                      });
                    },
                    min: 10,
                    max: 50,
                  ),
                ),
                Text("Radius: ${_endRadius.toStringAsFixed(2)}"),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.resolveWith(
                      (states) => const EdgeInsets.all(10),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) =>
                          Theme.of(context).colorScheme.secondaryContainer,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _count = 0;
                      _isDefault = true;
                      _buttonSize = 60;
                      _particleSize = 30;
                      _endRadius = 30;
                    });
                  },
                  child: const Text("Reset"),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isDefault = !_isDefault;
          });
        },
        child: _isDefault
            ? const Icon(Icons.switch_left_rounded)
            : const Icon(Icons.switch_right_rounded),
      ),
    );
  }
}
