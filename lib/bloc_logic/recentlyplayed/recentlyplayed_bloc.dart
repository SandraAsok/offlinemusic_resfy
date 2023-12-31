// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:offlinemusic_resfy/db/models/recentlyplayed.dart';

part 'recentlyplayed_event.dart';
part 'recentlyplayed_state.dart';

class RecentlyplayedBloc
    extends Bloc<RecentlyplayedEvent, RecentlyplayedState> {
  RecentlyplayedBloc() : super(RecentlyplayedInitial()) {
    on<FetchRecentlyPlayed>((event, emit) {
      try {
        final box = RecentlyPlayedBox.getInstance();
        final List<RecentlyPlayed> recentlyplayed =
            box.values.toList().reversed.toList();
        emit(DisplayRecentlyPlayed(recentlyplayed));
      } catch (e) {
        log(e.toString());
      }
    });

    on<AddToRecentlyPlayed>((event, emit) {
      final box = RecentlyPlayedBox.getInstance();
      final List<RecentlyPlayed> recentlyplayed = box.values.toList();
      try {
        bool isAlready = recentlyplayed
            .where(
                (element) => element.songname == event.recentlyPlayed.songname)
            .isEmpty;
        if (isAlready == true) {
          box.add(event.recentlyPlayed);
          add(FetchRecentlyPlayed());
        } else {
          int index = recentlyplayed
              .indexWhere((element) => element.id == event.recentlyPlayed.id);
          box.deleteAt(index);
          box.add(event.recentlyPlayed);
          add(FetchRecentlyPlayed());
        }
      } catch (e) {
        log(e.toString());
      }
    });
  }
}
