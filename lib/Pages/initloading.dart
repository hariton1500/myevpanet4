import 'package:flutter/material.dart';
import 'package:myevpanet4/Helpers/localstorage.dart';
import 'package:myevpanet4/Pages/mainpage.dart';
import 'package:myevpanet4/globals.dart';

class InitLoading extends StatefulWidget {
  const InitLoading({super.key});

  @override
  State<InitLoading> createState() => _InitLoadingState();
}

class _InitLoadingState extends State<InitLoading> {
  double opacityLevel = 0.0;
  bool needReRegister = false;

  void _changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }
  void _loadAppState() async {
    needReRegister = await loadAppState();
    if (needReRegister) {
      appState['guids'] = [];
    }
  }

  @override
  void initState() {
    super.initState();
    //runInit();
    Future.delayed(const Duration(milliseconds: 100), () {
      _loadAppState();
    });
    Future.delayed(const Duration(seconds: 1), _changeOpacity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        //mainAxisAlignment: MainAxisAlignment.center,
        child: AnimatedOpacity(
          opacity: opacityLevel,
          curve: Curves.decelerate,
          duration: const Duration(seconds: 2),
          onEnd: () => Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const MainPage()));
          }),
          child: Text(
            'EvpaNet',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
      ),
    );
  }
}
