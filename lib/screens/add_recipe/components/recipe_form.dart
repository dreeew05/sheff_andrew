/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Instantiatable class that creates a form for adding/modifying a recipe
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/common/utils/app_painter.dart';
import 'package:sheff_andrew/dialogs/form_error_dialog.dart';
import 'package:sheff_andrew/providers/recipe_form_provider.dart';
import 'package:sheff_andrew/screens/add_recipe/components/recipe_additional_information.dart';
import 'package:sheff_andrew/screens/add_recipe/components/recipe_details.dart';
import 'package:sheff_andrew/screens/add_recipe/components/recipe_ingredients.dart';
import 'package:sheff_andrew/screens/add_recipe/components/recipe_procedure.dart';

class RecipeForm extends StatefulWidget {
  const RecipeForm({super.key});

  @override
  RecipeFormState createState() => RecipeFormState();
}

class RecipeFormState extends State<RecipeForm> {
  int _currentIndex = 0;

  bool get isFirstStep => _currentIndex == 0;
  bool get isLastStep => _currentIndex == stepWidgets().length - 1;

  // Steps
  List<Step> stepWidgets() => [
        Step(
          isActive: _currentIndex == 0,
          state: _currentIndex > 0 ? StepState.complete : StepState.indexed,
          title: const Icon(Icons.description),
          content: const RecipeDetails(),
        ),
        Step(
          isActive: _currentIndex == 1,
          state: _currentIndex > 1 ? StepState.complete : StepState.indexed,
          title: const Icon(Icons.local_offer),
          content: const RecipeIngredients(),
        ),
        Step(
          isActive: _currentIndex == 2,
          state: _currentIndex > 2 ? StepState.complete : StepState.indexed,
          title: const Icon(Icons.format_list_numbered),
          content: const RecipeProcedure(),
        ),
        Step(
          isActive: _currentIndex == 3,
          title: const Icon(Icons.info),
          content: const RecipeAdditionalInformation(),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final AppPainter appPainter = AppPainter();
    final providerWatcher = context.watch<RecipeFormProvider>();

    void isActionValid(int nextIndex) {
      bool proceedNext = _currentIndex >= nextIndex;
      if (!proceedNext) {
        switch (_currentIndex) {
          case 0:
            if (providerWatcher.formKey.currentState!.validate()) {
              proceedNext = true;
            }
            break;
          case 1:
          // Falls through
          case 2:
            final isEmpty = _currentIndex == 1
                ? providerWatcher.ingredients.isEmpty
                : providerWatcher.steps.isEmpty;
            if (isEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FormErrorDialog(
                        labelType:
                            _currentIndex == 1 ? 'Ingredients' : 'Procedure');
                  });
            } else {
              proceedNext = true;
            }
          case 3:
            proceedNext = true;
          default:
            break;
        }
      }
      if (proceedNext) {
        setState(() {
          _currentIndex = nextIndex;
        });
      }
    }

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stepper(
        currentStep: _currentIndex,
        type: StepperType.horizontal,
        steps: stepWidgets(),
        onStepCancel: () {
          isFirstStep
              ? null
              : setState(() {
                  _currentIndex -= 1;
                });
        },
        onStepContinue: () {
          if (isLastStep) {
          } else {
            isActionValid(_currentIndex + 1);
          }
        },
        onStepTapped: (int nextIndex) {
          isActionValid(nextIndex);
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                if (!isFirstStep) ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appPainter.getPrimaryWhite(),
                        foregroundColor: appPainter.getPrimaryLavender(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        'Back',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (isLastStep) {
                        providerWatcher.submitForm(context);
                      } else {
                        details.onStepContinue!();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appPainter.getPrimaryLavender(),
                      foregroundColor: appPainter.getPrimaryWhite(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      isLastStep ? 'Submit' : 'Next',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
