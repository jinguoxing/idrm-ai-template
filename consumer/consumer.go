package main

import (
	"context"
	"flag"
	"fmt"
	"os"
	"os/signal"
	"syscall"

	"github.com/idrm/template/consumer/internal/config"
	"github.com/idrm/template/consumer/internal/handler"
	"github.com/idrm/template/consumer/internal/mq"
	"github.com/idrm/template/consumer/internal/svc"

	"github.com/zeromicro/go-zero/core/conf"
	"github.com/zeromicro/go-zero/core/logx"
)

var configFile = flag.String("f", "etc/consumer.yaml", "the config file")

func main() {
	flag.Parse()

	var c config.Config
	conf.MustLoad(*configFile, &c)
	ctx := svc.NewServiceContext(c)

	// 创建消费者
	consumer, err := mq.NewConsumer(c.MQ)
	if err != nil {
		logx.Errorf("Failed to create consumer: %v", err)
		os.Exit(1)
	}

	// 创建消息处理器
	h := handler.NewMessageHandler(ctx)

	// 订阅主题
	if err := consumer.Subscribe(context.Background(), h.Handle); err != nil {
		logx.Errorf("Failed to subscribe: %v", err)
		os.Exit(1)
	}

	// 启动消费
	if err := consumer.Start(); err != nil {
		logx.Errorf("Failed to start consumer: %v", err)
		os.Exit(1)
	}

	fmt.Printf("Starting consumer, type: %s...\n", c.MQ.Type)

	// 监听信号
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)
	<-sigChan

	logx.Info("Shutting down consumer...")
	consumer.Close()
}
