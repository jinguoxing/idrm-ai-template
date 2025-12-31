package main

import (
	"flag"
	"fmt"

	"github.com/idrm/template/api/internal/config"
	"github.com/idrm/template/api/internal/handler"
	"github.com/idrm/template/api/internal/svc"
	"github.com/idrm/template/pkg/middleware"
	"github.com/idrm/template/pkg/telemetry"
	"github.com/idrm/template/pkg/validator"

	"github.com/zeromicro/go-zero/core/conf"
	"github.com/zeromicro/go-zero/rest"
)

var configFile = flag.String("f", "etc/api.yaml", "the config file")

func main() {
	flag.Parse()

	var c config.Config
	conf.MustLoad(*configFile, &c)

	// Initialize Telemetry (Logging, Tracing, Audit)
	if err := telemetry.Init(c.Telemetry); err != nil {
		panic(fmt.Sprintf("failed to initialize telemetry: %v", err))
	}
	// defer telemetry.Close(context.Background())  // 临时注释，调试完成后恢复

	// Initialize validator
	validator.Init()
	fmt.Println("Validator initialized successfully")

	// Create server
	server := rest.MustNewServer(c.RestConf)
	defer server.Stop()

	// Register global middlewares (order matters!)
	server.Use(middleware.Recovery())  // 1. Panic recovery
	server.Use(middleware.RequestID()) // 2. Request ID generation
	server.Use(middleware.Trace())     // 3. OpenTelemetry tracing
	server.Use(middleware.CORS())      // 4. CORS handling
	server.Use(middleware.Logger())    // 5. Request logging

	// Initialize service context
	ctx := svc.NewServiceContext(c)

	// Register routes
	handler.RegisterHandlers(server, ctx)

	fmt.Printf("Starting API server at %s:%d...\n", c.Host, c.Port)
	server.Start()
}
