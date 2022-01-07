import 'package:flutter/material.dart';
import 'package:peliculas/models/movie.dart';
import 'package:peliculas/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
  
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBAr(movie),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle(movie),
              _Overview(movie),
              CastingCards(movie.id)
            ])
          )
        ],
      )
    );
  }
}


class _CustomAppBAr extends StatelessWidget {

  final Movie movie; 
  const _CustomAppBAr(this.movie);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating:false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle:true,
        titlePadding: const EdgeInsets.all(0),
        
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 10,left:10,right: 10),
          color:Colors.black12,
          child: Text(movie.title,style: const TextStyle(fontSize: 16),overflow: TextOverflow.ellipsis,maxLines: 2,textAlign: TextAlign.center,),
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.fullbackdropPath),
          fit: BoxFit.cover
        )
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {

  final Movie movie;

  const _PosterAndTitle(this.movie);

  @override
  Widget build(BuildContext context) {

    final textTheme= Theme.of(context).textTheme;
    final size= MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top:20),
      padding: const EdgeInsets.symmetric(horizontal:20),
      child: Row(
        children: [
          Hero(
            tag:movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'), 
                image: NetworkImage(movie.fullPosterImg),
                height: 150,
              )
            ),
          ),

          const SizedBox(width: 20,),
          ConstrainedBox(constraints: BoxConstraints(maxWidth: size.width-200),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[

              Text(
                movie.title, 
                style:textTheme.headline5,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              Text(
                movie.originalTitle, 
                style:textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              Row(children: [
                Icon(Icons.star_outline,size:15, color:Colors.grey),
                SizedBox(width: 5,),
                Text(movie.voteAverage.toString(),style: textTheme.caption)
                
              ],)
            ]
          ))
          
        ],
      )
    );
  }
}


class _Overview extends StatelessWidget {

  final Movie movie;
  const _Overview(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1
        )
    );
  }
}