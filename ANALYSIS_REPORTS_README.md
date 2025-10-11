# Analysis Reports Feature

## Overview
This feature adds an Analysis Reports screen that displays monthly expense reports with engaging loading states and interactive tiles.

## Files Created

### 1. BLoC Files
- **`lib/bloc/report_bloc.dart`**: Main BLoC that handles report fetching logic
- **`lib/bloc/report_event.dart`**: Events (FetchReports)
- **`lib/bloc/report_state.dart`**: States (Initial, Fetching, Fetched, Empty, Error)

### 2. Model
- **`lib/models/report_model.dart`**: Data model for reports containing:
  - `id`: Unique identifier
  - `month`: Month name (e.g., "January")
  - `year`: Year number
  - `isSeen`: Boolean flag for seen/unseen status
  - `createdAt`: Report creation date
  - `additionalData`: Map for future API data

### 3. Repository
- **`lib/repositories/report_repository.dart`**: Handles API calls to fetch reports from backend
  - Endpoint: `GET /api/reports`
  - Uses authentication token from LocalStorage

### 4. Screen & Widgets (Clean Architecture)
- **`lib/screens/AnalysisReports/analysis_reports_screen.dart`**: Main screen (orchestrator)
- **`lib/screens/AnalysisReports/widgets/`**: Separate widget files
  - `loading_state_widget.dart` - Loading UI with rotating messages
  - `report_tile_widget.dart` - Individual report card
  - `reports_list_widget.dart` - Scrollable list with pull-to-refresh
  - `empty_state_widget.dart` - Empty state UI
  - `error_state_widget.dart` - Error state UI

### 5. Documentation
- **`lib/screens/AnalysisReports/README.md`**: Detailed structure documentation

## Features

### Loading Messages
When fetching takes time, the screen cycles through encouraging messages every 3 seconds:
- "Fetching your reports..."
- "This might take a moment..."
- "We're working on it..."
- "Analyzing your data..."
- "Almost there..."
- "Thanks for your patience..."

### Report Tiles
Each tile displays:
- **Month abbreviation** and **Year** in a colored box
- **Full month name** and **Year** as title
- **Creation date** in formatted style
- **Seen/Unseen badge** with appropriate styling:
  - New reports: Green/Tertiary color with "New" badge
  - Seen reports: Gray with "Seen" badge

### Interactions
- Click on any tile to view report details (placeholder implemented)
- Pull down to refresh the list
- Tap refresh icon in AppBar to reload

## Backend API Expected Format

### Current Status: Using Dummy Data
The repository is currently configured to return dummy data with a 2-second simulated delay. This allows you to test the UI without needing the backend API.

**Dummy Data Includes:**
- 6 sample monthly reports (October 2025 back to May 2025)
- Mix of seen and unseen reports
- Sample additional data (transaction counts and amounts)

### When Backend is Ready

To enable the real API, edit `lib/repositories/report_repository.dart`:

1. Comment out the dummy data return:
```dart
// Comment out these lines:
// print("Fetching reports with dummy data (API not implemented yet)");
// await Future.delayed(const Duration(seconds: 2));
// return _getDummyReports();
```

2. Uncomment the API call block (around line 74)

### Endpoint
```
GET /api/reports
Authorization: Bearer <token>
```

### Expected Response Format
```json
{
  "reports": [
    {
      "id": "report_123",
      "month": "January",
      "year": 2025,
      "isSeen": false,
      "createdAt": "2025-01-15T10:30:00.000Z",
      "additionalData": {
        // Any additional fields the backend wants to send
      }
    }
  ]
}
```

Or simply as an array:
```json
[
  {
    "id": "report_123",
    "month": "January",
    "year": 2025,
    "isSeen": false,
    "createdAt": "2025-01-15T10:30:00.000Z"
  }
]
```

### Fallback Logic
Even when the API is enabled, if the API call fails or returns an error, the repository will automatically fall back to returning dummy data. This ensures the app always shows something to the user.

## Usage

### Navigation
The "Analysis Reports" button on the home screen navigates to this page:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AnalysisReportsScreen(),
  ),
);
```

### BLoC Integration
The ReportBloc is provided at the app level in `main.dart`:

```dart
BlocProvider(
  create: (_) => ReportBloc(reportRepository: reportRepo),
),
```

## Future Implementation

When clicking a report tile, you'll need to implement the report details page:

```dart
// In analysis_reports_screen.dart, line ~235
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ReportDetailsScreen(reportId: report.id),
  ),
);
```

## Customization

### Change Loading Messages
Edit the `_loadingMessages` list in `_AnalysisReportsScreenState`:

```dart
final List<String> _loadingMessages = [
  "Your custom message 1",
  "Your custom message 2",
  // Add more...
];
```

### Change Cycling Interval
Modify the duration in `initState` and `_cycleLoadingMessage`:

```dart
Future.delayed(const Duration(seconds: 3), _cycleLoadingMessage);
// Change to any duration you want
```

### Modify Tile Appearance
Edit the `_buildReportTile` method to customize:
- Colors
- Border radius
- Padding
- Font styles
- Badge appearance

## Testing

### Current Setup: Dummy Data Mode
The app is currently configured to use dummy data, so you can test immediately without a backend:

1. Run the app
2. Click "Analysis Reports" button on home screen
3. You'll see a 2-second loading animation with rotating messages
4. Then 6 sample reports will be displayed

### Dummy Reports Included
- October 2025 (New/Unseen)
- September 2025 (Seen)
- August 2025 (Seen)
- July 2025 (New/Unseen)
- June 2025 (Seen)
- May 2025 (Seen)

Each report includes sample transaction counts and amounts in the `additionalData` field.

### Testing with Backend
Once your backend is ready, uncomment the API code in `report_repository.dart` as described above. The app will:
1. Try to fetch from the API first
2. If the API fails, fall back to dummy data
3. Never show an error to the user (always shows something)
