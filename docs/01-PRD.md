# Task Tracker App

Version: 1.0
Status: Final
Author: Bangchan
Target Platform: Android (Flutter)
Backend: Go REST API
Database: Supabase PostgreSQL

---

# 1. Project Overview

## Background

Task Tracker App merupakan aplikasi sederhana untuk membantu pengguna mengelola daftar pekerjaan (task).

Aplikasi ini dibuat sebagai technical test untuk menunjukkan kemampuan dalam membangun aplikasi Flutter yang memiliki arsitektur yang baik, integrasi REST API, state management, dan implementasi backend yang bersih.

Fokus utama proyek adalah kualitas implementasi Flutter, sedangkan backend dibuat sederhana namun mengikuti praktik pengembangan yang baik.

---

# 2. Goals

Membangun aplikasi yang mampu:

* Menampilkan daftar task
* Menambahkan task baru
* Melihat detail task
* Mengubah status task
* Menangani loading, error, dan empty state
* Memiliki struktur project yang scalable
* Menggunakan REST API
* Menggunakan backend Go
* Menggunakan PostgreSQL pada Supabase

---

# 3. Tech Stack

## Frontend

* Flutter Stable
* Riverpod
* Dio
* Go Router
* Freezed
* Json Serializable
* Flutter Hooks (optional)

---

## Backend

* Go 1.24+
* Gin
* GORM
* PostgreSQL Driver
* Zap Logger
* Validator
* Air (Development)

---

## Database

Supabase PostgreSQL (Free Tier)

Supabase hanya digunakan sebagai managed PostgreSQL.

Seluruh business logic tetap berada pada backend Go.

---

# 4. User Story

## US-01

Sebagai user

Saya ingin melihat seluruh task

Agar mengetahui pekerjaan yang harus dilakukan.

---

## US-02

Sebagai user

Saya ingin membuat task baru

Agar pekerjaan dapat dicatat.

---

## US-03

Sebagai user

Saya ingin melihat detail task

Agar dapat membaca informasi lengkap.

---

## US-04

Sebagai user

Saya ingin mengubah status task

Agar mengetahui task yang sudah selesai.

---

# 5. Functional Requirements

## FR-01 Task List

Menampilkan seluruh task dari REST API.

Informasi yang ditampilkan:

* Title
* Short Description
* Status

---

## FR-02 Add Task

User dapat membuat task baru.

Field:

* Title (Required)
* Description (Required)

Validation:

* Tidak boleh kosong
* Trim whitespace
* Maksimal 255 karakter untuk title

---

## FR-03 Task Detail

Menampilkan:

* Title
* Description
* Status
* Created At

---

## FR-04 Update Status

User dapat mengubah status menjadi:

* Pending
* Done

---

## FR-05 Search Task

User dapat mencari task berdasarkan kata kunci.

* Search bar di halaman Task List
* Real-time search dengan debounce 300ms
* Mencari berdasarkan title dan description
* Clear button untuk menghapus search

---

## FR-06 Filter Task

User dapat memfilter task berdasarkan status.

* Filter chips: Semua, Pending, Done
* Default: Semua (tidak ada filter)
* Bisa dikombinasikan dengan search

---

## FR-07 Delete Task

User dapat menghapus task.

* Delete button di Task Detail page
* Swipe-to-delete di Task List
* Konfirmasi dialog sebelum delete
* Snackbar notifikasi setelah delete

---

## FR-08 Edit Task

User dapat mengedit title dan description task.

* Edit button di Task Detail page
* Form pre-fill dengan data existing
* Validasi sama seperti Add Task
* Kembali ke Task Detail setelah edit

---

## FR-09 Pagination

Task di-load per halaman.

* Server-side pagination
* Default 10 task per halaman
* Info "Menampilkan X dari Y task"

---

## FR-10 Infinite Scroll

Task di-load otomatis saat scroll.

* Otomatis load halaman berikutnya saat scroll mendekati akhir
* Loading indicator di bawah list
* Stop loading saat semua data sudah di-load

---

## FR-11 Dark Mode

User dapat menggunakan dark mode.

* Toggle di AppBar
* Persist pilihan dengan SharedPreferences
* Light theme dan dark theme

---

# 6. Non Functional Requirements

## Performance

* Response < 2 detik
* UI tetap responsif

---

## Maintainability

Project menggunakan separation layer:

* Presentation
* Data
* Domain

---

## Scalability

Penambahan fitur baru tidak mengubah struktur project utama.

---

## Reliability

Menampilkan:

* Loading State
* Empty State
* Error State

---

# 7. UI Pages

## Splash

Menampilkan logo aplikasi selama inisialisasi.

---

## Task List

Menampilkan:

* App Bar
* Search Bar
* Filter Chips
* List Task
* Floating Action Button
* Pull To Refresh
* Infinite Scroll
* Dark Mode Toggle

---

## Add Task

