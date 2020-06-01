library avatar;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;

const Color LIGHT_BLUE = Color(0xFFD6FFFB);
const Color LIGHT_YELLOW = Color(0xFFF9EFD3);
const Color LIGHT_ASH = Color(0xFFACC9BA);
const Color DARK_BLUE = Color(0xFF9AC2C9);
const Color RANDOM = Color(0xFFBBC5AA);
// const Color TRANSPARENT_BLACK = Color(0xF0080F0F);

const List<Color> AVATAR_COLORS = [
  ThriveColors.LIGHT_GREEN,
  ThriveColors.WHITE,
  ThriveColors.LIGHT_ORANGE,
  LIGHT_ASH,
  LIGHT_YELLOW,
  RANDOM,
  DARK_BLUE,
  LIGHT_BLUE,
  ThriveColors.LIGHTEST_GREEN,
];

const List<Icon> AVATAR_ICONS = [
  Icon(Icons.cloud, size: 25, color: ThriveColors.BLACK),
  Icon(FontAwesomeIcons.tree, color: ThriveColors.BLACK),
  Icon(FontAwesomeIcons.seedling, color: ThriveColors.BLACK),
  Icon(FontAwesomeIcons.canadianMapleLeaf, color: ThriveColors.BLACK),
  Icon(FontAwesomeIcons.pagelines, color: ThriveColors.BLACK),
  Icon(FontAwesomeIcons.dove, color: ThriveColors.BLACK),
  Icon(FontAwesomeIcons.tint, color: ThriveColors.BLACK),
];

const List<Icon> AVATAR_ICONS_PROFILE = [
  Icon(Icons.cloud, size: 60, color: ThriveColors.BLACK),
  Icon(FontAwesomeIcons.tree, size: 50, color: ThriveColors.BLACK),
  Icon(FontAwesomeIcons.seedling, size: 50, color: ThriveColors.BLACK),
  Icon(FontAwesomeIcons.canadianMapleLeaf, size: 50, color: ThriveColors.BLACK),
  Icon(FontAwesomeIcons.pagelines, size: 50, color: ThriveColors.BLACK),
  Icon(FontAwesomeIcons.dove, size: 50, color: ThriveColors.BLACK),
  Icon(FontAwesomeIcons.tint, size: 50, color: ThriveColors.BLACK),
];

// seedling, tree, canadian maple leaf, pagelines, dove, tint,
const List<Icon> AVATAR_ICONS_SOCIAL = [
  Icon(Icons.cloud),
  Icon(FontAwesomeIcons.tree),
  Icon(FontAwesomeIcons.seedling),
  Icon(FontAwesomeIcons.canadianMapleLeaf),
  Icon(FontAwesomeIcons.pagelines),
  Icon(FontAwesomeIcons.dove),
  Icon(FontAwesomeIcons.tint),
];

// const circleAvatar() {

// }
