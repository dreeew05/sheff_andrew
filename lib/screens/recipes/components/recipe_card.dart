import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheff_andrew/common/components/network_image_check.dart';
import 'package:sheff_andrew/common/utils/constants.dart';
import '../../recipe_view/recipe_view_page.dart';
import 'package:sheff_andrew/backend/firestore_service.dart';

class RecipeCard extends StatefulWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
  });

  final Map<String, dynamic> recipe;

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  String _imageLink = '';

  final NetworkImageCheck networkImageCheck = NetworkImageCheck();
  final Constants constants = Constants();

  @override
  void initState() {
    super.initState();
    _checkImageURL();
  }

  Future<void> _checkImageURL() async {
    String imageLink = await networkImageCheck.checkImageURL(
        widget.recipe['image'], constants.defaultRecipeImageLink);
    setState(() {
      _imageLink = imageLink;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RecipeViewPage(postKey: widget.recipe['post_key']),
          ),
        );
      },
      child: Card(
          margin: const EdgeInsets.all(8.0),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Ink.image(
                image: NetworkImage(_imageLink),
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.recipe['name'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    //author/chef, remove const if done
                    RecipeUserNameWidget(userKey: widget.recipe['user']),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class RecipeUserNameWidget extends StatelessWidget {
  final String? userKey;
  final FirestoreService firestoreService = FirestoreService();

  RecipeUserNameWidget({required this.userKey});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: firestoreService.getRecipeUserName(userKey),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('');
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Text('User not found');
        } else {
          return Text('By Chef: ${snapshot.data}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ));
        }
      },
    );
  }
}
