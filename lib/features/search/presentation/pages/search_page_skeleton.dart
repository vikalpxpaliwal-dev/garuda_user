part of 'search_page.dart';


class _SearchSkeletonListState extends State<_SearchSkeletonList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
      lowerBound: 0.5,
      upperBound: 1.0,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Opacity(opacity: _pulseController.value, child: child);
      },
      child: Column(
        key: const ValueKey<String>('loading-skeletons'),
        children: List<Widget>.generate(
          3,
          (index) => const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: _SearchSkeletonCard(),
          ),
        ),
      ),
    );
  }
}

class _SearchSkeletonCard extends StatelessWidget {
  const _SearchSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            AppColors.white.withValues(alpha: 0.9),
            AppColors.softBackground.withValues(alpha: 0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.65)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 1.62,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.lightLine.withValues(alpha: 0.8),
                      AppColors.mist.withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    width: 84,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _SkeletonBlock(height: 24, widthFactor: 0.62),
                    SizedBox(height: 8),
                    _SkeletonBlock(height: 10, widthFactor: 0.35),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _SkeletonFixedBlock(height: 24, width: 92),
                  SizedBox(height: 8),
                  _SkeletonFixedBlock(height: 10, width: 66),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 1,
            color: AppColors.lightLine.withValues(alpha: 0.45),
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(child: _SkeletonStat()),
              SizedBox(width: 10),
              Expanded(child: _SkeletonStat()),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(child: _SkeletonStat()),
              SizedBox(width: 10),
              Expanded(child: _SkeletonStat()),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.deepOrange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonStat extends StatelessWidget {
  const _SkeletonStat();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _SkeletonFixedBlock(height: 24, width: 24, isCircle: true),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkeletonBlock(height: 8, widthFactor: 0.5),
              SizedBox(height: 5),
              _SkeletonBlock(height: 11, widthFactor: 0.75),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({required this.height, required this.widthFactor});

  final double height;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: _SkeletonFixedBlock(height: height, width: double.infinity),
    );
  }
}

class _SkeletonFixedBlock extends StatelessWidget {
  const _SkeletonFixedBlock({
    required this.height,
    required this.width,
    this.isCircle = false,
  });

  final double height;
  final double width;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(isCircle ? 999 : 8),
      ),
    );
  }
}
