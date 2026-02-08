import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marshall/screens/library.dart';
import 'package:marshall/screens/homepage.dart';
import 'package:marshall/screens/search.dart';
import '../services/audio_services.dart';
import 'bottom_music.dart';
class Bottomnavigations extends StatefulWidget {
  const Bottomnavigations({super.key});
  @override
  State<Bottomnavigations> createState() => _BottomnavigationsState();
}
class _BottomnavigationsState extends State<Bottomnavigations> {
  int _selectedIndex = 0;
  final List<Widget> _pages = const [
    Onboard(),
    SearchScreen(),
    Library(),
  ];
  final List<Widget> _navItems = const [
    Icon(Icons.music_note_outlined),
    Icon(CupertinoIcons.search),
    ImageIcon(AssetImage('assets/library.png')),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          if (AudioService.currentSong != null)
            const Positioned(
              left: 16,
              right: 16,
              bottom: 100,
              child: BottomMusicBar(),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double itemSpacing =
                constraints.maxWidth / _navItems.length;
            return Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFF5628F8).withOpacity(0.2),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    left: itemSpacing * _selectedIndex +
                        itemSpacing / 2 -
                        40,
                    top: 5,
                    child: Container(
                      width: 80,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5628F8).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(_navItems.length, (index) {
                      return GestureDetector(
                        onTap: () => _onItemTapped(index),
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              _selectedIndex == index
                                  ? const Color(0xFF5628F8)
                                  : Colors.white,
                              BlendMode.srcIn,
                            ),
                            child: _navItems[index],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
