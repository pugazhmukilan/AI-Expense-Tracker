# Chart Toggle View Implementation

## Overview
Implemented a toggle view feature for the spending chart on the home screen, allowing users to switch between three different views: Total, Debited, and Credited transactions.

## Changes Made

### 1. Model Updates (`lib/models/monthly_chart_model.dart`)
- Added `debitedAmount` field to `MonthlySpend` class
- Added `creditedAmount` field to `MonthlySpend` class
- Updated `fromJson` method to parse new fields from API response

```dart
class MonthlySpend {
  final String month;
  final int year;
  final double totalSpent;
  final double debitedAmount;
  final double creditedAmount;
  final String monthName;
}
```

### 2. Home Screen Updates (`lib/screens/Home/home_screen.dart`)

#### State Management
- Added `String _chartView = 'total';` to track the current view selection
- Default view is 'total' showing all transactions

#### UI Components
- **Toggle Buttons**: Added three toggle buttons above the chart
  - Total (bar chart icon)
  - Debited (arrow upward icon)
  - Credited (arrow downward icon)
- Buttons are styled with glassmorphism design matching the app theme
- Selected button has highlighted background and accent color
- Unselected buttons have transparent background and muted color

#### Chart Logic Updates
- **Dynamic maxYValue Calculation**: Chart Y-axis scale now adjusts based on selected view
  ```dart
  switch (_chartView) {
    case 'debited':
      maxYValue = state.spendingData.map((d) => d.debitedAmount).reduce(max);
      break;
    case 'credited':
      maxYValue = state.spendingData.map((d) => d.creditedAmount).reduce(max);
      break;
    case 'total':
    default:
      maxYValue = state.spendingData.map((d) => d.totalSpent).reduce(max);
  }
  ```

- **Dynamic Bar Data**: Bar heights change based on selected view
  ```dart
  double barValue;
  Color barColor;
  switch (_chartView) {
    case 'debited':
      barValue = dataPoint.debitedAmount;
      barColor = Colors.pink.shade200; // Light pink for spending
      break;
    case 'credited':
      barValue = dataPoint.creditedAmount;
      barColor = Colors.green.shade400; // Green for income
      break;
    case 'total':
    default:
      barValue = dataPoint.totalSpent;
      barColor = AppColors.tertiary.withOpacity(0.8); // Default color
  }
  ```

- **Dynamic Tooltips**: Tooltip labels reflect the current view
  - Total view: "Total: ₹X"
  - Debited view: "Debited: ₹X"
  - Credited view: "Credited: ₹X"

### 3. Visual Design
- Toggle buttons use a compact, horizontal layout
- Background container with `Colors.white.withOpacity(0.1)`
- Individual buttons have rounded corners (6px)
- Selected state uses `AppColors.onPrimary.withOpacity(0.3)` background
- Icons and text color change based on selection state
- Smooth state transitions with `setState()`

#### Chart Color Coding
- **Total View**: Default app tertiary color (blue/purple) at 80% opacity
- **Debited View**: Light pink (`Colors.pink.shade200`) - indicates money spent
- **Credited View**: Green (`Colors.green.shade400`) - indicates money received
- Colors provide instant visual feedback about the data type being viewed

## API Requirements
The `/api/transactions/last-six-months` endpoint must return:
```json
{
  "success": true,
  "data": [
    {
      "monthName": "January",
      "totalAmount": 15000,
      "debitedAmount": 12000,
      "creditedAmount": 3000
    }
  ]
}
```

## User Experience
1. User opens the home screen
2. Chart displays total transaction amounts by default
3. User can tap "Debited" button to see only money spent
4. User can tap "Credited" button to see only money received
5. User can tap "Total" button to return to combined view
6. Chart smoothly updates with new data and Y-axis scale
7. Tooltips dynamically show the appropriate label and amount

## Benefits
- **Better Data Insights**: Users can separately analyze spending vs income trends
- **Visual Clarity**: Isolating transaction types makes patterns easier to identify
- **Intuitive UI**: Small, unobtrusive toggle buttons don't clutter the interface
- **Responsive**: Chart and Y-axis automatically adjust for optimal visualization
- **Consistent Design**: Matches the glassmorphism theme throughout the app

## Technical Details
- No additional API calls required (data already fetched)
- Minimal performance impact (simple state toggle and rebuild)
- Maintains existing chart animations and interactions
- Compatible with existing skeleton loader and error states
