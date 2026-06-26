package repository

import (
	"context"
	"task-tracker/internal/task/dto"
	"task-tracker/internal/task/model"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type TaskRepository interface {
	Create(ctx context.Context, task *model.Task) error
	FindAll(ctx context.Context, query dto.TaskQuery) ([]model.Task, int64, error)
	FindByID(ctx context.Context, id uuid.UUID) (*model.Task, error)
	Update(ctx context.Context, task *model.Task) error
	Delete(ctx context.Context, id uuid.UUID) int64
	UpdateStatus(ctx context.Context, id uuid.UUID, status model.TaskStatus) int64
}

type taskRepository struct {
	db *gorm.DB
}

func NewTaskRepository(db *gorm.DB) TaskRepository {
	return &taskRepository{db: db}
}

func (r *taskRepository) Create(ctx context.Context, task *model.Task) error {
	return r.db.WithContext(ctx).Create(task).Error
}

func (r *taskRepository) FindAll(ctx context.Context, query dto.TaskQuery) ([]model.Task, int64, error) {
	var tasks []model.Task
	var total int64

	q := r.db.WithContext(ctx).Model(&model.Task{})

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

func (r *taskRepository) FindByID(ctx context.Context, id uuid.UUID) (*model.Task, error) {
	var task model.Task
	if err := r.db.WithContext(ctx).Where("id = ?", id).First(&task).Error; err != nil {
		return nil, err
	}
	return &task, nil
}

func (r *taskRepository) Update(ctx context.Context, task *model.Task) error {
	return r.db.WithContext(ctx).Save(task).Error
}

func (r *taskRepository) Delete(ctx context.Context, id uuid.UUID) int64 {
	result := r.db.WithContext(ctx).Where("id = ?", id).Delete(&model.Task{})
	return result.RowsAffected
}

func (r *taskRepository) UpdateStatus(ctx context.Context, id uuid.UUID, status model.TaskStatus) int64 {
	result := r.db.WithContext(ctx).Model(&model.Task{}).Where("id = ?", id).Update("status", status)
	return result.RowsAffected
}
