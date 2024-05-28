import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/dialogs/add_nutrients_dialog.dart';
import 'package:sheff_andrew/dialogs/generic_label_dialog.dart';
import 'package:sheff_andrew/providers/recipe_form_provider.dart';
import 'package:sheff_andrew/screens/add_recipe/components/label_builder.dart';

class RecipeAdditionalInformation extends StatefulWidget {
  const RecipeAdditionalInformation({super.key});

  @override
  _RecipeAdditionalInformationState createState() =>
      _RecipeAdditionalInformationState();
}

class _RecipeAdditionalInformationState
    extends State<RecipeAdditionalInformation> {
  @override
  Widget build(BuildContext context) {
    final providerWatcher = context.watch<RecipeFormProvider>();
    final providerReader = context.read<RecipeFormProvider>();

    return Container(
      margin: const EdgeInsets.only(left: 3, right: 3),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Additional Information",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: providerReader.caloriesController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  // Allows digits, optional '.', and digits after '.'
                  RegExp(r'^\d*\.?\d*$'),
                ),
              ],
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Calories',
                labelStyle: GoogleFonts.poppins(),
                icon: const Icon(Icons.flash_on),
              ),
              validator: (value) {
                if ((value != null && value.isNotEmpty) &&
                    (value[value.length - 1] == '.')) {
                  return "Please enter proper value";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            LabelBuilder(
              title: "Diet Labels",
              labels: providerWatcher.dietLabels,
              onAddPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const GenericLabelDialog(topic: 'diet');
                    });
              },
              onRemovePressed: (index) {
                providerReader.removeDietLabel(index);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            LabelBuilder(
              title: "Health Labels",
              labels: providerWatcher.healthLabels,
              onAddPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const GenericLabelDialog(topic: 'health');
                    });
              },
              onRemovePressed: (index) {
                providerReader.removeHealthLabel(index);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Total Nutrients",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AddNutrientsDialog();
                              });
                        },
                        icon: const Icon(Icons.add_circle),
                      )
                    ],
                  ),
                  Visibility(
                    visible: providerWatcher.totalNutrients.isNotEmpty,
                    child: const SizedBox(
                      height: 10,
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: providerWatcher.totalNutrients
                        .asMap()
                        .entries
                        .map((entry) {
                      int index = entry.key;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 1,
                        child: ListTile(
                          title: Text(
                            providerWatcher.totalNutrients[index].label,
                            style: GoogleFonts.poppins(),
                          ),
                          subtitle: Text(
                            '${providerWatcher.totalNutrients[index].quantity} ${providerWatcher.totalNutrients[index].unit}',
                            style: GoogleFonts.poppins(),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              providerReader.removeNutrients(index);
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            LabelBuilder(
              title: 'Cautions',
              labels: providerWatcher.cautions,
              onAddPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const GenericLabelDialog(topic: 'caution');
                    });
              },
              onRemovePressed: (index) {
                providerReader.removeCaution(index);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            LabelBuilder(
              title: 'Tags',
              labels: providerWatcher.tags,
              onAddPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const GenericLabelDialog(topic: 'tag');
                    });
              },
              onRemovePressed: (index) {
                providerReader.removeTag(index);
              },
            )
          ],
        ),
      ),
    );
  }
}
