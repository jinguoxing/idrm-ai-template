package server

import (
	"context"

	"github.com/idrm/template/rpc/internal/logic"
	"github.com/idrm/template/rpc/internal/svc"
	"github.com/idrm/template/rpc/pb"
)

// ExampleServiceServer 示例服务实现
type ExampleServiceServer struct {
	svcCtx *svc.ServiceContext
	pb.UnimplementedExampleServiceServer
}

// NewExampleServiceServer 创建服务实例
func NewExampleServiceServer(svcCtx *svc.ServiceContext) *ExampleServiceServer {
	return &ExampleServiceServer{
		svcCtx: svcCtx,
	}
}

// GetById 根据ID获取
func (s *ExampleServiceServer) GetById(ctx context.Context, req *pb.IdRequest) (*pb.Response, error) {
	l := logic.NewGetByIdLogic(ctx, s.svcCtx)
	return l.GetById(req)
}
