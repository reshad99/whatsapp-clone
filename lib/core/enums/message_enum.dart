enum MessageType { text, video, image, audio, gif }

extension ConvertMessage on MessageType {
  static MessageType fromString(String? str) {
    switch (str?.toLowerCase()) {
      case 'text':
        return MessageType.text;
      case 'video':
        return MessageType.video;
      case 'image':
        return MessageType.image;
      case 'audio':
        return MessageType.audio;
      case 'gif':
        return MessageType.gif;
      default:
        return MessageType.text;
    }
  }

  String get chatText {
    switch (this) {
      case MessageType.audio:
        return "🎵 audio";
      case MessageType.image:
        return "📷 photo";
      case MessageType.video:
        return "🎥 video";
      case MessageType.gif:
        return "GIF";
      default:
        return "GIF";
    }
  }

  String get name {
    switch (this) {
      case MessageType.text:
        return 'text';
      case MessageType.audio:
        return 'audio';
      case MessageType.video:
        return 'video';
      case MessageType.image:
        return 'image';
      case MessageType.audio:
        return 'audio';
      case MessageType.gif:
        return 'gif';

      default:
        return 'text';
    }
  }
}
