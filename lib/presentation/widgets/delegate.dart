import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  final bool? scroll;
  HeaderDelegate({required this.child, required this.height, this.scroll});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final bool isScrolled = shrinkOffset > 0;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: isScrolled ? Brightness.dark : Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: isScrolled ? Colors.black : Colors.transparent,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: isScrolled ? Colors.black : Colors.transparent,
        padding: EdgeInsets.only(top: isScrolled ? statusBarHeight : 0),
        alignment: Alignment.center,
        child: ClipRect(child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: child)),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant HeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
