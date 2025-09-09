# Flutter Boilerplate - API Documentation and Integration

## API Overview

### Base Configuration
- **Base URL**: `https://api.example.com/v1/` (configurable per flavor)
- **Protocol**: HTTPS/TLS 1.3
- **Authentication**: Bearer Token (JWT)
- **Content Type**: `application/json`
- **API Version**: v1.0

### Authentication Flow
```dart
// HTTP client configuration
class ApiClient {
  static const String baseUrl = 'https://api.example.com/v1/';
  
  Map<String, String> get headers => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
    'X-API-Version': '1.0',
    'X-Client-Platform': Platform.isAndroid ? 'android' : 'ios',
    'X-Client-Version': packageInfo.version,
  };
}
```

## Core API Endpoints

### Authentication Endpoints

#### 1. User Registration
```http
POST /auth/register
Content-Type: application/json

{
  "email": "contractor@example.com",
  "password": "securePassword123",
  "userType": "contractor", // or "customer"
  "firstName": "John",
  "lastName": "Doe",
  "phoneNumber": "+1234567890"
}

Response:
{
  "success": true,
  "data": {
    "userId": "user_123456",
    "accessToken": "jwt_token_here",
    "refreshToken": "refresh_token_here",
    "expiresIn": 3600
  }
}
```

#### 2. User Login
```http
POST /auth/login
Content-Type: application/json

{
  "email": "contractor@example.com",
  "password": "securePassword123"
}

Response:
{
  "success": true,
  "data": {
    "userId": "user_123456",
    "accessToken": "jwt_token_here",
    "refreshToken": "refresh_token_here",
    "expiresIn": 3600,
    "userProfile": {
      "firstName": "John",
      "lastName": "Doe",
      "userType": "contractor",
      "profileComplete": true
    }
  }
}
```

#### 3. Token Refresh
```http
POST /auth/refresh
Content-Type: application/json

{
  "refreshToken": "refresh_token_here"
}

Response:
{
  "success": true,
  "data": {
    "accessToken": "new_jwt_token_here",
    "expiresIn": 3600
  }
}
```

### Contractor Profile Endpoints

#### 1. Get Contractor Profile
```http
GET /contractors/profile/{contractorId}
Authorization: Bearer <token>

Response:
{
  "success": true,
  "data": {
    "contractorId": "contractor_123",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "phoneNumber": "+1234567890",
    "profileImage": "https://cdn.obhai.com/profiles/contractor_123.jpg",
    "bio": "Experienced electrician with 10+ years...",
    "services": ["electrical", "lighting", "wiring"],
    "hourlyRate": 75.00,
    "availability": {
      "monday": {"start": "08:00", "end": "18:00"},
      "tuesday": {"start": "08:00", "end": "18:00"}
    },
    "rating": 4.8,
    "completedJobs": 156,
    "verified": true,
    "insuranceVerified": true
  }
}
```

#### 2. Update Contractor Profile
```http
PUT /contractors/profile
Authorization: Bearer <token>
Content-Type: application/json

{
  "firstName": "John",
  "lastName": "Doe",
  "bio": "Updated bio text...",
  "services": ["electrical", "lighting", "wiring", "panel_upgrade"],
  "hourlyRate": 80.00,
  "availability": {
    "monday": {"start": "08:00", "end": "18:00"}
  }
}

Response:
{
  "success": true,
  "message": "Profile updated successfully"
}
```

### Job Management Endpoints

#### 1. Get Available Jobs
```http
GET /jobs/available?page=1&limit=20&category=electrical&location=12345
Authorization: Bearer <token>

Response:
{
  "success": true,
  "data": {
    "jobs": [
      {
        "jobId": "job_789",
        "title": "Kitchen Electrical Outlet Installation",
        "description": "Need 3 new outlets installed in kitchen...",
        "category": "electrical",
        "budget": {
          "min": 200,
          "max": 400,
          "type": "fixed"
        },
        "location": {
          "address": "123 Main St, City, State",
          "latitude": 40.7128,
          "longitude": -74.0060,
          "zipCode": "12345"
        },
        "scheduledDate": "2024-01-15T10:00:00Z",
        "urgency": "normal",
        "customerId": "customer_456",
        "customerRating": 4.5,
        "postedDate": "2024-01-10T14:30:00Z",
        "bidCount": 3
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 5,
      "totalJobs": 98
    }
  }
}
```

