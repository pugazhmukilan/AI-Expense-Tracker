# Home Page API Logging Documentation

## Overview
Enhanced logging has been added to all API calls made from the Home Page. You will now see clear, formatted console output every time an API is called.

## APIs Being Logged

### 1. Monthly Summary API
**Location**: `lib/repositories/monthly_details_repository.dart`
**Called By**: `HomeSummaryBloc` (for the monthly summary card at the top of the home page)
**Endpoint**: `/api/transactions/monthly?year={year}&month={month}`

**Console Output Example**:
```
╔════════════════════════════════════════════════════════════════════════════╗
║                    HOME PAGE - MONTHLY SUMMARY API CALL                    ║
╚════════════════════════════════════════════════════════════════════════════╝
📅 Requesting Month: 10, Year: 2025
🔗 Endpoint: /api/transactions/monthly?year=2025&month=10
✅ Auth Token Found: eyJhbGciOiJIUzI1NiIs...
🚀 Making API Request to: http://localhost:3000/api/transactions/monthly?year=2025&month=10

📥 API RESPONSE RECEIVED:
├─ Status Code: 200
├─ Status: ✅ SUCCESS
├─ Response Body:
│  {"success":true,"data":{...}}
│
├─ Parsed Data:
│  ├─ Success: true
│  ├─ Total Transactions: 45
│  ├─ Total Amount: ₹12,450.50
│  ├─ Total Debited: 40
│  ├─ Total Credited: 5
│  ├─ Categories Found: Food, Travel, Shopping
│  │
│  ├─ Category: Food
│  │  ├─ Transaction Count: 15
│  │  ├─ Total Amount: 4500.00
│  │  └─ Sample Transactions (showing first 2):
│  │     ├─ Transaction 1:
│  │     │  ├─ Merchant: Swiggy
│  │     │  ├─ Amount: 350.00
│  │     │  ├─ Type: debited
│  │     │  └─ Date: 2025-10-15
└─ ✅ Data Parsed Successfully
╚════════════════════════════════════════════════════════════════════════════╝
```

### 2. Spending Chart API
**Location**: `lib/repositories/monthly_chart_repository.dart`
**Called By**: `MonthlyChartBloc` (for the bar chart showing last 6 months spending)
**Endpoint**: `/api/transactions/last-six-months`

**Console Output Example**:
```
╔════════════════════════════════════════════════════════════════════════════╗
║                    HOME PAGE - SPENDING CHART API CALL                     ║
╚════════════════════════════════════════════════════════════════════════════╝
📊 Requesting: Last 6 months spending data
🔗 Endpoint: /api/transactions/last-six-months
✅ Auth Token Found: eyJhbGciOiJIUzI1NiIs...
🚀 Making API Request to: http://localhost:3000/api/transactions/last-six-months

📥 API RESPONSE RECEIVED:
├─ Status Code: 200
├─ Status: ✅ SUCCESS
├─ Response Body:
│  {"data":{"months":[...]}}
│
├─ Parsed Data:
│  ├─ Number of Months: 6
│  │
│  ├─ Month 1:
│  │  ├─ Month Name: October
│  │  ├─ Month Number: 10
│  │  ├─ Year: 2025
│  │  ├─ Total Spent: 12450.50
│  │  └─ Transaction Count: 45
│  ├─ Month 2:
│  │  ├─ Month Name: September
│  │  ├─ Month Number: 9
│  │  ├─ Year: 2025
│  │  ├─ Total Spent: 15600.75
│  │  └─ Transaction Count: 52
└─ ✅ Chart Data Parsed Successfully
╚════════════════════════════════════════════════════════════════════════════╝
```

### 3. Message Batch API
**Location**: `lib/utils/MessageFetcher.dart`
**Called By**: `MessageBloc` (when you click the floating action button to fetch SMS)
**Endpoint**: `/api/transactions/batch`

**Console Output Example**:
```
╔════════════════════════════════════════════════════════════════════════════╗
║                     HOME PAGE - MESSAGE BATCH API CALL                     ║
╚════════════════════════════════════════════════════════════════════════════╝
📱 Processing SMS Messages
📊 Total Messages to Send: 15
🔗 Endpoint: /api/transactions/batch
✅ Auth Token Found: eyJhbGciOiJIUzI1NiIs...

📤 REQUEST PAYLOAD:
├─ Number of Transactions: 15
├─ Sample Transactions (showing first 3):
│  ├─ Transaction 1:
│  │  ├─ Merchant: Swiggy
│  │  ├─ Amount: 350.00
│  │  ├─ Type: debited
│  │  ├─ Date: 2025-10-15T10:30:00.000
│  │  └─ Address: VM-SWIGGY
│  ├─ Transaction 2:
│  │  ├─ Merchant: Zomato
│  │  ├─ Amount: 450.00
│  │  ├─ Type: debited
│  │  ├─ Date: 2025-10-14T15:20:00.000
│  │  └─ Address: VM-ZOMATO
│  └─ ... and 12 more transactions
│
🚀 Making API Request to: http://localhost:3000/api/transactions/batch

📥 API RESPONSE RECEIVED:
├─ Status Code: 200
├─ Status: ✅ SUCCESS
├─ Response Body: {"success":true,"message":"Transactions saved"}
└─ ✅ Messages Sent Successfully to Backend
╚════════════════════════════════════════════════════════════════════════════╝
```

## When These APIs Are Called

### On Home Page Load (initState):
1. **Monthly Summary API** - Called automatically via `HomeSummaryBloc`
2. **Spending Chart API** - Called automatically via `MonthlyChartBloc`

### When Floating Action Button is Pressed:
1. **Message Batch API** - Fetches SMS and sends to backend via `MessageBloc`
2. **Monthly Summary API** - Refreshes the summary data
3. **Spending Chart API** - Refreshes the chart data

## Status Indicators

- ✅ = Success
- ❌ = Error
- ⚠️ = Warning
- 📅 = Date/Time
- 🔗 = Endpoint URL
- 🚀 = Request being sent
- 📥 = Response received
- 📤 = Data being sent
- 📱 = SMS related
- 📊 = Chart/Statistics related

## Error Scenarios

### If Authentication Token is Missing:
```
❌ ERROR: Authentication token not found
```

### If API Returns Error:
```
├─ Status: ❌ ERROR (400/500)
├─ Error Response: {error details}
└─ Failed to fetch data
```

### If Exception Occurs:
```
└─ ❌ EXCEPTION OCCURRED: {exception details}
```

## How to Use

1. **Open Your Console/Terminal** where you run the Flutter app
2. **Navigate to Home Page** - You'll see the first two API calls
3. **Press the Floating Action Button** - You'll see all three API calls
4. **Watch the Console** - All API request/response details will be clearly displayed

## Benefits

✅ **Easy Debugging**: Quickly see what data is being sent/received
✅ **Error Tracking**: Clear error messages with status codes
✅ **Data Validation**: Verify API responses match expectations
✅ **Performance Monitoring**: Track API response times
✅ **Development Aid**: Understand data flow between frontend and backend
