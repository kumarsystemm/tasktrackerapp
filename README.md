# Task Tracker App

Aplikasi manajemen task dengan Flutter (Android) dan Go REST API backend. Menggunakan Clean Architecture di kedua sisi (frontend & backend), Supabase PostgreSQL sebagai managed database, dan offline-first strategy untuk UX yang tetap smooth tanpa koneksi internet.

## Tech Stack

### Frontend
- **Flutter** Stable
- **Riverpod** — State Management (compile-safe, no BuildContext dependency)
- **Dio** — HTTP Client
- **GoRouter** — Declarative navigation
- **sqflite** — Local database untuk offline cache & sync queue
- **connectivity_plus** — Network monitoring

### Backend
- **Go** 1.24+
- **Gin** — HTTP framework (performa tinggi, ringan)
- **GORM** — ORM untuk PostgreSQL
- **Zap** — Structured logger
- **Swaggo** — Swagger UI auto-generated

### Database
- **Supabase PostgreSQL** — Managed PostgreSQL (free tier)
- Backend mengakses langsung via connection pooler (port 5432)

---

## Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Go 1.24+
- Akun Supabase (untuk PostgreSQL)
- Android Emulator atau BlueStacks

### 1. Database (Supabase)

1. Buat project baru di [supabase.com](https://supabase.com)
2. Buka **Project Settings → Database**
3. Catat connection info:
   - Host: `aws-1-<region>.pooler.supabase.com`
   - Port: `5432`
   - User: `postgres.<project-ref>`
   - Password: (yang dibuat saat create project)
4. Tabel `tasks` akan dibuat otomatis oleh AutoMigrate saat backend pertama kali dijalankan

### 2. Backend

```bash
cd backend

# Update .env dengan credentials Supabase kamu:
# PORT=8081
# DB_HOST=aws-1-ap-northeast-2.pooler.supabase.com
# DB_PORT=5432
# DB_USER=postgres.<project-ref>
# DB_PASSWORD=<password>
# DB_NAME=postgres
# DB_SSL_MODE=require

go run ./cmd/main.go
```

Backend berjalan di `http://localhost:8081`

Swagger UI tersedia di `http://localhost:8081/swagger/index.html`

### 3. Flutter

```bash
cd flutter_app

# Update .env (untuk Android emulator):
# BASE_URL=http://10.0.2.2:8081/api

flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

> Untuk **Android Emulator** atau **BlueStacks**, gunakan `10.0.2.2:8081` sebagai backend address. `10.0.2.2` adalah gateway dari emulator ke host machine.

### 4. Build APK

```bash
cd flutter_app
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## Architecture

Proyek ini menggunakan **Clean Architecture** di kedua sisi — backend Go dan frontend Flutter. Pendekatan ini memisahkan concerns menjadi layer yang terdefinisi dengan jelas, sehingga setiap layer hanya bergantung pada layer di bawahnya.

### Backend Architecture

```
HTTP Request
    │
    ▼
┌─────────────────────────────────────┐
│  Handler (task_handler.go)          │  ← Parse request, validate input
│  Validasi input, format response    │     Kirim response JSON
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Service (task_service.go)          │  ← Business logic
│  Orchestrate repo + cache           │     Encode decode
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Repository (task_repository.go)    │  ← Data access
│  Interface di domain, impl di data  │     Query database
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Database (Supabase PostgreSQL)     │  ← Persistent storage
│  GORM AutoMigrate, connection pool  │     Index untuk performa
└─────────────────────────────────────┘
```

**Layer peran:**
- **Handler**: Hanya urusan HTTP — parse request, panggil service, format response. Tidak ada business logic.
- **Service**: Business logic — orchestrate repository, validasi bisnis, in-memory cache.
- **Repository**: Data access — query database via GORM. Interface didefinisikan di domain layer.
- **Model**: Domain entity — tidak bergantung pada framework atau ORM.

### Flutter Architecture

```
┌─────────────────────────────────────┐
│  UI (Pages & Widgets)               │  ← Render state, handle user input
│  ConsumerWidget, ref.watch()        │     Panggil provider
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Presentation (Providers)           │  ← State management
│  StateNotifierProvider, FutureProv. │     Atur loading/error/data state
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  UseCase (domain/usecases/)         │  ← Single responsibility
│  GetTasks, CreateTask, DeleteTask   │     Satu use case = satu aksi
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Repository (data/repositories/)    │  ← Coordinate remote + local
│  Online → API, Offline → SQLite +   │     Sync queue
│  sync_queue                         │
└──────────────┬──────────────────────┘
               │
       ┌───────┴───────┐
       ▼               ▼
┌──────────────┐ ┌──────────────┐
│ RemoteSource │ │ LocalCache   │
│ (Dio API)    │ │ (SQLite)     │
└──────────────┘ └──────────────┘
```

**Layer peran:**
- **UI**: Hanya render state dari provider. Tidak ada business logic di widget.
- **Provider/Notifier**: Kelola state (loading, data, error). Panggil use case.
- **UseCase**: Single responsibility — satu use case = satu aksi bisnis. Panggil repository.
- **Repository**: Koordinasi remote API dan local cache. Handle online/offline logic.
- **Mapper**: Konversi antara data models (API response) dan domain entities.

---

## State Management (Riverpod)

### Provider Types yang Digunakan

| Provider | Fungsi | Contoh |
|----------|--------|--------|
| `Provider` | Dependency injection untuk service/repository | `taskRepositoryProvider`, `taskRemoteSourceProvider` |
| `StateProvider` | Simple state (primitive value) | `searchQueryProvider`, `statusFilterProvider` |
| `StateNotifierProvider` | Complex state dengan logic | `taskListProvider` (kelola list + pagination) |
| `StreamProvider` | Real-time data stream | `connectivityStreamProvider` |
| `FutureProvider` | Async single read | `taskDetailProvider` |

---

## Project Structure

```
task-tracker-app/
├── backend/
│   ├── cmd/main.go                        # Entry point + Swagger annotations
│   ├── config/config.go                   # Environment config (.env)
│   ├── database/database.go              # PostgreSQL + GORM + AutoMigrate
│   ├── docs/                              # Auto-generated Swagger (swag init)
│   ├── internal/
│   │   ├── cache/cache.go                # In-memory task cache (5-min TTL)
│   │   ├── middleware/apikey.go          # X-API-Key auth middleware
│   │   └── task/
│   │       ├── dto/task.go               # Request/response DTOs
│   │       ├── model/task.go             # Domain model (Task)
│   │       ├── handler/task_handler.go   # HTTP handlers
│   │       ├── service/task_service.go   # Business logic
│   │       ├── repository/task_repository.go # Data access (GORM)
│   │       └── routes/task_routes.go     # Route registration
│   ├── pkg/logger/logger.go             # Zap structured logger
│   └── go.mod
├── flutter_app/
│   └── lib/
│       ├── api/                           # Generated API client (from OpenAPI)
│       ├── core/
│       │   ├── constants/                 # API constants
│       │   ├── database/app_database.dart # SQLite (tasks + sync_queue)
│       │   ├── errors/                    # Failure types + Result pattern
│       │   ├── network/                   # Dio client + connectivity service
│       │   ├── sync/sync_service.dart     # Offline sync queue processor
│       │   └── theme/                     # App theme + dark mode
│       ├── features/task/
│       │   ├── data/
│       │   │   ├── sources/              # Remote data source (Dio)
│       │   │   ├── repositories/         # Repository impl (online/offline)
│       │   │   └── mappers/              # API model ↔ domain entity
│       │   ├── domain/
│       │   │   ├── entities/             # TaskEntity, TaskStatus
│       │   │   ├── repositories/         # Abstract repository interface
│       │   │   └── usecases/             # GetTasks, CreateTask, etc.
│       │   └── presentation/
│       │       ├── pages/                # TaskList, TaskDetail, AddTask, EditTask
│       │       ├── providers/            # StateNotifier, use case providers
│       │       └── widgets/              # SearchFilterBar, etc.
│       ├── shared/widgets/               # LoadingWidget, TaskCard, OfflineBanner
│       └── main.dart                     # App entry + connectivity listener
├── docs/
│   ├── 01-PRD.md                         # Product Requirements Document
│   ├── openapi.yaml                      # OpenAPI 3.0 spec
│   └── saran.md                          # Architecture best practices
└── README.md
```

---

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tasks` | List tasks (search, filter, pagination) |
| GET | `/api/tasks/:id` | Get task detail |
| POST | `/api/tasks` | Create task |
| PUT | `/api/tasks/:id` | Update task (title & description) |
| DELETE | `/api/tasks/:id` | Delete task |
| PATCH | `/api/tasks/:id/status` | Update task status |

**Swagger UI**: `http://localhost:8081/swagger/index.html`

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
curl http://localhost:8081/api/tasks

# Search tasks
curl "http://localhost:8081/api/tasks?search=jakarta&status=pending&page=1&limit=10"

# Create task
curl -X POST http://localhost:8081/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Belajar Go", "description": "Selesaikan tutorial"}'

# Update status
curl -X PATCH http://localhost:8081/api/tasks/{id}/status \
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

---

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
- **Offline CRUD** — operasi write tetap jalan tanpa koneksi
- **Auto-sync** — perubahan tersinkron otomatis saat kembali online
- **Offline banner** — indikator real-time saat offline + pending sync
- **Swagger UI** — dokumentasi API interaktif

---

## Configuration

### Backend Environment Variables (`backend/.env`)

| Variable | Default | Description |
|----------|---------|-------------|
| PORT | 8081 | Server port |
| API_KEY | - | API key untuk X-API-Key header |
| DB_HOST | - | Supabase pooler host |
| DB_PORT | 5432 | Database port |
| DB_USER | - | `postgres.<project-ref>` |
| DB_PASSWORD | - | Database password |
| DB_NAME | postgres | Database name |
| DB_SSL_MODE | require | SSL mode (required for Supabase) |

### Flutter Environment (`flutter_app/.env`)

| Variable | Default | Description |
|----------|---------|-------------|
| BASE_URL | `http://10.0.2.2:8081/api` | Backend URL (emulator address) |
| TIMEOUT | 30 | HTTP timeout in seconds |
| API_KEY | - | Same as backend API_KEY |

---

## License

MIT
