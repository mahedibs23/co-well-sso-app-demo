import 'package:domain/model/movie_details.dart';
import 'package:domain/repository/movie_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:hello_flutter/presentation/base/base_viewmodel.dart';
import 'package:hello_flutter/presentation/feature/movieDetails/route/movie_details_argument.dart';

class MovieDetailsViewModel extends BaseViewModel<MovieDetailsArgument> {
  final MovieRepository movieRepository;

  final ValueNotifier<MovieDetails?> _movie = ValueNotifier(null);

  ValueListenable<MovieDetails?> get movie => _movie;

  MovieDetailsViewModel({required this.movieRepository});

  @override
  void onViewReady({MovieDetailsArgument? argument}) {
    super.onViewReady();
    fetchMovie(movieId: argument!.movieId);
  }

  void fetchMovie({required String movieId}) async {
    MovieDetails? movie =
        await loadData(movieRepository.getMovieDetails(movieId: movieId));
    if (movie != null) {
      _movie.value = movie;
    }
  }
}
