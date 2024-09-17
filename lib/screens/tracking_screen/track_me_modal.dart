import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/emergency_contact_model.dart';
import '../../providers.dart';
import '../../utils/constants/colors.dart';

class TrackMeModal extends ConsumerWidget {
  const TrackMeModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emergencyContacts = ref.watch(emergencyContactsProvider);
    final selectedContacts = ref.watch(selectedContactsProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedOption = ref.watch(selectedOptionProvider);

    List<EmergencyContact> filteredContacts = emergencyContacts
        .where((contact) => contact.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Container(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 30.0, bottom: 10),
      color: Colors.white,
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
                ref.read(searchQueryProvider.notifier).state = value;
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
                  final contact = filteredContacts[index];
                  return GestureDetector(
                    onTap: () {
                      final updatedSelectedContacts = List<int>.from(selectedContacts);
                      if (updatedSelectedContacts.contains(index)) {
                        updatedSelectedContacts.remove(index);
                      } else {
                        updatedSelectedContacts.add(index);
                      }
                      ref.read(selectedContactsProvider.notifier).state = updatedSelectedContacts;
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(contact.profilePic),
                                radius: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                contact.name,
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
              if (value != null) {
                ref.read(selectedOptionProvider.notifier).state = value;
              }
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
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

class RadioButtonRow extends ConsumerWidget {
  final int selectedOption;
  final ValueChanged<int?> onChanged;

  const RadioButtonRow({
    super.key,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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