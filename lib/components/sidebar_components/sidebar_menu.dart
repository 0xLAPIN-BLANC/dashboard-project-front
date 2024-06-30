// lib
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

// Pages
import 'package:main_project/components/sidebar_components/autocomplet_component.dart';

// types
import 'package:main_project/types/games_data.dart';

// types def
typedef IntCallback = void Function(int appId);



class SideBar extends StatefulWidget {
  final IntCallback onGameSelection;
  final List<GameData> gamesData;

  const SideBar(
      {super.key, required this.onGameSelection, required this.gamesData});

  @override
  State<SideBar> createState() => _SideBarState();
}


class _SideBarState extends State<SideBar> {
  bool isExtended = false;

  void extend() {
    setState(() {
      isExtended = !isExtended;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> nameOptions = widget.gamesData.map((game) => game.name.toLowerCase()).toList();
    double maxWidth = isExtended ? 300 : 70;

    int nbrOfGames = widget.gamesData.length;
    int maxNbrLinesPossible = ((MediaQuery.of(context).size.height) /80).floor();
    int nbrLines = nbrOfGames != 0 ? (nbrOfGames > maxNbrLinesPossible ? maxNbrLinesPossible : nbrOfGames) : 1;
    //List<IntrinsicContentTrackSize> rowSizes = List.filled(nbrLines, 1.fr);

    return GestureDetector(
      onTap: extend,

      child: AnimatedContainer(
        width: maxWidth,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,

        child: LayoutGrid(
          columnSizes: [1.fr],
          rowSizes: [70.px, 1.fr],

          rowGap: 20,

          children: [

            Container(
              width: double.maxFinite,
              height: double.maxFinite,

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  color: const Color(0xff0F3D2F)
              ),

              child: Container(
                margin: const EdgeInsets.all(15),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1000)
                ),

                child: const Padding(
                  padding: EdgeInsets.only(left: 7.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.search, color: Colors.black,)
                  ),
                ),
              )
            ),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xff0D1612)
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// image: const DecorationImage(
//   image: AssetImage('images/Liquid-Bg-Green.jpg'),
//   fit: BoxFit.cover,
// ),



// ElevatedButton(
//   style: const ButtonStyle(
//     elevation: WidgetStatePropertyAll(0),
//     padding: WidgetStatePropertyAll(EdgeInsets.zero),
//     backgroundColor: WidgetStatePropertyAll(Colors.transparent),
//     overlayColor: WidgetStatePropertyAll(Colors.transparent),
//   ),
//   onPressed: () {
//     extend();
//   },
//   child: Padding(
//     padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
//     child: LayoutGrid(
//
//       columnSizes: [1.fr],
//       rowSizes: [auto, 1.fr],
//
//       rowGap: 100,
//
//       children: [
//         if (isExtended)
//           AutocompleteWidget(
//             nameOptions: nameOptions,
//             onGameSelection: widget.onGameSelection,
//           )
//         else
//           Container(
//               width: double.maxFinite,
//               height: 50,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(100),
//               ),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: ElevatedButton(
//                     style: const ButtonStyle(
//                       elevation: MaterialStatePropertyAll(0),
//                       padding: MaterialStatePropertyAll(EdgeInsets.zero),
//                       backgroundColor: MaterialStatePropertyAll(Colors.transparent),
//                       overlayColor: MaterialStatePropertyAll(Colors.transparent),
//                     ),
//                     onPressed: extend,
//                     child: const Icon(Icons.search,color: Colors.black,)
//                 ),
//               )
//           ),
//
//         // MAXIME PART !!!
//         LayoutGrid(
//           columnSizes: [1.fr],
//           rowSizes: List.filled(nbrLines, 1.fr),
//           rowGap: 10,
//
//           children: List<Widget>.generate(nbrLines, (int index) => AnimatedIconButton(isExtended: isExtended,icon: Icons.add,color: Colors.black,data: widget.gamesData.isNotEmpty?widget.gamesData[index].name: "", appId: index, onPressedCallback: widget.onGameSelection)), // Empty initially
//         )
//       ],
//     ),
//   ),
// ),



class ExtendButton extends StatelessWidget {
  final bool isExtended;
  final VoidCallback onPressedExtendedButton;

  const ExtendButton(
      {super.key,
      required this.isExtended,
      required this.onPressedExtendedButton});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        style: const ButtonStyle(
            fixedSize: WidgetStatePropertyAll(Size.square(45)),
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
            backgroundColor: WidgetStatePropertyAll(Colors.white),
            shape: WidgetStatePropertyAll(CircleBorder())),
        onPressed: onPressedExtendedButton,
        child: Icon(isExtended ? Icons.arrow_back : Icons.arrow_forward,
            color: Colors.black),
      ),
    );
  }
}

class AnimatedIconButton extends StatelessWidget {
  final bool isExtended;

  final IconData icon;
  final Color color;
  final String data;

  final int appId;
  final IntCallback onPressedCallback;

  const AnimatedIconButton(
      {super.key,
      required this.isExtended,
      required this.icon,
      required this.color,
      required this.data,
      required this.appId,
      required this.onPressedCallback});

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      alignment: Alignment.center,
      excludeBottomFocus: true,
      firstChild: IconButtonClose(
        icon: icon,
        color: color,
        onPressed: () {
          onPressedCallback(appId);
        },
      ),
      firstCurve: Curves.easeOutExpo,
      secondChild: IconButtonOpen(
        icon: icon,
        color: color,
        data: data,
        onPressed: () {
          onPressedCallback(appId);
        },
      ),
      secondCurve: Curves.easeOutExpo,
      crossFadeState:
          isExtended ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 389),
    );
  }
}

class IconButtonClose extends StatelessWidget {
  final IconData icon;
  final Color color;

  final VoidCallback onPressed;

  const IconButtonClose(
      {super.key,
      required this.icon,
      required this.color,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 45,
        width: double.maxFinite,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(100)),
        child: ElevatedButton(
            onPressed: onPressed,
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.zero)),
            child: Icon(icon, color: color)));
  }
}

class IconButtonOpen extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String data;

  final VoidCallback onPressed;

  const IconButtonOpen(
      {super.key,
      required this.icon,
      required this.color,
      required this.data,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(icon, color: color),
            ),
            Expanded(
                child: Text(
              data,
              style: TextStyle(color: color),
              overflow: TextOverflow.fade,
            ))
          ],
        ),
      ),
    );
  }
}
