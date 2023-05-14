// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp_clone/core/enums/file_type.dart';
import 'package:whatsapp_clone/core/utils/colors.dart';
import 'package:whatsapp_clone/core/utils/helpers.dart';
import 'package:whatsapp_clone/core/utils/style.dart';
import 'package:whatsapp_clone/features/status/controller/status_controller.dart';
import 'package:whatsapp_clone/models/story.dart';
import 'package:whatsapp_clone/models/user.dart';

class StoryViewScreen extends ConsumerStatefulWidget {
  const StoryViewScreen({
    Key? key,
    required this.stories,
    required this.user,
  }) : super(key: key);
  final List<Story> stories;
  final UserModel user;

  @override
  ConsumerState<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends ConsumerState<StoryViewScreen> {
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
            uid: story.uid,
            url: story.url,
            controller: storyController,
            caption: story.text,
            shown: true,
            imageFit: BoxFit.contain));
      } else {
        storyItems.add(StoryItem.pageVideo(story.uid, story.url,
            controller: storyController, caption: story.text));
      }
    }
  }

  void _showModalBottomSheet() {
    debugPrint('Show modal bottom sheet clickeddddddd');
    Size size = MediaQuery.of(context).size;

    Future.delayed(Duration.zero, () {
      debugPrint('Futureye girildi');
      showModalBottomSheet(
        isScrollControlled: true,
        constraints: BoxConstraints(
            maxWidth: size.width * 0.95, maxHeight: size.height / 1.5),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        context: context,
        builder: (context) {
          debugPrint('showmodal builderine girildi');

          return StreamBuilder<List<UserModel>>(
            stream: ref
                .read(statusControllerProvider)
                .getWhoHasSeen(ref.watch(currentStoryUidProvider)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }

              if (snapshot.hasError) {
                debugPrint('hasError');

                return const Text('Something went wrong');
              }

              if (snapshot.hasData) {
                debugPrint('has data ${snapshot.data!}');
              } else {
                debugPrint('Not any data');
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    color: tabColor,
                    height: 65.h,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19),
                      child: Row(
                        children: [
                          Text(
                            'Viewed by ${snapshot.data!.length}',
                            style: viewedByTextStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var user = snapshot.data![index];
                        debugPrint('${user.name} listview buildir icinde ');
                        return ListTile(
                          leading: CircleAvatar(
                              backgroundImage: getProfilePic(user.profilePic)),
                          title: Text(user.name),
                          subtitle: Text(user.lastUpdate!),
                        );
                      },
                    ),
                  )
                ],
              );
            },
          );
        },
      );
    });
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
            onStoryShow: (story) {
              debugPrint(story.uid);
              ref
                  .read(statusControllerProvider)
                  .viewStatus(ref.watch(currentStatusUidProvider), story.uid!);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref
                    .read(currentStoryUidProvider.notifier)
                    .update((state) => story.uid!);
              });
            },
            onVerticalSwipeComplete: (p0) {
              _showModalBottomSheet();
            },
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 48,
              left: 16,
              right: 16,
            ),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
                CircleAvatar(
                    backgroundImage: getProfilePic(widget.user.profilePic)),
                Text(widget.user.name),
                StreamBuilder(
                  stream: ref
                      .read(statusControllerProvider)
                      .getWhoHasSeen(ref.watch(currentStatusUidProvider)),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!.length.toString());
                    }

                    return Text('sdd');
                  },
                )
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 50,
            left: 50,
            child: IconButton(
                onPressed: () {
                  _showModalBottomSheet();
                },
                icon: const Icon(Icons.remove_red_eye)),
          )
        ],
      ),
    );
  }
}
