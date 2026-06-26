package main

import (
	"context"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"task-tracker/config"
	"task-tracker/database"
	"task-tracker/internal/cache"
	"task-tracker/internal/middleware"
	"task-tracker/internal/task/handler"
	"task-tracker/internal/task/repository"
	"task-tracker/internal/task/routes"
	"task-tracker/internal/task/service"
	"task-tracker/pkg/logger"
	"time"

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

	taskCache := cache.NewTaskCache(5 * time.Minute)

	taskRepo := repository.NewTaskRepository(db)
	taskService := service.NewTaskService(taskRepo, taskCache)
	taskHandler := handler.NewTaskHandler(taskService, log)

	r := gin.Default()

	r.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok"})
	})

	api := r.Group("/api")
	api.Use(middleware.ApiKeyAuth(cfg.APIKey))
	routes.SetupTaskRoutes(api, taskHandler)

	srv := &http.Server{
		Addr:         ":" + cfg.Port,
		Handler:      r,
		ReadTimeout:  cfg.ReadTimeout,
		WriteTimeout: cfg.WriteTimeout,
		IdleTimeout:  cfg.IdleTimeout,
	}

	go func() {
		log.Info("server starting", zap.String("port", cfg.Port))
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatal("failed to start server", zap.Error(err))
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	log.Info("shutting down server...")

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	if err := srv.Shutdown(ctx); err != nil {
		log.Fatal("server forced to shutdown", zap.Error(err))
	}

	log.Info("server exited gracefully")
}
