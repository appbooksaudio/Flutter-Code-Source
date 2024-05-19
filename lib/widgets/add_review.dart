// // Generated code for this TextField Widget...
// import 'package:flutter/material.dart';

// class PopupReview extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return // Generated code for this reviewTrip Widget...
//         Padding(
//       padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
//       child: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           color: FlutterFlowTheme.of(context).secondaryBackground,
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 6,
//               color: Color(0x35000000),
//               offset: Offset(0, -2),
//             )
//           ],
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(0),
//             bottomRight: Radius.circular(0),
//             topLeft: Radius.circular(16),
//             topRight: Radius.circular(16),
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
//                   child: Container(
//                     width: 60,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: FlutterFlowTheme.of(context).lineGray,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                 ),
//                 Row(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         'Rate Your Trip',
//                         textAlign: TextAlign.start,
//                         style: FlutterFlowTheme.of(context).headlineSmall,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
//                         child: Text(
//                           'Let us know what you thought of the place below!',
//                           textAlign: TextAlign.start,
//                           style: FlutterFlowTheme.of(context).bodyMedium,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Expanded(
//                         child: Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
//                           child: Text(
//                             'How would you rate it?',
//                             textAlign: TextAlign.start,
//                             style: FlutterFlowTheme.of(context).bodySmall,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
//                   child: RatingBar.builder(
//                     onRatingUpdate: (newValue) =>
//                         setState(() => _model.ratingBarValue = newValue),
//                     itemBuilder: (context, index) => Icon(
//                       Icons.star_rounded,
//                       color: FlutterFlowTheme.of(context).primary,
//                     ),
//                     direction: Axis.horizontal,
//                     initialRating: _model.ratingBarValue ??= 0,
//                     unratedColor: FlutterFlowTheme.of(context).lineGray,
//                     itemCount: 5,
//                     itemSize: 48,
//                     glowColor: FlutterFlowTheme.of(context).primary,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
//                   child: TextFormField(
//                     controller: _model.textController,
//                     obscureText: false,
//                     decoration: InputDecoration(
//                       hintText: 'Please leave a description of the place...',
//                       hintStyle: FlutterFlowTheme.of(context).bodyMedium,
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: FlutterFlowTheme.of(context).lineGray,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     style: FlutterFlowTheme.of(context).bodySmall,
//                     maxLines: 4,
//                     validator:
//                         _model.textControllerValidator.asValidator(context),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(0, 32, 0, 0),
//                   child: FFButtonWidget(
//                     onPressed: () async {
//                       final reviewsCreateData = createReviewsRecordData(
//                         propertyRef: widget.propertyReference!.reference,
//                         userRef: currentUserReference,
//                         rating: _model.ratingBarValue,
//                         ratingDescription: _model.textController.text,
//                         ratingCreated: getCurrentTimestamp,
//                       );
//                       await ReviewsRecord.collection
//                           .doc()
//                           .set(reviewsCreateData);
//                       final propertiesUpdateData = {
//                         'ratingSummary': FieldValue.increment(1.0),
//                       };
//                       await widget.propertyReference!.reference
//                           .update(propertiesUpdateData);
//                       final tripsUpdateData = createTripsRecordData(
//                         rated: true,
//                       );
//                       await widget.tripDetails!.reference
//                           .update(tripsUpdateData);
//                       context.pushNamed(
//                         'myTrips',
//                         extra: <String, dynamic>{
//                           kTransitionInfoKey: TransitionInfo(
//                             hasTransition: true,
//                             transitionType: PageTransitionType.leftToRight,
//                             duration: Duration(milliseconds: 240),
//                           ),
//                         },
//                       );
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             'Your review was submitted succesffuly!',
//                             style: FlutterFlowTheme.of(context)
//                                 .bodyMedium
//                                 .override(
//                                   fontFamily: 'Urbanist',
//                                   color: FlutterFlowTheme.of(context).tertiary,
//                                 ),
//                           ),
//                           duration: Duration(milliseconds: 4000),
//                           backgroundColor:
//                               FlutterFlowTheme.of(context).turquoise,
//                         ),
//                       );
//                     },
//                     text: 'Submit Review',
//                     options: FFButtonOptions(
//                       width: 300,
//                       height: 60,
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                       iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                       color: FlutterFlowTheme.of(context).primary,
//                       textStyle:
//                           FlutterFlowTheme.of(context).headlineSmall.override(
//                                 fontFamily: 'Urbanist',
//                                 color: FlutterFlowTheme.of(context).tertiary,
//                               ),
//                       elevation: 3,
//                       borderSide: BorderSide(
//                         color: Colors.transparent,
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.circular(40),
//                     ),
//                   ).animateOnPageLoad(
//                       animationsMap['buttonOnPageLoadAnimation']!),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
