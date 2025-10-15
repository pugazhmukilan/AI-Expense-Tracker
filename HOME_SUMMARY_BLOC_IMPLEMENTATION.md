# Home Page Monthly Summary - Separate BLoC Implementation

## Problem
The home page and history page were sharing the same `MonthlyDetailsBloc`, causing the home page's monthly summary to be replaced with historical data when viewing previous months in the history page.

## Solution
Created a dedicated `HomeSummaryBloc` specifically for the home page's monthly summary widget. This ensures the home page always displays the current month's data, regardless of what month is being viewed in the history section.

## Changes Made

### 1. New BLoC Files Created
- **`lib/bloc/home_summary_event.dart`**: Contains `FetchHomeSummary` event
- **`lib/bloc/home_summary_state.dart`**: Contains states: `HomeSummaryInitial`, `HomeSummaryLoading`, `HomeSummaryLoaded`, `HomeSummaryEmpty`, `HomeSummaryError`
- **`lib/bloc/home_summary_bloc.dart`**: Handles home page monthly summary logic independently

### 2. Updated Files

#### `lib/main.dart`
- Added import for `HomeSummaryBloc`
- Registered `HomeSummaryBloc` in the `MultiBlocProvider` list
- Uses the same `MonthlyDetailsRepository` instance but maintains separate state

#### `lib/screens/Home/home_screen.dart`
- Updated imports to use `HomeSummaryBloc`, `HomeSummaryEvent`, and `HomeSummaryState`
- Removed imports for `MonthlyDetailsBloc`, `MonthlyDetailsEvent`, and `MonthlyDetailsState`
- Changed `initState()` to dispatch `FetchHomeSummary` event to `HomeSummaryBloc`
- Updated `FloatingActionButton` to refresh using `HomeSummaryBloc`
- Changed `BlocBuilder` from `MonthlyDetailsBloc` to `HomeSummaryBloc`
- Updated state checks:
  - `MonthlyDetailsLoading` → `HomeSummaryLoading`
  - `MonthlyDetailsLoaded` → `HomeSummaryLoaded`
  - `MonthlyDetailsError` → `HomeSummaryError`

## Benefits
1. ✅ **State Isolation**: Home page and history page now have independent states
2. ✅ **No Side Effects**: Viewing past months in history won't affect the home page
3. ✅ **Always Current**: Home page always shows the current month's summary
4. ✅ **Proper Refresh**: Floating action button correctly refreshes only the home page data
5. ✅ **Clean Architecture**: Follows BLoC pattern with clear separation of concerns

## Testing Checklist
- [ ] Home page displays current month's summary correctly
- [ ] Floating action button refreshes home page data
- [ ] Navigate to history page and view previous months
- [ ] Return to home page - should still show current month (not the historical month)
- [ ] Refresh button on home page works correctly
- [ ] No state conflicts between home and history pages

## Technical Details
- Both `HomeSummaryBloc` and `MonthlyDetailsBloc` use the same repository (`MonthlyDetailsRepository`)
- They are completely independent BLoC instances with separate state streams
- The repository is shared, but each BLoC maintains its own state
- This is a standard BLoC pattern for handling the same data type in different contexts
