import 'package:flutter/material.dart';
import 'package:zo_collection_animation/zo_collection_animation.dart';

void main() {
  runApp(const MyApp());
}

/// Root of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reusable Coin Animation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

/// HomePage demonstrating usage of CoinEmitter and CoinDestination
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _coinDestKey = GlobalKey();
  int coinCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Collector'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ZoDestination(
              key: _coinDestKey,
              onCoinArrived: () {}, // Optional, already handled in emitter
              child: Row(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    '$coinCount',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Builder(
          builder: (context) {
            return ZoSource(
              destinationKey: _coinDestKey,
              collectionWidget: Container(
                width: 100,
                height: 100,
                color: Colors.red,
              ),
              onAnimationComplete: () {
                setState(() {
                  coinCount++;
                });
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    "Tap to Collect",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
