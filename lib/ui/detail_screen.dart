import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/bloc/get_movie_videos_bloc.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/model/video.dart';
import 'package:movie_app/model/video_response.dart';
import 'package:movie_app/style/theme.dart' as Style;
import 'package:movie_app/ui/video_player.dart';
import 'package:movie_app/widgets/cast.dart';
import 'package:movie_app/widgets/movie_info.dart';
import 'package:movie_app/widgets/similiar_movies.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  MovieDetailScreen({Key key, @required this.movie}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState(movie);
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final Movie movie;

  _MovieDetailScreenState(this.movie);

  @override
  void initState() {
    super.initState();
    movieVideoBLoc..getMovieVideo(movie.id);
  }

  @override
  void dispose() {
    super.dispose();
    movieVideoBLoc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      body: Builder(builder: (context) {
        return SliverFab(
          floatingPosition: FloatingPosition(right: 20.0),
          floatingWidget: StreamBuilder<VideoResponse>(
            stream: movieVideoBLoc.subject.stream,
            builder: (context, AsyncSnapshot<VideoResponse> snapshot) {
              // (context, AsyncSnapshot<VideoResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    snapshot.data.error.length > 0) {
                  return _buildErrorWidget(snapshot.data.error);
                }
                return _buildVideoWidget(snapshot.data);
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error);
              } else {
                return _buildLoadingWidget();
              }
            },
          ),
          expandedHeight: 200.0,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              backgroundColor: Style.Colors.mainColor,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  movie.title.length > 40
                      ? movie.title.substring(0, 37) + "..."
                      : movie.title,
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
                background: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://image.tmdb.org/t/p/original" +
                                  movie.backdropPath),
                        ),
                      ),
                      child: Container(
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.5)),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.0),
                          ])),
                    )
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(0.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          movie.voteAverage.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        RatingBar(
                          itemSize: 8.0,
                          initialRating: movie.voteCount / 2,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => Icon(
                            EvaIcons.star,
                            color: Style.Colors.secondColor,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 20.0),
                    child: Text(
                      "OVERVIEW",
                      style: TextStyle(
                          color: Style.Colors.titleColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      movie.overview,
                      style: TextStyle(
                          color: Colors.white, fontSize: 12.0, height: 1.5),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  MovieInfo(id: movie.id),
                  Casts(id: movie.id),
                  SimiliarMovies(id: movie.id),
                ]),
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Sorry, data not found!\n$error",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVideoWidget(VideoResponse data) {
    List<Video> videos = data.videos;
    return FloatingActionButton(
      backgroundColor: Style.Colors.secondColor,
      child: Icon(Icons.play_arrow),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(
                      controller: YoutubePlayerController(
                          initialVideoId: videos[0].key,
                          flags: YoutubePlayerFlags(
                            autoPlay: true,
                          )),
                    )));
      },
    );
  }
}
