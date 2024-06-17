import 'package:flutter/material.dart';

class Report2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 428,
          height: 926,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Color(0xFF6C022A)),
          child: Stack(
            children: [
              Positioned(
                left: 3679,
                top: -1262,
                child: Container(
                  width: 375,
                  height: 811.59,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/375x812"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 79,
                top: 55,
                child: Container(
                  width: 269.55,
                  height: 79.44,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 81.64,
                          height: 79.44,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 11.73,
                                top: 9.59,
                                child: Container(
                                  width: 54.46,
                                  height: 59.48,
                                  child: Stack(),
                                ),
                              ),
                              Positioned(
                                left: 27.82,
                                top: 20.65,
                                child: Container(
                                  width: 53.82,
                                  height: 58.79,
                                  child: Stack(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 95.67,
                        top: 32.31,
                        child: Container(
                          width: 173.88,
                          height: 19.53,
                          child: Stack(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 187,
                child: Container(
                  width: 396,
                  height: 718,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 0,
                        top: 35,
                        child: SizedBox(
                          width: 396,
                          child: Text(
                            'Report Incident',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: 0.07,
                              letterSpacing: 0.72,
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 27,
                        top: 99,
                        child: SizedBox(
                          width: 341,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Kindly take a few minutes to report the incident you faced. It will help us mark unsafe places for other users.\n\n',
                                  style: TextStyle(
                                    color: Color(0xFF545252),
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0.11,
                                    letterSpacing: 0.45,
                                  ),
                                ),
                                TextSpan(
                                  text: 'You can also submit later from history.',
                                  style: TextStyle(
                                    color: Color(0xFF545252),
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    height: 0.11,
                                    letterSpacing: 0.45,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 40,
                        top: 256,
                        child: Container(
                          width: 328,
                          height: 362,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 328,
                                  height: 98,
                                  child: Stack(
                                    children: [
                                      const Positioned(
                                        left: 0,
                                        top: 0,
                                        child: SizedBox(
                                          width: 328,
                                          child: Text(
                                            'Type of Incident',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              height: 0.16,
                                              letterSpacing: 0.48,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        top: 48,
                                        child: Container(
                                          width: 314,
                                          height: 50,
                                          padding: const EdgeInsets.only(
                                            top: 13,
                                            left: 279,
                                            right: 11,
                                            bottom: 13,
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(width: 1, color: Color(0xFFBDBDBD)),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 24,
                                                height: double.infinity,
                                                padding: const EdgeInsets.symmetric(horizontal: 6.69),
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: const Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [

                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 110,
                                child: Container(
                                  width: 328,
                                  height: 177,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: SizedBox(
                                          width: 328,
                                          height: 72.24,
                                          child: Text(
                                            'Additional Remarks',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              height: 0.16,
                                              letterSpacing: 0.48,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        top: 45,
                                        child: Container(
                                          width: 314,
                                          height: 132,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(width: 1, color: Color(0xFFBDBDBD)),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 318,
                                child: Container(
                                  width: 314,
                                  height: 44,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF6C022A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10000),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Submit',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          height: 0.09,
                                          letterSpacing: 0.48,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 45,
                        top: 649,
                        child: SizedBox(
                          width: 309,
                          child: Text(
                            'Submit Later',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF6C022A),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              height: 0.11,
                              letterSpacing: 0.45,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}