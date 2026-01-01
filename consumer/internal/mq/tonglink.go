package mq

import (
	"context"

	"github.com/zeromicro/go-zero/core/logx"
)

// TongLinkConsumer TongLINK/Q-CN消费者实现
// TongLINK/Q-CN 是国产消息中间件
type TongLinkConsumer struct {
	config  TongLinkConfig
	handler Handler
}

// NewTongLinkConsumer 创建TongLINK消费者
func NewTongLinkConsumer(cfg TongLinkConfig) (*TongLinkConsumer, error) {
	return &TongLinkConsumer{
		config: cfg,
	}, nil
}

// Subscribe 订阅队列
func (c *TongLinkConsumer) Subscribe(ctx context.Context, handler Handler) error {
	c.handler = handler
	return nil
}

// Start 启动消费
func (c *TongLinkConsumer) Start() error {
	logx.Infof("Starting TongLINK consumer, host: %s:%d, queue: %s",
		c.config.Host, c.config.Port, c.config.Queue)

	// TODO: 实现 TongLINK/Q-CN 的消费逻辑
	// 需要根据 TongLINK SDK 实现

	return nil
}

// Stop 停止消费
func (c *TongLinkConsumer) Stop() error {
	logx.Info("TongLINK consumer stopped")
	return nil
}

// Close 关闭连接
func (c *TongLinkConsumer) Close() error {
	return c.Stop()
}
