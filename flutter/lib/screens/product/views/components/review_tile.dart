import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../../../../constants.dart';
import '../../../../models/review_model.dart';

class ReviewTile extends StatelessWidget {
  final Review review;
  ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Photo
          Container(
            width: 36,
            height: 36,
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                image: NetworkImage(review.userPhoto.replaceFirst(
                    ApiConstants.local,
                    ApiConstants.ifcon)), // Hiển thị ảnh từ API
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Username - Rating - Comments
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username - Rating
                  Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 8,
                          child: Text(
                            review.userName,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColor.primary,
                                fontFamily: 'poppins'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: SmoothStarRating(
                            allowHalfRating: false,
                            size: 16,
                            color: Colors.orange[400],
                            rating: review.rate,
                            borderColor: AppColor.primarySoft,
                          ),
                        )
                      ],
                    ),
                  ),
                  // Date of Review
                  Text(
                    DateFormat('dd-MM-yyyy').format(
                        review.createdAt), // Định dạng ngày thành dd-MM-yyyy
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  // Comments
                  Text(
                    '${review.review}',
                    style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.7),
                        height: 150 / 100),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
