package handler

import (
	"context"

	"github.com/idrm/template/consumer/internal/mq"
	"github.com/idrm/template/consumer/internal/svc"

	"github.com/zeromicro/go-zero/core/logx"
)

// MessageHandler 消息处理器
type MessageHandler struct {
	svcCtx *svc.ServiceContext
}

// NewMessageHandler 创建消息处理器
func NewMessageHandler(svcCtx *svc.ServiceContext) *MessageHandler {
	return &MessageHandler{
		svcCtx: svcCtx,
	}
}

// Handle 处理消息
func (h *MessageHandler) Handle(ctx context.Context, msg *mq.Message) error {
	logx.Infof("Received message, key: %s, topic: %s", msg.Key, msg.Topic)

	// TODO: 实现具体的消息处理逻辑
	// 示例：
	// 1. 解析消息体
	// 2. 调用业务逻辑
	// 3. 更新数据库
	// 4. 发送通知

	logx.Infof("Message processed successfully")
	return nil
}
