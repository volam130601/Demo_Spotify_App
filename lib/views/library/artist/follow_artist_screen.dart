import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/data/network/firebase/follow_artist_service.dart';
import 'package:demo_spotify_app/models/firebase/follow_artist.dart';
import 'package:demo_spotify_app/utils/colors.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:demo_spotify_app/utils/constants/default_constant.dart';
import 'package:demo_spotify_app/utils/toast_utils.dart';
import 'package:demo_spotify_app/widgets/navigator/slide_animation_page_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../models/artist.dart';
import 'more_artist_search_screen.dart';

class FollowArtistScreen extends StatelessWidget {
  const FollowArtistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Ionicons.search))
        ],
      ),
      body: StreamBuilder(
        stream: FollowArtistService.instance
            .getFollowArtistByUserId(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return buildNullFollowArtist(context);
          }
          if (!snapshot.hasData) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 300,
              child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 40,
                ),
              ),
            );
          }
          FollowArtist? followArtist = snapshot.data;
          List<Artist>? artists = snapshot.data!.artists;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Text(
                  'Artist',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Colors.white),
                ),
                Text(
                  '${artists!.length} Artist • Following',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                paddingHeight(1),
                SizedBox(
                  height: artists.length * 70,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return buildListTileFollowArtist(
                          context, artists[index], followArtist!);
                    },
                    itemCount: artists.length,
                  ),
                ),
                paddingHeight(1),
                buildListITileMoreArtist(context, followArtist!),
                paddingHeight(9),
              ],
            ),
          );
        },
      ),
    );
  }

  InkWell buildListITileMoreArtist(
      BuildContext context, FollowArtist followArtist) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            SlideTopPageRoute(page: MoreArtists(followArtist: followArtist)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: ListTile(
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: ColorsConsts.primaryColorDark,
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: const Icon(Ionicons.add_circle_outline),
          ),
          contentPadding: const EdgeInsets.all(0),
          title: Text(
            'More Artist',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }

  Widget buildListTileFollowArtist(
      BuildContext context, Artist artist, FollowArtist followArtist) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: ListTile(
        leading: SizedBox(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              imageUrl: artist.pictureMedium.toString(),
              placeholder: (context, url) => Image.asset(
                'assets/images/music_default.jpg',
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.all(0),
        title: Text(
          artist.name.toString(),
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          (artist.nbFan != null)
              ? '${CommonUtils.convertToShorthand(artist.nbFan!.toInt())} following'
              : '0 following',
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        trailing: IconButton(
          onPressed: () {
            FollowArtistService.instance
                .unFollowingArtist(followArtist: followArtist, artist: artist);
            ToastCommon.showCustomText(
                content: 'Unfollow artist ${artist.name} from artist follow');
          },
          icon: const Icon(Ionicons.heart),
        ),
      ),
    );
  }

  Container buildNullFollowArtist(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
      height: double.infinity,
      child: Column(
        children: [
          Text(
            'Artist',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white),
          ),
          paddingHeight(5),
          Image.asset(
            'assets/images/artist_default.png',
            width: 150,
            color: Colors.grey,
          ),
          Text(
            'You haven\'t followed any artists yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          paddingHeight(0.3),
          Text(
            'Find an artist you love and click interested to add to the library',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          paddingHeight(0.3),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(SlideTopPageRoute(page: const MoreArtists()));
              },
              style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding:
                      const EdgeInsets.symmetric(vertical: defaultPadding)),
              child: Text(
                'More artists'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }
}
