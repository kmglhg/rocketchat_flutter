import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:crinity_teamchat/src/constants.dart';
import 'package:crinity_teamchat/src/commons/controller/web_socket_controller.dart';
import 'package:crinity_teamchat/src/commons/service/storage.dart';
import 'package:crinity_teamchat/src/screens/room/dto/message_dto.dart';
import 'package:crinity_teamchat/src/screens/room/service/room_service.dart';
import 'package:crinity_teamchat/src/screens/home/controller/app_home_controller.dart';
import 'package:crinity_teamchat/src/screens/rooms/controller/rooms_controller.dart';
import 'package:crinity_teamchat/src/screens/room/dto/attachment_dto.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:crinity_teamchat/src/commons/utils/date_time_utils.dart';


class RoomController extends GetxController {
  static RoomController get to => Get.find();
  static RoomsController get roomsController => Get.find<RoomsController>();
  static WebSocketController get webSocketController => Get.find<WebSocketController>();
  static AppHomeController get appHomeController => Get.find<AppHomeController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool loading = false;

  String roomName = '';
  late String roomId;
  int date = DateTimeUtils.nowMilliseconds();
  int mark = 0;

  // 메시지 목록
  RxList<MessageDto> messageList = <MessageDto>[].obs;
  RxBool showAttach = false.obs;
  RxBool showSend = false.obs;

  final TextEditingController messageController = TextEditingController();

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  late String token;
  late String userId;

  late Worker everMessageList;
  late Worker everResultMap;

  Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json;charset=UTF-8',
      'X-Auth-Token': token,
      'X-User-Id': userId,
    };
  }

  @override
  void onClose() {
    everResultMap.dispose();
    everMessageList.dispose();
    super.onClose();
  }

  @override
  void onInit() async {
    super.onInit();

    roomId = Get.arguments['id'];
    int index = roomsController.roomList.indexWhere((room) => room.id == roomId);
    roomName = roomsController.roomList[index].name;
    token = await Storage.get(ACCESS_TOKEN);
    userId = await Storage.get(USER_ID);

    messageList.clear();

    messageController.addListener(() => showSend.value = messageController.text.isNotEmpty);

    everResultMap = ever(webSocketController.resultMap, (_) {
      if (webSocketController.resultMap.containsKey('loadHistoryId')) {
        dynamic event = webSocketController.resultMap.remove('loadHistoryId');
        if (messageList.isNotEmpty) {
          if (event['result'] != null && event['result']['messages'] != null) {
            for (var jsonMessage in event['result']['messages']) {
              addMessage(jsonMessage);
            }
            if (event['result']['messages'].length > 0) {
              mark = event['result']['messages'][event['result']['messages'].length - 1]['ts']['\$date'];
            }
          }
        } else {
          if (event['result'] != null && event['result']['messages'] != null) {
            for (var jsonMessage in event['result']['messages'].reversed) {
              insertMessage(jsonMessage);
            }
            if (event['result']['messages'].length > 0) {
              mark = event['result']['messages'][event['result']['messages'].length - 1]['ts']['\$date'];
            }
          }
          RoomService().readMessage(roomId);
          RoomService().streamRoomMessages(roomId);
        }
        loading = false;
      }
    });

    everMessageList = ever(webSocketController.messageList, (_) async {
      if (webSocketController.messageList.isNotEmpty) {
        dynamic event = webSocketController.messageList.removeAt(0);
        dynamic fields = event['fields'];
        insertMessage(fields['args'][0]);
      }
    });

    loading = true;
    RoomService().loadHistory(rId: roomId, date: date);
  }

  MessageDto mergeMessage(jsonMessage) {
    MessageDto message = MessageDto.fromJson(jsonMessage);
    message.name = jsonMessage['u']['name'];
    message.uId = jsonMessage['u']['_id'];
    message.my = jsonMessage['u']['_id'] == appHomeController.myInfo.id;

    if (jsonMessage['attachments'] != null) {
      message.attachment = AttachmentDto.fromJson(jsonMessage['attachments'][0]);
    }
    return message;
  }

  void insertMessage(jsonMessage) {
    MessageDto message = mergeMessage(jsonMessage);

    if (messageList.isNotEmpty) {
      // 메시지 날(day)이 바뀐 경우 날짜 표시
      message.showDate = message.dateFormat != messageList[0].dateFormat;

      if (message.uId != messageList[0].uId || message.timeFormat != messageList[0].timeFormat) {
        // 메시지 소유자가 다른 경우
        // 메시지 분(minute)이 다른 경우
        messageList[0].showTime = true;
      } else if (message.uId == messageList[0].uId && message.timeFormat == messageList[0].timeFormat) {
        // 메시지 소유자가 같으면서 메시지 분(minute)이 같은 경우
        messageList[0].showTime = false;
      }
    }

    messageList.insert(0, message);
  }

  void addMessage(jsonMessage) {
    MessageDto message = mergeMessage(jsonMessage);

    if (messageList.isNotEmpty) {
      // 메시지 날(day)이 바뀐 경우 날짜 표시
      messageList[messageList.length - 1].showDate = message.dateFormat != messageList[messageList.length - 1].dateFormat;

      if (message.uId != messageList[messageList.length - 1].uId || message.timeFormat != messageList[messageList.length - 1].timeFormat) {
        // 메시지 소유자가 다른 경우
        // 메시지 분(minute)이 다른 경우
        message.showTime = true;
      } else if (message.uId == messageList[messageList.length - 1].uId && message.timeFormat == messageList[messageList.length - 1].timeFormat) {
        // 메시지 소유자가 같으면서 메시지 분(minute)이 같은 경우
        message.showTime = false;
      }
    }

    messageList.add(message);
  }

  void toggleAttachVisible() {
    showAttach.value = !showAttach.value;
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      RoomService().readMessage(roomId);
      RoomService().sendMessage(roomId, messageController.text);
      messageController.text = '';
    }
  }

  void downloadFile(message) {
    print(message.attachment?.link);
  }

  // 파일 첨부
  void chooseFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }

    PlatformFile file = result.files.single;

    const mb_10 = 10485760;
    if (file.size > mb_10) {
      Get.snackbar(
        "알림",
        "업로드 제한 용량은 10MB 입니다.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    await RoomService().uploadFile(roomId: roomId, file: file, fileType: 'image');
  }

  void moreLoadHistory() {
    loading = true;
    RoomService().loadHistory(rId: roomId, mark: mark, date: date);
  }
}