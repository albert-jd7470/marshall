import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marshall/screens/liked_songs.dart';

import 'bottomnavigations.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Library",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontFamily: "dot",
              ),
            ),
            SizedBox(width: 20,),
            Image(image: AssetImage("assets/library.png",),color: Colors.black54,)
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.black,
                border: Border.all(color: Colors.white)
              ),
              child: Center(
                child: Text("AJ",style: TextStyle(
                  fontFamily: "dot",
                  fontWeight: FontWeight.bold,color: Colors.white
                ),),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset("assets/backgroundWhite.png", fit: BoxFit.fill),
          ),
          //-------BodyHead-------------
          Padding(
            padding: const EdgeInsets.only(top: 150,left: 20,right: 20),
            child: Column(
              children: [
                Row(
                  children: [

                    GestureDetector(onTap:(){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  LikedSongs(),
                        ),
                      );
    },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white10
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Liked Songs",
                      style: TextStyle(
                        fontFamily: "semi",
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
               const SizedBox(height: 25,),
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
                    const SizedBox(width: 10),
                    Text(
                      "Party Songs",
                      style: TextStyle(
                        fontFamily: "semi",
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                )

              ],
            ),
          ),
          //-----------BodyClose
        ],
      ),
    );
  }
}
