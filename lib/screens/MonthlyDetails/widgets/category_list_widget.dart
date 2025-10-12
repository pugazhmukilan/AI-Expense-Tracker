import 'package:flutter/material.dart';
import 'package:ai_expense/models/monthly_details_model.dart';
import 'package:ai_expense/theme/app_theme.dart';

class CategoryListWidget extends StatelessWidget {
  final MonthlyDetailsModel monthlyDetails;

  const CategoryListWidget({Key? key, required this.monthlyDetails}) : super(key: key);

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
          );
        }).toList(),
      ],
    );
  }
}

class CategoryExpansionTile extends StatefulWidget {
  final String categoryName;
  final CategoryDetails categoryDetails;

  const CategoryExpansionTile({
    Key? key,
    required this.categoryName,
    required this.categoryDetails,
  }) : super(key: key);

  @override
  State<CategoryExpansionTile> createState() => _CategoryExpansionTileState();
}

class _CategoryExpansionTileState extends State<CategoryExpansionTile> {
  bool _isExpanded = false;

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
          },
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.tertiary, AppColors.tertiary.withOpacity(0.7)],
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
                _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: AppColors.onPrimary,
              ),
            ],
          ),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: widget.categoryDetails.transactions.map((transaction) {
                  return _buildTransactionTile(transaction);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(Transaction transaction) {
    // Determine the transaction direction text
    String transactionDirection = transaction.transactionType == 'debited'
        ? 'Paid to'
        : 'Received from';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
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
          // Merchant/Recipient and Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.merchant.isNotEmpty 
                          ? transaction.merchant 
                          : 'Unknown',
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          transaction.transactionType == 'debited'
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 12,
                          color: transaction.transactionType == 'debited'
                              ? AppColors.tertiary
                              : Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            transactionDirection,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: transaction.transactionType == 'debited'
                        ? AppColors.tertiary.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    transaction.formattedAmount,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: transaction.transactionType == 'debited'
                          ? AppColors.tertiary
                          : Colors.green,
                    ),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          
          // Subject (if available)
          if (transaction.subject.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.onPrimary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.subject, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      transaction.subject,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Full message body (no truncation)
          if (transaction.body.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.onPrimary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.message, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(
                        'Transaction Details',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    transaction.body,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Date and Transaction Type Badge
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        transaction.formattedDate,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: transaction.transactionType == 'debited'
                      ? AppColors.tertiary.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  transaction.transactionType.toUpperCase(),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: transaction.transactionType == 'debited'
                        ? AppColors.tertiary
                        : Colors.green,
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
