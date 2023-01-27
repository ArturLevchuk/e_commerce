import 'package:e_commerce/widgets/DefaultButton.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

enum SortType { priceLow, priceHigh, popular, newProduct }

const List<String> sortNames = [
  "Sort by low price!",
  "Sort by high price!",
  "Sort by popular!",
  "Sort by new!",
];

class SortingScreen extends StatefulWidget {
  const SortingScreen({super.key});
  static const routeName = '/SortingScreen';

  @override
  State<SortingScreen> createState() => _SortingScreenState();
}

class _SortingScreenState extends State<SortingScreen> {
  late SortType sortType;

  @override
  void didChangeDependencies() {
    sortType = ModalRoute.of(context)?.settings.arguments as SortType;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      backgroundColor: const Color(0xfff5f6f9),
      body: Column(
        children: [
          SizedBox(
            height: getProportionateScreenWidth(20),
          ),
          ...List.generate(
            SortType.values.length,
            (index) => paddingContainer(
              child: RadioListTile(
                value: SortType.values[index],
                title: Text(sortNames[index]),
                groupValue: sortType,
                onChanged: (value) {
                  setState(() {
                    sortType = value!;
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                activeColor: kPrimaryColor,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: DefaultButton(
              text: "Close and apply",
              press: () {
                Navigator.of(context).pop(sortType);
              },
            ),
          ),
          SizedBox(
            height: getProportionateScreenWidth(20),
          ),
        ],
      ),
    );
  }

  Container paddingContainer({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(
        left: getProportionateScreenWidth(20),
        right: getProportionateScreenWidth(20),
        bottom: getProportionateScreenWidth(20),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  AppBar customAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          splashRadius: getProportionateScreenWidth(25),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      title: Text(
        'Sort products by...',
        style: TextStyle(
          color: Colors.black,
          fontSize: getProportionateScreenWidth(18),
        ),
      ),
      titleSpacing: 0,
    );
  }
}
