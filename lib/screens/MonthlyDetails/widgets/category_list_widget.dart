import 'package:flutter/material.dart';
import 'package:ai_expense/models/monthly_details_model.dart';
import 'package:ai_expense/models/category_details_model.dart';
import 'package:ai_expense/repositories/category_details_repository.dart';
import 'package:ai_expense/theme/app_theme.dart';

class CategoryListWidget extends StatelessWidget {
  final MonthlyDetailsModel monthlyDetails;

  const CategoryListWidget({Key? key, required this.monthlyDetails})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = monthlyDetails.categoryWiseSummary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        ...categories.entries.map((entry) {
          return CategoryExpansionTile(
            categoryName: entry.key,
            categoryDetails: entry.value,
            month: monthlyDetails.month,
            year: monthlyDetails.year,
          );
        }).toList(),
      ],
    );
  }
}

class CategoryExpansionTile extends StatefulWidget {
  final String categoryName;
  final CategoryDetails categoryDetails;
  final int month;
  final int year;

  const CategoryExpansionTile({
    Key? key,
    required this.categoryName,
    required this.categoryDetails,
    required this.month,
    required this.year,
  }) : super(key: key);

  @override
  State<CategoryExpansionTile> createState() => _CategoryExpansionTileState();
}

class _CategoryExpansionTileState extends State<CategoryExpansionTile> {
  bool _isExpanded = false;
  bool _isLoading = false;
  CategoryDetailsModel? _categoryData;
  String? _errorMessage;
  final CategoryDetailsRepository _repository = CategoryDetailsRepository();

  Future<void> _loadCategoryDetails() async {
    if (_categoryData != null) return; // Already loaded

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print(
        'Loading category details for: ${widget.categoryName}, Month: ${widget.month}, Year: ${widget.year}',
      );

      final data = await _repository.fetchCategoryDetails(
        category: widget.categoryName,
        month: widget.month,
        year: widget.year,
      );

      print('Received data: ${data != null ? "Success" : "Null"}');
      if (data != null) {
        print('Merchant breakdown count: ${data.merchantBreakdown.length}');
      }

      setState(() {
        _categoryData = data;
        _isLoading = false;
        if (data == null) {
          _errorMessage = 'No data available for this category';
        } else if (data.merchantBreakdown.isEmpty) {
          _errorMessage = 'No merchants found for this category';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading data: $e';
      });
      print('Error loading category details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.onPrimary.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
            if (expanded) {
              _loadCategoryDetails();
            }
          },
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.tertiary,
                  AppColors.tertiary.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                widget.categoryDetails.count.toString(),
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          title: Text(
            widget.categoryName,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          subtitle: Text(
            '${widget.categoryDetails.count} transactions',
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.categoryDetails.formattedTotalAmount,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppColors.onPrimary,
              ),
            ],
          ),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child:
                  _isLoading
                      ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      )
                      : _errorMessage != null
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.grey[400],
                                size: 48,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                      : _categoryData == null ||
                          _categoryData!.merchantBreakdown.isEmpty
                      ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'No merchants found',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                      : Column(
                        children:
                            _categoryData!.merchantBreakdown.map((merchant) {
                              return _buildMerchantTile(merchant);
                            }).toList(),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMerchantTile(MerchantBreakdown merchant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.onPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Merchant Name and Total Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.store,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            merchant.merchant,
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${merchant.transactionCount} transaction${merchant.transactionCount > 1 ? 's' : ''}',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.onPrimary),
          const SizedBox(height: 16),

          // Amount Breakdown
          Row(
            children: [
              // Paid to merchant (Debited)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.tertiary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            size: 16,
                            color: AppColors.tertiary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Paid to',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 11,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        merchant.formattedDebitedAmount,
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.tertiary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${merchant.debitedCount} transaction${merchant.debitedCount > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Received from merchant (Credited)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_downward,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Received from',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 11,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        merchant.formattedCreditedAmount,
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${merchant.creditedCount} transaction${merchant.creditedCount > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
