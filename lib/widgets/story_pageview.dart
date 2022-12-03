import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vgram/widgets/storymodel.dart';
import 'package:video_player/video_player.dart';

class Storypageview extends StatefulWidget {
  Storypageview({Key? key, required this.stories}) : super(key: key);
  List<Story> stories;

  @override
  State<Storypageview> createState() => _StorypageviewState();
}

class _StorypageviewState extends State<Storypageview> {
  PageController page = PageController();
  late VideoPlayerController videoPlayerController;
  int pageindex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    page = PageController();
    videoPlayerController = VideoPlayerController.network(widget.stories[1].url)
      ..initialize().then((value) => setState(() {}));
    videoPlayerController.play();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController.dispose();
    page.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Story st = widget.stories[pageindex];
    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) =>
            _ontapdown(details, st, widget.stories.length - 1),
        child: Stack(
          children: [
            PageView.builder(
              onPageChanged: (val) => {
                if (st.media == MediaType.image)
                  {
                    videoPlayerController.pause(),
                  }
                else
                  videoPlayerController.play()
              },
              controller: page,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.stories.length,
              itemBuilder: (context, index) {
                final story = widget.stories[index];
                switch (story.media) {
                  case MediaType.image:
                    return CachedNetworkImage(
                      imageUrl: story.url,
                      fit: BoxFit.cover,
                    );
                  case MediaType.video:
                    if (videoPlayerController != null &&
                        videoPlayerController.value.isInitialized) {
                      return FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: videoPlayerController.value.size.width,
                          height: videoPlayerController.value.size.height,
                          child: VideoPlayer(videoPlayerController),
                        ),
                      );
                    }
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _ontapdown(TapDownDetails details, story, last) {
    final double screenwidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (pageindex == last) {
      Navigator.pop(context);
    }
    if (dx < screenwidth / 3) {
      setState(() {
        if (pageindex - 1 >= 0) {
          pageindex -= 1;
        }
      });
    } else if (dx > 2 * screenwidth / 3) {
      setState(() {
        if (pageindex + 1 < widget.stories.length) {
          pageindex += 1;
        } else {
          pageindex = 0;
        }
      });
    } else {
      if (story.media == MediaType.video) {
        if (videoPlayerController.value.isPlaying) {
          videoPlayerController.pause();
        } else {
          videoPlayerController.play();
        }
      }
    }
    page.animateToPage(pageindex,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }
}
