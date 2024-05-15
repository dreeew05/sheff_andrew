import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheff_andrew/common/utils/app_painter.dart';

class FeaturedRecipe extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const FeaturedRecipe({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    AppPainter appPainter = AppPainter();
    return Container(
      height: 255,
      width: 175,
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                margin: const EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                    color: appPainter.getCardColor(),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Container(
                  margin: const EdgeInsets.only(top: 50),
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 10),
                  child: Column(
                    children: [
                      Text(recipe['name'] as String,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.poppins(
                            color: appPainter.getCardTextColor(),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      const Padding(padding: EdgeInsets.only(top: 25)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Time",
                            style: GoogleFonts.poppins(
                              color: appPainter.getCardTextColor(),
                              fontSize: 14,
                            )),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Row(
                        children: [
                          Text(recipe['time_to_cook'].toString(),
                              style: GoogleFonts.poppins(
                                color: appPainter.getCardTextColor(),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      )
                    ],
                  ),
                )),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircleAvatar(
                    radius: 100,
                    backgroundColor: appPainter.getCardColor(),
                    child: SizedBox(
                      height: 90,
                      width: 90,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(recipe['image'] as String)
                            as ImageProvider<Object>?,
                      ),
                    )),
              )),
        ],
      ),
    );
  }
}
