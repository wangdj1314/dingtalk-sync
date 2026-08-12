# DingTalk Sync Tool (钉钉同步工具)

企业钉钉数据全量同步 + 本地浏览一体化解决方案。通过 dws CLI 拉取钉钉聊天记录、文件、图片、日程、待办、听记、通讯录等数据，导出为本地 CSV/JSON/文件，并提供纯前端 Web Viewer 进行检索浏览。

## 功能概览

| 模块 | 说明 |
|------|------|
| 聊天记录同步 | 按会话增量拉取消息，导出 CSV，支持文本/文件/图片/日程等消息类型 |
| 文件下载 | 自动下载聊天中的文件附件，按会话/日期归档 |
| 图片下载 | 下载聊天图片，支持失败重试、断点续传、本地去重 |
| 日程同步 | 拉取日历事件，导出 CSV（含参与人、会议室、入会码） |
| 待办同步 | 拉取钉钉待办任务，导出 CSV |
| 听记同步 | 拉取 AI 听记/会议纪要，保存 JSON + 摘要 CSV |
| 通讯录同步 | BFS 遍历全公司部门树，导出员工信息 CSV |
| GUI 客户端 | PySide6 桌面应用，可视化操作各模块同步 |
| Web Viewer | 纯前端聊天记录浏览器，支持搜索/日历/文件/听记/待办 |
| Windows 安装包 | PyInstaller + Inno Setup 打包，无需 Python 环境即可运行 |

## 技术栈

- Python 3.14 + PySide6 6.11 (Qt 6)
- dws-core CLI (钉钉工作台命令行工具)
- 前端：原生 HTML/CSS/JS，无框架依赖
- 打包：PyInstaller 6.21 + Inno Setup 6.4

## 项目结构

```
钉钉同步/
├── dingtalk_sync.py          # 核心同步引擎（4000+ 行）
├── sync_config.json          # 运行时配置（不入库，见 example）
├── sync_config.example.json  # 配置模板
├── app/                      # GUI 桌面客户端
│   ├── main.py               # 入口
│   ├── main_window.py        # 主窗口
│   ├── sync_worker.py        # 后台工作线程
│   ├── wizard.py             # 首次配置向导
│   ├── crash_handler.py      # 崩溃捕获
│   └── resources/            # 图标资源
├── _viewer/                  # Web 聊天记录浏览器
│   ├── index.html            # 主页面
│   ├── app.js                # 前端逻辑
│   ├── styles.css            # 样式
│   ├── build_index.py        # 索引生成脚本
│   └── 数据交接文档.md       # Viewer 开发交接文档
├── packaging/                # 打包配置
│   ├── dingtalk_sync.spec    # PyInstaller 配置
│   ├── installer.iss         # Inno Setup 安装脚本
│   ├── build.bat             # 一键构建脚本
│   └── ChineseSimplified.isl # 安装向导中文语言
├── docs/                     # 项目文档
│   ├── architecture.md       # 架构设计
│   ├── sync-engine.md        # 同步引擎详解
│   ├── gui.md                # GUI 客户端说明
│   └── packaging.md          # 打包部署指南
└── _tools/                   # 辅助工具/历史脚本
```

## 快速开始

### 环境要求

- Windows 10/11 x64
- Python 3.12+（开发/源码运行）
- dws-core CLI（已登录钉钉账号）

### 源码运行

```bash
# 1. 安装依赖
pip install PySide6

# 2. 确保 dws-core 已登录
dws auth status

# 3. 启动 GUI
python app/main.py

# 4. 或命令行直接调用同步引擎
python dingtalk_sync.py
```

### Web Viewer

```bash
# 同步完成后，生成索引
cd _viewer
python build_index.py

# 启动本地服务
cd ..
python -m http.server 8777 --bind 127.0.0.1

# 浏览器访问 http://127.0.0.1:8777/_viewer/
```

### 打包安装程序

```bash
cd packaging
build.bat
# 产出: Output/DingTalkSync_Setup_v2.4.exe
```

## 数据输出

同步后的数据存放在同步根目录下：

| 目录/文件 | 内容 |
|-----------|------|
| `_chat_export/*.csv` | 聊天记录（每会话一个文件） |
| `{会话名}/{日期}/` | 已下载的聊天文件 |
| `_images/{会话名}/{日期}/` | 已下载的聊天图片 |
| `_calendar_export/*.csv` | 日程/会议 |
| `_todo_export/*.csv` | 待办任务 |
| `_minutes_export/*.json` | 听记/会议纪要 |
| `_contacts_export/*.csv` | 通讯录 |
| `_all_convs.json` | 会话列表 |
| `_sync_state/` | 同步状态（增量标记、清单） |

## 配置

复制 `sync_config.example.json` 为 `sync_config.json` 并修改：

```json
{
  "account": { "name": "你的姓名" },
  "paths": { "dws_core": "dws-core 可执行文件路径" },
  "defaults": { "days": 7, "request_interval": 0.3 }
}
```

## 版本历史

- v2.4 — DWS 新命令适配：会话列表全量分页(list-all-conversations)、待办标准接口(task list)、听记分步详情(get info/summary/keywords/todos)+批量获取(get batch)、逐字稿分页拉取、通讯录新增花名字段
- v2.3 — 新增通讯录同步模块、Windows 安装包打包、CREATE_NO_WINDOW 修复
- v2.2 — 新增听记同步、日程同步、待办同步
- v2.1 — 图片下载重试、文件断点续传、原子写入
- v2.0 — PySide6 GUI 重构、多模块并行同步
- v1.x — 命令行版本，基础聊天记录导出

## License

Private / Internal Use Only
