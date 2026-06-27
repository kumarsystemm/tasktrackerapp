package dto

import "task-tracker/internal/task/model"

type CreateTaskRequest struct {
	Title       string `json:"title" binding:"required,max=255"`
	Description string `json:"description" binding:"required"`
}

type UpdateTaskRequest struct {
	Title       string `json:"title" binding:"required,max=255"`
	Description string `json:"description" binding:"required"`
}

type UpdateStatusRequest struct {
	Status string `json:"status" binding:"required,oneof=pending done"`
}

type TaskQuery struct {
	Search string `form:"search"`
	Status string `form:"status" binding:"omitempty,oneof=pending done"`
	Page   int    `form:"page,default=1" binding:"min=1"`
	Limit  int    `form:"limit,default=10" binding:"min=1,max=100"`
}

type PaginationMeta struct {
	Page       int   `json:"page"`
	Limit      int   `json:"limit"`
	Total      int64 `json:"total"`
	TotalPages int   `json:"total_pages"`
}

type PaginatedTasksResponse struct {
	Tasks      []model.Task  `json:"tasks"`
	Pagination PaginationMeta `json:"pagination"`
}

// Swagger response wrappers

type TaskResponse struct {
	Success bool        `json:"success"`
	Message string      `json:"message"`
	Data    model.Task  `json:"data"`
}

type TaskListResponse struct {
	Success bool                  `json:"success"`
	Message string                `json:"message"`
	Data    PaginatedTasksResponse `json:"data"`
}

type ErrorResponse struct {
	Success bool   `json:"success"`
	Message string `json:"message"`
	Errors  string `json:"errors,omitempty"`
}

type DeleteResponse struct {
	Success bool   `json:"success"`
	Message string `json:"message"`
}
