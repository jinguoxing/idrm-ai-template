package svc

import "github.com/idrm/template/rpc/internal/config"

// ServiceContext RPC服务上下文
type ServiceContext struct {
	Config config.Config
	// 添加其他依赖，如 Model、Redis 等
}

// NewServiceContext 创建服务上下文
func NewServiceContext(c config.Config) *ServiceContext {
	return &ServiceContext{
		Config: c,
	}
}
