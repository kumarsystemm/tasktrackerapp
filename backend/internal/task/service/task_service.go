package service

import (
	"context"
	"errors"
	"math"
	"task-tracker/internal/cache"
	"task-tracker/internal/task/dto"
	"task-tracker/internal/task/model"
	"task-tracker/internal/task/repository"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

var ErrTaskNotFound = errors.New("task not found")

type TaskService interface {
	Create(ctx context.Context, req dto.CreateTaskRequest) (*model.Task, error)
	GetAll(ctx context.Context, query dto.TaskQuery) (*dto.PaginatedTasksResponse, error)
	GetByID(ctx context.Context, id uuid.UUID) (*model.Task, error)
	Update(ctx context.Context, id uuid.UUID, req dto.UpdateTaskRequest) (*model.Task, error)
	Delete(ctx context.Context, id uuid.UUID) error
	UpdateStatus(ctx context.Context, id uuid.UUID, req dto.UpdateStatusRequest) (*model.Task, error)
}

type taskService struct {
	repo  repository.TaskRepository
	cache *cache.TaskCache
}

func NewTaskService(repo repository.TaskRepository, taskCache *cache.TaskCache) TaskService {
	return &taskService{repo: repo, cache: taskCache}
}

func (s *taskService) Create(ctx context.Context, req dto.CreateTaskRequest) (*model.Task, error) {
	task := &model.Task{
		Title:       req.Title,
		Description: req.Description,
		Status:      model.StatusPending,
	}

	if err := s.repo.Create(ctx, task); err != nil {
		return nil, err
	}

	return task, nil
}

func (s *taskService) GetAll(ctx context.Context, query dto.TaskQuery) (*dto.PaginatedTasksResponse, error) {
	tasks, total, err := s.repo.FindAll(ctx, query)
	if err != nil {
		return nil, err
	}

	totalPages := int(math.Ceil(float64(total) / float64(query.Limit)))

	return &dto.PaginatedTasksResponse{
		Tasks: tasks,
		Pagination: dto.PaginationMeta{
			Page:       query.Page,
			Limit:      query.Limit,
			Total:      total,
			TotalPages: totalPages,
		},
	}, nil
}

func (s *taskService) GetByID(ctx context.Context, id uuid.UUID) (*model.Task, error) {
	cacheKey := "task:" + id.String()
	if cached, found := s.cache.Get(cacheKey); found {
		return cached.(*model.Task), nil
	}

	task, err := s.repo.FindByID(ctx, id)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrTaskNotFound
		}
		return nil, err
	}

	s.cache.Set(cacheKey, task)
	return task, nil
}

func (s *taskService) Update(ctx context.Context, id uuid.UUID, req dto.UpdateTaskRequest) (*model.Task, error) {
	task, err := s.repo.FindByID(ctx, id)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrTaskNotFound
		}
		return nil, err
	}

	task.Title = req.Title
	task.Description = req.Description

	if err := s.repo.Update(ctx, task); err != nil {
		return nil, err
	}

	s.cache.InvalidateTask(id)
	return task, nil
}

func (s *taskService) Delete(ctx context.Context, id uuid.UUID) error {
	result := s.repo.Delete(ctx, id)
	if result == 0 {
		return ErrTaskNotFound
	}

	s.cache.InvalidateTask(id)
	return nil
}

func (s *taskService) UpdateStatus(ctx context.Context, id uuid.UUID, req dto.UpdateStatusRequest) (*model.Task, error) {
	rowsAffected := s.repo.UpdateStatus(ctx, id, model.TaskStatus(req.Status))
	if rowsAffected == 0 {
		return nil, ErrTaskNotFound
	}

	s.cache.InvalidateTask(id)

	return s.repo.FindByID(ctx, id)
}
