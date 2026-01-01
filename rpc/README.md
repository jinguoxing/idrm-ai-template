# RPC 服务

Go-Zero zRPC 服务模板。

## 目录结构

```
rpc/
├── proto/              # Protobuf 定义
│   └── service.proto
├── pb/                 # 生成的 Go 代码 (goctl 生成)
├── etc/                # 配置文件
│   └── rpc.yaml
├── rpc.go              # 入口文件
└── internal/
    ├── config/         # 配置结构
    ├── logic/          # 业务逻辑
    ├── server/         # gRPC 服务实现
    └── svc/            # 服务上下文
```

## 使用方法

### 1. 生成代码

```bash
# 生成 protobuf Go 代码
goctl rpc protoc rpc/proto/service.proto --go_out=rpc/pb --go-grpc_out=rpc/pb --zrpc_out=rpc/
```

### 2. 运行服务

```bash
go run rpc/rpc.go -f rpc/etc/rpc.yaml
```

### 3. 添加新接口

1. 在 `proto/service.proto` 添加新的 rpc 定义
2. 运行 goctl 重新生成代码
3. 在 `internal/server/` 实现接口
4. 在 `internal/logic/` 编写业务逻辑
