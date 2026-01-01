# Job 服务

定时任务服务模板，支持 K8S CronJob 调度。

## 目录结构

```
job/
├── etc/                # 配置文件
│   └── job.yaml
├── job.go              # 入口文件
└── internal/
    ├── config/         # 配置结构
    ├── handler/        # 任务处理器
    └── svc/            # 服务上下文
```

## 使用方法

### 1. 本地运行

```bash
go run job/job.go -f job/etc/job.yaml
```

### 2. K8S CronJob 配置

参考 `deploy/helm/idrm/templates/job/cronjob.yaml`

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: my-job
spec:
  schedule: "0 2 * * *"  # 每天凌晨 2 点
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: job
              image: my-registry/job:latest
              args: ["-f", "etc/job.yaml"]
          restartPolicy: OnFailure
```

### 3. 添加新任务

1. 在 `internal/handler/` 创建新的处理器
2. 在 `job.go` 中调用新的处理器
3. 或创建新的 job 目录作为独立任务

## 后续扩展

计划支持 [asynq](https://github.com/hibiken/asynq) 作为异步任务队列。
