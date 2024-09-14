import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safeguardher_flutter_app/screens/home_screen/home_screen.dart';
import '../../providers.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/helpers/helper_functions.dart';

AppHelperFunctions appHelperFunctions = AppHelperFunctions();

class ReportIncidentPage extends ConsumerWidget {
  const ReportIncidentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userStreamProvider);
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Controllers for input fields
    final TextEditingController descriptionController = TextEditingController();
    String selectedReportType = 'Harassment'; // Default value

    Future<Map<String, dynamic>?> _fetchAlertData(String alertID) async {
      try {
        final alertDoc = await firestore.collection('users').doc("01719958727").collection('alerts').doc(alertID).get();
        if (alertDoc.exists) {
          return alertDoc.data();
        } else {
          print('Document does not exist.');
          return null;
        }
      } catch (e) {
        print('Error fetching alert data: $e');
        return null;
      }
    }

    Future<void> _submitReport(String reportType, String reportDescription) async {
      try {
        final user = await ref.read(userStreamProvider.future);

        if (user != null)
        {
          // Fetch the alert data to get geolocation
          final alertData = await _fetchAlertData('1');
          final geolocation = (alertData != null && alertData.containsKey('alert_duration'))
              ? alertData['alert_duration']['alert_start'] as Map<String, dynamic>
              : {'latitude': 0.0, 'longitude': 0.0}; // Default geolocation if not available

          await firestore.collection('users').doc("01719958727").collection
      ('alerts').doc('1').update({
            'report': {
              'report_type': reportType,
              'report_description': reportDescription,
              'report_geolocation': geolocation,
            },
          });

          await firestore.collection('unsafe_places').doc('unsafe_places').set({
            'report_type': reportType,
            'report_description': reportDescription,
            'report_geolocation': geolocation,
          }, SetOptions(merge: true));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Your report has been submitted!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              duration: const Duration(seconds: 1),
            ),
          );

          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(user: user),
              ),
                  (Route<dynamic> route) => false,
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to retrieve user data.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error submitting report.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SvgPicture.asset(
            ImageStrings.darkAppLogo,
            height: 70,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Report Incident',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Kindly take a few minutes to report the incident you faced. It will help us mark unsafe places for other users.',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'You can also submit later from history.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Type of Incident',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                value: selectedReportType,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    selectedReportType = newValue;
                  }
                },
                items: <String>[
                  'Harassment',
                  'Assault',
                  'Robbery',
                  'Violence',
                  'Other'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: AppColors.borderFocused,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: AppColors.borderPrimary,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Additional Remarks',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: AppColors.borderFocused,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24.0),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        minimumSize: Size(constraints.maxWidth, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      onPressed: () {
                        String reportType = selectedReportType;
                        String reportDescription = descriptionController.text;

                        _submitReport(reportType, reportDescription);
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15.0),
              Center(
                child: TextButton(
                  onPressed: () {
                    userAsyncValue.when(
                      data: (user) {
                        if (user != null) {
                          appHelperFunctions.goToScreenAndDoNotComeBack(
                            context,
                            HomeScreen(user: user),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Failed to retrieve user data.'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          );
                        }
                      },
                      loading: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Loading...'),
                            backgroundColor: Colors.blue,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        );
                      },
                      error: (e, stackTrace) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Go Back',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: AppColors.buttonPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
