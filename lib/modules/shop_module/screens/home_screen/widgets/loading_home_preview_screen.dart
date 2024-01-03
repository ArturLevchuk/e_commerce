import 'package:flutter/material.dart';

import '../../../../../widgets/shimmer.dart';
import 'home_preview_screen.dart';

class LoadingHomePreviewScreen extends StatelessWidget {
  const LoadingHomePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Shimmer(
          linearGradient: shimmerGradient,
          child: ShimmerLoading(
            isLoading: true,
            child: HomePreviewScreen(),
          ),
        ),
      ),
    );
  }
}

