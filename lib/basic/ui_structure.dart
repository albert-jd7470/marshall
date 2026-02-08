import 'package:flutter/material.dart';

class UiStructure extends StatefulWidget {
  const UiStructure({super.key});

  @override
  State<UiStructure> createState() => _UiStructureState();
}

class _UiStructureState extends State<UiStructure> {
  //----------colors
   Color neonBlue = Color(0xFF00E5FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions:  [

        ],
      ),
      extendBodyBehindAppBar: true,

      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset("assets/backgroundGreen.png", fit: BoxFit.fill),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 90),
            child: Column(
              children: [

              ],
            ),
          )
        ],
      ),
    );
  }
}
