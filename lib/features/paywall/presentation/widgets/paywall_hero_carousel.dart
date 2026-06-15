import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/config/app_assets.dart';
import 'package:home_ai/core/theme/app_colors.dart';

class PaywallHeroCarousel extends StatefulWidget {
  const PaywallHeroCarousel({super.key});

  @override
  State<PaywallHeroCarousel> createState() => _PaywallHeroCarouselState();
}

class _PaywallHeroCarouselState extends State<PaywallHeroCarousel> {
  final _controller = PageController();
  Timer? _timer;
  var _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _next());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    final images = AppAssets.paywallStyleImages;
    if (images.isEmpty || !_controller.hasClients) {
      return;
    }

    final next = (_index + 1) % images.length;
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = AppAssets.paywallStyleImages;

    return PageView.builder(
      controller: _controller,
      itemCount: images.length,
      onPageChanged: (value) => _index = value,
      itemBuilder: (context, index) {
        return Image.asset(
          images[index],
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: _imageError,
        );
      },
    );
  }

  Widget _imageError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return const ColoredBox(color: AppColors.imagePlaceholder);
  }
}