#### 2. Submit Job Bid
```http
POST /jobs/{jobId}/bids
Authorization: Bearer <token>
Content-Type: application/json

{
  "bidAmount": 350.00,
  "estimatedDuration": 4,
  "message": "I can complete this job efficiently...",
  "availableDate": "2024-01-15T10:00:00Z"
}

Response:
{
  "success": true,
  "data": {
    "bidId": "bid_321",
    "status": "submitted",
    "submittedAt": "2024-01-10T15:45:00Z"
  }
}
```

#### 3. Accept Job
```http
POST /jobs/{jobId}/accept
Authorization: Bearer <token>

Response:
{
  "success": true,
  "data": {
    "jobId": "job_789",
    "status": "accepted",
    "acceptedAt": "2024-01-10T16:00:00Z",
    "customerContact": {
      "name": "Jane Smith",
      "phone": "+1987654321",
      "email": "jane@example.com"
    }
  }
}
```

#### 4. Update Job Status
```http
PUT /jobs/{jobId}/status
Authorization: Bearer <token>
Content-Type: application/json

{
  "status": "in_progress", // or "completed", "cancelled"
  "notes": "Started work on electrical outlets",
  "photos": [
    "https://cdn.obhai.com/job_photos/photo1.jpg",
    "https://cdn.obhai.com/job_photos/photo2.jpg"
  ]
}

Response:
{
  "success": true,
  "message": "Job status updated successfully"
}
```

### Payment and Earnings Endpoints

#### 1. Get Earnings Summary
```http
GET /contractors/earnings?period=month&year=2024&month=1
Authorization: Bearer <token>

Response:
{
  "success": true,
  "data": {
    "totalEarnings": 3250.00,
    "completedJobs": 12,
    "averageJobValue": 270.83,
    "platformFees": 487.50,
    "netEarnings": 2762.50,
    "pendingPayments": 450.00,
    "breakdown": [
      {
        "jobId": "job_789",
        "amount": 350.00,
        "platformFee": 52.50,
        "netAmount": 297.50,
        "paidDate": "2024-01-16T10:00:00Z"
      }
    ]
  }
}
```

#### 2. Request Payout
```http
POST /contractors/payout
Authorization: Bearer <token>
Content-Type: application/json

{
  "amount": 500.00,
  "paymentMethod": "bank_transfer",
  "accountId": "account_123"
}

Response:
{
  "success": true,
  "data": {
    "payoutId": "payout_456",
    "amount": 500.00,
    "status": "processing",
    "estimatedArrival": "2024-01-12T00:00:00Z"
  }
}
```

### Communication Endpoints

#### 1. Get Messages
```http
GET /messages?conversationId=conv_123&page=1&limit=50
Authorization: Bearer <token>

Response:
{
  "success": true,
  "data": {
    "messages": [
      {
        "messageId": "msg_789",
        "senderId": "user_456",
        "receiverId": "user_123",
        "content": "When can you start the electrical work?",
        "timestamp": "2024-01-10T14:30:00Z",
        "messageType": "text",
        "readStatus": true
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 2,
      "totalMessages": 15
    }
  }
}
```

#### 2. Send Message
```http
POST /messages
Authorization: Bearer <token>
Content-Type: application/json

{
  "receiverId": "user_456",
  "content": "I can start tomorrow morning at 9 AM",
  "messageType": "text",
  "jobId": "job_789"
}

Response:
{
  "success": true,
  "data": {
    "messageId": "msg_790",
    "timestamp": "2024-01-10T15:00:00Z",
    "status": "sent"
  }
}
```

## Firebase Integration

### Firebase Authentication
```kotlin
// Firebase Auth configuration
FirebaseAuth.getInstance().signInWithCustomToken(jwtToken)
  .addOnCompleteListener { task ->
    if (task.isSuccessful) {
      val user = task.result?.user
      // Handle successful authentication
    }
  }
```

### Firebase Cloud Messaging
```kotlin
// FCM token registration
FirebaseMessaging.getInstance().token
  .addOnCompleteListener { task ->
    val token = task.result
    // Send token to backend
    registerFCMToken(token)
  }
```

### Firestore Real-time Updates
```kotlin
// Listen to job status updates
FirebaseFirestore.getInstance()
  .collection("jobs")
  .document(jobId)
  .addSnapshotListener { snapshot, error ->
    if (error == null && snapshot != null) {
      val job = snapshot.toObject(Job::class.java)
      // Update UI with job changes
    }
  }
```

