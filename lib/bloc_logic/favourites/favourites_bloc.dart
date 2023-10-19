import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offlinemusic_resfy/db/functions/dbfunctions.dart';
import 'package:offlinemusic_resfy/db/models/favourites.dart';
import 'package:offlinemusic_resfy/db/models/songmodel.dart';
import 'package:offlinemusic_resfy/splash.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  FavouritesBloc() : super(FavouritesInitial()) {
    on<FetchFavSongs>((event, emit) {
      try {
        final favbox = Favouritesbox.getinstance();
        List<Favourites> favourite = favbox.values.toList();
        emit(DisplayFavSongs(favourite));
      } catch (e) {
        log(e.toString());
      }
    });

    on<AddorRemoveFavourites>((event, emit) {
      List<Songs> dbsongs = box.values.toList();
      final favbox = Favouritesbox.getinstance();
      final favouritesongs = favouritesdb.values.toList();
      bool isalready = favouritesongs
          .where((element) => element.songname == dbsongs[event.index].songname)
          .isEmpty;
      if (isalready) {
        favouritesdb.add(event.favsong);
        add(FetchFavSongs());
      } else {
        int index = favouritesongs.indexWhere(
            (element) => element.songname == event.favsong.songname);
        favbox.deleteAt(index);
        add(FetchFavSongs());
      }
    });

    on<RemoveFromFavouritesList>((event, emit) {
      try {
        final favbox = Favouritesbox.getinstance();
        favbox.deleteAt(event.index);
        add(FetchFavSongs());
      } on Exception catch (e) {
        log(e.toString());
      }
    });
  }
}
