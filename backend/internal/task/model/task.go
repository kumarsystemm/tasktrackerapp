package model

import (
	"time"

	"github.com/google/uuid"
)

type TaskStatus string

const (
	StatusPending TaskStatus = "pending"
	StatusDone    TaskStatus = "done"
)

type Task struct {
	ID          uuid.UUID  `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	Title       string     `gorm:"type:varchar(255);not null" json:"title"`
	Description string     `gorm:"type:text;not null" json:"description"`
	Status      TaskStatus `gorm:"type:varchar(20);not null;default:'pending';index:idx_tasks_status,priority:1" json:"status"`
	CreatedAt   time.Time  `gorm:"autoCreateTime;index:idx_tasks_status_created,priority:2" json:"created_at"`
	UpdatedAt   time.Time  `gorm:"autoUpdateTime" json:"updated_at"`
}
