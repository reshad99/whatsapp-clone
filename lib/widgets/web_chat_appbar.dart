// import 'package:flutter/material.dart';
// import 'package:whatsapp_clone/common/utils/colors.dart';
// import 'package:whatsapp_clone/common/utils/info.dart';

// class WebChatAppBar extends StatelessWidget {
//   const WebChatAppBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       padding: const EdgeInsets.all(15),
//       width: size.width * 0.75,
//       height: size.height * 0.077,
//       decoration: const BoxDecoration(
//           color: webAppBarColor,
//           border: Border(bottom: BorderSide(color: dividerColor))),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               const CircleAvatar(
//                 backgroundImage: NetworkImage(
//                     "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
//               ),
//               SizedBox(
//                 width: size.width * 0.01,
//               ),
//               Text(
//                 info[0]['name'].toString(),
//                 style: const TextStyle(fontSize: 18),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
//               IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
