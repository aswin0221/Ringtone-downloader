import 'package:flutter/material.dart';

class LoadingManager {
  static bool showProgress = true;
}

class CIrculaIndicater extends StatefulWidget {
  const CIrculaIndicater({super.key});

  @override
  State<CIrculaIndicater> createState() => _CIrculaIndicaterState();
}

class _CIrculaIndicaterState extends State<CIrculaIndicater> {
  bool showProgress = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Use a Future.delayed with setState to trigger a rebuild
    Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
      setState(() {
        LoadingManager.showProgress = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return showProgress
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: Colors.blue.shade900,
              strokeWidth: 10,
            ),
          )
        : Icon(Icons.pause);
  }
}
