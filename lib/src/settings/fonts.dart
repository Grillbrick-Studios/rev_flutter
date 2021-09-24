import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A SimpleFont wrapper for the fonts to be exported.
class SimpleFont {
  final TextStyle style;
  final String label;

  const SimpleFont({required this.style, required this.label});
}

// Serifed fonts
TextStyle _merriweather = GoogleFonts.merriweather();
const TextStyle _timesNewRoman = TextStyle(
  fontFamily: 'Times New Roman',
  fontFamilyFallback: ['merriweather', 'times', 'serif'],
);
TextStyle _caladea = GoogleFonts.caladea();
TextStyle _ibmPlexSerif = GoogleFonts.ibmPlexSerif();

// Non-Serifed Fonts
const TextStyle _arial =
    TextStyle(fontFamily: 'arial', fontFamilyFallback: ['sans-serif']);
TextStyle _roboto = GoogleFonts.roboto();
TextStyle _montserrat = GoogleFonts.montserrat();
TextStyle _balsamiqSans = GoogleFonts.balsamiqSans();

// Fancy Fonts
const TextStyle _chalkduster = TextStyle(fontFamily: 'Chalkduster');
const TextStyle _copperplate = TextStyle(fontFamily: 'Copperplate');
const TextStyle _copperplateLight =
    TextStyle(fontFamily: 'Copperplate', fontWeight: FontWeight.w100);
const TextStyle _copperplateBold =
    TextStyle(fontFamily: 'Copperplate', fontWeight: FontWeight.w900);
const TextStyle _noteworthy = TextStyle(fontFamily: 'Noteworthy');
const TextStyle _noteworthyBold =
    TextStyle(fontFamily: 'Noteworthy', fontWeight: FontWeight.w900);
const TextStyle _papyrus = TextStyle(fontFamily: 'Papyrus');

const List<SimpleFont> fancyFonts = [
  SimpleFont(style: _chalkduster, label: 'Chalkduster'),
  SimpleFont(style: _copperplate, label: 'Copperplate'),
  SimpleFont(style: _copperplateLight, label: 'Copperplate (Light)'),
  SimpleFont(style: _copperplateBold, label: 'Copperplate (Bold)'),
  SimpleFont(style: _noteworthy, label: 'Noteworthy'),
  SimpleFont(style: _noteworthyBold, label: 'Noteworthy (Bold)'),
  SimpleFont(style: _papyrus, label: 'Papyrus'),
];

List<SimpleFont> serifFonts = [
  SimpleFont(
    style: _merriweather,
    label: 'Merriweather',
  ),
  const SimpleFont(
    style: _timesNewRoman,
    label: 'Times New Roman',
  ),
  SimpleFont(
    style: _caladea,
    label: 'Caladea',
  ),
  SimpleFont(
    style: _ibmPlexSerif,
    label: 'IBM Plex Serif',
  ),
];

List<SimpleFont> nonSerifFonts = [
  const SimpleFont(
    style: _arial,
    label: 'Arial',
  ),
  SimpleFont(
    style: _roboto,
    label: 'Roboto',
  ),
  SimpleFont(
    style: _montserrat,
    label: 'Montserrat',
  ),
  SimpleFont(
    style: _balsamiqSans,
    label: 'Balsamiq Sans',
  ),
];

TextStyle defaultFont = _merriweather;
TextStyle lightFont = _copperplateLight;
