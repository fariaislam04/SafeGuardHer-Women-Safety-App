import 'package:flutter/material.dart';
import '../../utils/constants/colors/colors.dart';

class TrackMeModal extends StatefulWidget {
  @override
  _TrackMeModalState createState() => _TrackMeModalState();
}

class _TrackMeModalState extends State<TrackMeModal> {
  List<int> selectedContacts = [];
  String searchQuery = "";
  int selectedOption = 1;
  List<String> contacts = [
    'Binita Sarker',
    'Farheen Trisha',
    'Faria Islam',
    'Raisa Rahman',
  ]; // Sample contact names

  @override
  Widget build(BuildContext context) {
    List<String> filteredContacts = contacts
        .where((contact) => contact.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Container(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 30.0, bottom: 10),
      height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Contacts to Share Location',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 60,
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                ),
                prefixIcon: Icon(Icons.search_rounded),
                focusColor: AppColors.borderFocused,
                contentPadding: EdgeInsets.symmetric(vertical: 5.0),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          const SizedBox(height: 13),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                filteredContacts.length,
                    (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedContacts.contains(index)) {
                          selectedContacts.remove(index);
                        } else {
                          selectedContacts.add(index);
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              const CircleAvatar(
                                backgroundImage: AssetImage('assets/placeholders/profile.png'),
                                radius: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                filteredContacts[index],
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          if (selectedContacts.contains(index))
                            const Positioned(
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 12,
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          RadioButtonRow(
            selectedOption: selectedOption,
            onChanged: (value) {
              setState(() {
                selectedOption = value!;
              });
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () {
                // Handle continue button press
                Navigator.pop(context); // Close the modal
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RadioButtonRow extends StatelessWidget {
  final int selectedOption;
  final ValueChanged<int?> onChanged;

  const RadioButtonRow({
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio<int>(
          value: 1,
          groupValue: selectedOption,
          onChanged: onChanged,
          activeColor: AppColors.secondary,
        ),
        const Text('Always', style: TextStyle(fontFamily: 'Poppins')),
        Radio<int>(
          value: 2,
          groupValue: selectedOption,
          onChanged: onChanged,
          activeColor: AppColors.secondary,
        ),
        const Text('1 hour', style: TextStyle(fontFamily: 'Poppins')),
        Radio<int>(
          value: 3,
          groupValue: selectedOption,
          onChanged: onChanged,
          activeColor: AppColors.secondary,
        ),
        const Text('8 hours', style: TextStyle(fontFamily: 'Poppins')),
      ],
    );
  }
}