Komponen:

* TextField Title
* TextField Description
* Save Button

---

## Task Detail

Komponen:

* Title
* Description
* Status Badge
* Toggle Status Button
* Edit Button
* Delete Button

---

# 8. Navigation Flow

Splash

↓

Task List

├── Add Task

└── Task Detail

---

# 9. REST API

## GET

/api/tasks

Mengambil seluruh task.

Query Parameters:

* search (optional): Kata kunci pencarian
* status (optional): Filter status (pending/done)
* page (optional): Halaman (default: 1)
* limit (optional): Jumlah per halaman (default: 10)

---

## GET

/api/tasks/{id}

Mengambil detail task.

---

## POST

/api/tasks

Membuat task baru.

---

## PUT

/api/tasks/{id}

Mengupdate task (title & description).

---

## DELETE

/api/tasks/{id}

Menghapus task.

---

## PATCH

/api/tasks/{id}/status

Mengubah status task.

---

# 10. Data Model

## Task

| Field       | Type      |
| ----------- | --------- |
| id          | UUID      |
| title       | String    |
| description | Text      |
| status      | Enum      |
| created_at  | Timestamp |
| updated_at  | Timestamp |

---

Status

* pending
* done

---

# 11. Database Schema

tasks

* id UUID Primary Key
* title VARCHAR(255)
* description TEXT
* status VARCHAR(20)
* created_at TIMESTAMP
* updated_at TIMESTAMP

---

# 12. Validation Rules

## Title

* Required
* Max 255

---

## Description

* Required

---

## Status

* pending
* done

---

# 13. Error Handling

Frontend harus menangani:

Loading

API Error

Network Error

Timeout

No Internet

Empty Data

Validation Error

---

# 14. Loading State

Task List

Skeleton Loader

Add Task

Loading Button

Update Status

Progress Indicator

---

# 15. Empty State

Belum ada task.

Silakan tambahkan task pertama Anda.

---

# 16. API Response Standard

Success

```json
{
    "success": true,
    "message": "Success",
    "data": {}
}
```

Error

```json
{
    "success": false,
    "message": "Validation Error",
    "errors": {}
}
```

---

# 17. Architecture

## Flutter

Presentation

↓

Controller

↓

Repository

↓

Remote Data Source

↓

Dio

↓

Go REST API

---

## Backend

HTTP Request

↓

Handler

↓

Service

↓

Repository

↓

Database

---

# 18. Folder Structure

## Flutter

```
lib/

core/

shared/

features/

    task/

        data/

        domain/

        presentation/

main.dart
```

---

## Backend

```
cmd/

internal/

    task/

        handler/

        service/

        repository/

        dto/

        model/

        routes/

pkg/

config/

database/

```

---

# 19. Bonus Features

* Local Cache
* Offline Read
* Docker
* Unit Test
* Widget Test
* Reusable Widget
* Logger
* Environment Configuration

---

# 20. Implemented Features (v1.1)

## Search Task
- Real-time search dengan debounce 300ms
- Mencari berdasarkan title dan description
- Clear button untuk menghapus search

## Filter Task
- Filter berdasarkan status: Semua, Pending, Done
- Bisa dikombinasikan dengan search

## Delete Task
- Delete dengan konfirmasi dialog
- Swipe-to-delete di task list
- Snackbar notifikasi

## Edit Task
- Edit title dan description
- Pre-fill form dengan data existing
- Validasi sama seperti add task

## Pagination
- Server-side pagination
- Default 10 task per halaman
- Info "Menampilkan X dari Y task"

## Infinite Scroll
- Otomatis load halaman berikutnya saat scroll
- Loading indicator di bawah list
- Pull to refresh

## Dark Mode
- Toggle tema terang/gelap
- Persist pilihan dengan SharedPreferences
- Ikuti sistem theme

---

# 21. Future Improvements

* Authentication
* Push Notification
* Multi User
* Attachments

---

# 21. Acceptance Criteria

✅ User dapat melihat daftar task

✅ User dapat membuat task

✅ User dapat melihat detail task

✅ User dapat mengubah status

✅ User dapat mencari task

✅ User dapat memfilter task berdasarkan status

✅ User dapat menghapus task

✅ User dapat mengedit task

✅ Task di-load dengan pagination

✅ Task di-load dengan infinite scroll

✅ User dapat menggunakan dark mode

✅ Seluruh data berasal dari REST API

✅ Loading ditampilkan

✅ Error ditampilkan

✅ Empty State tersedia

✅ Struktur project rapi

✅ State Management menggunakan Riverpod

✅ Networking menggunakan Dio

✅ Backend menggunakan Go Gin

✅ Database menggunakan Supabase PostgreSQL

---

# 22. Deliverables

Flutter Source Code

Go Backend Source Code

README.md

Dockerfile

docker-compose.yml

API Documentation

Database Schema

Screen Recording

GitHub Repository
