import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/peliculas_model.dart';

class PeliculasProvider {

  String _apiKey = 'cbbd0ad01616708adf22c7cd639060a0';
  String _url = 'api.themoviedb.org';
  String _languaje = 'en-US';
  int _popularesPage = 0;
  bool _cargando = false; // para cargar una sola vez en el infite scroll

  List<Pelicula> _populares = new List();

  // broadcast -> permite que varios lugares escuchen la emision del Stream
  final _popularesStreamCtrl = StreamController<List<Pelicula>>.broadcast();

  // introducir datos al stream
  Function(List<Pelicula>) get popularesSink => _popularesStreamCtrl.sink.add;

  // escuchar cambios del stream
  Stream<List<Pelicula>> get popularesStream => _popularesStreamCtrl.stream;

  void disposeStreams() {
    _popularesStreamCtrl?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {    

    final resp = await http.get( url );
    final decodedData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList( decodedData['results'] );

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _languaje
    });

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    
    if (_cargando) {
      return [];
    }

    _cargando = true;
    _popularesPage++;
    
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _languaje,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink( _populares );
    _cargando = false;

    return resp;
  }

  Future<List<Actor>> getCast(String peliculaId) async {

    print(peliculaId);

    final url = Uri.https(_url, '3/movie/$peliculaId/credits', {
      'api_key': _apiKey,
      'language': _languaje
    });

    final resp = await http.get(url);
    final decodeData = json.decode( resp.body );
    final cast = new Cast.fromJsonList( decodeData['cast']);
    
    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {

    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apiKey,
      'language': _languaje,
      'query': query,
      'include_adult': 'true'
    });

    return await _procesarRespuesta(url);
  }

}