package routes

import (
	"task-tracker/internal/task/handler"

	"github.com/gin-gonic/gin"
)

func SetupTaskRoutes(rg *gin.RouterGroup, h *handler.TaskHandler) {
	tasks := rg.Group("/tasks")
	{
		tasks.POST("", h.Create)
		tasks.GET("", h.GetAll)
		tasks.GET("/:id", h.GetByID)
		tasks.PUT("/:id", h.Update)
		tasks.DELETE("/:id", h.Delete)
		tasks.PATCH("/:id/status", h.UpdateStatus)
	}
}
