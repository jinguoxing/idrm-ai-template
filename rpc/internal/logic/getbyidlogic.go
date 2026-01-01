package logic

import (
	"context"

	"github.com/idrm/template/rpc/internal/svc"
	"github.com/idrm/template/rpc/pb"

	"github.com/zeromicro/go-zero/core/logx"
)

// GetByIdLogic 获取详情业务逻辑
type GetByIdLogic struct {
	ctx    context.Context
	svcCtx *svc.ServiceContext
	logx.Logger
}

// NewGetByIdLogic 创建逻辑实例
func NewGetByIdLogic(ctx context.Context, svcCtx *svc.ServiceContext) *GetByIdLogic {
	return &GetByIdLogic{
		ctx:    ctx,
		svcCtx: svcCtx,
		Logger: logx.WithContext(ctx),
	}
}

// GetById 根据ID获取
func (l *GetByIdLogic) GetById(req *pb.IdRequest) (*pb.Response, error) {
	// TODO: 实现业务逻辑
	return &pb.Response{
		Code:    0,
		Message: "success",
	}, nil
}
