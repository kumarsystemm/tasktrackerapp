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
* List Task
* Floating Action Button
* Pull To Refresh

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

---

## GET

/api/tasks/{id}

Mengambil detail task.

---

## POST

/api/tasks

Membuat task baru.

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

# 20. Future Improvements

* Authentication
* Search Task
* Filter Task
* Delete Task
* Edit Task
* Pagination
* Infinite Scroll
* Push Notification
* Dark Mode
* Multi User
* Attachments

---

# 21. Acceptance Criteria

✅ User dapat melihat daftar task

✅ User dapat membuat task

✅ User dapat melihat detail task

✅ User dapat mengubah status

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
