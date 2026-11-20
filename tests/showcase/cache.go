package cache

import (
	"sync"
	"time"
)

// Cache is a tiny TTL map safe for concurrent use.
type Cache struct {
	mu    sync.RWMutex
	items map[string]entry
	ttl   time.Duration
}

func (c *Cache) Get(key string) (string, bool) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	e, ok := c.items[key]
	if !ok || time.Since(e.at) > c.ttl {
		return "", false
	}
	return string(e.val), true
}
