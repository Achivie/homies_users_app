import 'package:flutter_emoji/flutter_emoji.dart';

class ChatScreenNavigateModel {
  final String name;

  ChatScreenNavigateModel({
    required this.name,
  });
}

enum MessageType { text, voice, image, video }

class Message {
  bool isSentByMe;
  MessageType messageType;
  String content, imageUrl, imagePath;
  String voiceUrl, voicePath;
  DateTime sentDateTime;
  DateTime startDateTime; // additional parameter for voice messages
  DateTime endDateTime; // additional parameter for voice messages

  // Constructor for text messages
  Message.text({
    required this.isSentByMe,
    required this.content,
    required this.sentDateTime,
  })  : messageType = MessageType.text,
        voiceUrl = '',
        voicePath = '',
        imagePath = '',
        imageUrl = '',
        startDateTime = DateTime.now(),
        endDateTime = DateTime.now();

  // Constructor for voice messages
  Message.voice({
    required this.isSentByMe,
    required this.voiceUrl,
    required this.voicePath,
    required this.startDateTime,
    required this.endDateTime,
    required this.sentDateTime,
  })  : messageType = MessageType.voice,
        imagePath = '',
        imageUrl = '',
        content = ''; // placeholder value for text-specific parameter

  // Constructor for image messages
  Message.image({
    required this.content,
    required this.isSentByMe,
    required this.imagePath,
    required this.imageUrl,
    required this.sentDateTime,
  })  : messageType = MessageType.image,
        voicePath = '',
        voiceUrl = '',
        startDateTime = DateTime.now(),
        endDateTime = DateTime.now();
}

// class Message {
//   final String type;
//   final String message;
//   final bool isSentByMe;
//   final DateTime dateTime;
//
//   Message({
//     required this.type,
//     required this.message,
//     required this.isSentByMe,
//     required this.dateTime,
//   });
// }

class EmojiWithCounter extends Emoji {
  int _counter;

  EmojiWithCounter(String name, String emoji,
      {bool hasSkinTone = false, int counter = 0})
      : _counter = counter,
        super(name, emoji);

  // Getter for the counter variable
  int get counter => _counter;

  // Setter for the counter variable
  set counter(int value) {
    // Ensure the counter value is non-negative
    _counter = value >= 0 ? value : 0;
  }

  // Convert the EmojiWithCounter object to a JSON-like map
  Map<String, dynamic> toJson() {
    // Include the counter in the JSON representation
    return {
      'name': name,
      'counter': _counter,
    };
  }

  // Create an EmojiWithCounter object from a JSON-like map
  factory EmojiWithCounter.fromJson(Map<String, dynamic> json) {
    // Initialize the counter from the JSON representation
    return EmojiWithCounter(
      json['name'],
      json['emoji'],
      hasSkinTone: json['hasSkinTone'] ?? false,
      counter: json['counter'] ?? 0,
    );
  }
}
