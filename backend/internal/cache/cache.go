package cache

import (
	"fmt"
	"sync"
	"time"

	"github.com/google/uuid"
)

type TaskCache struct {
	items map[string]*cacheItem
	mu    sync.RWMutex
	ttl   time.Duration
}

type cacheItem struct {
	value     interface{}
	expiresAt time.Time
}

func NewTaskCache(ttl time.Duration) *TaskCache {
	c := &TaskCache{
		items: make(map[string]*cacheItem),
		ttl:   ttl,
	}
	go c.cleanup()
	return c
}

func (c *TaskCache) Get(key string) (interface{}, bool) {
	c.mu.RLock()
	defer c.mu.RUnlock()

	item, found := c.items[key]
	if !found || time.Now().After(item.expiresAt) {
		return nil, false
	}
	return item.value, true
}

func (c *TaskCache) Set(key string, value interface{}) {
	c.mu.Lock()
	defer c.mu.Unlock()

	c.items[key] = &cacheItem{
		value:     value,
		expiresAt: time.Now().Add(c.ttl),
	}
}

func (c *TaskCache) Delete(key string) {
	c.mu.Lock()
	defer c.mu.Unlock()

	delete(c.items, key)
}

func (c *TaskCache) InvalidateTask(id uuid.UUID) {
	c.Delete(fmt.Sprintf("task:%s", id))
}

func (c *TaskCache) cleanup() {
	ticker := time.NewTicker(time.Minute)
	defer ticker.Stop()

	for range ticker.C {
		c.mu.Lock()
		now := time.Now()
		for key, item := range c.items {
			if now.After(item.expiresAt) {
				delete(c.items, key)
			}
		}
		c.mu.Unlock()
	}
}
