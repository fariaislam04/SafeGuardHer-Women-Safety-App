import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safeguardher_flutter_app/screens/home_screen/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ReportIncidentPage(),
    );
  }
}

class ReportIncidentPage extends StatefulWidget {
  const ReportIncidentPage({super.key});

  @override
  ReportIncidentPageState createState() => ReportIncidentPageState();
}

class ReportIncidentPageState extends State<ReportIncidentPage> {
  String dropdownValue = 'Harassment';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF831D2D),
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SvgPicture.asset(
            'assets/logos/logo_dark_theme.svg',
            height: 70,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  color: const Color(0XFFF5F5F5),
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
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>[
                        'Harassment',
                        'Assault',
                        'Theft',
                        'Robbery',
                        'Stalking',
                        'Violence',
                        'Domestic Violence',
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
                            color: Color(0xFF831D2D),
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
                        focusColor: const Color(0xFF831D2D),
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
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color(0xFF831D2D),
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
                              backgroundColor: const Color(0xFF831D2D),
                              padding: const EdgeInsets.symmetric(vertical:
                              14.0),
                              minimumSize: Size(constraints.maxWidth, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            onPressed: ()
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.white),
                                      SizedBox(width: 10),
                                      Text('Your report has been submitted!'),
                                    ],
                                  ),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                              Future.delayed(const Duration(seconds: 2), ()
                              {
                                Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const HomeScreen()),
                                (Route<dynamic> route) => false,
                                );
                              });
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                        },
                        child: const Text(
                          'Submit Later',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF831D2D),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
