import 'dart:async';

import 'package:flutter/material.dart';

class ImageSlideshow extends StatefulWidget {
  ImageSlideshow({
    @required this.children,
    this.width = double.infinity,
    this.height = 200,
    this.initialPage = 0,
    this.indicatorColor = Colors.blue,
    this.indicatorBackgroundColor = Colors.grey,
    this.onPageChanged,
  });
  final List<Widget> children;
  final double width;
  final double height;
  final int initialPage;
  final Color indicatorColor;
  final Color indicatorBackgroundColor;
  final ValueChanged<int> onPageChanged;

  @override
  _ImageSlideshowState createState() => _ImageSlideshowState();
}

class _ImageSlideshowState extends State<ImageSlideshow> {
  final StreamController<int> _pageStreamController =
      StreamController<int>.broadcast();
  PageController _pageController;

  void _onPageChanged(int value) {
    _pageStreamController.sink.add(value);
    if (widget.onPageChanged != null) {
      widget.onPageChanged(value);
    }
  }

  Widget _indicator(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: List<Widget>.generate(
        widget.children.length,
        (index) {
          return StreamBuilder<int>(
            initialData: _pageController.initialPage,
            stream: _pageStreamController.stream.where(
              (pageIndex) {
                print('index $index');
                print('page index $pageIndex');
                return index >= pageIndex - 1 && index <= pageIndex + 1;
              },
            ),
            builder: (_, AsyncSnapshot<int> snapshot) {
              return Container(
                width: 6,
                height: 6,
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: snapshot.data == index
                      ? widget.indicatorColor
                      : widget.indicatorBackgroundColor,
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    _pageController = PageController(
      initialPage: widget.initialPage,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: _onPageChanged,
            itemCount: widget.children.length,
            controller: _pageController,
            itemBuilder: (context, index) {
              return widget.children[index];
            },
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 10.0,
            child: _indicator(context),
          ),
        ],
      ),
    );
  }
}
