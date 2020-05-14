import 'package:flutter/material.dart';
import './http_helper.dart';
import './movie.dart';
import './movie_detail.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  Icon visibleIcon = Icon(Icons.search);
  Widget searchBar = Text('Movies');

  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
  int moviesCount;
  List movies;

  //List result; // = [Movie(2, 'tile', 2, 'xxxx', 'yyyyy', 'zzzzzS')];
  HttpHelper helper;

  Future initialize() async {
    movies = List();
    movies = await helper.getUpcoming();
    setState(() {
      moviesCount = movies.length;
      movies = movies;
    });
  }

  Future search(text) async {
    movies = await helper.findMovies(text);
    setState(() {
      moviesCount = movies.length;
      movies = movies;
    });
  }

  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    return Scaffold(
      appBar: AppBar(
        title: searchBar,
        actions: <Widget>[
          IconButton(
              icon: visibleIcon,
              onPressed: () {
                setState(() {
                  if (this.visibleIcon.icon == Icons.search) {
                    this.visibleIcon = Icon(Icons.cancel);
                    this.searchBar = TextField(
                      textInputAction: TextInputAction.search,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                      autofocus: true,
                      onSubmitted: search,
                    );
                  } else {
                    this.visibleIcon = Icon(Icons.search);
                    this.searchBar = Text('Movies');
                  }
                });
              })
        ],
      ),
      body: Container(
          child: ListView.builder(
        itemCount: this.moviesCount == null ? 0 : this.moviesCount,
        itemBuilder: (BuildContext context, int index) {
          var imageUrl = (movies[index] as Movie).posterPath != null
              ? iconBase + (movies[index] as Movie).posterPath
              : defaultImage;
          image = NetworkImage(imageUrl);
          print(imageUrl);
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text((movies[index] as Movie).title),
              subtitle: Text(
                  'released: ${(movies[index] as Movie).releaseDate} - Vote: ${(movies[index] as Movie).voteAverage.toString()}'),
              leading: CircleAvatar(
                backgroundImage: image,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MovieDetail(movies[index])));
              },
            ),
          );
        },
      )),
    );
  }
}
