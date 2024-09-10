import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/auth_screen/login_screen/login_screen.dart';
import 'screens/splash_screen/splash_screen.dart';
import 'providers.dart';

class SafeGuardHer extends ConsumerWidget
{
  final bool appOpenedBefore;
  final bool loggedIn;

  const SafeGuardHer({
    super.key,
    required this.appOpenedBefore,
    required this.loggedIn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref)
  {
    final userAsyncValue = ref.watch(userStreamProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SafeGuardHer',
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: userAsyncValue.when(
        data: (user)
        {
          if (user == null)
          {
            //-- if user is null, then automatically add a phone number with
            // default placeholders
            return const Center(child: Text('No user data available'));
          }
         // return loggedIn ? Home(user: user) : const LoginScreen();
          return HomeScreen(user: user); //TODO: change this logic later
         // return Home(user: user);
        },
        loading: () => const SplashScreen(),
        error: (error, stackTrace) => Center(child: Text('Error loading data: $error')),
      ),
    );
  }
}