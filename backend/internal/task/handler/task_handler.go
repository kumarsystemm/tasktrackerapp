package handler

import (
	"errors"
	"net/http"
	"task-tracker/internal/task/dto"
	"task-tracker/internal/task/service"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"go.uber.org/zap"
)

type TaskHandler struct {
	service service.TaskService
	logger  *zap.Logger
}

func NewTaskHandler(service service.TaskService, logger *zap.Logger) *TaskHandler {
	return &TaskHandler{service: service, logger: logger}
}

func (h *TaskHandler) Create(c *gin.Context) {
	var req dto.CreateTaskRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "Validation Error",
			"errors":  err.Error(),
		})
		return
	}

	task, err := h.service.Create(c.Request.Context(), req)
	if err != nil {
		h.logger.Error("failed to create task", zap.Error(err))
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "Failed to create task",
		})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"success": true,
		"message": "Task created successfully",
		"data":    task,
	})
}

func (h *TaskHandler) GetAll(c *gin.Context) {
	var query dto.TaskQuery
	if err := c.ShouldBindQuery(&query); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "Invalid query parameters",
			"errors":  err.Error(),
		})
		return
	}

	result, err := h.service.GetAll(c.Request.Context(), query)
	if err != nil {
		h.logger.Error("failed to get tasks", zap.Error(err))
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "Failed to get tasks",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "Success",
		"data":    result,
	})
}

func (h *TaskHandler) GetByID(c *gin.Context) {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "Invalid task ID",
		})
		return
	}

	task, err := h.service.GetByID(c.Request.Context(), id)
	if err != nil {
		if errors.Is(err, service.ErrTaskNotFound) {
			c.JSON(http.StatusNotFound, gin.H{
				"success": false,
				"message": "Task not found",
			})
			return
		}
		h.logger.Error("failed to get task", zap.Error(err))
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "Failed to get task",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "Success",
		"data":    task,
	})
}

func (h *TaskHandler) Update(c *gin.Context) {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "Invalid task ID",
		})
		return
	}

	var req dto.UpdateTaskRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "Validation Error",
			"errors":  err.Error(),
		})
		return
	}

	task, err := h.service.Update(c.Request.Context(), id, req)
	if err != nil {
		if errors.Is(err, service.ErrTaskNotFound) {
			c.JSON(http.StatusNotFound, gin.H{
				"success": false,
				"message": "Task not found",
			})
			return
		}
		h.logger.Error("failed to update task", zap.Error(err))
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "Failed to update task",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "Task updated successfully",
		"data":    task,
	})
}

func (h *TaskHandler) Delete(c *gin.Context) {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "Invalid task ID",
		})
		return
	}

	if err := h.service.Delete(c.Request.Context(), id); err != nil {
		if errors.Is(err, service.ErrTaskNotFound) {
			c.JSON(http.StatusNotFound, gin.H{
				"success": false,
				"message": "Task not found",
			})
			return
		}
		h.logger.Error("failed to delete task", zap.Error(err))
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "Failed to delete task",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "Task deleted successfully",
		"data":    nil,
	})
}

func (h *TaskHandler) UpdateStatus(c *gin.Context) {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "Invalid task ID",
		})
		return
	}

	var req dto.UpdateStatusRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "Validation Error",
			"errors":  err.Error(),
		})
		return
	}

	task, err := h.service.UpdateStatus(c.Request.Context(), id, req)
	if err != nil {
		if errors.Is(err, service.ErrTaskNotFound) {
			c.JSON(http.StatusNotFound, gin.H{
				"success": false,
				"message": "Task not found",
			})
			return
		}
		h.logger.Error("failed to update task status", zap.Error(err))
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "Failed to update task status",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "Task status updated successfully",
		"data":    task,
	})
}
