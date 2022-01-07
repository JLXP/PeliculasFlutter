import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/models/cast.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {

   final int movieId;
   const CastingCards( this.movieId);

  @override
  Widget build(BuildContext context) {

    final moviesProvider= Provider.of<MoviesProvider>(context, listen:false);


    //El Future es para poder hacer peticiones asyncronas
    return FutureBuilder(
      future:moviesProvider.getMovieCast(movieId),
      builder: (_,AsyncSnapshot<List<Cast>> snapshot){

        if(!snapshot.hasData){
          return Container(
            constraints: BoxConstraints(maxWidth: 150),
            height: 180,
            child: CupertinoActivityIndicator(),
          );
        }

        final List<Cast> cast = snapshot.data!;


        return Container(
          margin: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height:180,
          child: ListView.builder(
            itemCount: cast.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, int index) => _CastCard(cast[index]),
          ),
        );
      },
    );
      


    
  }
}

class _CastCard extends StatelessWidget {

  final Cast cast;

  const _CastCard(this.cast);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width:110,
      height: 100,
      child: Column(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FadeInImage(
            placeholder: AssetImage('assets/no-image.jpg'),
            image: NetworkImage(cast.fullProfilePath),
            height: 140,
            width: 100,
            fit: BoxFit.cover
          ),
        ),
        SizedBox(height: 5,),
        Text(cast.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,)
      ],),
    );
  }
}