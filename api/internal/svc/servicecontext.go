package svc

import (
	"database/sql"
	"fmt"

	"github.com/idrm/template/api/internal/config"
	"github.com/idrm/template/model/resource_catalog/category"
	"github.com/idrm/template/pkg/db"

	_ "github.com/go-sql-driver/mysql"
	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
	"gorm.io/gorm"
)

type ServiceContext struct {
	Config config.Config

	// Model层（使用接口类型，支持自动ORM选择）
	CategoryModel category.Model
}

func NewServiceContext(c config.Config) *ServiceContext {
	// 1. 初始化 sqlx 连接（作为备用）
	var sqlConn *sql.DB
	var sqlxErr error
	dsn := buildDSN(c.DB.ResourceCatalog)
	logx.Infof("尝试连接数据库(SQLx): %s:%d/%s", c.DB.ResourceCatalog.Host, c.DB.ResourceCatalog.Port, c.DB.ResourceCatalog.Database)
	conn := sqlx.NewMysql(dsn)
	sqlConn, sqlxErr = conn.RawDB()
	if sqlxErr != nil {
		logx.Errorf("SQLx RawDB获取失败: %v, DSN: %s", sqlxErr, dsn)
		sqlConn = nil
	} else {
		logx.Info("SQLx 连接成功")
	}

	// 2. 初始化 gorm 连接（优先）
	var gormDB *gorm.DB
	var gormErr error
	logx.Infof("尝试连接数据库(GORM): %s:%d/%s", c.DB.ResourceCatalog.Host, c.DB.ResourceCatalog.Port, c.DB.ResourceCatalog.Database)
	gormDB, gormErr = db.InitGorm(c.DB.ResourceCatalog)
	if gormErr != nil {
		logx.Errorf("GORM初始化失败: %v", gormErr)
		gormDB = nil
	} else {
		logx.Info("GORM 连接成功")
	}

	// 如果两个都失败，提前panic
	if sqlConn == nil && gormDB == nil {
		panic(fmt.Sprintf("数据库连接失败！SQLx错误: %v, GORM错误: %v", sqlxErr, gormErr))
	}

	// 3. 使用工厂自动选择ORM（gorm优先，sqlx降级）
	categoryModel := category.NewModel(sqlConn, gormDB)

	return &ServiceContext{
		Config:        c,
		CategoryModel: categoryModel,
	}
}

// buildDSN 构建 sqlx 的 DSN
func buildDSN(cfg db.Config) string {
	return fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=%s&parseTime=True&loc=Local",
		cfg.Username,
		cfg.Password,
		cfg.Host,
		cfg.Port,
		cfg.Database,
		cfg.Charset,
	)
}
