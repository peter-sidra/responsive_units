import 'package:flutter/material.dart';
import 'package:responsive_units/responsive_units.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => AppSizer(
        child: child,
      ),
      home: const ResponsiveBox(),
    );
  }
}

class ResponsiveBox extends StatelessWidget {
  const ResponsiveBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: Center(
        child: Container(
          width: 50.w,
          height: 50.h,
          color: Colors.lightGreen,
          child: Center(
            child: Text(
              "This box (and text) scales with the window size",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  ?.copyWith(fontSize: 4.dg.sp, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
