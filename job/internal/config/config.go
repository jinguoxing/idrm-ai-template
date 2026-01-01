package config

// Config Job服务配置
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
	Job JobConfig
}

// JobConfig 任务配置
type JobConfig struct {
	Name    string
	Timeout int
}
