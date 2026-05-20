# TODO - SmartBloodCare

## Step 1: Firestore Security Rules
- [x] Created `firestore.rules` with proper rules for requests, donors, hospitals, notifications collections
- Deploy to Firebase Console (no local file existed previously)

## Step 2: Emergency button UI
- [x] Restructured emergency broadcast screen layout: button now uses `Expanded` + `Center` so it stays centered regardless of pulse circle animations
- Fixed: Body changed from `Container` with `Column(mainAxisAlignment: center)` to `Padding` + `Column` with `Expanded(Center(Stack(...)))`
- Fixed: Removed large fixed SizedBox gaps that pushed content; button area now flexes proportionally

## Step 3: Hospitals tab/text spacing
- [x] Reduced NavigationBar `labelTextStyle` fontSize from 11 to 10, letterSpacing from -0.2 to -0.3
- This prevents the Arabic word "المستشفيات" from wrapping to two lines on narrow screens

## Step 4: Verification
- [ ] Add blood request -> confirm Firestore write succeeds
- [ ] Open Emergency screen -> confirm button fits in center
- [ ] Open Hospitals screen -> confirm tab label spacing
