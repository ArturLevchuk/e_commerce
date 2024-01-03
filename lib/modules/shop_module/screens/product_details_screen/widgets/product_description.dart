import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandableDescription extends StatefulWidget {
  const ExpandableDescription({super.key, required this.description});
  final String description;

  @override
  State<ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  bool _isExpanded = false;

  Widget textDescription(bool isExpanded) {
    return Text(
      widget.description,
      maxLines: isExpanded ? 50 : 5,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      style: TextStyle(fontSize: 14.sp),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AnimatedCrossFade(
              firstChild: textDescription(false),
              secondChild: textDescription(true),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 500),
            ),
          ),
          RPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              // vertical: 10,
            ),
            child: ExpandableTextActionButton(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandableTextActionButton extends StatefulWidget {
  const ExpandableTextActionButton({
    super.key,
    required this.onTap,
  });

  final Function() onTap;

  @override
  State<ExpandableTextActionButton> createState() =>
      _ExpandableTextActionButtonState();
}

class _ExpandableTextActionButtonState extends State<ExpandableTextActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> turns;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    turns = Tween(begin: 0.25, end: 0.75).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.primary.withOpacity(.4),
        borderRadius: BorderRadius.circular(10).r,
        onTap: () {
          widget.onTap();
          if (_controller.isDismissed) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        },
        child: FittedBox(
          child: RPadding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                AnimatedBuilder(
                  builder: (context, _) {
                    return Text(
                      _controller.value == 0
                          ? "See More Details"
                          : "See Less Details",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w600),
                    );
                  },
                  animation: _controller,
                ),
                const SizedBox(width: 5),
                RotationTransition(
                  turns: turns,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
