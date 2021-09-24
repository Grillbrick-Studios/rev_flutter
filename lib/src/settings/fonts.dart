import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleFont {
  final TextStyle style;
  final String label;

  const SimpleFont({required this.style, required this.label});
}

// Serifed fonts
TextStyle merriweather = GoogleFonts.merriweather();
const TextStyle timesNewRoman = TextStyle(
  fontFamily: 'Times New Roman',
  fontFamilyFallback: ['merriweather', 'times', 'serif'],
);
TextStyle caladea = GoogleFonts.caladea();
TextStyle ibmPlexSerif = GoogleFonts.ibmPlexSerif();

List<SimpleFont> serifFonts = [
  SimpleFont(
    style: merriweather,
    label: 'Merriweather',
  ),
  const SimpleFont(
    style: timesNewRoman,
    label: 'Times New Roman',
  ),
  SimpleFont(
    style: caladea,
    label: 'Caladea',
  ),
  SimpleFont(
    style: ibmPlexSerif,
    label: 'IBM Plex Serif',
  ),
];

// Non-Serifed Fonts
const TextStyle arial =
    TextStyle(fontFamily: 'arial', fontFamilyFallback: ['sans-serif']);
TextStyle roboto = GoogleFonts.roboto();
TextStyle montserrat = GoogleFonts.montserrat();
TextStyle balsamiqSans = GoogleFonts.balsamiqSans();

List<SimpleFont> nonSerifFonts = [
  const SimpleFont(
    style: arial,
    label: 'Arial',
  ),
  SimpleFont(
    style: roboto,
    label: 'Roboto',
  ),
  SimpleFont(
    style: montserrat,
    label: 'Montserrat',
  ),
  SimpleFont(
    style: balsamiqSans,
    label: 'Balsamiq Sans',
  ),
];

TextStyle defaultFont = merriweather;
