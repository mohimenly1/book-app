// File: lib/screens/playground_details_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../hotel_booking/model/playground_list_data.dart';
import '../screens/booking/booking_schedule_screen.dart';
import '../hotel_booking/playground_app_theme.dart';

class PlaygroundDetailsDialog extends StatelessWidget {
  final Playground playground;

  const PlaygroundDetailsDialog({required this.playground});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 2,
                child: Image.network(
                  playground.images.isNotEmpty ? playground.images[0] : '',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                playground.name,
                style: TextStyle(
                  fontFamily: 'HacenSamra',
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                playground.description,
                style: TextStyle(
                  fontFamily: 'HacenSamra',
                  fontSize: 14,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 8.0),
              RatingBar(
                initialRating: 4.5, // Assuming a static rating for now
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 24,
                ratingWidget: RatingWidget(
                  full: Icon(
                    Icons.star_rate_rounded,
                    color: HotelAppTheme.buildLightTheme().primaryColor,
                  ),
                  half: Icon(
                    Icons.star_half_rounded,
                    color: HotelAppTheme.buildLightTheme().primaryColor,
                  ),
                  empty: Icon(
                    Icons.star_border_rounded,
                    color: HotelAppTheme.buildLightTheme().primaryColor,
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
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '${playground.pricePerHour} دينار / لكل ساعة',
                style: TextStyle(
                  fontFamily: 'HacenSamra',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16.0),
              _buildImageGallery(playground.images),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      // Handle share action
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.phone),
                    onPressed: () {
                      // Handle phone action
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.map),
                    onPressed: () {
                      // Handle map action
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookingScheduleScreen(playgroundId: playground.id),
                    ),
                  );
                },
                child: Text(
                  'حجز الملعب',
                  style: TextStyle(fontFamily: 'HacenSamra'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HotelAppTheme.buildLightTheme().primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageGallery(List<String> galleryImages) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: galleryImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                galleryImages[index],
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
          );
        },
      ),
    );
  }
}
