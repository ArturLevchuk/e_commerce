import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedFavRoundButton extends StatefulWidget {
  const AnimatedFavRoundButton({
    super.key,
    required this.onTap,
    required this.active,
  });

  final Function() onTap;
  final bool active;

  @override
  State<AnimatedFavRoundButton> createState() => _AnimatedFavRoundButtonState();
}

class _AnimatedFavRoundButtonState extends State<AnimatedFavRoundButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1.3), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.3, end: 0.7), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.7, end: 1), weight: 1),
    ]).animate(_animationController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30).r,
      onTap: () async {
        widget.onTap();
        _animationController
            .forward()
            .then((_) => _animationController.value = 0);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: widget.active
                ? Theme.of(context).colorScheme.primary.withOpacity(.15)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8).r,
          child: Transform.scale(
            scale: _animation.value,
            child: SvgPicture.asset(
              "assets/icons/Heart Icon_2.svg",
              color: widget.active ? Colors.red : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
