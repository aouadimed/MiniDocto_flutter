/// Utility class for pagination calculations
class PaginationUtils {
  /// Calculates the number of pages based on total items and items per page
  static int calculatePageCount(int totalItems, int itemsPerPage) {
    return (totalItems / itemsPerPage).ceil();
  }

  /// Calculates start and end index for a given page
  static Map<String, int> getPageIndices(int pageIndex, int itemsPerPage, int totalItems) {
    final startIndex = pageIndex * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, totalItems);
    
    return {
      'start': startIndex,
      'end': endIndex,
    };
  }

  /// Checks if the current page is the loading page
  static bool isLoadingPage(int pageIndex, int totalItems, int itemsPerPage) {
    final totalPages = calculatePageCount(totalItems, itemsPerPage);
    return pageIndex >= totalPages;
  }

  /// Gets the items for a specific page
  static List<T> getPageItems<T>(List<T> allItems, int pageIndex, int itemsPerPage) {
    final indices = getPageIndices(pageIndex, itemsPerPage, allItems.length);
    return allItems.sublist(indices['start']!, indices['end']!);
  }
}
