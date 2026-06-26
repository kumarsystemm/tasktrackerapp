package database

import (
	"fmt"
	"task-tracker/config"
	"task-tracker/internal/task/model"

	"go.uber.org/zap"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func Connect(cfg *config.Config, logger *zap.Logger) (*gorm.DB, error) {
	dsn := fmt.Sprintf(
		"host=%s user=%s password=%s dbname=%s port=%s sslmode=%s",
		cfg.DBHost, cfg.DBUser, cfg.DBPassword, cfg.DBName, cfg.DBPort, cfg.DBSSLMode,
	)

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		return nil, fmt.Errorf("failed to connect database: %w", err)
	}

	if err := db.AutoMigrate(&model.Task{}); err != nil {
		return nil, fmt.Errorf("failed to migrate database: %w", err)
	}

	logger.Info("database connected successfully")
	return db, nil
}
