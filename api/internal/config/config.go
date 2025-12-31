package config

import (
	"github.com/idrm/template/pkg/db"
	"github.com/idrm/template/pkg/telemetry"

	"github.com/zeromicro/go-zero/rest"
)

type Config struct {
	rest.RestConf

	// Telemetry配置
	Telemetry telemetry.Config

	// 数据库配置（详细配置）
	DB struct {
		// 资源目录数据库
		ResourceCatalog db.Config

		// 数据视图数据库
		DataView db.Config

		// 数据理解数据库
		DataUnderstanding db.Config
	}

	// 认证配置
	Auth struct {
		AccessSecret string
		AccessExpire int64
	}
}
