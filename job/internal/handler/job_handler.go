package handler

import (
	"context"

	"github.com/idrm/template/job/internal/svc"

	"github.com/zeromicro/go-zero/core/logx"
)

// JobHandler 任务处理器
type JobHandler struct {
	svcCtx *svc.ServiceContext
}

// NewJobHandler 创建任务处理器
func NewJobHandler(svcCtx *svc.ServiceContext) *JobHandler {
	return &JobHandler{
		svcCtx: svcCtx,
	}
}

// Run 执行任务
func (h *JobHandler) Run(ctx context.Context) error {
	logx.Info("Job started")

	// TODO: 实现具体的任务逻辑
	// 示例：
	// 1. 从数据库获取待处理数据
	// 2. 批量处理数据
	// 3. 更新处理状态

	// 检查 context 是否被取消
	select {
	case <-ctx.Done():
		return ctx.Err()
	default:
	}

	logx.Info("Job finished successfully")
	return nil
}
