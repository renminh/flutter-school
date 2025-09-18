# Flutter Window Size
the size of the window can be used from the MediaQuery class
https://onlyflutter.com/how-to-get-the-screen-size-in-flutter/
https://api.flutter.dev/flutter/widgets/MediaQueryData-class.html

```dart
final Size size = MediaQuery.sizeOf(context);
final double width = size.width;
final double height = size.height;
```

---

# On Async
https://dart.dev/libraries/async/async-await

---

## On seperating audio service from music player

Music player is the implementation of the service it runs under (the audio service)
There is NO, ZERO, NADA, need to have both under the same file when they deal with seperate issues.
Music Player page is implemented for the UI while audio service is for the logic