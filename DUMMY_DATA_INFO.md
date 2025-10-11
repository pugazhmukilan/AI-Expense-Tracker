# 🎭 Dummy Data Configuration - Analysis Reports

## ✅ Current Status: DUMMY DATA MODE ACTIVE

The Analysis Reports feature is currently running with **dummy data** instead of real API calls. This allows you to test the UI immediately without needing a backend.

---

## 📊 Dummy Data Details

### Reports Included (6 Total)

| Month | Year | Status | Transactions | Amount | Created |
|-------|------|--------|--------------|--------|---------|
| October | 2025 | 🆕 **NEW** | 45 | ₹12,450.50 | Today |
| September | 2025 | ✅ Seen | 52 | ₹15,600.75 | 30 days ago |
| August | 2025 | ✅ Seen | 38 | ₹9,800.25 | 60 days ago |
| July | 2025 | 🆕 **NEW** | 41 | ₹11,250.00 | 90 days ago |
| June | 2025 | ✅ Seen | 35 | ₹8,900.50 | 120 days ago |
| May | 2025 | ✅ Seen | 48 | ₹13,400.75 | 150 days ago |

---

## 🎮 How to Test Right Now

1. **Run the app**: `flutter run`
2. **Navigate to home screen**
3. **Click "Analysis Reports" button**
4. **Watch the loading messages** (they change every 3 seconds):
   - "Fetching your reports..."
   - "This might take a moment..."
   - "We're working on it..."
   - etc.
5. **After 2 seconds**, see the 6 dummy reports displayed
6. **Click on any report** to see the interaction (placeholder for now)

---

## 🔄 How Dummy Data Works

### Location
File: `lib/repositories/report_repository.dart`

### Current Code
```dart
Future<List<ReportModel>> fetchReports() async {
  print("Fetching reports with dummy data (API not implemented yet)");
  await Future.delayed(const Duration(seconds: 2)); // Simulates network
  return _getDummyReports(); // Returns the 6 dummy reports
}
```

### Features
- ✅ 2-second delay to simulate real network call
- ✅ Console message to confirm dummy mode
- ✅ Returns consistent, predictable data
- ✅ No backend required

---

## 🚀 Switching to Real API (When Ready)

### Step 1: Edit `report_repository.dart`

**Comment out the dummy return:**
```dart
// print("Fetching reports with dummy data (API not implemented yet)");
// await Future.delayed(const Duration(seconds: 2));
// return _getDummyReports();
```

**Uncomment the API block** (starts around line 74):
```dart
/* Remove this line
final url = Uri.parse('$backend/api/reports');
final headers = {
  "Content-Type": "application/json",
  "Authorization": "Bearer ${LocalStorage.getString('authToken')}",
};

try {
  final response = await http.get(url, headers: headers);
  // ... rest of API code
} catch (e) {
  // Fallback to dummy data if API fails
  print('Error fetching reports: $e, using dummy data');
  return _getDummyReports();
}
Remove this line too */
```

### Step 2: Test with Your Backend
The app will now:
1. ✅ Try to call your API first
2. ✅ If API succeeds → show real data
3. ✅ If API fails → automatically fall back to dummy data
4. ✅ Never crash or show errors to users

---

## 🎯 Backend API Requirements (When Implementing)

### Endpoint
```
GET /api/reports
```

### Headers
```
Authorization: Bearer <user_auth_token>
Content-Type: application/json
```

### Response Format (Option 1 - Recommended)
```json
{
  "reports": [
    {
      "id": "unique_id_123",
      "month": "October",
      "year": 2025,
      "isSeen": false,
      "createdAt": "2025-10-11T10:30:00.000Z",
      "additionalData": {
        "totalTransactions": 45,
        "totalAmount": 12450.50
      }
    }
  ]
}
```

### Response Format (Option 2 - Also Supported)
```json
[
  {
    "id": "unique_id_123",
    "month": "October",
    "year": 2025,
    "isSeen": false,
    "createdAt": "2025-10-11T10:30:00.000Z"
  }
]
```

### Field Requirements
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | String | ✅ Yes | Unique report identifier (or _id) |
| month | String | ✅ Yes | Full month name (e.g., "January") |
| year | Number | ✅ Yes | Year as integer |
| isSeen | Boolean | ❌ No | Default: false. True if user has viewed |
| createdAt | String | ❌ No | ISO 8601 date string |
| additionalData | Object | ❌ No | Any extra data you want to store |

---

## 🛡️ Safety Features

### Fallback Logic
Even when API is enabled, the code includes fallback:

```dart
} catch (e) {
  print('Error fetching reports: $e, using dummy data');
  return _getDummyReports(); // Always returns something!
}
```

**Benefits:**
- ✅ App never crashes due to API errors
- ✅ Users always see something (even if it's dummy data)
- ✅ Developers can test UI without backend
- ✅ Smooth transition from dummy to real data

---

## 📝 Modifying Dummy Data

To change the dummy reports, edit the `_getDummyReports()` method:

```dart
List<ReportModel> _getDummyReports() {
  final now = DateTime.now();
  
  return [
    ReportModel(
      id: 'your_id',
      month: 'Your Month',
      year: 2025,
      isSeen: false, // or true
      createdAt: now,
      additionalData: {
        'any': 'data',
        'you': 'want',
      },
    ),
    // Add more reports...
  ];
}
```

---

## ✨ Summary

| Feature | Status |
|---------|--------|
| UI Screen | ✅ Complete |
| BLoC Logic | ✅ Complete |
| Loading States | ✅ Complete |
| Dummy Data | ✅ Active |
| API Integration | 🚧 Ready (commented out) |
| Fallback Logic | ✅ Complete |
| Error Handling | ✅ Complete |

**🎉 You can test the entire feature right now without any backend!**

Just run the app and click "Analysis Reports" on the home screen.
