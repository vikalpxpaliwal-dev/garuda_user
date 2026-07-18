part of 'search_listing_detail_page.dart';

class _VisualDocumentationSection extends StatelessWidget {
  const _VisualDocumentationSection({required this.land});

  final LandEntity land;

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error, color: Colors.white),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchVideo(BuildContext context, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AppVideoPlayer(videoUrl: url),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images =
        land.media.where((m) => m.isBuyerFacingImage).toList();
    final videos = land.media.where((m) => m.type == 'video').toList();

    final displayImages = images.map((e) => e.url).toList();
    final displayVideos = videos.map((e) => e.url).toList();
    final crossAxisCount = ResponsiveGrid.gridCrossAxisCount(context);
    final onSurface = context.colors.onSurface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.deepOrange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.photo_library_outlined,
                  size: 14,
                  color: AppColors.deepOrange,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'VISUAL DOCUMENTATION',
                style: TextStyle(
                  color: onSurface,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (displayImages.isEmpty && displayVideos.isEmpty)
            Text(
              'No visual documentation available',
              style: TextStyle(
                color: onSurface,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          if (displayImages.isNotEmpty)
            GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
              ),
              itemCount: displayImages.length,
              itemBuilder: (context, index) {
                final mediaUrl = displayImages[index];
                return GestureDetector(
                  onTap: () => _showImageDialog(context, mediaUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: AppColors.lightLine,
                      child: CachedNetworkImage(
                        imageUrl: mediaUrl,
                        fit: BoxFit.cover,
                        memCacheWidth: 600,
                        placeholder: (context, url) =>
                            const ColoredBox(color: AppColors.lightLine),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.lightLine,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 12),
          if (displayVideos.isNotEmpty)
            ...displayVideos.map((videoUrl) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => _launchVideo(context, videoUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.black,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
