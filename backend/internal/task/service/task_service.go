package service

import (
	"errors"
	"math"
	"task-tracker/internal/task/dto"
	"task-tracker/internal/task/model"
	"task-tracker/internal/task/repository"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

var ErrTaskNotFound = errors.New("task not found")

type TaskService interface {
	Create(req dto.CreateTaskRequest) (*model.Task, error)
	GetAll(query dto.TaskQuery) (*dto.PaginatedTasksResponse, error)
	GetByID(id uuid.UUID) (*model.Task, error)
	Update(id uuid.UUID, req dto.UpdateTaskRequest) (*model.Task, error)
	Delete(id uuid.UUID) error
	UpdateStatus(id uuid.UUID, req dto.UpdateStatusRequest) (*model.Task, error)
}

type taskService struct {
	repo repository.TaskRepository
}

func NewTaskService(repo repository.TaskRepository) TaskService {
	return &taskService{repo: repo}
}

func (s *taskService) Create(req dto.CreateTaskRequest) (*model.Task, error) {
	task := &model.Task{
		Title:       req.Title,
		Description: req.Description,
		Status:      model.StatusPending,
	}

	if err := s.repo.Create(task); err != nil {
		return nil, err
	}

	return task, nil
}

func (s *taskService) GetAll(query dto.TaskQuery) (*dto.PaginatedTasksResponse, error) {
	tasks, total, err := s.repo.FindAll(query)
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

func (s *taskService) GetByID(id uuid.UUID) (*model.Task, error) {
	task, err := s.repo.FindByID(id)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrTaskNotFound
		}
		return nil, err
	}
	return task, nil
}

func (s *taskService) Update(id uuid.UUID, req dto.UpdateTaskRequest) (*model.Task, error) {
	task, err := s.repo.FindByID(id)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrTaskNotFound
		}
		return nil, err
	}

	task.Title = req.Title
	task.Description = req.Description

	if err := s.repo.Update(task); err != nil {
		return nil, err
	}

	return task, nil
}

func (s *taskService) Delete(id uuid.UUID) error {
	_, err := s.repo.FindByID(id)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return ErrTaskNotFound
		}
		return err
	}

	return s.repo.Delete(id)
}

func (s *taskService) UpdateStatus(id uuid.UUID, req dto.UpdateStatusRequest) (*model.Task, error) {
	task, err := s.repo.FindByID(id)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrTaskNotFound
		}
		return nil, err
	}

	if err := s.repo.UpdateStatus(id, model.TaskStatus(req.Status)); err != nil {
		return nil, err
	}

	task.Status = model.TaskStatus(req.Status)
	return task, nil
}
