import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheff_andrew/common/components/network_image_check.dart';
import 'package:sheff_andrew/common/utils/constants.dart';

class IngredientCard extends StatefulWidget {
  final String image;
  final String name;
  final String quantity;
  final String unit;

  const IngredientCard({
    super.key,
    required this.image,
    required this.name,
    required this.quantity,
    required this.unit,
  });

  @override
  _IngredientCardState createState() => _IngredientCardState();
}

class _IngredientCardState extends State<IngredientCard> {
  String _imageLink = '';
  final NetworkImageCheck networkImageCheck = NetworkImageCheck();
  final Constants constants = Constants();

  @override
  void initState() {
    super.initState();
    _checkImageURL();
  }

  Future<void> _checkImageURL() async {
    String imageLink = '';
    if (widget.image.isNotEmpty) {
      imageLink = await networkImageCheck.checkImageURL(
          widget.image, constants.defaultRecipeImageLink);
    }
    setState(() {
      _imageLink = imageLink;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _imageLink.isNotEmpty
                ? Image.network(
                    _imageLink,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    constants.defaultIngredientImageLink,
                    fit: BoxFit.cover,
                  ),
          )),
      title: Text(
        widget.name,
        style: GoogleFonts.poppins(),
      ),
      subtitle: Text(
        '${widget.quantity} ${widget.unit}',
        style: GoogleFonts.poppins(),
      ),
    );
  }
}
