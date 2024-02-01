import 'dart:convert';
import 'dart:developer';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:homies/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // Load emojis from shared preferences
  Future<List<Emoji>> getRecentEmojis() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? emojisString = pref.getString(AppKeys.recentEmojiKey);
    if (emojisString != null) {
      return (jsonDecode(emojisString) as List<dynamic>)
          .map((e) => Emoji.fromJson(e))
          .toList();
    } else {
      return [];
    }
  }

  List<Map<String, dynamic>> addCounterToJsonList(
      List<Map<String, dynamic>> jsonList, Emoji newEmoji) {
    for (var jsonMap in jsonList) {
      // Add or increment the counter variable for each element
      if (jsonMap['name'] == newEmoji.name) {
        jsonMap['counter'] =
            jsonMap['counter'] == null ? 0 : jsonMap['counter'] + 1;
      }
    }
    return jsonList;
  }

  Future<void> saveRecentEmojis(Emoji newEmoji) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<Emoji> recentEmojis = await getRecentEmojis();
    // Check if the emoji is already in the list
    Emoji? existingEmoji = recentEmojis.firstWhere(
      (emoji) => emoji.name == newEmoji.name,
      orElse: () => Emoji('', ''),
    );

    if (existingEmoji.name.isNotEmpty) {
      // If the emoji is already in the list, increment the counter
      // existingEmoji.counter++;
    } else {
      // If the emoji is not in the list, add it with counter set to 1
      // recentEmojis.add(newEmoji..counter = 1);
    }
    // Convert the list of Emoji to a list of maps
    List<Map<String, dynamic>> emojiMaps =
        recentEmojis.map((e) => e.toJson()).toList();

    // Add or increment the counter variable for each element
    emojiMaps = addCounterToJsonList(emojiMaps, newEmoji);

    String jsonString = jsonEncode(emojiMaps);
    log(jsonString);
    await pref.setString(AppKeys.recentEmojiKey, jsonString);
  }
}
