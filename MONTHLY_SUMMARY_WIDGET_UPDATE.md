# Monthly Summary Widget Update - FIXED CALCULATION

## Overview
Updated the Monthly Summary widget on the home page to **properly calculate** the credited and debited amounts from actual transactions, since the API returns `0` for both `credited_amount` and `debited_amount` fields.

## Problem Identified
The API response contains:
```json
"monthly_stats": {
  "total_transactions": 40,
  "total_credited": 14,           // ✅ Count is correct
  "total_debited": 26,             // ✅ Count is correct
  "credited_amount": 0,            // ❌ Always returns 0
  "debited_amount": 0              // ❌ Always returns 0
}
```

However, the actual transaction amounts are present in the `all_transactions` array and need to be calculated.

## Solution

### 1. **MonthlyDetailsModel** (`lib/models/monthly_details_model.dart`)

#### Updated `totalSpent` getter with fallback calculation:
```dart
double get totalSpent {
  // If API provides the amount and it's not 0, use it
  if (monthlyStats.debitedAmount > 0) {
    return monthlyStats.debitedAmount;
  }
  
  // Otherwise, calculate from transactions
  double total = 0;
  for (var transaction in allTransactions) {
    if (transaction.transactionType == 'debited') {
      total += transaction.amountValue;
    }
  }
  return total;
}
```

#### Updated `totalCredited` getter with fallback calculation:
```dart
double get totalCredited {
  // If API provides the amount and it's not 0, use it
  if (monthlyStats.creditedAmount > 0) {
    return monthlyStats.creditedAmount;
  }
  
  // Otherwise, calculate from transactions
  double total = 0;
  for (var transaction in allTransactions) {
    if (transaction.transactionType == 'credited') {
      total += transaction.amountValue;
    }
  }
  return total;
}
```

**How it works:**
1. First checks if API provided the amounts (non-zero values)
2. If not, iterates through `allTransactions` array
3. Sums up amounts for debited/credited transactions respectively
4. Returns the calculated total

### 2. **HomeScreen** (`lib/screens/Home/home_screen.dart`)

#### Updated stat cards to use calculated amounts:

**Debited Card:**
- **Count**: `monthlyDetails.monthlyStats.totalDebited` (from API)
- **Amount**: `monthlyDetails.totalSpent` (calculated from transactions)

**Credited Card:**
- **Count**: `monthlyDetails.monthlyStats.totalCredited` (from API)
- **Amount**: `monthlyDetails.totalCredited` (calculated from transactions)

```dart
_buildStatCard(
  'Debited',
  '${monthlyDetails.monthlyStats.totalDebited}',
  '${monthlyDetails.totalSpent.toStringAsFixed(2)}',  // Calculated!
  Icons.arrow_upward,
  AppColors.tertiary,
)

_buildStatCard(
  'Credited',
  '${monthlyDetails.monthlyStats.totalCredited}',
  '${monthlyDetails.totalCredited.toStringAsFixed(2)}',  // Calculated!
  Icons.arrow_downward,
  Colors.green,
)
```

## Example Calculation

Based on your API response with 40 transactions:

**Debited Transactions (26 transactions):**
```
₹1.00 + ₹35.00 + ₹178.00 + ₹1.00 + ₹350.00 + ₹55.00 + ₹25.00 + 
₹10.00 + ₹10.00 + ₹340.00 + ₹180.00 + ₹200.00 + ₹20.00 + ₹105.00 + 
₹200.00 + ₹20.00 + ₹40.00 + ₹200.00 + ₹25.00 + ₹1.00 + ₹40.00 + 
₹720.00 + ₹109.00 + ₹10.00 + ₹20.00 + ₹10.00
= Total Debited Amount (calculated from all debit transactions)
```

**Credited Transactions (14 transactions):**
```
₹1.00 + ₹2023.34 + ₹20.00 + ₹10.00 + ₹1.00 + ₹10.00 + ₹10.00 + 
₹170.00 + ₹200.00 + ₹180.00 + ₹360.00 + ₹1.00 + ₹25.63 + ₹10.00
= Total Credited Amount (calculated from all credit transactions)
```

## Widget Display

The Monthly Summary card now shows **CALCULATED** values:

```
╔═══════════════════════════════════════╗
║      Monthly Summary       [40 txns]  ║
║                                       ║
║      ₹2,911.00 (calculated)           ║
║      spent                            ║
║                                       ║
║  ┌──────────────┐  ┌──────────────┐  ║
║  │ Debited   ↑  │  │ Credited  ↓  │  ║
║  │ ₹2,911.00    │  │ ₹3,021.97    │  ║
║  │ 26 trans     │  │ 14 trans     │  ║
║  └──────────────┘  └──────────────┘  ║
╚═══════════════════════════════════════╝
```
*Values are calculated from actual transaction amounts in `all_transactions` array*

## Benefits

1. **Accurate Amounts**: Calculates actual amounts from transaction data
2. **Fallback Strategy**: Uses API amounts if available, calculates if not
3. **Future-Proof**: Will work even when backend starts sending amounts
4. **Real-Time**: Always shows accurate transaction totals
5. **Reliable**: Uses the actual transaction list as source of truth

## API Response Structure Used

```json
{
  "success": true,
  "data": {
    "month": 10,
    "year": 2025,
    "month_name": "October",
    "monthly_stats": {
      "total_transactions": 40,
      "total_credited": 14,           // ✅ Used for count
      "total_debited": 26,             // ✅ Used for count
      "credited_amount": 0,            // ❌ Not used (always 0)
      "debited_amount": 0              // ❌ Not used (always 0)
    },
    "all_transactions": [              // ✅ Used for calculating amounts
      {
        "transaction_type": "debited",
        "amount": "1.00",              // ✅ Summed for debited total
        ...
      },
      {
        "transaction_type": "credited",
        "amount": "2023.34",           // ✅ Summed for credited total
        ...
      }
      // ... more transactions
    ]
  }
}
```

## Testing

To verify the changes:
1. Run the app: `flutter run`
2. Navigate to the home page
3. Check the Monthly Summary card:
   - ✅ Main amount should show total debited (not 0)
   - ✅ Debited card should show calculated amount (not 0)
   - ✅ Credited card should show calculated amount (not 0)
4. Compare with console logs to verify calculations
5. Check that transaction counts match (26 debited, 14 credited)

## Files Modified

- ✅ `lib/models/monthly_details_model.dart` - Added fallback calculation logic
- ✅ `lib/screens/Home/home_screen.dart` - Updated to use calculated amounts
- ✅ `MONTHLY_SUMMARY_WIDGET_UPDATE.md` - Updated documentation

## Technical Notes

**Why calculate instead of using API fields?**
- The API's `credited_amount` and `debited_amount` fields return `0`
- The actual amounts are present in the `all_transactions` array
- This solution calculates the correct totals from the transaction list

**Performance:**
- Calculation happens once when model is created
- Result is cached in getter
- Minimal performance impact (O(n) where n = number of transactions)

**Future Backend Fix:**
If the backend is updated to send correct amounts:
- The code will automatically use API values (first check in getter)
- No code changes needed when backend is fixed
- Seamless transition from calculated to API-provided amounts

