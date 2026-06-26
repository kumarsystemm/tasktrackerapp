package middleware

import (
	"crypto/subtle"
	"net/http"

	"github.com/gin-gonic/gin"
)

func ApiKeyAuth(validKey string) gin.HandlerFunc {
	return func(c *gin.Context) {
		if validKey == "" {
			c.Next()
			return
		}

		key := c.GetHeader("X-API-Key")
		if key == "" {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
				"success": false,
				"message": "Unauthorized: missing API key",
			})
			return
		}

		if subtle.ConstantTimeCompare([]byte(key), []byte(validKey)) != 1 {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
				"success": false,
				"message": "Unauthorized: invalid API key",
			})
			return
		}

		c.Next()
	}
}
