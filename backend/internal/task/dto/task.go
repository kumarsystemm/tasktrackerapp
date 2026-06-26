package dto

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
	Tasks      interface{}    `json:"tasks"`
	Pagination PaginationMeta `json:"pagination"`
}
