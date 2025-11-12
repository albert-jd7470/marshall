import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marshall/screens/library.dart';
import 'package:marshall/screens/onboard.dart';
import 'package:marshall/screens/search.dart';
import '../models/search_models.dart';
import '../services/audio_services.dart';
import 'bottom_music.dart';


class Bottomnavigations extends StatefulWidget {
  final Result? currentSong;
  const Bottomnavigations({super.key, this.currentSong});
  @override
  State<Bottomnavigations> createState() => _BottomnavigationsState();
}
class _BottomnavigationsState extends State<Bottomnavigations> {
  Result? currentlyPlayingSong;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final List<Widget> _pages = const [
    Onboard(),
    SearchScreen(),
    Library(),
  ];
  final List<Widget> _navItems = [
    Icon(Icons.music_note_outlined),
    Icon(CupertinoIcons.search),
    ImageIcon(AssetImage('assets/library.png')),
  ];
  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body:  Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          if (AudioService.currentSong != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 100,
              child: const BottomMusicBar(),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double totalWidth = constraints.maxWidth;
            double itemSpacing = totalWidth / _navItems.length;

            return Container(
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                color: Colors.white10,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Moving highlight circle
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    left: itemSpacing * _selectedIndex + itemSpacing / 2 - 30,
                    top: 5,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Nav items Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(_navItems.length, (index) {
                      return GestureDetector(
                        onTap: () => _onItemTapped(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(8),
                          child: SizedBox(
                            width: _selectedIndex == index ? 32 : 28,
                            height: _selectedIndex == index ? 32 : 28,
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                _selectedIndex == index
                                    ? Colors.white
                                    : Colors.white70,
                                BlendMode.srcIn,
                              ),
                              child: _navItems[index],
                            ),
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
