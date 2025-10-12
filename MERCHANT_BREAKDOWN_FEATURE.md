# Merchant Breakdown Feature

## Overview
Enhanced the Monthly Details page to show merchant-level transaction breakdown when clicking on categories.

## What Changed

### 1. New API Integration
**Endpoint**: `/api/transactions/category?category={category}&month={month}&year={year}`

When a user clicks on a category (e.g., "Travel", "Food"), the app now:
- Calls this API with category name, month, and year
- Fetches detailed merchant breakdown for that category

### 2. New Files Created

#### `lib/models/category_details_model.dart`
Models for the API response:
- `CategoryDetailsModel` - Main response wrapper
- `FilterInfo` - Category, month, year info
- `SummaryInfo` - Total amounts, transaction counts
- `MerchantBreakdown` - Individual merchant data with amounts
- `MerchantTransaction` - Transaction details under each merchant

#### `lib/repositories/category_details_repository.dart`
Repository to fetch category details from the API with:
- Authentication token handling
- Error handling
- Debug print statements for troubleshooting

### 3. Modified Files

#### `lib/screens/MonthlyDetails/widgets/category_list_widget.dart`
**Major Changes**:
- Added `month` and `year` parameters to `CategoryExpansionTile`
- When category is expanded, calls API to fetch merchant breakdown
- Shows loading indicator while fetching data
- Displays merchant tiles instead of individual transactions

## UI Changes

### Before:
Category Dropdown → Individual Transactions

### After:
Category Dropdown → Merchant Tiles → Each showing:
- **Merchant Name** with store icon
- **Total transaction count**
- **Paid To (Debited)**:
  - Total amount paid to this merchant
  - Number of debit transactions
  - Red/coral color scheme
- **Received From (Credited)**:
  - Total amount received from this merchant
  - Number of credit transactions
  - Green color scheme

## Merchant Tile Design

```
┌─────────────────────────────────────────┐
│ 🏪 Merchant Name                        │
│    5 transactions                       │
├─────────────────────────────────────────┤
│ ┌──────────────┐  ┌──────────────────┐ │
│ │ ↑ Paid to    │  │ ↓ Received from  │ │
│ │ ₹4,600.00    │  │ ₹450.00          │ │
│ │ 4 transactions│  │ 1 transaction    │ │
│ └──────────────┘  └──────────────────┘ │
└─────────────────────────────────────────┘
```

## Performance Optimizations
- ✅ Data is only fetched when category is expanded (lazy loading)
- ✅ Cached after first load - no duplicate API calls
- ✅ Loading indicator for better UX
- ✅ Proper error handling

## Benefits
1. **Better Organization**: See all transactions grouped by merchant
2. **Quick Overview**: Instantly see how much paid/received from each merchant
3. **Reduced Clutter**: Instead of 50 individual transactions, see 5 merchant groups
4. **Better Performance**: Lazy loading only when needed

## Example Use Case
**Scenario**: You have 10 food transactions in October

**Old Way**:
- Click "Food" category
- See 10 individual transactions mixed together

**New Way**:
- Click "Food" category
- See 3 merchant tiles:
  - Zomato: Paid ₹2,500 (7 orders), Received ₹0
  - Swiggy: Paid ₹1,200 (2 orders), Received ₹0
  - Restaurant Refund: Paid ₹0, Received ₹300 (1 refund)

Much cleaner and easier to understand! 🎉
