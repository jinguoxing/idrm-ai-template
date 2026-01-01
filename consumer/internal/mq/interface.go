package mq

import (
	"context"
	"fmt"
)

// Message 统一消息结构
type Message struct {
	Key     string            // 消息键
	Value   []byte            // 消息体
	Headers map[string]string // 消息头
	Topic   string            // 主题
	Offset  int64             // 偏移量（如适用）
}

// Handler 消息处理函数
type Handler func(ctx context.Context, msg *Message) error

// Consumer 消息消费者接口
// 抽象层，支持多种消息中间件
type Consumer interface {
	// Subscribe 订阅主题
	Subscribe(ctx context.Context, handler Handler) error
	// Start 启动消费
	Start() error
	// Stop 停止消费
	Stop() error
	// Close 关闭连接
	Close() error
}

// Config 消息队列配置
type Config struct {
	Type     string         // 类型：kafka, tonglink, redis
	Kafka    KafkaConfig    // Kafka 配置
	TongLink TongLinkConfig // TongLINK 配置
}

// KafkaConfig Kafka配置
type KafkaConfig struct {
	Brokers []string
	Topic   string
	Group   string
}

// TongLinkConfig TongLINK/Q-CN配置
type TongLinkConfig struct {
	Host  string
	Port  int
	Queue string
}

// NewConsumer 工厂函数，根据配置创建不同实现
func NewConsumer(cfg Config) (Consumer, error) {
	switch cfg.Type {
	case "kafka":
		return NewKafkaConsumer(cfg.Kafka)
	case "tonglink":
		return NewTongLinkConsumer(cfg.TongLink)
	default:
		return nil, fmt.Errorf("unsupported mq type: %s", cfg.Type)
	}
}
