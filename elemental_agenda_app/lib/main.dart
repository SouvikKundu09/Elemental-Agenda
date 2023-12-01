import 'package:elemental_agenda_app/components/eventform.dart';
import 'package:elemental_agenda_app/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elemental Calender',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffb4befe)),
        useMaterial3: true,
        textTheme: TextTheme(
          titleLarge: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Color(0xff94e2d5),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          bodyMedium: GoogleFonts.ubuntu(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xffcdd6f4),
            ),
          ),
        ),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const HomePage(),
        "/form": (context) => const Eventform()
      },
    );
  }
}
