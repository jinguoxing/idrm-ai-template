package main

import (
	"flag"
	"fmt"

	"github.com/idrm/template/rpc/internal/config"
	"github.com/idrm/template/rpc/internal/server"
	"github.com/idrm/template/rpc/internal/svc"
	"github.com/idrm/template/rpc/pb"

	"github.com/zeromicro/go-zero/core/conf"
	"github.com/zeromicro/go-zero/zrpc"
	"google.golang.org/grpc"
)

var configFile = flag.String("f", "etc/rpc.yaml", "the config file")

func main() {
	flag.Parse()

	var c config.Config
	conf.MustLoad(*configFile, &c)
	ctx := svc.NewServiceContext(c)

	s := zrpc.MustNewServer(c.RpcServerConf, func(grpcServer *grpc.Server) {
		pb.RegisterExampleServiceServer(grpcServer, server.NewExampleServiceServer(ctx))
	})
	defer s.Stop()

	fmt.Printf("Starting rpc server at %s:%d...\n", c.Host, c.Port)
	s.Start()
}
