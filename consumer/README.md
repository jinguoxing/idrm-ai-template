# Consumer 服务

消息消费者服务模板，支持多种消息中间件。

## 目录结构

```
consumer/
├── etc/                # 配置文件
│   └── consumer.yaml
├── consumer.go         # 入口文件
└── internal/
    ├── config/         # 配置结构
    ├── handler/        # 消息处理器
    ├── mq/             # 消息队列抽象层
    │   ├── interface.go    # 统一接口
    │   ├── kafka.go        # Kafka 实现
    │   └── tonglink.go     # TongLINK 实现
    └── svc/            # 服务上下文
```

## 支持的消息中间件

| 类型 | 说明 | 状态 |
|------|------|------|
| kafka | Apache Kafka | ✅ 已实现 |
| tonglink | 东方通 TongLINK/Q-CN | 🚧 占位 |
| redis | Redis Stream | 📋 计划中 |

## 使用方法

### 1. 配置消息队列

修改 `etc/consumer.yaml`:

```yaml
MQ:
  Type: kafka
  Kafka:
    Brokers:
      - localhost:9092
    Topic: orders
    Group: consumer-group
```

### 2. 运行服务

```bash
go run consumer/consumer.go -f consumer/etc/consumer.yaml
```

### 3. 添加新消息类型

1. 在 `internal/handler/` 创建新的处理器
2. 根据消息类型路由到不同的处理器

## 扩展新的消息中间件

1. 在 `internal/mq/` 添加新的实现
2. 实现 `Consumer` 接口
3. 在 `interface.go` 的 `NewConsumer` 工厂函数中添加新类型

```go
case "newmq":
    return NewNewMQConsumer(cfg.NewMQ)
```
