import 'package:flutter/material.dart';
import 'package:vsartist/src/global/uidata.dart';

const Color _mariner = Color(0xFFD7816A);
const Color _mediumPurple = Color(0xFFEC9F05);
const Color _tomato = Color(0xFFF2A65A);
const Color _mySin = Color(0xFFF2A65A);

const String _kGalleryAssetsPackage = 'assets';

class SectionDetail {
  const SectionDetail({
    this.title,
    this.subtitle,
    this.imageAsset,
    this.imageAssetPackage,
  });
  final String title;
  final String subtitle;
  final String imageAsset;
  final String imageAssetPackage;
}

class Section {
  const Section({
    this.title,
    this.backgroundAsset,
    this.backgroundAssetPackage,
    this.leftColor,
    this.rightColor,
    this.details,
    this.keyword,
  });
  final String title;
  final String backgroundAsset;
  final String backgroundAssetPackage;
  final Color leftColor;
  final Color rightColor;
  final List<SectionDetail> details;
  final String keyword;

  @override
  bool operator ==(Object other) {
    if (other is! Section) return false;
    final Section otherSection = other;
    return title == otherSection.title;
  }

  @override
  int get hashCode => title.hashCode;
}

// TODO(hansmuller): replace the SectionDetail images and text. Get rid of
// the const vars like _eyeglassesDetail and insert a variety of titles and
// image SectionDetails in the allSections list.

const SectionDetail _eyeglassesDetail = SectionDetail(
  imageAsset: UiData.logo,
  //imageAssetPackage: _kGalleryAssetsPackage,
  title: 'Flutter enables interactive animation',
  subtitle: '3K views - 5 days',
);

const SectionDetail _eyeglassesImageDetail = SectionDetail(
  imageAsset: UiData.logo,
  //imageAssetPackage: _kGalleryAssetsPackage,
);

final List<Section> allSections = <Section>[
  const Section(
    title: 'ALL SONGS',
    leftColor: UiData.orange,
    rightColor: Colors.lime,
    backgroundAsset: UiData.logoWhite,
    keyword: 'all',
  ),
  const Section(
    title: 'SINGLES RELEASE',
    leftColor: UiData.orange,
    rightColor: Colors.green,
    backgroundAsset: UiData.logoWhite,
    keyword: 'release',
  ),
  const Section(
    title: 'ALBUMS',
    leftColor: UiData.orange,
    rightColor: Colors.purple,
    backgroundAsset: UiData.logoWhite,
    keyword: 'album',
  ),
];
