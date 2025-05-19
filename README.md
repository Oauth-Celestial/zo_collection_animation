# zo_collection_animation

A lightweight Flutter package to create smooth "collect" animations — perfect for gamification, reward systems, add to cart . Animate widgets (like coins, stars, or points) from one widget to another with customizable effects.

## Getting started

First, add `zo_collection_animation` as a dependency in your pubspec.yaml file.

```dart
dependencies:
  flutter:
    sdk: flutter
  zo_collection_animation: ^[version]
```

## Import the package

```dart
import 'package:zo_collection_animation/zo_collection_animation.dart'
```

# Usage

**1. Create Global Key**

```dart
final GlobalKey _coinDestKey = GlobalKey();
```

**2.Wrap your source widget with `ZoCollectionSource`**.

```dart
ZoCollectionSource(
  destinationKey: _coinDestKey,
  count: 5,
  collectionWidget: Icon(
    Icons.monetization_on,
    color: Colors.amber,
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
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    ),
  ),
);

```

**3. Wrap your destination widget with `ZoCollectionDestination`**.

```dart
ZoCollectionDestination(
  key: _coinDestKey,
  child: Row(
    children: [
      const Icon(
        Icons.monetization_on,
        color: Colors.amber,
      ),
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
);

```

Feel free to post a feature requests or report a bug [here](https://github.com/Oauth-Celestial/zo_collection_animation/issues).

## My Other packages

- [zo_animated_border](https://pub.dev/packages/zo_animated_border): A package that provides a modern way to create gradient borders with animation in Flutter
- [zo_screenshot](https://pub.dev/packages/zo_screenshot): The zo_screenshot plugin helps restrict screenshots and screen recording in Flutter apps, enhancing security and privacy by preventing unauthorized screen captures.
- [connectivity_watcher](https://pub.dev/packages/connectivity_watcher): A Flutter package to monitor internet connectivity with subsecond response times, even on mobile networks.
- [ultimate_extension](https://pub.dev/packages/ultimate_extension): Enhances Dart collections and objects with utilities for advanced data manipulation and simpler coding.
- [theme_manager_plus](https://pub.dev/packages/theme_manager_plus): Allows customization of your app's theme with your own theme class, eliminating the need for traditional
- [date_util_plus](https://pub.dev/packages/date_util_plus): A powerful Dart API designed to augment and simplify date and time handling in your Dart projects.
- [pick_color](https://pub.dev/packages/pick_color): A Flutter package that allows you to extract colors and hex codes from images with a simple touch.
