import 'package:flutter/material.dart';

class ScheduleShimmerWidget extends StatelessWidget {
  const ScheduleShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header shimmer
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: _ShimmerBlock(
            width: 150,
            height: 24,
          ),
        ),
        const SizedBox(height: 16),
        
        // Schedule groups grid shimmer
        SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return const _ScheduleGroupCardShimmer();
              },
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Time slots section shimmer
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Available Times header
                  const _ShimmerBlock(
                    width: 140,
                    height: 20,
                  ),
                  const SizedBox(height: 16),
                  
                  // Morning section
                  const _ShimmerBlock(
                    width: 80,
                    height: 16,
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return const _TimeSlotShimmer();
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Afternoon section
                  const _ShimmerBlock(
                    width: 90,
                    height: 16,
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return const _TimeSlotShimmer();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Continue button shimmer
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: _ShimmerBlock(
            width: double.infinity,
            height: 48,
          ),
        ),
      ],
    );
  }
}

class _ScheduleGroupCardShimmer extends StatelessWidget {
  const _ScheduleGroupCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Date shimmer
          const _ShimmerBlock(
            width: 40,
            height: 12,
          ),
          const SizedBox(height: 4),
          // Month shimmer
          const _ShimmerBlock(
            width: 30,
            height: 10,
          ),
          const SizedBox(height: 8),
          // Count badge shimmer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const _ShimmerBlock(
              width: 15,
              height: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeSlotShimmer extends StatelessWidget {
  const _TimeSlotShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: _ShimmerBlock(
          width: 60,
          height: 14,
        ),
      ),
    );
  }
}

class _ShimmerBlock extends StatelessWidget {
  final double width;
  final double height;

  const _ShimmerBlock({
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
