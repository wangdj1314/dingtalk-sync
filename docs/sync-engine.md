# 同步引擎详解 (dingtalk_sync.py)

## 概述

`dingtalk_sync.py` 是整个系统的核心，约 4000+ 行 Python 代码，负责与 dws-core CLI 交互，
拉取钉钉各模块数据并持久化到本地文件系统。

## 主要函数/模块

### 基础设施

| 函数 | 说明 |
|------|------|
| `find_dws_core()` | 定位 dws-core 可执行文件路径 |
| `run_dws(args)` | 封装 subprocess 调用，返回 JSON 解析结果 |
| `save_json(path, data)` | 原子写入 JSON（tmp + replace + 重试） |
| `load_json(path, default)` | 安全读取 JSON |
| `safe_filename(name)` | 文件名清洗（去除非法字符） |
| `ensure_dirs()` | 创建所有必要的输出目录 |

### 聊天记录

| 函数 | 说明 |
|------|------|
| `list_conversations()` | 获取会话列表 |
| `fetch_messages(conv_id, start_time)` | 拉取指定会话的消息 |
| `export_chat_csv(conv_title, messages)` | 导出为 CSV |
| `sync_all_chats()` | 全量/增量同步所有会话 |

### 文件下载

| 函数 | 说明 |
|------|------|
| `download_file(file_id, save_path)` | 下载单个文件 |
| `sync_files()` | 扫描消息中的文件并下载 |
| `retry_failed_downloads()` | 重试失败的文件 |

### 图片下载

| 函数 | 说明 |
|------|------|
| `download_image(media_id, save_path)` | 下载单张图片 |
| `sync_images()` | 扫描消息中的图片并下载 |
| `retry_failed_images()` | 重试失败图片（跳过已存在） |

### 日程

| 函数 | 说明 |
|------|------|
| `fetch_calendar_events(start, end)` | 拉取日历事件 |
| `sync_calendar()` | 同步日程到 CSV |

### 待办

| 函数 | 说明 |
|------|------|
| `fetch_todos()` | 拉取待办列表 |
| `sync_todos()` | 同步待办到 CSV |

### 听记

| 函数 | 说明 |
|------|------|
| `fetch_minutes_list()` | 获取听记列表 |
| `fetch_minutes_detail(uuid)` | 获取单条听记详情 |
| `sync_minutes()` | 同步听记到 JSON |

### 通讯录

| 函数 | 说明 |
|------|------|
| `fetch_dept_children(dept_id)` | 获取子部门 |
| `fetch_dept_members(dept_id)` | 获取部门成员 |
| `fetch_user_detail(user_id)` | 获取用户详情 |
| `sync_contacts()` | BFS 遍历部门树，导出全员 CSV |

## 状态管理

所有状态文件位于 `_sync_state/` 目录：

- `chat_export_state.json` — 每会话的增量截止时间
- `image_manifest.json` — 图片下载清单
- `download_manifest.json` — 文件下载清单
- `calendar_state.json` — 日程同步状态
- `todo_state.json` — 待办同步状态
- `minutes_state.json` — 听记同步状态
- `contacts_state.json` — 通讯录同步状态

## Windows 特殊处理

- `_CREATE_NO_WINDOW = 0x08000000`：所有 subprocess 调用携带此标志，防止弹出 CMD 窗口
- `save_json` 中 PermissionError 重试：应对 Windows Defender/索引服务锁文件
- 打包模式下 `BASE_DIR` 使用 `sys.executable` 路径

## 错误处理

- dws 命令超时：默认 60s，可配置
- API 限流：自动等待 + 重试
- 网络异常：指数退避重试（最多 3 次）
- 文件写入失败：原子写入 + 重试
