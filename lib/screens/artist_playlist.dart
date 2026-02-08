import 'package:flutter/material.dart';
import 'package:marshall/widgets/bottomnavigations.dart';

class ArtistPlaylist extends StatefulWidget {
  final dynamic artistId;
  final String artistName;
  const ArtistPlaylist({super.key, this.artistId, required this.artistName});

  @override
  State<ArtistPlaylist> createState() => _ArtistPlaylistState();
}

class _ArtistPlaylistState extends State<ArtistPlaylist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(onTap: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Bottomnavigations(),));
        },child: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset("assets/backgroundGreen.png", fit: BoxFit.fill),
          ),
          Column(
            children: [
              Container(
                width: double.maxFinite,
                height: 350,
                color: Colors.white10,
              ),
             const SizedBox(height: 25,),
              Row(
                children: [
                  const SizedBox(width: 25,),
                  Text(
                    "Popular",
                    style: TextStyle(
                      fontFamily: "semi",
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              //------------------

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Row(
                      children: [
                        Text(
                          "1",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: "semi",
                          ),
                        ),                        SizedBox(width: 15,),
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

                    Icon(Icons.more_vert_outlined,color: Colors.white,),

                  ],
                ),
              )

            ],
          ),

        ],
      ),
    );
  }
}
