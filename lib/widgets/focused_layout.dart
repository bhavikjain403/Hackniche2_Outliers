import 'package:flutter/material.dart';
import 'package:nomnom/utils/colors.dart';
import 'package:nomnom/widgets/wrapper.dart';

class FocusedLayout extends StatelessWidget {
  const FocusedLayout(
      {Key? key,
      required this.child,
      this.appBarTitle,
      this.padding,
      this.isScrollable = false,
      this.bottomWidget,
      this.fab,
      this.actions,
      this.pos,
      this.titleSize = 18})
      : super(key: key);

  final Widget child;
  final String? appBarTitle;
  final double? titleSize;
  final EdgeInsets? padding;
  final bool isScrollable;
  final Widget? bottomWidget;
  final Widget? fab;
  final FloatingActionButtonLocation? pos;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
      child: Scaffold(
        floatingActionButtonLocation: pos,
        backgroundColor: AppColors.whiteColor,
        resizeToAvoidBottomInset: isScrollable,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          centerTitle: true,
          title: Text(
            appBarTitle ?? "",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: titleSize,
                color: AppColors.darkorangeAccent),
          ),
          actions: actions,
        ),
        body: Builder(
          builder: (context) {
            if (isScrollable) {
              return SingleChildScrollView(
                padding: padding ?? EdgeInsets.zero,
                child: child,
              );
            }
            return Padding(
              padding: padding ?? EdgeInsets.zero,
              child: child,
            );
          },
        ),
        floatingActionButton: fab,
        bottomNavigationBar: bottomWidget,
      ),
    );
  }
}
