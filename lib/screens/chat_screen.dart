import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:homies/constants.dart';
import 'package:homies/models/chat_model.dart';
import 'package:homies/screens/auth_screen.dart';
import 'package:homies/services/emoji_service.dart';
import 'package:homies/services/shared_preferences_service.dart';
import 'package:homies/styles.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_emoji_picker/keyboard_emoji_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:record_mp3/record_mp3.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.chatScreenNavigateModel,
  }) : super(key: key);

  final ChatScreenNavigateModel chatScreenNavigateModel;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  late AudioPlayer audioPlayer;
  int i = 0;
  String voicePath = "";
  DateTime voiceRecordingStartTime = DateTime.now(),
      voiceRecordingEndTime = DateTime.now();
  List<Message> messages = [
    Message.text(
      content: "Hi there, will you come in time?",
      isSentByMe: false,
      sentDateTime: DateTime.now().subtract(
        Duration(
          minutes: 1,
        ),
      ),
    ),
    Message.text(
      content: "Yes, I will",
      isSentByMe: true,
      sentDateTime: DateTime.now().subtract(
        Duration(
          minutes: 1,
        ),
      ),
    ),
    Message.text(
      content:
          "Thanks a lot. We also have different services for guest like: free wifi, sauna and spa",
      isSentByMe: false,
      sentDateTime: DateTime.now().subtract(
        Duration(
          minutes: 1,
        ),
      ),
    ),
    Message.text(
      content: "Sound great. Where can I contact?",
      isSentByMe: true,
      sentDateTime: DateTime.now().subtract(
        Duration(
          minutes: 1,
        ),
      ),
    ),
    Message.text(
      content: "Please tell the receptionist",
      isSentByMe: false,
      sentDateTime: DateTime.now().subtract(
        Duration(
          minutes: 1,
        ),
      ),
    ),
    Message.text(
      content: "Thank you",
      isSentByMe: true,
      sentDateTime: DateTime.now().subtract(
        Duration(
          minutes: 1,
        ),
      ),
    ),
    Message.text(
      content: "You’re welcome and have a good day. See you soon!",
      isSentByMe: false,
      sentDateTime: DateTime.now().subtract(
        Duration(
          minutes: 1,
        ),
      ),
    ),
  ];
  bool emojiKeyboardOpen = false;

  // late PlayerState globalState;
  // Duration globalNewDuration = Duration(seconds: 0),
  //     globalNewPosition = Duration(seconds: 0);

  @override
  void initState() {
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    _messageController.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(seconds: 2),
        curve: Curves.ease,
      );
    });

    audioPlayer = AudioPlayer();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {});
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {});
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {});
    });
    super.initState();
  }

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath =
        "${storageDirectory.path}/record${DateTime.now().microsecondsSinceEpoch}.acc";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/test_${i++}.mp3";
  }

  void startRecording() async {
    PermissionStatus permission = await Permission.microphone.status;
    if (permission.isDenied) {
      await Permission.microphone.request();
    }
    if (permission.isPermanentlyDenied) {
      await openAppSettings();
    }
    if (permission.isGranted) {
      voicePath = await getFilePath();
      // RecordMp3.instance.start(voicePath, (type) {
      //   setState(() {});
      // });
    }
    setState(() {});
  }

  Future<void> toggleEmojiKeyboard() async {
    setState(() {
      emojiKeyboardOpen = !emojiKeyboardOpen;
    });
    if (emojiKeyboardOpen) {
      await Future.delayed(
        Duration(milliseconds: 200),
      ).then((value) async {
        await SystemChannels.textInput.invokeListMethod('TextInput.hide');
      });
    } else {
      {
        await Future.delayed(
          Duration(milliseconds: 200),
        ).then((value) async {
          await SystemChannels.textInput.invokeListMethod('TextInput.show');
        });
      }
    }
  }

  getEmojiKeyboardIos() async {
    final hasEmojiKeyboard =
        await KeyboardEmojiPicker().checkHasEmojiKeyboard();
    if (hasEmojiKeyboard) {
      // log("ios emoji keyboard");
      // Open the keyboard.
      final emoji = await KeyboardEmojiPicker().pickEmoji();
      if (emoji != null) {
        // Do something with the emoji
        _messageController.text = "${_messageController.text}$emoji ";

        // log(emoji);
      } else {
        // The emoji picking process was cancelled (usually, the keyboard was closed).
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        // centerTitle: true,
        title: Text(
          widget.chatScreenNavigateModel.name,
          style: TextStyle(
            fontSize: 18,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: (() {}),
            icon: Icon(Icons.video_call_rounded),
            color: AppColors.white,
          ),
          IconButton(
            onPressed: (() {}),
            icon: Icon(Icons.call),
            color: AppColors.white,
          ),
          IconButton(
            onPressed: (() {}),
            icon: Icon(Icons.menu),
            color: AppColors.white,
          ),
        ],
      ),
      body: KeyboardEmojiPickerWrapper(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 15,
            ),
            child: Column(
              children: [
                Expanded(
                  child: GroupedListView<Message, DateTime>(
                    controller: _scrollController,
                    reverse: true,
                    order: GroupedListOrder.DESC,
                    elements: messages,
                    groupBy: ((message) => DateTime(2024)),
                    groupHeaderBuilder: ((Message message) => SizedBox()),
                    itemBuilder: ((ctx, Message message) {
                      switch (message.messageType) {
                        case MessageType.text:
                          {
                            if (message.isSentByMe == true) {
                              return ChatBubble(
                                message: message.content,
                                alignment: Alignment.centerRight,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                right: 15,
                                containerColor: AppColors.activeDotColor,
                                textColor: AppColors.white,
                                timeTextColor: AppColors.white,
                                topLeft: Radius.circular(15),
                                sentDateTime: message.sentDateTime,
                              );
                            } else {
                              return ChatBubble(
                                message: message.content,
                                sentDateTime: message.sentDateTime,
                                alignment: Alignment.centerLeft,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                left: 15,
                                containerColor: AppColors.inactiveDotColor,
                                textColor: AppColors.mainColor,
                                timeTextColor: AppColors.mainColor,
                                topRight: Radius.circular(15),
                              );
                            }
                          }

                        case MessageType.image:
                          {
                            if (message.isSentByMe) {
                              return ChatBubble(
                                message: message.content,
                                alignment: Alignment.centerRight,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                right: 15,
                                containerColor: AppColors.activeDotColor,
                                textColor: AppColors.white,
                                timeTextColor: AppColors.white,
                                topLeft: Radius.circular(15),
                                sentDateTime: message.sentDateTime,
                              );
                            } else {
                              return Container();
                            }
                          }
                        // case MessageType.voice:
                        //   {
                        //     bool isPlaying = false;
                        //     Duration duration = message.endDateTime
                        //         .difference(message.startDateTime);
                        //     Duration position = Duration(seconds: 0);
                        //
                        //     if (message.isSentByMe == true) {
                        //       return ChatBubble(
                        //         message: message.content,
                        //         alignment: Alignment.centerRight,
                        //         crossAxisAlignment: CrossAxisAlignment.end,
                        //         right: 15,
                        //         containerColor: AppColors.activeDotColor,
                        //         textColor: AppColors.white,
                        //         timeTextColor: AppColors.white,
                        //         topLeft: Radius.circular(15),
                        //         sentDateTime: message.sentDateTime,
                        //         mainContent: Row(
                        //           children: [
                        //             IconButton(
                        //               onPressed: (() async {}),
                        //               icon: Icon(
                        //                 isPlaying == true
                        //                     ? Icons.cancel
                        //                     : Icons.play_arrow,
                        //               ),
                        //             ),
                        //             Expanded(
                        //               child: Column(
                        //                 children: [
                        //                   Slider(
                        //                     min: 0,
                        //                     max: duration.inSeconds.toDouble(),
                        //                     value: position.inSeconds.toDouble(),
                        //                     onChanged: ((val) async {
                        //                       position =
                        //                           Duration(seconds: val.toInt());
                        //                     }),
                        //                   ),
                        //                   Text(position.inSeconds.toString()),
                        //                 ],
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       );
                        //     } else {
                        //       return Container();
                        //     }
                        //   }
                        default:
                          {
                            if (message.isSentByMe == true) {
                              return ChatBubble(
                                message: message.content,
                                alignment: Alignment.centerRight,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                right: 15,
                                containerColor: AppColors.activeDotColor,
                                textColor: AppColors.white,
                                timeTextColor: AppColors.white,
                                topLeft: Radius.circular(15),
                                sentDateTime: message.sentDateTime,
                              );
                            } else {
                              return ChatBubble(
                                message: message.content,
                                sentDateTime: message.sentDateTime,
                                alignment: Alignment.centerLeft,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                left: 15,
                                containerColor: AppColors.inactiveDotColor,
                                textColor: AppColors.mainColor,
                                timeTextColor: AppColors.mainColor,
                                topRight: Radius.circular(15),
                              );
                            }
                          }
                      }
                    }),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.transparent,
                  ),
                  padding: const EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                    left: 5,
                    right: 5,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        // duration: Duration(milliseconds: 200),
                        // width: _messageController.text.trim().isNotEmpty
                        //     ? MediaQuery.of(context).size.width - 65
                        //     : MediaQuery.of(context).size.width - 10,
                        child: InputChatField(
                          textColor: AppColors.white,
                          visibility: false,
                          minLines: 1,
                          maxLines: 5,
                          controller: _messageController,
                          textInputType: TextInputType.multiline,
                          hint: "Type message",
                          fillColor: AppColors.activeDotColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              width: 0,
                              color: AppColors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              width: 0,
                              color: AppColors.transparent,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              width: 0,
                              color: AppColors.transparent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              width: 0,
                              color: AppColors.transparent,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              width: 0,
                              color: AppColors.transparent,
                            ),
                          ),
                          prefix: SuffixBtn(
                            icon: emojiKeyboardOpen
                                ? Icons.emoji_emotions
                                : Icons.emoji_emotions_outlined,
                            onTap: Platform.isIOS
                                ? getEmojiKeyboardIos
                                : toggleEmojiKeyboard,
                          ),
                          suffix: SizedBox(
                            height: 30,
                            width: 85,
                            child: Row(
                              children: [
                                Transform.rotate(
                                  angle: 0.8,
                                  child: SuffixBtn(
                                    icon: Icons.attach_file_rounded,
                                    onTap: () {},
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                SuffixBtn(
                                  icon: CupertinoIcons.camera,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                          contentPadding: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 15,
                            bottom: 15,
                          ),
                        ),
                      ),
                      if (_messageController.text.trim().isNotEmpty)
                        SizedBox(
                          width: 5,
                        ),
                      // if (_messageController.text.trim().isNotEmpty)
                      GestureDetector(
                        onTap: (() {
                          messages.add(
                            Message.text(
                              content: _messageController.text.trim(),
                              isSentByMe: true,
                              sentDateTime: DateTime.now(),
                            ),
                          );
                          _messageController.clear();
                          setState(() {});
                          _scrollController.animateTo(
                            _scrollController.position.minScrollExtent,
                            duration: Duration(seconds: 2),
                            curve: Curves.ease,
                          );
                        }),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: _messageController.text.trim().isNotEmpty
                              ? 50
                              : 0,
                          height: _messageController.text.trim().isNotEmpty
                              ? 50
                              : 0,
                          decoration: BoxDecoration(
                            color: AppColors.activeButtonColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.send,
                            color: AppColors.white,
                            size: _messageController.text.trim().isNotEmpty
                                ? 30
                                : 0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Offstage(
                  offstage: !emojiKeyboardOpen,
                  child: EmojiKeyBoard(
                    textEditingController: _messageController,
                    emailKeyboardOpen: emojiKeyboardOpen,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmojiKeyBoard extends StatefulWidget {
  const EmojiKeyBoard({
    super.key,
    required this.textEditingController,
    required this.emailKeyboardOpen,
  });

  final TextEditingController textEditingController;
  final bool emailKeyboardOpen;

  @override
  State<EmojiKeyBoard> createState() => _EmojiKeyBoardState();
}

class _EmojiKeyBoardState extends State<EmojiKeyBoard>
    with SingleTickerProviderStateMixin {
  late TextEditingController _emojiSearchController;
  EmojiService emojiService = EmojiService();
  List<Emoji> smileyEmojis = [];
  List<Emoji> activityEmojis = [];
  List<Emoji> animalEmojis = [];
  List<Emoji> flagEmojis = [];
  List<Emoji> foodEmojis = [];
  List<Emoji> objectEmojis = [];
  List<Emoji> recentEmojis = [];
  List<Emoji> symbolEmojis = [];
  List<Emoji> travelEmojis = [];
  List<Emoji> searchEmojis = [];
  List<Emoji> allEmojis = [];
  int selectedCat = 0;
  int i = 0;

  @override
  void initState() {
    _emojiSearchController = TextEditingController();
    getRecentEmojis();

    for (var emojiSet in defaultEmojiSet) {
      emojiService.getCategoryEmojis(categoryEmoji: emojiSet).then((e) async =>
          await emojiService.filterUnsupported(data: [e]).then((filtered) {
            for (var element in filtered) {
              switch (emojiSet.category) {
                case Category.SMILEYS:
                  setState(() {
                    smileyEmojis = element.emoji;
                  });
                  break;
                case Category.ACTIVITIES:
                  setState(() {
                    activityEmojis = element.emoji;
                  });
                  break;
                case Category.ANIMALS:
                  setState(() {
                    animalEmojis = element.emoji;
                  });
                  break;
                case Category.FLAGS:
                  setState(() {
                    flagEmojis = element.emoji;
                  });
                  break;
                case Category.FOODS:
                  setState(() {
                    foodEmojis = element.emoji;
                  });
                  break;
                case Category.OBJECTS:
                  setState(() {
                    objectEmojis = element.emoji;
                  });
                  break;
                case Category.RECENT:
                  setState(() {
                    recentEmojis = element.emoji;
                  });
                  break;
                case Category.SYMBOLS:
                  setState(() {
                    symbolEmojis = element.emoji;
                  });
                  break;
                case Category.TRAVEL:
                  setState(() {
                    travelEmojis = element.emoji;
                  });
                  break;
                default:
              }
            }
          }));
    }

    if (recentEmojis.isEmpty) {
      selectedCat = 1;
      setState(() {});
    }

    // _emojiSearchController.addListener(() {});
    super.initState();
  }

  getRecentEmojis() async {
    recentEmojis = await LocalStorageService().getRecentEmojis();
    setState(() {});
  }

  void search(String query) {
    searchEmojis.clear();

    for (Emoji emoji in allEmojis) {
      // Case-sensitive comparison for whole word match
      if (emoji.name
                  .trim()
                  .toLowerCase()
                  .compareTo(query.trim().toLowerCase()) ==
              0 ||
          emoji.name
                  .trim()
                  .toLowerCase()
                  .compareTo(query.trim().toLowerCase()) >
              0) {
        searchEmojis.add(emoji);
      }
    }

    Foundation.mergeSort(
      searchEmojis,
      start: 0,
      end: searchEmojis.length - 1,
      compare: ((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: selectedCat == 9
          ? MediaQuery.of(context).size.height * 0.25
          : MediaQuery.of(context).size.height * 0.35,
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      decoration: BoxDecoration(
        color: AppColors.inactiveSliderColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              EmojiCategory(
                icon: selectedCat == 0
                    ? CupertinoIcons.clock_solid
                    : Icons.schedule,
                selectedIndex: selectedCat,
                index: 0,
                onTap: (() {
                  selectedCat = 0;
                  getRecentEmojis();
                  setState(() {});
                }),
              ),
              EmojiCategory(
                icon: selectedCat == 1
                    ? Icons.emoji_emotions_rounded
                    : Icons.sentiment_satisfied_alt_rounded,
                selectedIndex: selectedCat,
                index: 1,
                onTap: (() {
                  selectedCat = 1;
                  setState(() {});
                }),
              ),
              EmojiCategory(
                icon: selectedCat == 2
                    ? Icons.sports_baseball_rounded
                    : Icons.sports_soccer,
                selectedIndex: selectedCat,
                index: 2,
                onTap: (() {
                  selectedCat = 2;
                  setState(() {});
                }),
              ),
              EmojiCategory(
                icon: selectedCat == 3
                    ? CupertinoIcons.hare_fill
                    : CupertinoIcons.hare,
                selectedIndex: selectedCat,
                index: 3,
                onTap: (() {
                  selectedCat = 3;
                  setState(() {});
                }),
              ),
              EmojiCategory(
                icon: selectedCat == 4 ? Icons.flag : Icons.flag_outlined,
                selectedIndex: selectedCat,
                index: 4,
                onTap: (() {
                  selectedCat = 4;
                  setState(() {});
                }),
              ),
              EmojiCategory(
                icon: selectedCat == 5
                    ? Icons.lightbulb
                    : Icons.lightbulb_outline,
                selectedIndex: selectedCat,
                index: 5,
                onTap: (() {
                  selectedCat = 5;
                  setState(() {});
                }),
              ),
              EmojiCategory(
                icon: selectedCat == 6
                    ? Icons.fastfood_rounded
                    : Icons.fastfood_outlined,
                selectedIndex: selectedCat,
                index: 6,
                onTap: (() {
                  selectedCat = 6;
                  setState(() {});
                }),
              ),
              EmojiCategory(
                icon: selectedCat == 7
                    ? Icons.directions_car
                    : Icons.directions_car_filled_outlined,
                selectedIndex: selectedCat,
                index: 7,
                onTap: (() {
                  selectedCat = 7;
                  setState(() {});
                }),
              ),
              EmojiCategory(
                icon: selectedCat == 8
                    ? Icons.emoji_symbols_rounded
                    : Icons.emoji_symbols_outlined,
                selectedIndex: selectedCat,
                index: 8,
                onTap: (() {
                  selectedCat = 8;
                  setState(() {});
                }),
              ),
              EmojiCategory(
                icon: selectedCat == 9
                    ? Icons.search_rounded
                    : Icons.search_sharp,
                selectedIndex: selectedCat,
                index: 9,
                onTap: (() {
                  selectedCat = 9;
                  if (allEmojis.isNotEmpty) {
                    allEmojis.clear();
                  }
                  allEmojis.addAll(smileyEmojis);
                  allEmojis.addAll(activityEmojis);
                  allEmojis.addAll(animalEmojis);
                  allEmojis.addAll(flagEmojis);
                  allEmojis.addAll(foodEmojis);
                  allEmojis.addAll(objectEmojis);
                  allEmojis.addAll(symbolEmojis);
                  allEmojis.addAll(travelEmojis);
                  // log(searchEmojis.length.toString());
                  setState(() {});
                }),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: Builder(
              builder: ((ctx) {
                switch (selectedCat) {
                  case 0:
                    return EmojiWidget(
                      emojis: recentEmojis,
                      textEditingController: widget.textEditingController,
                    );
                  case 1:
                    return EmojiWidget(
                      emojis: smileyEmojis,
                      textEditingController: widget.textEditingController,
                    );
                  case 2:
                    return EmojiWidget(
                      emojis: activityEmojis,
                      textEditingController: widget.textEditingController,
                    );
                  case 3:
                    return EmojiWidget(
                      emojis: animalEmojis,
                      textEditingController: widget.textEditingController,
                    );
                  case 4:
                    return EmojiWidget(
                      emojis: flagEmojis,
                      textEditingController: widget.textEditingController,
                    );
                  case 5:
                    return EmojiWidget(
                      emojis: objectEmojis,
                      textEditingController: widget.textEditingController,
                    );
                  case 6:
                    return EmojiWidget(
                      emojis: foodEmojis,
                      textEditingController: widget.textEditingController,
                    );
                  case 7:
                    return EmojiWidget(
                      emojis: travelEmojis,
                      textEditingController: widget.textEditingController,
                    );
                  case 8:
                    return EmojiWidget(
                      emojis: symbolEmojis,
                      textEditingController: widget.textEditingController,
                    );
                  case 9:
                    return EmojiWidget(
                      emojis: searchEmojis,
                      textEditingController: widget.textEditingController,
                    );
                  default:
                    return EmojiWidget(
                      emojis: recentEmojis,
                      textEditingController: widget.textEditingController,
                    );
                }
              }),
            ),
          ),
          if (selectedCat == 9)
            Container(
              height: 50,
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
              ),
              child: InputTextFormField(
                autoFocus: true,
                contentPadding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 5,
                  bottom: 5,
                ),
                controller: _emojiSearchController,
                textInputType: TextInputType.text,
                hint: "Search Emoji",
                onChanged: ((query) {
                  if (query.isNotEmpty) {
                    search(query);
                    setState(() {});
                  } else {
                    searchEmojis.clear();
                  }
                }),
              ),
            )
        ],
      ),
    );
  }
}

class EmojiCategory extends StatelessWidget {
  const EmojiCategory({
    super.key,
    required this.onTap,
    required this.index,
    required this.selectedIndex,
    required this.icon,
  });

  final VoidCallback onTap;
  final int index, selectedIndex;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        icon,
        color: selectedIndex == index
            ? AppColors.activeButtonColor
            : AppColors.mainColor.withOpacity(0.5),
      ),
    );
  }
}

class EmojiWidget extends StatelessWidget {
  const EmojiWidget({
    super.key,
    required this.emojis,
    required this.textEditingController,
  });

  final List<Emoji> emojis;
  final TextEditingController textEditingController;

  void addToTextField({required Emoji emoji}) {
    textEditingController.text = textEditingController.text + emoji.emoji;
    textEditingController.selection = TextSelection.fromPosition(
      TextPosition(offset: textEditingController.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (emojis.isEmpty) {
      return Center(
        child: Text(
          "No emojis",
          style: TextStyle(
            color: AppColors.mainColor.withOpacity(0.5),
          ),
        ),
      );
    } else {
      return GridView.builder(
        physics: AppConstants.scrollPhysics,
        itemCount: emojis.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemBuilder: ((ctx, idx) {
          Emoji emoji = emojis[idx];
          return Center(
            child: InkWell(
              onTap: (() {
                addToTextField(emoji: emojis[idx]);
                LocalStorageService().saveRecentEmojis(emojis[idx]);
                log(emojis[idx].toJson().toString());
              }),
              child: Text(
                emoji.emoji,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          );
        }),
      );
    }
  }
}

class SuffixBtn extends StatelessWidget {
  const SuffixBtn({
    super.key,
    required this.icon,
    this.iconColor,
    required this.onTap,
    this.iconSize,
  });

  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        icon,
        size: iconSize ?? 25,
        color: iconColor ?? AppColors.white,
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.alignment,
    required this.crossAxisAlignment,
    this.left,
    this.right,
    required this.containerColor,
    required this.textColor,
    required this.timeTextColor,
    this.topLeft,
    this.topRight,
    required this.sentDateTime,
    this.mainContent,
  });

  final String message;
  final DateTime sentDateTime;
  final Alignment alignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double? left, right;
  final Color containerColor, textColor, timeTextColor;
  final Radius? topLeft, topRight;
  final Widget? mainContent;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width / 1.3,
        ),
        child: Container(
          margin: EdgeInsets.only(
            left: left ?? 0,
            right: right ?? 0,
            bottom: 10,
            // right: MediaQuery.of(context).size.width / 4,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.only(
              topLeft: topLeft ?? Radius.circular(0),
              topRight: topRight ?? Radius.circular(0),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              if (mainContent == null)
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              if (mainContent != null)
                SizedBox(
                  child: mainContent,
                ),
              SizedBox(
                height: 5,
              ),
              Text(
                DateFormat('hh:mm a').format(sentDateTime),
                style: TextStyle(
                  color: timeTextColor.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputChatField extends StatelessWidget {
  const InputChatField({
    super.key,
    this.enableInteractiveSelection,
    required this.controller,
    required this.textInputType,
    this.validator,
    this.visibility,
    this.onChanged,
    required this.hint,
    this.prefix,
    this.suffix,
    this.textInputAction,
    this.focusNode,
    this.fillColor,
    this.contentPadding,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.border,
    this.textColor,
    this.minLines,
    this.maxLines,
  });

  final bool? visibility, enableInteractiveSelection;
  final TextEditingController controller;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final String hint;
  final Widget? prefix, suffix;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Color? fillColor, textColor;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? enabledBorder,
      focusedBorder,
      errorBorder,
      focusedErrorBorder,
      border;
  final int? minLines, maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      enableInteractiveSelection: enableInteractiveSelection,
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      style: TextStyle(
        color: textColor ?? AppColors.mainColor,
        fontSize: 15,
        letterSpacing: 1.5,
      ),
      textInputAction: textInputAction,
      keyboardType: textInputType,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.hintTextColor,
          fontWeight: FontWeight.w600,
        ),
        focusColor: AppColors.activeButtonColor,
        border: border ??
            const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              borderSide: BorderSide(
                color: AppColors.white,
              ),
            ),
        enabledBorder: enabledBorder ??
            const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              borderSide: BorderSide(
                color: AppColors.white,
              ),
            ),
        focusedBorder: focusedBorder ??
            const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              borderSide: BorderSide(
                color: AppColors.mainColor,
              ),
            ),
        errorBorder: errorBorder ??
            const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              borderSide: BorderSide(
                color: AppColors.red,
              ),
            ),
        focusedErrorBorder: focusedBorder ??
            const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              borderSide: BorderSide(
                color: AppColors.red,
              ),
            ),
        prefixIcon: prefix,
        suffixIcon: suffix,
        filled: true,
        fillColor: fillColor ?? AppColors.textFieldColor,
        isDense: true,
      ),
    );
  }
}
