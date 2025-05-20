import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final double aspectRatio;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const ImageCarousel({
    Key? key,
    required this.imageUrls,
    this.aspectRatio = 16 / 9,
    this.borderRadius,
    this.padding = const EdgeInsets.all(0),
    this.onTap,
  }) : super(key: key);

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_pageListener);
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  void _pageListener() {
    int page = _pageController.page?.round() ?? 0;
    if (_currentPage != page && mounted) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  void _viewFullScreen(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(
          imageUrls: widget.imageUrls,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: widget.borderRadius,
          ),
          child: const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 50,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: widget.padding,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: ClipRRect(
              borderRadius: widget.borderRadius ?? BorderRadius.zero,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: widget.imageUrls.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: widget.onTap ?? () => _viewFullScreen(context, index),
                        child: Image.network(
                          widget.imageUrls[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / 
                                        loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  // Gradient overlay at the bottom for better visibility of indicators
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Image count indicator
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_currentPage + 1}/${widget.imageUrls.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.imageUrls.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imageUrls.length,
                  (index) => _buildPageIndicator(index),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive 
            ? Theme.of(context).colorScheme.primary 
            : Theme.of(context).colorScheme.primary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// Full screen image viewer for tapped images
class FullScreenImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImageViewer({
    Key? key,
    required this.imageUrls,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Image ${_currentPage + 1}/${widget.imageUrls.length}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemCount: widget.imageUrls.length,
          itemBuilder: (context, index) {
            return InteractiveViewer(
              minScale: 0.5,
              maxScale: 3.0,
              child: Center(
                child: Image.network(
                  widget.imageUrls[index],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[900],
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.white54,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / 
                              loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}