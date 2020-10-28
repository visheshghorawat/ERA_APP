import 'package:ERA/VideoLibrary/customTile.dart';
import 'package:ERA/VideoLibrary/fetchvideomethod.dart';
import 'package:ERA/VideoLibrary/size_config.dart';
import 'package:ERA/VideoLibrary/storagemethos.dart';
import 'package:ERA/models/videodetail.dart';
import 'package:flutter/material.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  TextEditingController textcontroller = TextEditingController();
  StorageMethods storageMethods = StorageMethods();
  String query = " ";
  List<VideoDetail> videoList = List<VideoDetail>();
  GetVideo getVideo = GetVideo();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVideo.fetchAllVideos().then((List<VideoDetail> value) {
      setState(() {
        videoList = value;
        print(videoList);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buildSuggestions(String query) {
      print(query);

      final List<VideoDetail> suggestionList = query.isEmpty
          ? []
          : videoList != null
              ? videoList.where((VideoDetail videodetail) {
                  String _getSubtitle = videodetail.subtitle.toLowerCase();
                  String _query = query.toLowerCase();
                  String _getTitle = videodetail.title.toLowerCase();
                  bool matchesUsername = _getSubtitle.contains(_query);
                  bool matchesName = _getTitle.contains(_query);

                  return (matchesUsername || matchesName);
                }).toList()
              : [];

      if (suggestionList.length == 0) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Oop! Sorry result found...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(25),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        );
      } else {
        return ListView.builder(
          // reverse: true,
          itemCount: suggestionList.length,
          itemBuilder: ((context, index) {
            VideoDetail searchvideo = VideoDetail(
                videoId: suggestionList[index].videoId,
                videoUrl: suggestionList[index].videoUrl,
                title: suggestionList[index].title,
                subtitle: suggestionList[index].subtitle,
                timestamp: suggestionList[index].timestamp);
            print(searchvideo.videoUrl);
            return CustomTile(
              searchvideo: searchvideo,
            );
          }),
        );
      }
    }

    allvideo() {
      return ListView.builder(
        // reverse: true,
        itemCount: videoList.length,
        itemBuilder: ((context, index) {
          VideoDetail searchvideo = VideoDetail(
              videoId: videoList[index].videoId,
              videoUrl: videoList[index].videoUrl,
              title: videoList[index].title,
              subtitle: videoList[index].subtitle,
              timestamp: videoList[index].timestamp);

          return CustomTile(
            searchvideo: searchvideo,
          );
        }),
      );
    }

    SizeConfig().init(context);
    print(SizeConfig.orientation);
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Color(0xff03258C),
        title: Text("VIDEOS", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.cloud_upload,
              color: Colors.white,
            ),
            onPressed: () {
              storageMethods.uploadToStorage();
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: SizeConfig.orientation == Orientation.landscape
                ? 60
                : getProportionateScreenHeight(75),
            margin: EdgeInsets.all(3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey[350]),
            child: Card(
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Search",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(22),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: SizeConfig.orientation == Orientation.landscape
                        ? 40
                        : getProportionateScreenHeight(40),
                    width: MediaQuery.of(context).size.width > 500 ? 450 : 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: TextField(
                      controller: textcontroller,
                      onChanged: (value) {
                        setState(() {
                          query = value;
                        });
                      },
                      textInputAction: TextInputAction.done,
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: query.isEmpty ? allvideo() : buildSuggestions(query),
          ),
        ],
      ),
    );
  }
}
