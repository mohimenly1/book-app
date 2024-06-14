// File: lib/screens/playground_list_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../hotel_booking/model/playground_list_data.dart'; // Updated import
import 'playground_app_theme.dart';
import 'playground_details_dialog.dart'; // Import the dialog widget

class PlaygroundListView extends StatelessWidget {
  const PlaygroundListView({
    super.key,
    this.playground,
    this.animationController,
    this.animation,
    this.callback,
  });

  final VoidCallback? callback;
  final Playground? playground; // Updated to use Playground model
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    if (playground == null) {
      // Handle the case where playground is null
      return Container(
        height: 130,
        color: Colors.grey[200], // Placeholder color
        child: Center(
          child: Text('No data available'), // Placeholder text
        ),
      );
    }

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              50 * (1.0 - animation!.value),
              0.0,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 8,
                bottom: 16,
              ),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  if (playground != null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return PlaygroundDetailsDialog(
                          playground:
                              playground!, // Updated to use Playground model
                        );
                      },
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 2,
                              child: Image.network(
                                playground!.images.isNotEmpty
                                    ? playground!.images[0]
                                    : '',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              color: HotelAppTheme.buildLightTheme()
                                  .colorScheme
                                  .surface,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        top: 8,
                                        bottom: 8,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            playground!.name,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              fontFamily: 'HacenSamra',
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 22,
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                playground!.description,
                                                style: TextStyle(
                                                  fontFamily: 'HacenSamra',
                                                  fontSize: 14,
                                                  color: Colors.grey
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Icon(
                                                FontAwesomeIcons.locationDot,
                                                size: 12,
                                                color: HotelAppTheme
                                                        .buildLightTheme()
                                                    .primaryColor,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Row(
                                              children: <Widget>[
                                                RatingBar(
                                                  initialRating:
                                                      4.5, // Assuming a static rating for now
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: 24,
                                                  ratingWidget: RatingWidget(
                                                    full: Icon(
                                                      Icons.star_rate_rounded,
                                                      color: HotelAppTheme
                                                              .buildLightTheme()
                                                          .primaryColor,
                                                    ),
                                                    half: Icon(
                                                      Icons.star_half_rounded,
                                                      color: HotelAppTheme
                                                              .buildLightTheme()
                                                          .primaryColor,
                                                    ),
                                                    empty: Icon(
                                                      Icons.star_border_rounded,
                                                      color: HotelAppTheme
                                                              .buildLightTheme()
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  itemPadding: EdgeInsets.zero,
                                                  onRatingUpdate: (rating) {
                                                    print(rating);
                                                  },
                                                ),
                                                Text(
                                                  ' 80 Reviews', // Assuming static review count for now
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'HacenSamra',
                                                    color: Colors.grey
                                                        .withOpacity(0.8),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, top: 8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '${playground!.pricePerHour} دينار',
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontFamily: 'HacenSamra',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontSize: 22,
                                          ),
                                        ),
                                        Text(
                                          '/لكل ساعة',
                                          style: TextStyle(
                                            fontFamily: 'HacenSamra',
                                            fontSize: 14,
                                            color: Colors.grey.withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(32.0),
                              ),
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.favorite_border,
                                  color: HotelAppTheme.buildLightTheme()
                                      .primaryColor,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
