import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:offlinemusic_resfy/core/colors.dart';
import 'package:offlinemusic_resfy/db/models/mostplayed.dart';
import 'package:offlinemusic_resfy/db/models/songmodel.dart';
import 'package:offlinemusic_resfy/screens/homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

final OnAudioQuery audioQuery = OnAudioQuery();

final box = SongBox.getInstance();
final mostbox = MostplayedBox.getInstance();

List<SongModel> fetchsongs = [];
List<SongModel> allsongs = [];

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // requestStoragePermission();
    navigateToHome(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedSplashScreen(
          splashIconSize: 250,
          backgroundColor: splashcolor,
          splashTransition: SplashTransition.scaleTransition,
          splash: const Image(image: AssetImage('assets/logo.png')),
          nextScreen: const MyHomePage(),
        ),
      ),
    );
  }
}

navigateToHome(BuildContext ctx) async {
  bool permissionStatus = await audioQuery.permissionsStatus();
  if (!permissionStatus) {
    await audioQuery.permissionsRequest();
  }
  fetchsongs = await audioQuery.querySongs();
  for (var element in fetchsongs) {
    if (element.fileExtension == "mp3") {
      allsongs.add(element);
    }
  }
  for (var element in allsongs) {
    mostbox.add(
      MostPlayed(
          songname: element.title,
          // artist: element.artist!,
          duration: element.duration!,
          id: element.id,
          songurl: element.uri!,
          count: 1),
    );
  }
  for (var element in allsongs) {
    box.add(Songs(
      songname: element.title,
      // artist: element.artist,
      duration: element.duration,
      id: element.id,
      songurl: element.uri,
    ));
  }
  await Future.delayed(const Duration(milliseconds: 500), () {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const MyHomePage(),
      ),
    );
  });
}
