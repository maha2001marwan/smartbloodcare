## المقترح لحل `cloud_firestore/permission-denied`

ملف القواعد الحالي عندك:

```js
match /{document=**} {
  allow read, write: if false;
}
```

هذا يعني: ممنوع 100% قراءة وكتابة.

### تعديل مقترح (مناسب لبنية التطبيق الحالية)
اعمل override لهذه القواعد في Firebase Console > Firestore > Rules:

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // helper: user must be authenticated
    function isSignedIn() { return request.auth != null; }

    // helper: user must be donor or hospital based on users/{uid}.role
    function hasRole(role) {
      return isSignedIn() && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == role;
    }

    // USERS
    match /users/{uid} {
      allow read: if isSignedIn() && request.auth.uid == uid;
      allow write: if isSignedIn() && request.auth.uid == uid;
    }

    // BLOOD REQUESTS
    // - Hospitals: create/update
    // - Donors: read (optional)
    match /requests/{id} {
      allow read: if isSignedIn() && (
        hasRole('donor') || hasRole('hospital')
      );

      allow create: if hasRole('hospital');
      allow update, delete: if hasRole('hospital');
    }

    // NOTIFICATIONS
    match /notifications/{id} {
      allow read: if isSignedIn();
      allow write: if hasRole('hospital');
    }

    // HOSPITALS / DONORS / OTHER PUBLIC DATA
    match /hospitals/{id} {
      allow read: if true;
      allow write: if hasRole('hospital');
    }

    match /donors/{id} {
      allow read: if true;
      allow write: if hasRole('hospital');
    }

    // default: deny
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

### ملاحظات مهمة
- هذا الحل يعتمد أن عندك `users/{uid}.role` قيمته فعلًا:
  - `hospital` للحالات التي تضيف request
  - `donor` للمتبرعين
- إذا role مختلفة، سنعدّل القواعد.

### ملاحظة كبيرة
إذا لا تريد تفعيل role الآن، مؤقتًا للتجربة ممكن تعمل:
- `allow read, write: if isSignedIn();` على `requests` و `notifications` فقط.

