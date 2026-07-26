## 钉钉同步工具 (DingTalk Sync)

扫描钉钉群聊中的文件消息并自动下载到本地，同时支持将聊天记录导出为 CSV 格式。支持增量同步和全量扫描两种模式，可手动运行也可配合 Windows 计划任务定时执行。通过配置文件可以在不同电脑、不同钉钉账号间灵活切换。

### 前置条件

- **Python 3.8+**（Windows 环境需要安装，推荐从 [python.org](https://www.python.org) 下载）
- **QoderWork**（提供 `dws-core` 命令行工具，用于访问钉钉 API）

脚本会自动在以下路径查找 `dws-core` 可执行文件：

```
~/.qoderworkcn/bin/dws-ext/dws-core-windows-amd64.exe   (Windows)
~/.qoderworkcn/bin/dws-ext/dws-core-darwin-amd64         (macOS Intel)
~/.qoderworkcn/bin/dws-ext/dws-core-darwin-arm64         (macOS Apple Silicon)
```

也可以通过配置文件 `config.json` 的 `paths.dws_core` 字段或环境变量 `DWS_CORE_PATH` 手动指定路径。

### 配置文件

首次运行前，用 `--init` 自动生成配置文件：

```bash
python dws_sync.py --init
```

脚本会自动探测当前环境的以下信息并预填到 `config.json`：

- **账号名称**（通过 `dws-core contact user get-self` 获取当前登录用户姓名）
- **所属组织 / 部门**（自动拼接为描述信息）
- **企业 ID**（corp_id）
- **dws-core 路径**（在 QoderWork 默认安装位置查找）
- **同步目录**（默认为 `_tools/` 的上一级目录）

生成的配置文件示例：

```json
{
  "version": 1,
  "account": {
    "name": "张三",
    "description": "某某公司 / 技术部",
    "corp_id": "ding1234567890"
  },
  "paths": {
    "sync_dir": "D:\\myfiles\\钉钉同步",
    "convs_file": "_all_convs.json",
    "dws_core": "",
    "chat_export_subdir": "_chat_export"
  },
  "defaults": {
    "days": 7,
    "request_interval": 0.3
  },
  "features": {
    "auto_download": true,
    "export_csv": false
  }
}
```

**字段说明：**

| 字段 | 自动? | 说明 |
|------|-------|------|
| `account.name` | 是 | 当前钉钉用户名，`--init` 自动探测，运行时也会自动补全并回写 |
| `account.description` | 是 | 自动拼接「公司 / 部门」，可手动修改 |
| `account.corp_id` | 是 | 钉钉企业 ID，自动获取 |
| `paths.sync_dir` | 是 | 默认 `_tools/` 上一级目录，可改为任意路径 |
| `paths.convs_file` | - | 会话列表文件名，默认 `_all_convs.json` |
| `paths.dws_core` | 是 | 留空则自动检测 QoderWork 安装路径 |
| `paths.chat_export_subdir` | - | CSV 导出子目录名，默认 `_chat_export` |
| `defaults.days` | - | 增量扫描默认天数，命令行 `--days` 优先 |
| `defaults.request_interval` | - | API 请求间隔秒数，默认 0.3 秒 |
| `features.auto_download` | - | 是否自动下载文件（保留字段） |
| `features.export_csv` | - | 设为 `true` 时每次运行自动导出 CSV（等价于 `--all`） |

标"是"的字段无需手动填写，`--init` 或运行时会自动探测。即使没有配置文件，脚本也能正常运行（所有路径都有合理默认值）。

**多账号 / 多机器使用：**

在同一台电脑上管理多个钉钉账号时，可以准备多份配置文件，通过 `--config` 指定：

```bash
# 账号 A
python dws_sync.py --config config_accountA.json

# 账号 B
python dws_sync.py --config config_accountB.json --days 14
```

在不同电脑上使用时，只需将 `_tools/` 目录整体复制过去。如果 `config.json` 中的 `account.name` 为空，首次运行时脚本会自动探测当前登录的钉钉账号并回写到配置文件中。

### 目录结构

```
钉钉同步\                                # 同步根目录（paths.sync_dir）
├── _tools\                              # 工具脚本（可整体复制到其他机器）
│   ├── dws_sync.py                      # 主程序
│   ├── config.json                      # 配置文件（每台机器/账号各一份）
│   ├── dws_sync_task.bat                # Windows 计划任务入口
│   ├── README.md                        # 本文件
│   └── archive\                         # 历史过程脚本归档
├── _sync_state\                         # 运行状态数据
│   ├── download_manifest.json           # 文件下载清单
│   ├── space_ids.json                   # spaceId 缓存
│   ├── chat_export_state.json           # CSV 导出进度
│   ├── conversations.json               # 会话缓存
│   └── sync.log                         # 运行日志
├── _chat_export\                        # 聊天记录 CSV 输出
│   ├── 群聊名称.csv
│   └── ...
├── _all_convs.json                      # 会话列表（由 QoderWork 生成）
├── 群聊名称\                            # 下载的文件按会话名/日期存放
│   └── 2026-05-20\
│       └── 文件名.ext
└── ...
```

### 基本用法

```bash
# 首次运行，生成配置文件
python dws_sync.py --init

# 增量同步文件（默认扫描最近 7 天，或按 config.json 中 defaults.days）
python dws_sync.py

# 全量扫描并下载所有历史文件
python dws_sync.py --full

# 扫描最近 30 天的文件
python dws_sync.py --days 30

# 仅扫描不下载（预览有多少新文件）
python dws_sync.py --scan-only

# 预览将要下载的文件列表
python dws_sync.py --dry-run

# 导出聊天记录到 CSV
python dws_sync.py --export-csv

# 导出全量聊天记录（从最早开始）
python dws_sync.py --export-csv --full

# 文件同步 + 聊天记录导出一起执行
python dws_sync.py --all

# 查看当前同步状态
python dws_sync.py --status

# 使用指定配置文件
python dws_sync.py --config config_other.json
```

### 参数说明

| 参数 | 说明 |
|------|------|
| `--init` | 生成配置文件模板（首次运行时使用） |
| `--config PATH` | 指定配置文件路径，默认读取同目录 `config.json` |
| `--full` | 全量模式，从 2020-01-01 开始扫描所有历史消息 |
| `--days N` | 增量扫描天数，优先于配置文件中的 `defaults.days` |
| `--scan-only` | 仅扫描文件消息，更新清单但不下载 |
| `--dry-run` | 预览模式，列出将要下载的文件但不实际执行 |
| `--export-csv` | 导出聊天记录为 CSV 文件 |
| `--all` | 同时执行文件同步和聊天记录导出 |
| `--status` | 显示当前同步状态摘要 |

### 工作原理

脚本的核心流程分为两个阶段：

**阶段一：扫描。** 遍历 `_all_convs.json` 中记录的会话，调用 `dws-core chat message list` 逐页获取消息，用正则表达式匹配 `[文件] 文件名 fileId:xxx` 格式的文件消息。扫描结果存入 `download_manifest.json`，同时缓存每个会话的 `spaceId`（从 `conversationInfo.extension.newCSpaceIdIM` 获取）。

**阶段二：下载。** 对清单中尚未下载的文件，调用 `dws-core drive download` 获取临时下载 URL，然后用 Python `urllib` 下载文件到本地。文件按 `会话名/日期/文件名` 的目录结构存放。已下载的文件会标记 `_downloaded`，过期的标记 `_expired`。

**聊天记录导出** 使用相同的消息拉取机制，将每个会话的完整消息写入独立的 CSV 文件。CSV 使用 `utf-8-sig` 编码（UTF-8 BOM），可以直接用 Excel 打开而不会乱码。导出支持增量追加——记住每个会话上次导出到的位置，下次只拉取新消息。

### 定时自动同步

项目中包含一个 Windows 计划任务 `DingTalkSync`，每天 21:00 自动运行，执行 `dws_sync_task.bat`。该批处理文件会以 `--all --days 2` 参数调用主脚本，同时完成文件同步和聊天记录导出。

`dws_sync_task.bat` 使用 `%~dp0`（脚本自身所在目录）自动推导路径，并尝试从 PATH 或常见安装位置查找 Python，因此可以直接复制到其他机器使用，无需修改。

手动管理计划任务：

```powershell
# 查看任务状态
Get-ScheduledTask -TaskName "DingTalkSync"

# 立即执行一次
Start-ScheduledTask -TaskName "DingTalkSync"

# 删除任务
Unregister-ScheduledTask -TaskName "DingTalkSync" -Confirm:$false

# 重新创建任务（每天 21:00 执行，修改路径为本机的 bat 位置）
$action = New-ScheduledTaskAction -Execute "C:\Windows\System32\cmd.exe" `
    -Argument '/c "D:\myfiles\钉钉同步\_tools\dws_sync_task.bat"'
$trigger = New-ScheduledTaskTrigger -Daily -At 21:00
Register-ScheduledTask -TaskName "DingTalkSync" -Action $action -Trigger $trigger
```

运行日志保存在 `_sync_state\task_run.log`。

### 在新机器上部署

1. 将 `_tools/` 目录整体复制到新机器
2. 确保新机器已安装 Python 3.8+ 和 QoderWork（QoderWork 提供 dws-core）
3. 运行 `python dws_sync.py --init`，脚本会自动探测本机环境并生成 `config.json`（账号名、dws-core 路径等均已预填）
4. 如需修改同步目录，编辑 `config.json` 中的 `paths.sync_dir`
5. 将 `_all_convs.json`（会话列表）复制到 sync_dir 下
6. 运行 `python dws_sync.py --status` 验证是否正常
7. 如需定时运行，在 Windows 计划任务中注册 `dws_sync_task.bat`

如果不需要 `--init`，也可以直接运行——脚本检测到 `account.name` 为空时会自动调用钉钉 API 获取当前用户信息并回写到配置文件。

### 常见问题

**Q: 显示"未找到 dws-core 可执行文件"怎么办？**
确保已安装 QoderWork 桌面端。如果 `dws-core` 安装在非标准路径，在 `config.json` 的 `paths.dws_core` 中指定完整路径，或设置环境变量 `DWS_CORE_PATH`。

**Q: 很多文件显示"已过期"？**
钉钉文件消息的下载链接有有效期，过期的链接无法重新获取。这是钉钉平台限制，无法绕过。

**Q: `_all_convs.json` 从哪里来？**
这个文件需要通过 QoderWork 扫描钉钉会话列表生成。脚本本身不负责获取会话列表。每个钉钉账号的会话列表不同，切换账号时需要替换此文件。

**Q: CSV 文件用 Excel 打开乱码？**
CSV 已使用 UTF-8 BOM 编码，正常情况下 Excel 可以直接识别。如果仍有问题，可以在 Excel 中使用"数据 → 从文本/CSV"导入功能，手动选择 UTF-8 编码。

**Q: 如何只同步特定群聊的文件？**
目前脚本不支持按会话筛选。可以编辑 `_all_convs.json`，只保留需要同步的会话条目。

**Q: 同一台电脑能同步多个钉钉账号吗？**
可以。为每个账号准备一份 `config.json`（文件名可以不同），用 `--config` 参数指定。同时每个账号需要各自的 `_all_convs.json` 和 `sync_dir`。

### 技术细节

- 请求间隔可配置（默认 0.3 秒），避免触发钉钉 API 频率限制
- 文件下载使用原子写入（先写 `.tmp` 再重命名），避免产生不完整的文件
- `dws-core` 命令通过 `subprocess` 调用，输出用 UTF-8 解码（兼容 Windows GBK 环境）
- `sender` 字段在钉钉 API 中可能是字符串也可能是字典，脚本做了兼容处理
- `spaceId` 字段做了类型校验，防止 API 返回异常数据导致崩溃
- 配置文件支持相对路径和绝对路径，相对路径基于 `_tools/` 目录解析
- `dws-core` 查找优先级：配置文件 > 环境变量 > QoderWork 默认路径 > 系统 PATH
