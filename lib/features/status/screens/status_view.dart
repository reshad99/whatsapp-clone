// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp_clone/common/enums/file_type.dart';
import 'package:whatsapp_clone/common/utils/helpers.dart';
import 'package:whatsapp_clone/models/story.dart';
import 'package:whatsapp_clone/models/user.dart';

class StoryViewScreen extends StatefulWidget {
  const StoryViewScreen({
    Key? key,
    required this.stories,
    required this.user,
  }) : super(key: key);
  final List<Story> stories;
  final UserModel user;

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  final StoryController storyController = StoryController();
  late List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    initStoryItems();
  }

  void initStoryItems() {
    for (var story in widget.stories) {
      if (story.fileType == FileType.image) {
        storyItems.add(StoryItem.pageImage(
            url: story.url,
            controller: storyController,
            caption: story.text,
            imageFit: BoxFit.contain));
      } else {
        storyItems.add(StoryItem.pageVideo(story.url,
            controller: storyController, caption: story.text));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StoryView(
            storyItems: storyItems,
            controller: storyController,
            onComplete: () {
              Navigator.maybePop(context);
            },
            progressPosition: ProgressPosition.bottom,
            onVerticalSwipeComplete: (p0) {},
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 48,
              left: 16,
              right: 16,
            ),
            child: Row(
              children: [
                IconButton(onPressed: () {
                  Navigator.maybePop(context);
                }, icon: const Icon(Icons.arrow_back)),
                CircleAvatar(
                    backgroundImage: getProfilePic(widget.user.profilePic)),
                Text(widget.user.name)
              ],
            ),
          )
        ],
      ),
    );
  }
}
