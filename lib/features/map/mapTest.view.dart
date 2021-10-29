import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvp_proex/features/widgets/person.widget.dart';

class MapTestView extends StatefulWidget {
  const MapTestView({Key? key}) : super(key: key);

  @override
  State<MapTestView> createState() => _MapTestViewState();
}

class _MapTestViewState extends State<MapTestView> {
  double scaleFactor = 1.5;
  bool flag = true;
  double top = 50, left = -450;

  final Widget svg = SvgPicture.asset(
    "assets/maps/reitoria/mapaTeste.svg",
    color: Colors.blue[900],
    fit: BoxFit.none,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Teste'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            top += details.delta.dy;
            left += details.delta.dx;
          });
        },
        onDoubleTap: () {
          setState(() {
            if (flag) {
              scaleFactor *= 2;
              flag = false;
            } else {
              scaleFactor *= 1 / 2;
              flag = true;
            }
          });
        },
        onPanDown: (details) {
          setState(() {
            //pegar localização x, y da tela, no click
            print(MediaQuery.of(context).size);
            print(details.localPosition);
            //img x = 800 e y = 600
            //img obj x = 639 e y = 274
            //ob x = -450 e y = 50

            /*
              tam_img.x / 358 = !
              
            */
          });
        },
        child: Transform.scale(
          scale: scaleFactor,
          child: Stack(
            children: [
              Positioned(
                top: top,
                left: left,
                child: Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  child: Stack(
                    children: [
                      svg,
                      const PersonWidget(
                        top: 274,
                        left: 639,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
