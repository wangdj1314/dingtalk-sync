# GUI 客户端 (app/)

## 概述

基于 PySide6 (Qt 6) 的桌面客户端，提供可视化界面操作各同步模块。

## 文件说明

| 文件 | 行数 | 职责 |
|------|------|------|
| `main.py` | 165 | 应用入口，初始化 QApplication、设置图标、启动主窗口 |
| `main_window.py` | 1428 | 主窗口 UI，模块列表、状态面板、日志输出、按钮交互 |
| `sync_worker.py` | 501 | QThread 工作线程，封装各模块同步调用 |
| `wizard.py` | 378 | 首次运行配置向导（选择 dws-core 路径、设置姓名等） |
| `crash_handler.py` | 278 | 全局异常捕获，写入崩溃日志 |
| `resources/dingtalk_sync.ico` | — | 应用图标（多尺寸） |

## 工作线程

`sync_worker.py` 中定义了多个 Worker 类，均继承自 `BaseWorker(QThread)`：

- `ChatSyncWorker` — 聊天记录同步
- `FileDownloadWorker` — 文件下载
- `ImageDownloadWorker` — 图片下载
- `ImageRetryWorker` — 图片重试
- `CalendarSyncWorker` — 日程同步
- `TodoSyncWorker` — 待办同步
- `MinutesSyncWorker` — 听记同步
- `ContactsSyncWorker` — 通讯录同步
- `StatusWorker` — 状态刷新（读取各 state 文件）

每个 Worker 通过 Qt Signal 与主窗口通信：
- `sig.phase` — 阶段提示
- `sig.log` — 日志输出
- `sig.progress` — 进度百分比
- `sig.finished` — 完成信号 (success, message)

## 主窗口布局

```
+------------------------------------------+
| 标题栏（图标 + 钉钉同步工具 v2.4）        |
+------------------------------------------+
| 模块列表（表格）  |  日志输出区           |
| [x] 聊天记录     |  [实时滚动日志]        |
| [x] 文件下载     |                       |
| [x] 图片下载     |                       |
| [x] 日程         |                       |
| [x] 待办         |                       |
| [x] 听记         |                       |
| [x] 通讯录       |                       |
+------------------------------------------+
| [开始同步] [停止] | 状态栏（上次同步时间）|
+------------------------------------------+
```

## 打包模式适配

- `getattr(sys, "frozen", False)` 检测是否为 PyInstaller 打包环境
- 打包模式下 `BASE_DIR = Path(sys.executable).parent`
- 图标路径：`{exe_dir}/resources/dingtalk_sync.ico`
- dws-core 路径：优先查找 `{exe_dir}/bin/dws-core-windows-amd64.exe`

## 运行

```bash
pip install PySide6
python app/main.py
```

打包后直接运行 `DingTalkSync.exe`，无需 Python 环境。
