import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.active,
    required this.child,
    required this.func,
  }) : super(key: key);

  final bool active;
  final Widget child;
  final Function() func;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: MaterialButton(
        onPressed: func,
        color: active ? Colors.blueAccent : Colors.white,
        shape: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}
