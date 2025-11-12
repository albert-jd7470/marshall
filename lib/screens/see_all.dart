import 'package:flutter/material.dart';
import 'package:marshall/screens/bottomnavigations.dart';

class SeeAll extends StatefulWidget {
  const SeeAll({super.key});
  @override
  State<SeeAll> createState() => _SeeAllState();
}
class _SeeAllState extends State<SeeAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Bottomnavigations(),));
        },
            child: Icon(Icons.arrow_back_ios,color: Colors.black,)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: const [
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
