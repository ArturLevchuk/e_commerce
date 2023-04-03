// import 'package:e_commerce/constants.dart';
// import 'package:e_commerce/size_config.dart';
// import 'package:e_commerce/widgets/SectionTitle.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../widgets/DefaultButton.dart';
// import '../home/products_bloc/products_bloc.dart';

// class FiltersScreen extends StatefulWidget {
//   const FiltersScreen({super.key});
//   static const routeName = '/FiltersScreen';

//   @override
//   State<FiltersScreen> createState() => _FiltersScreenState();
// }

// class _FiltersScreenState extends State<FiltersScreen> {
//   late List<Color> filterColors;
//   late Set<Color> avaliableColors;

//   @override
//   void initState() {
//     final listOfListOfColors = context
//         .read<ProductsBloc>()
//         .state
//         .items
//         .map((product) => product.colors)
//         .toList();
//     avaliableColors = listOfListOfColors.expand((list) => list).toSet();
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     filterColors = ModalRoute.of(context)?.settings.arguments as List<Color>;
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: customAppBar(context),
//       body: Column(
//         children: [
//           SectionTitle(
//             text: "Colors",
//             button_text: "Clear selected",
//             press: () {
//               setState(() {
//                 filterColors.clear();
//               });
//             },
//           ),
//           Container(
//             width: SizeConfig.screenWidth,
//             padding: EdgeInsets.symmetric(
//                 horizontal: getProportionateScreenWidth(20)),
//             child: Wrap(
//               spacing: getProportionateScreenWidth(10),
//               runSpacing: getProportionateScreenWidth(10),
//               children: [
//                 ...avaliableColors.map(
//                   (color) => ColorChooseBlock(
//                     color: color,
//                     checked: filterColors.contains(color),
//                     press: () {
//                       if (!filterColors.contains(color)) {
//                         setState(() {
//                           filterColors.add(color);
//                         });
//                       } else {
//                         setState(() {
//                           filterColors.remove(color);
//                         });
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Spacer(),
//           Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: getProportionateScreenWidth(20)),
//             child: DefaultButton(
//               text: "Close and apply",
//               press: () {
//                 Navigator.of(context).pop(filterColors);
//               },
//             ),
//           ),
//           SizedBox(
//             height: getProportionateScreenWidth(20),
//           ),
//         ],
//       ),
//     );
//   }

//   AppBar customAppBar(BuildContext context) {
//     return AppBar(
//       leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           splashRadius: getProportionateScreenWidth(25),
//           onPressed: () {
//             Navigator.of(context).pop();
//           }),
//       title: Text(
//         'Filter products by...',
//         style: TextStyle(
//           color: Colors.black,
//           fontSize: getProportionateScreenWidth(18),
//         ),
//       ),
//       titleSpacing: 0,
//     );
//   }
// }

// class ColorChooseBlock extends StatefulWidget {
//   const ColorChooseBlock({
//     Key? key,
//     required this.color,
//     required this.checked,
//     required this.press,
//   }) : super(key: key);
//   final Color color;
//   final bool checked;
//   final Function() press;

//   @override
//   State<ColorChooseBlock> createState() => _ColorChooseBlockState();
// }

// class _ColorChooseBlockState extends State<ColorChooseBlock> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.press,
//       child: AnimatedContainer(
//         duration: defaultDuration,
//         width: getProportionateScreenWidth(47),
//         height: getProportionateScreenWidth(47),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black,
//               blurRadius: 1,
//             ),
//           ],
//           border:
//               widget.checked ? Border.all(width: 1, color: Colors.black) : null,
//         ),
//         child: AnimatedPadding(
//           duration: defaultDuration,
//           padding: widget.checked ? const EdgeInsets.all(2.0) : EdgeInsets.zero,
//           child: Container(
//             decoration: BoxDecoration(
//               color: widget.color,
//               border: widget.checked
//                   ? Border.all(width: 1, color: Colors.black)
//                   : null,
//             ),
//             child: widget.checked ? const Icon(Icons.check) : null,
//           ),
//         ),
//       ),
//     );
//   }
// }
