// import 'dart:convert';

// import 'package:breaking_project/data/models/chatting_model.dart';
// import 'package:pusher_client/pusher_client.dart';

// class PusherService {
//   late PusherClient pusher;
//   late Channel channel;

//   void initPusher({required String channelName}) {
//     pusher = PusherClient(
//       "ed41791f7556c5bae990", // APP_KEY
//       PusherOptions(
//         cluster: "ap1",
//         encrypted: true,
//       ),
//       enableLogging: true,
//     );

//     channel = pusher.subscribe(channelName);

//     channel.bind("new-message", (event) {
//       final data = jsonDecode(event!.data!);
//       final newMessage = Messages.fromJson(data);
//     });

//     pusher.connect();
//   }

//   void disconnect() {
//     pusher.disconnect();
//   }
// }
