# Task Tracker App

Aplikasi manajemen task sederhana dengan Flutter (Android) dan Go REST API backend.

## Tech Stack

### Frontend
- Flutter Stable
- Riverpod (State Management)
- Dio (HTTP Client)
- GoRouter (Navigation)
- Freezed + Json Serializable (Models)

### Backend
- Go 1.24+
- Gin (HTTP Framework)
- GORM (ORM)
- PostgreSQL
- Zap Logger

### Infrastructure
- Docker + Docker Compose
- Supabase PostgreSQL (managed database)

## Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Go 1.24+
- Docker & Docker Compose (optional)

### 1. Start Database & Backend

**Menggunakan Docker:**
```bash
docker-compose up -d
```

Backend berjalan di `http://localhost:8080`

**Manual (tanpa Docker):**
```bash
# Buat database PostgreSQL, lalu jalankan:
cd backend
go run ./cmd/main.go
```

### 2. Setup Flutter

```bash
cd flutter_app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

> Aplikasi menggunakan emulator address `10.0.2.2:8080` untuk koneksi ke backend. Pastikan menggunakan Android Emulator.

## Project Structure

```
task-tracker-app/
├── backend/
│   ├── cmd/main.go                     # Entry point
│   ├── config/config.go                # Environment config
│   ├── database/database.go            # DB connection
│   ├── internal/task/
│   │   ├── handler/task_handler.go     # HTTP handlers
│   │   ├── service/task_service.go     # Business logic
│   │   ├── repository/task_repository.go # Data access
│   │   ├── dto/task.go                 # Request/Response models
│   │   ├── model/task.go               # Domain model
│   │   └── routes/task_routes.go       # Route registration
│   ├── pkg/logger/logger.go            # Zap logger
│   └── Dockerfile
├── flutter_app/
│   └── lib/
│       ├── core/
│       │   ├── constants/              # API constants
│       │   ├── network/                # Dio client
│       │   └── theme/                  # App theme & dark mode
│       ├── features/task/
│       │   ├── data/                   # Models, repositories, remote source
│       │   ├── domain/                 # Repository interface
│       │   └── presentation/           # Pages, providers, widgets
│       ├── shared/widgets/             # Reusable widgets
│       └── main.dart
├── docs/01-PRD.md
└── docker-compose.yml
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tasks` | List tasks (supports search, status filter, pagination) |
| GET | `/api/tasks/:id` | Get task detail |
| POST | `/api/tasks` | Create task |
| PUT | `/api/tasks/:id` | Update task (title & description) |
| DELETE | `/api/tasks/:id` | Delete task |
| PATCH | `/api/tasks/:id/status` | Update task status |

### Query Parameters (GET /api/tasks)

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| search | string | - | Search by title/description |
| status | string | - | Filter: `pending` or `done` |
| page | int | 1 | Page number |
| limit | int | 10 | Items per page (max 100) |

### Example Request

```bash
# Get all tasks
curl http://localhost:8080/api/tasks

# Search tasks
curl "http://localhost:8080/api/tasks?search=jakarta&status=pending&page=1&limit=10"

# Create task
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Belajar Go", "description": "Selesaikan tutorial"}'

# Update status
curl -X PATCH http://localhost:8080/api/tasks/{id}/status \
  -H "Content-Type: application/json" \
  -d '{"status": "done"}'
```

### Response Format

**Success:**
```json
{
  "success": true,
  "message": "Success",
  "data": {}
}
```

**Error:**
```json
{
  "success": false,
  "message": "Validation Error",
  "errors": "..."
}
```

## Features

- Task CRUD (Create, Read, Update, Delete)
- Search with 300ms debounce
- Filter by status (All / Pending / Done)
- Server-side pagination (10 per page)
- Infinite scroll with loading indicator
- Pull to refresh
- Dark mode toggle with persistence
- Shimmer skeleton loader
- Empty state & error state handling
- Swipe-to-delete with confirmation dialog

## Configuration

### Backend Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| PORT | 8080 | Server port |
| DB_HOST | localhost | Database host |
| DB_PORT | 5432 | Database port |
| DB_USER | postgres | Database user |
| DB_PASSWORD | postgres | Database password |
| DB_NAME | task_tracker | Database name |
| DB_SSL_MODE | disable | SSL mode |

## License

MIT
