

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/cast.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/popular_response.dart';
import 'package:peliculas/models/search_response.dart';

class MoviesProvider extends ChangeNotifier{

  String _apiKey = '700f316b453aa0257e334f1bdde79aa7';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-ES';

  List<Movie> onDisplayMovies= [];
  List<Movie> popularMovies= [];


  //creamos un objeto para luego poder asignar valores
  Map <int, List<Cast>> movieCast = {};
  
  
  int _popularPage=0;

  final debouncer = Debouncer(duration: Duration(milliseconds: 500), );

  final StreamController<List<Movie>> _suggestionStreamController = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => this._suggestionStreamController.stream;


  MoviesProvider(){
    print('MoviesProvider inicializando');
    this.getOnDisplayMovies();
    this.getPopularMovies();

    
  }

  Future<String> _getJsonData( String endpoint, [int page = 1] )async{
    final url = Uri.https(_baseUrl, endpoint, 
      {
        'api_key':_apiKey,
        'language': _language,
        'page':'$page'
      });    
        
    final response = await http.get(url);
    return response.body;
  }


  getOnDisplayMovies() async{

    final jsonData=await _getJsonData('3/movie/now_playing');   
    final nowPlayingResponse=NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPlayingResponse.results;
    
    notifyListeners();
    
  }

  getPopularMovies() async{

    _popularPage++;
    final jsonData=await _getJsonData('3/movie/popular',_popularPage);   
    final popularResponse=PopularResponse.fromJson(jsonData);

    popularMovies = [...popularMovies, ...popularResponse.results];
        
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async{

    if(movieCast.containsKey(movieId)) return movieCast[movieId]!;


     final jsonData=await _getJsonData('3/movie/$movieId/credits');  
     final creditsResponse = CredistResponse.fromJson(jsonData);

     movieCast[movieId] = creditsResponse.cast;

     return creditsResponse.cast;
  }


  Future<List<Movie>> searchMovies(String query) async{

    final url = Uri.https(_baseUrl, '3/search/movie', 
      {
        'api_key':_apiKey,
        'language': _language,
        'query': query
      });    
        
    
    try{
      final response = await http.get(url);
      final searchResponse = SearchResponse.fromJson(response.body);
      return searchResponse.results;
    } catch (error) {
      print(('ERROR: $error'));
      final List<Movie> list = [];
      return list;
    }

    
  }
  
  void getSuggestionByQuery(String searchTerm){
    debouncer.value = '';
    debouncer.onValue = (value) async {
    
      final results = await this.searchMovies(value);
      this._suggestionStreamController.add(results);
    };
    final timer = Timer.periodic(Duration(milliseconds: 300),(_){
      debouncer.value = searchTerm;
    });
    
    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }

}