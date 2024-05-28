/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Procedure for Recipe Form
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/dialogs/add_step_dialog.dart';
import 'package:sheff_andrew/providers/recipe_form_provider.dart';

class RecipeProcedure extends StatefulWidget {
  const RecipeProcedure({super.key});

  @override
  _RecipeProcedureState createState() => _RecipeProcedureState();
}

class _RecipeProcedureState extends State<RecipeProcedure> {
  @override
  Widget build(BuildContext context) {
    final providerWatcher = context.watch<RecipeFormProvider>();
    final providerReader = context.read<RecipeFormProvider>();

    bool showGuide = providerWatcher.steps.isEmpty;

    return Container(
      margin: const EdgeInsets.only(left: 3, right: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Procedure",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Visibility(
                  visible: !showGuide,
                  child: IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AddStepDialog();
                        },
                      );
                    },
                  )),
            ],
          ),
          const SizedBox(height: 20),
          Visibility(
            visible: showGuide,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Tap the icon to add",
                    style: GoogleFonts.poppins(fontSize: 22),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AddStepDialog();
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.add_circle,
                        size: 75,
                      ))
                ],
              ),
            ),
          ),
          Visibility(
              visible: !showGuide,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: providerWatcher.steps.asMap().entries.map((entry) {
                  int index = entry.key;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    elevation: 1,
                    child: ListTile(
                      title: Text(
                        providerWatcher.steps[index],
                        style: GoogleFonts.poppins(),
                      ),
                      leading: Text(
                        (index + 1).toString(),
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          providerReader.removeStep(index);
                        },
                      ),
                    ),
                  );
                }).toList(),
              ))
        ],
      ),
    );
  }
}
