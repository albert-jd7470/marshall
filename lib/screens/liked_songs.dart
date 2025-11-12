import 'package:flutter/material.dart';

import 'bottomnavigations.dart';

class LikedSongs extends StatefulWidget {
  const LikedSongs({super.key});

  @override
  State<LikedSongs> createState() => _LikedSongsState();
}

class _LikedSongsState extends State<LikedSongs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context
            );
          },
          child: const Image(
            image: AssetImage("assets/Hide.png"),
            color: Colors.white,
          ),
        ),

        centerTitle: true,
        actions: const [],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset("assets/backgroundWhite.png", fit: BoxFit.fill),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150, left: 20, right: 20),
            //-------BodyStart----------
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Liked Songs",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: "semi",
                      ),
                    ),
                    Text(
                      "100 Songs",
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 15,
                        fontFamily: "semi",
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: Stack(
                        children: [
                          Image(image: AssetImage("assets/Play.png"),
                          ),
                          Positioned(bottom: 0,right: 0,
                              child: Image(image: AssetImage("assets/Shuffle.png")))
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 50,),
                Container(
                  width: double.maxFinite,
                  height: 100,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white10
                            ),
                          ),
                          SizedBox(width: 15,),
                          Column(mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ModeModeModeMode",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "semi",
                                ),
                              ),
                              Text(
                                "Sai Abhyankkar",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 14,
                                  fontFamily: "semi",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Icon(Icons.favorite,color: Colors.green,),
                      Icon(Icons.more_vert_outlined,color: Colors.white,),

                    ],
                  ),
                )

              ],
            ),
            //-------BodyEnd----------

          ),
        ],
      ),
    );
  }
}
