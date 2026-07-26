# 架构设计

## 系统组成

本系统由三个独立但协作的子系统组成：

1. **同步引擎** (`dingtalk_sync.py`) — 数据拉取与持久化
2. **GUI 客户端** (`app/`) — 用户交互界面
3. **Web Viewer** (`_viewer/`) — 数据浏览与检索

## 数据流

```
dws-core CLI (钉钉 API 封装)
       |
       v
dingtalk_sync.py (同步引擎)
  - subprocess 调用 dws 命令
  - 解析 JSON 输出
  - 增量策略（状态文件记录上次同步时间）
  - 原子写入（tmp + os.replace）
  - 失败重试（指数退避）
       |
       v
本地文件系统
  - CSV 文件（聊天/日程/待办/通讯录）
  - JSON 文件（听记/状态/清单）
  - 二进制文件（图片/附件）
       |
       v
build_index.py (索引生成)
  - 扫描数据目录
  - 生成前端所需的 JSON 索引
       |
       v
Web Viewer (纯前端)
  - fetch 加载 CSV/JSON
  - 客户端解析渲染
  - 无需后端服务
```

## 关键设计决策

### 增量同步

每个模块维护独立的状态文件（`_sync_state/xxx_state.json`），记录上次同步的时间戳或游标。
下次同步只拉取增量数据，追加到已有 CSV 文件末尾。

### 原子写入

所有 JSON 状态文件使用 `tmp + os.replace()` 模式写入，防止断电/崩溃导致数据损坏。
Windows 下额外增加 PermissionError 重试（防杀毒软件锁文件）。

### 进程隔离

GUI 通过 QThread 将同步任务放到后台线程，避免阻塞 UI。
通讯录等长时间任务支持独立进程运行（`subprocess.Popen` + `CREATE_NO_WINDOW`）。

### 前端无依赖

Viewer 不依赖任何前端框架或构建工具，单个 HTML + JS + CSS 即可运行。
数据通过 HTTP 静态服务提供，兼容任何 Web 服务器。

## 模块间关系

```
app/main_window.py
  └── app/sync_worker.py (QThread)
        └── dingtalk_sync.py (import 调用)
              └── dws-core CLI (subprocess)

_viewer/build_index.py
  └── 读取 dingtalk_sync.py 产出的数据文件
  └── 生成 _viewer/*.json 索引

_viewer/app.js
  └── fetch 加载 _all_convs.json + _viewer/*.json + _chat_export/*.csv
```

## 并发与性能

- 同步引擎单线程顺序执行（避免触发钉钉 API 限流）
- `request_interval` 配置项控制请求间隔（默认 0.3s）
- 图片下载支持跳过已存在文件（本地去重）
- 前端大批量消息使用分批渲染（300条/批）+ 虚拟滚动思路
