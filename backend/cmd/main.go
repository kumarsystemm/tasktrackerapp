package main

import (
	"task-tracker/config"
	"task-tracker/database"
	"task-tracker/internal/task/handler"
	"task-tracker/internal/task/repository"
	"task-tracker/internal/task/routes"
	"task-tracker/internal/task/service"
	"task-tracker/pkg/logger"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

func main() {
	cfg := config.Load()
	log := logger.New()

	db, err := database.Connect(cfg, log)
	if err != nil {
		log.Fatal("failed to connect database", zap.Error(err))
	}

	taskRepo := repository.NewTaskRepository(db)
	taskService := service.NewTaskService(taskRepo)
	taskHandler := handler.NewTaskHandler(taskService, log)

	r := gin.Default()

	r.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok"})
	})

	api := r.Group("/api")
	routes.SetupTaskRoutes(api, taskHandler)

	log.Info("server starting", zap.String("port", cfg.Port))
	if err := r.Run(":" + cfg.Port); err != nil {
		log.Fatal("failed to start server", zap.Error(err))
	}
}
