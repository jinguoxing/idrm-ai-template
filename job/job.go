package main

import (
	"context"
	"flag"
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/idrm/template/job/internal/config"
	"github.com/idrm/template/job/internal/handler"
	"github.com/idrm/template/job/internal/svc"

	"github.com/zeromicro/go-zero/core/conf"
	"github.com/zeromicro/go-zero/core/logx"
)

var configFile = flag.String("f", "etc/job.yaml", "the config file")

func main() {
	flag.Parse()

	var c config.Config
	conf.MustLoad(*configFile, &c)
	ctx := svc.NewServiceContext(c)

	// 创建带超时的 context
	timeout := time.Duration(c.Job.Timeout) * time.Second
	jobCtx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()

	// 监听信号
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)

	// 执行任务
	h := handler.NewJobHandler(ctx)

	fmt.Printf("Starting job: %s...\n", c.Job.Name)
	startTime := time.Now()

	errChan := make(chan error, 1)
	go func() {
		errChan <- h.Run(jobCtx)
	}()

	select {
	case err := <-errChan:
		if err != nil {
			logx.Errorf("Job failed: %v", err)
			os.Exit(1)
		}
		logx.Infof("Job completed in %v", time.Since(startTime))
	case sig := <-sigChan:
		logx.Infof("Received signal: %v, cancelling job...", sig)
		cancel()
		os.Exit(0)
	case <-jobCtx.Done():
		logx.Error("Job timeout")
		os.Exit(1)
	}
}
