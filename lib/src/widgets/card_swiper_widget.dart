import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/peliculas_model.dart';

class CardSwiper extends StatelessWidget {

  final List<Pelicula> peliculas;

  CardSwiper({ @required this.peliculas });

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        itemWidth: _screenSize.width * 0.7, // 70%
        itemHeight: _screenSize.height * 0.45, // 45%
        layout: SwiperLayout.STACK,
        itemBuilder: (BuildContext context, int index){
          peliculas[index].uniqueId = '${ peliculas[index].id }-tarjeta';
          return Hero(
            tag: peliculas[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: _gestureDetector(context, peliculas[index])
            ),
          );
        },
        itemCount: peliculas.length
        //pagination: new SwiperPagination(), // 3 puntos
        //control: new SwiperControl(), // <izq - der>
      )
    );
  }

  Widget _gestureDetector(BuildContext context, Pelicula pelicula) {
    return GestureDetector(
      child: FadeInImage(
        fit: BoxFit.cover,
        placeholder: AssetImage('assets/img/no-image.jpg'), 
        image: NetworkImage( pelicula.getPosterImg() ),
      ),
      onTap: () => Navigator.pushNamed(context, 'detalle', arguments: pelicula)      
    );
  }
}