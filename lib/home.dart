import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: TrackMeAlert(),
      ),
    ),
  ));
}

class TrackMeAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.0, // Match the height of NotificationWidget
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1, // Subtle shadow
            blurRadius: 4,   // Soft shadow effect
            offset: Offset(0, 2), // Shadow offset
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Center items vertically
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center, // Center items vertically
              children: [
                Text(
                  'Track Me Alert Triggered',
                  style: TextStyle(
                    fontSize: 14, // Slightly larger text for better readability
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Your live location is being tracked by',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: CircleAvatar(
                        radius: 14, // Slightly smaller radius
                        backgroundImage: AssetImage('assets/placeholders/binita.png'),
                        // Replace with your image path
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
          SizedBox(width: 12), // Adjust spacing between columns
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center, // Center items vertically
              children: [
                Text(
                  'Time',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '01:04:20',
                  style: TextStyle(
                    fontSize: 18, // Adjusted size for better fit
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '2.5 km',
                  style: TextStyle(
                    fontSize: 12, // Adjusted size
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
