package config

import "github.com/idrm/template/consumer/internal/mq"

// Config Consumer服务配置
type Config struct {
	Name string
	Mode string
	Log  struct {
		ServiceName string
		Mode        string
		Level       string
	}
	Telemetry struct {
		Name     string
		Endpoint string
		Sampler  float64
		Batcher  string
	}
	MQ mq.Config
}
