// import 'package:flutter/material.dart';
// import 'package:whatsapp_clone/common/utils/colors.dart';
// import 'package:whatsapp_clone/features/chat/screens/chat_list.dart';
// import 'package:whatsapp_clone/features/chat/screens/contacts_list.dart';
// import 'package:whatsapp_clone/features/chat/screens/components/chat_textfield.dart';
// import 'package:whatsapp_clone/widgets/web_chat_appbar.dart';
// import 'package:whatsapp_clone/widgets/web_profile.dart';
// import 'package:whatsapp_clone/widgets/web_search_bar.dart';

// class WebScreenLayout extends StatelessWidget {
//   const WebScreenLayout({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Row(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: const [
//                   WebProfileBar(),
//                   WebSearchBar(),
//                   ContactsList()
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             width: size.width * 0.75,
//             decoration: const BoxDecoration(
//                 border: Border(left: BorderSide(color: dividerColor)),
//                 image: DecorationImage(
//                     image: AssetImage('assets/backgroundImage.png'),
//                     fit: BoxFit.cover)),
//             child: Column(
//               children: const [
//                 WebChatAppBar(),
//                 Expanded(child: ChatList()),
//                 MobileTextField(receiverId: 'adgfad',)
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
