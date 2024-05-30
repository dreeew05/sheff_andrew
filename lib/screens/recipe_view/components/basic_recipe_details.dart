import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/common/components/network_image_check.dart';
import 'package:sheff_andrew/common/utils/constants.dart';
import 'package:sheff_andrew/providers/user_provider.dart';

class BasicRecipeDetails extends StatefulWidget {
  final String image;
  final String name;
  final String timeToCook;
  final String postKey;
  const BasicRecipeDetails({
    super.key,
    required this.image,
    required this.name,
    required this.timeToCook,
    required this.postKey,
  });

  @override
  _BasicRecipeDetailsState createState() => _BasicRecipeDetailsState();
}

class _BasicRecipeDetailsState extends State<BasicRecipeDetails> {
  bool _isBookmarked = false;
  String _imageLink = '';
  final NetworkImageCheck networkImageCheck = NetworkImageCheck();
  final Constants constants = Constants();

  final firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkImageURL();
    _checkBookmarkStatus();
  }

  void _checkBookmarkStatus() async {
    final userKey = context.watch<UserProvider>().userKey;
    final doc = await firestore.collection('users').doc(userKey).get();
    setState(() {
      _isBookmarked = doc.data()?['bookmarks'].contains(widget.postKey);
    });
  }

  void _toggleBookmark() async {
    final userKey = context.read<UserProvider>().userKey;
    final doc = firestore.collection('users').doc(userKey);
    _isBookmarked
        ? await doc.update({
            'bookmarks': FieldValue.arrayRemove([widget.postKey])
          })
        : await doc.update({
            'bookmarks': FieldValue.arrayUnion([widget.postKey])
          });
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  Future<void> _checkImageURL() async {
    String imageLink = await networkImageCheck.checkImageURL(
        widget.image, constants.defaultRecipeImageLink);
    setState(() {
      _imageLink = imageLink;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 250,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                image: NetworkImage(_imageLink), fit: BoxFit.cover),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
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
                    padding: const EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.timer,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${widget.timeToCook} Minutes',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 20),
                          CircleAvatar(
                            child: IconButton(
                              onPressed: _toggleBookmark,
                              icon: _isBookmarked
                                  ? const Icon(Icons.bookmark_added_rounded)
                                  : const Icon(Icons.bookmark_add_rounded),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
        const SizedBox(height: 15),
        Text(
          widget.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
    );
  }
}
