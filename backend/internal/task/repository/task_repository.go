package repository

import (
	"task-tracker/internal/task/dto"
	"task-tracker/internal/task/model"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type TaskRepository interface {
	Create(task *model.Task) error
	FindAll(query dto.TaskQuery) ([]model.Task, int64, error)
	FindByID(id uuid.UUID) (*model.Task, error)
	Update(task *model.Task) error
	Delete(id uuid.UUID) error
	UpdateStatus(id uuid.UUID, status model.TaskStatus) error
}

type taskRepository struct {
	db *gorm.DB
}

func NewTaskRepository(db *gorm.DB) TaskRepository {
	return &taskRepository{db: db}
}

func (r *taskRepository) Create(task *model.Task) error {
	return r.db.Create(task).Error
}

func (r *taskRepository) FindAll(query dto.TaskQuery) ([]model.Task, int64, error) {
	var tasks []model.Task
	var total int64

	q := r.db.Model(&model.Task{})

	if query.Search != "" {
		search := "%" + query.Search + "%"
		q = q.Where("title ILIKE ? OR description ILIKE ?", search, search)
	}

	if query.Status != "" {
		q = q.Where("status = ?", query.Status)
	}

	if err := q.Count(&total).Error; err != nil {
		return nil, 0, err
	}

	offset := (query.Page - 1) * query.Limit
	if err := q.Order("created_at DESC").Offset(offset).Limit(query.Limit).Find(&tasks).Error; err != nil {
		return nil, 0, err
	}

	return tasks, total, nil
}

func (r *taskRepository) FindByID(id uuid.UUID) (*model.Task, error) {
	var task model.Task
	if err := r.db.Where("id = ?", id).First(&task).Error; err != nil {
		return nil, err
	}
	return &task, nil
}

func (r *taskRepository) Update(task *model.Task) error {
	return r.db.Save(task).Error
}

func (r *taskRepository) Delete(id uuid.UUID) error {
	return r.db.Where("id = ?", id).Delete(&model.Task{}).Error
}

func (r *taskRepository) UpdateStatus(id uuid.UUID, status model.TaskStatus) error {
	return r.db.Model(&model.Task{}).Where("id = ?", id).Update("status", status).Error
}
