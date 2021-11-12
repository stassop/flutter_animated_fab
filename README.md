# Flutter Animated Floating Action Button

This article will help you build a `FloatingActionButton` that changes its properties using animations.

![Flutter Hero Page Route](flutter_animated_fab.gif)

It looks much better live, I promise.

## Getting Started

To run the project open the iPhone simulator and run `flutter run`.

This article assumes basic knowledge of [Flutter](https://flutter.dev/) and [Dart](https://dart.dev/).

You can find the complete project [here](https://github.com/stassop/flutter_animated_fab).

## The Premise

Sometimes you want to dynamically change the appearance of a `FloatingActionButton` in order to draw the user's attention to it or to let the user know that the primary action has changed.

At the same time, you probably want to isolate the animation in a separate widget, and keep it agnostic of the button contents so that whenever the button is updated, the animation knows what to do regardless of the change.

## Implementation

Let's consider the simple example above. At the top level, `AnimatedFAB` repeats the familiar `FloatingActionButton` syntax and accepts the same properties:

```
@override
Widget build(BuildContext context) {
  return Scaffold(
    floatingActionButton: AnimatedFAB(
      onPressed: toggleDarkMode,
      foregroundColor: isDarkMode ? Colors.black : Colors.white,
      backgroundColor: isDarkMode ? Colors.white : Colors.black,
      child: isDarkMode ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
    ),
  );
}
```

Under the hood, `AnimatedFAB` saves the initial properties in the state, and watches for changes by overriding the `didUpdateWidget` method. When any of the properties change, it starts the animation, waits for it to finish, then reverses it and updates the state. This makes the button briefly disappear and pop up again with updated properties:

```
@override
void didUpdateWidget(AnimatedFAB oldWidget) {
  super.didUpdateWidget(oldWidget);

  if (widget.child != child
   || widget.foregroundColor != foregroundColor
   || widget.backgroundColor != backgroundColor
  ) {
    controller.reset();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          child = widget.child;
          foregroundColor = widget.foregroundColor;
          backgroundColor = widget.backgroundColor;
        });
        controller.reverse();
      }
    });
    controller.forward();
  }
}
```

`AnimatedFAB` wraps a `FloatingActionButton` in a `FABTransition`, that handles the transitions using an `AnimationController` it receives as a property. `FABTransition` extends `AnimatedWidget`, which can run multiple animations using the same controller:

```
class FABTransition extends AnimatedWidget {
  FABTransition({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key, listenable: animation);

  final Animation<double> animation;
  final Widget child;

  static final opacityTween = Tween<double>(begin: 1, end: 0);
  static final sizeTween = Tween<double>(begin: 1, end: 0);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Opacity(
      opacity: opacityTween.evaluate(animation).clamp(0.0, 1.0),
      child: Transform.scale(
        scale: sizeTween.evaluate(animation),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
```

Note that is uses the `clamp()` method to limit opacity to the expected values in order to avoid an error.

## Conclusion

There are [multiple ways](https://flutter.dev/docs/development/ui/animations/tutorial) to animate widgets in Flutter. It's often simpler than it seems. 
