import 'package:flutter/material.dart';
import 'package:myevpanet4/Helpers/localstorage.dart';
import 'package:myevpanet4/Pages/mainpage.dart';

class InitLoading extends StatefulWidget {
  const InitLoading({super.key});

  @override
  State<InitLoading> createState() => _InitLoadingState();
}

class _InitLoadingState extends State<InitLoading> {
  double opacityLevel = 0.0;

  void _changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  @override
  void initState() {
    super.initState();
    runInit();
    Future.delayed(const Duration(seconds: 1), _changeOpacity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        //mainAxisAlignment: MainAxisAlignment.center,
        child: AnimatedOpacity(
          opacity: opacityLevel,
          duration: const Duration(seconds: 3),
          child: Text(
            'EvpaNet',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
      ),
    );
  }

  void runInit() async {
    loadAppState().then((value) {
      //print('init complete');
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MainPage()));
      });
    });
  }
}
