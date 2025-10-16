# Delete Account Feature Implementation

## Overview
Implemented a comprehensive account deletion feature with a hamburger menu drawer, replacing the previous logout button in the AppBar. Users can now access both logout and delete account options through a side navigation drawer.

## Changes Made

### 1. Auth Repository (`lib/repositories/auth_repository.dart`)
Added `deleteAccount()` method to handle account deletion API call:

```dart
final String deleteUrl = 'https://capestone-backend-1-q0hb.onrender.com/api/auth/delete';

Future<void> deleteAccount() async {
  final token = await LocalStorage.getString('authToken');
  
  if (token == null || token.isEmpty) {
    throw Exception('No authentication token found');
  }

  final response = await http.delete(
    Uri.parse(deleteUrl),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    return;
  }
  throw Exception('Failed to delete account');
}
```

**API Endpoint**: `DELETE /api/auth/delete`
- Requires Bearer token authentication
- Deletes all user data from backend
- Returns 200 on success

### 2. Auth Event (`lib/bloc/auth_event.dart`)
Added new event for delete account:

```dart
class DeleteAccountRequested extends AuthEvent {}
```

### 3. Auth BLoC (`lib/bloc/auth_bloc.dart`)
Added event handler for delete account:

```dart
on<DeleteAccountRequested>(_onDeleteAccountRequested);

Future<void> _onDeleteAccountRequested(
  DeleteAccountRequested event,
  Emitter<AuthState> emit,
) async {
  emit(AuthLoadingState(action: AuthAction.logout));
  try {
    await authRepo.deleteAccount();
    // Clear all local storage
    await LocalStorage.remove('authToken');
    await LocalStorage.remove('name');
    await LocalStorage.remove('email');
    await LocalStorage.remove('lastdate');
    // After deleting account, go to LoginOrSign
    emit(AuthUnauthenticatedState());
  } catch (e) {
    print('Delete account error: ${e.toString()}');
    emit(AuthFailureState(message: 'Failed to delete account: ${e.toString()}'));
    // Still logout locally even if API call fails
    await LocalStorage.remove('authToken');
    emit(AuthUnauthenticatedState());
  }
}
```

**Key Features:**
- Calls backend API to delete account
- Clears ALL local storage data (token, name, email, lastdate)
- Handles errors gracefully (logs out even if API fails)
- Emits appropriate states for loading/error handling

### 4. Home Screen UI (`lib/screens/Home/home_screen.dart`)

#### AppBar Changes
- **Removed**: Logout IconButton from AppBar
- **Added**: Hamburger menu icon (☰) as leading widget
- Opens side drawer when tapped

```dart
leading: Builder(
  builder: (context) => IconButton(
    icon: const Icon(Icons.menu, color: Colors.white, size: 28),
    onPressed: () {
      Scaffold.of(context).openDrawer();
    },
  ),
),
```

#### Navigation Drawer (`_buildDrawer`)
Created a beautiful side drawer with:

**Header Section:**
- User avatar (circle with first letter of name)
- User's full name
- User's email address
- Gradient background (tertiary color)

**Menu Options:**
1. **Logout** (white icon/text)
   - Logs out user
   - Clears auth token
   - Navigates to login screen
   
2. **Delete Account** (red icon/text)
   - Shows confirmation dialog
   - Permanently deletes account
   - Clears all data
   - Returns to login screen

```dart
Widget _buildDrawer(BuildContext context) {
  String userName = LocalStorage.getString('name') ?? "User";
  String userEmail = LocalStorage.getString('email') ?? "";

  return Drawer(
    backgroundColor: AppColors.primary,
    child: Column(
      children: [
        // Header with user info
        // Logout option
        // Delete Account option
      ],
    ),
  );
}
```

#### Confirmation Dialog (`_showDeleteConfirmationDialog`)
Shows an alert dialog before account deletion:

**Design:**
- Warning icon (amber)
- Clear title: "Delete Account"
- Detailed warning message
- Two actions:
  - **Cancel**: Dismisses dialog
  - **Delete**: Confirms deletion (red button)

```dart
void _showDeleteConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.primary,
        title: Row with warning icon,
        content: Warning message,
        actions: [Cancel, Delete buttons],
      );
    },
  );
}
```

## User Flow

### Logout Flow
1. User opens app
2. Taps hamburger menu (☰) in AppBar
3. Drawer slides in from left
4. User taps "Logout"
5. Auth token removed from local storage
6. User redirected to login screen

### Delete Account Flow
1. User opens app
2. Taps hamburger menu (☰) in AppBar
3. Drawer slides in from left
4. User taps "Delete Account" (red)
5. Confirmation dialog appears with warning
6. User can:
   - **Cancel**: Returns to app
   - **Delete**: Proceeds with deletion
7. If Delete confirmed:
   - API call to `DELETE /api/auth/delete`
   - All backend data deleted
   - All local storage cleared
   - User logged out
   - Redirected to login screen
8. User must create new account to use app again

## Visual Design

### Drawer Styling
- **Background**: `AppColors.primary` (dark blue)
- **Header Gradient**: Tertiary color gradient
- **Avatar**: White circle with colored initial
- **Text**: Poppins font family
- **Divider**: Semi-transparent white line between options
- **Icons**: 26px size for visual clarity

### Color Coding
- **Logout**: White (neutral action)
- **Delete Account**: Red/RedAccent (destructive action)
- **Dialog Delete Button**: Red background (emphasizes danger)

### Spacing & Layout
- Header padding: 50px top, 20px sides/bottom
- Avatar radius: 40px
- List tiles: Default Material padding
- Divider: 20px indent on both sides

## Security & Data Handling

### Authentication
- Bearer token sent in Authorization header
- Token validated on backend before deletion

### Data Cleanup
Local storage items cleared:
- `authToken` - User authentication token
- `name` - User's name
- `email` - User's email address
- `lastdate` - Transaction history date marker

### Error Handling
- Graceful fallback if API fails
- User still logged out locally
- Error message shown in AuthFailureState
- Console logging for debugging

## Backend API Requirements

### Endpoint Specification
```
DELETE /api/auth/delete
Headers:
  Content-Type: application/json
  Authorization: Bearer {token}

Response:
  Success (200): { "success": true, "message": "Account deleted successfully" }
  Error (401): { "success": false, "message": "Unauthorized" }
  Error (500): { "success": false, "message": "Server error" }
```

### Expected Backend Actions
1. Verify Bearer token
2. Identify user from token
3. Delete all user's transactions
4. Delete all user's budgets
5. Delete user account
6. Return success response

## Benefits

1. **Better UX**: Side drawer is more discoverable than single button
2. **Clear Separation**: Logout vs Delete are visually distinct
3. **Safety**: Confirmation dialog prevents accidental deletion
4. **Complete Cleanup**: All data removed from both backend and local storage
5. **Intuitive**: Hamburger menu is a familiar navigation pattern
6. **Scalable**: Easy to add more menu options in future
7. **Professional**: Follows Material Design guidelines

## Testing Checklist

- [ ] Hamburger menu opens drawer
- [ ] Drawer displays correct user info
- [ ] Logout works and redirects to login
- [ ] Delete confirmation dialog appears
- [ ] Cancel button closes dialog without action
- [ ] Delete button calls API and clears data
- [ ] User redirected to login after deletion
- [ ] Cannot access app after deletion without re-registering
- [ ] Error handling works if API fails
- [ ] Drawer closes when option is tapped

## Future Enhancements

Potential additions to the drawer:
- Settings/Preferences
- Profile editing
- Privacy policy
- Terms of service
- App version info
- Dark/Light theme toggle
- Language selection
