import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/dialogs/add_ingredient_dialog.dart';
import 'package:sheff_andrew/providers/recipe_form_provider.dart';

class RecipeIngredients extends StatefulWidget {
  const RecipeIngredients({super.key});

  @override
  _RecipeIngredientsState createState() => _RecipeIngredientsState();
}

class _RecipeIngredientsState extends State<RecipeIngredients> {
  @override
  Widget build(BuildContext context) {
    final providerWatcher = context.watch<RecipeFormProvider>();
    final providerReader = context.read<RecipeFormProvider>();

    bool showGuide = providerWatcher.ingredients.isEmpty;

    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Ingredients",
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
                          return const AddIngredientDialog();
                        },
                      );
                    },
                  )),
            ],
          ),
          const SizedBox(height: 20),
          Visibility(
              visible: showGuide,
              child: Expanded(
                child: Container(
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
                                return const AddIngredientDialog();
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
              )),
          Visibility(
              visible: !showGuide,
              child: Expanded(
                child: ListView.builder(
                  itemCount: providerWatcher.ingredients.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          providerWatcher.ingredients[index].label,
                          style: GoogleFonts.poppins(),
                        ),
                        subtitle: Text(
                          '${providerWatcher.ingredients[index].quantity} ${providerWatcher.ingredients[index].unit}',
                          style: GoogleFonts.poppins(),
                        ),
                        leading: providerWatcher.ingredients[index].image !=
                                null
                            ? (providerWatcher.ingredients[index].isImageFile()
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(
                                        providerWatcher
                                            .ingredients[index].image!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        providerWatcher
                                            .ingredients[index].image!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ))
                            : const Icon(Icons.fastfood),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            providerReader.removeIngredient(index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ))
        ],
      ),
    );
  }
}