## Error Handling

### Standard Error Response Format
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input parameters",
    "details": {
      "field": "email",
      "reason": "Invalid email format"
    },
    "timestamp": "2024-01-10T15:30:00Z",
    "requestId": "req_123456"
  }
}
```

### Common Error Codes
- `AUTHENTICATION_FAILED`: Invalid credentials
- `TOKEN_EXPIRED`: JWT token has expired
- `VALIDATION_ERROR`: Input validation failed
- `RESOURCE_NOT_FOUND`: Requested resource doesn't exist
- `PERMISSION_DENIED`: Insufficient permissions
- `RATE_LIMIT_EXCEEDED`: Too many requests
- `SERVER_ERROR`: Internal server error

## Rate Limiting

### Rate Limit Headers
```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1609459200
```

### Rate Limits by Endpoint Type
- **Authentication**: 10 requests per minute
- **Profile Updates**: 5 requests per minute
- **Job Queries**: 100 requests per minute
- **Messaging**: 50 requests per minute
- **File Uploads**: 20 requests per minute

## File Upload Endpoints

### Upload Profile Image
```http
POST /upload/profile-image
Authorization: Bearer <token>
Content-Type: multipart/form-data

Form Data:
- image: [binary file data]
- userId: contractor_123

Response:
{
  "success": true,
  "data": {
    "imageUrl": "https://cdn.obhai.com/profiles/contractor_123.jpg",
    "thumbnailUrl": "https://cdn.obhai.com/profiles/thumbs/contractor_123.jpg"
  }
}
```

### Upload Job Photos
```http
POST /upload/job-photos
Authorization: Bearer <token>
Content-Type: multipart/form-data

Form Data:
- photos: [multiple binary files]
- jobId: job_789
- description: "Before and after photos"

Response:
{
  "success": true,
  "data": {
    "uploadedPhotos": [
      {
        "photoId": "photo_123",
        "url": "https://cdn.obhai.com/job_photos/photo_123.jpg",
        "thumbnailUrl": "https://cdn.obhai.com/job_photos/thumbs/photo_123.jpg"
      }
    ]
  }
}
```

## WebSocket Integration

### Real-time Notifications
```kotlin
// WebSocket connection for real-time updates
val webSocket = OkHttpClient().newWebSocket(
  Request.Builder()
    .url("wss://api.obhai.com/ws")
    .addHeader("Authorization", "Bearer $token")
    .build(),
  webSocketListener
)

// Message types
{
  "type": "job_update",
  "data": {
    "jobId": "job_789",
    "status": "accepted",
    "timestamp": "2024-01-10T16:00:00Z"
  }
}
```

## API Client Implementation

### Retrofit Configuration
```kotlin
@Module
@InstallIn(SingletonComponent::class)
object NetworkModule {
    
    @Provides
    @Singleton
    fun provideRetrofit(okHttpClient: OkHttpClient): Retrofit {
        return Retrofit.Builder()
            .baseUrl("https://api.obhai.com/v1/")
            .client(okHttpClient)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
    }
    
    @Provides
    @Singleton
    fun provideOkHttpClient(
        authInterceptor: AuthInterceptor,
        loggingInterceptor: HttpLoggingInterceptor
    ): OkHttpClient {
        return OkHttpClient.Builder()
            .addInterceptor(authInterceptor)
            .addInterceptor(loggingInterceptor)
            .connectTimeout(30, TimeUnit.SECONDS)
            .readTimeout(30, TimeUnit.SECONDS)
            .build()
    }
}
```

### API Service Interface
```kotlin
interface ObhaiApiService {
    
    @POST("auth/login")
    suspend fun login(@Body request: LoginRequest): Response<AuthResponse>
    
    @GET("contractors/profile/{id}")
    suspend fun getContractorProfile(@Path("id") contractorId: String): Response<ContractorProfile>
    
    @GET("jobs/available")
    suspend fun getAvailableJobs(
        @Query("page") page: Int,
        @Query("limit") limit: Int,
        @Query("category") category: String?,
        @Query("location") location: String?
    ): Response<JobsResponse>
    
    @POST("jobs/{jobId}/bids")
    suspend fun submitBid(
        @Path("jobId") jobId: String,
        @Body bid: BidRequest
    ): Response<BidResponse>
}
```
