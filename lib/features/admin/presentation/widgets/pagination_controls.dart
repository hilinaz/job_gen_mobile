import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;
  
  const PaginationControls({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPageButton(
            icon: Icons.chevron_left,
            onPressed: currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
          ),
          const SizedBox(width: 8),
          ...List.generate(
            _getPageRange().length,
            (index) {
              final pageNumber = _getPageRange()[index];
              return _buildNumberButton(
                pageNumber: pageNumber,
                isActive: pageNumber == currentPage,
                onPressed: () => onPageChanged(pageNumber),
              );
            },
          ),
          const SizedBox(width: 8),
          _buildPageButton(
            icon: Icons.chevron_right,
            onPressed: currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }

  List<int> _getPageRange() {
    const maxVisiblePages = 5;
    
    if (totalPages <= maxVisiblePages) {
      return List.generate(totalPages, (i) => i + 1);
    }
    
    int start = currentPage - 2;
    int end = currentPage + 2;
    
    if (start < 1) {
      start = 1;
      end = start + maxVisiblePages - 1;
    }
    
    if (end > totalPages) {
      end = totalPages;
      start = end - maxVisiblePages + 1;
      if (start < 1) start = 1;
    }
    
    return List.generate(end - start + 1, (i) => start + i);
  }

  Widget _buildPageButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: onPressed == null
                    ? Colors.grey[200]
                    : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: onPressed == null
                    ? Colors.grey[400]
                    : Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNumberButton({
    required int pageNumber,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  pageNumber.toString(),
                  style: TextStyle(
                    color: isActive
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
