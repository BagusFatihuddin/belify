// import 'package:flutter/material.dart';

// class CustomBottomNavigation extends StatelessWidget {
//   final VoidCallback onAddToCart;

//   const CustomBottomNavigation({Key? key, required this.onAddToCart})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Color.fromRGBO(0, 0, 0, 0.14),
//             blurRadius: 32,
//             offset: Offset(0, -1),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Color(0xFF156651)),
//             ),
//             child: const Icon(
//               Icons.favorite_border,
//               color: Color(0xFF156651),
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Material(
//               color: const Color(0xFF156651),
//               borderRadius: BorderRadius.circular(8),
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(8),
//                 onTap: onAddToCart,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 12,
//                     horizontal: 18,
//                   ),
//                   alignment: Alignment.center,
//                   child: const Text(
//                     'Add to Cart',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class CustomBottomNavigation extends StatelessWidget {
//   const CustomBottomNavigation({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Color.fromRGBO(0, 0, 0, 0.14),
//             blurRadius: 32,
//             offset: Offset(0, -1),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Color(0xFF156651)),
//             ),
//             child: const Icon(
//               Icons.favorite_border,
//               color: Color(0xFF156651),
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Material(
//               color: Color(0xFF156651),
//               borderRadius: BorderRadius.circular(8),
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(8),
//                 onTap: () {
//                   // Aksi ketika diklik
//                   print('Add to Cart tapped');
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 12,
//                     horizontal: 18,
//                   ),
//                   alignment: Alignment.center,
//                   child: const Text(
//                     'Add to Cart',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
