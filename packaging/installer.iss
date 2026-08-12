; 钉钉同步工具 - Inno Setup 安装脚本
; ====================================
; 编译: ISCC.exe installer.iss
; 输出: Output/DingTalkSync_Setup_v2.4.exe

#define MyAppName "钉钉同步工具"
#define MyAppVersion "2.4"
#define MyAppPublisher "Risen IT"
#define MyAppExeName "DingTalkSync.exe"
#define MyAppIcon "dist\DingTalkSync\resources\dingtalk_sync.ico"

[Setup]
AppId={{A3F8B2C1-7D4E-4A9F-B6C5-1E2D3F4A5B6C}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={localappdata}\DingTalkSync
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputDir=Output
OutputBaseFilename=DingTalkSync_Setup_v{#MyAppVersion}
SetupIconFile={#MyAppIcon}
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayIcon={app}\{#MyAppExeName}
UninstallDisplayName={#MyAppName}

[Languages]
Name: "chinesesimplified"; MessagesFile: "ChineseSimplified.isl"

[Tasks]
Name: "desktopicon"; Description: "创建桌面快捷方式"; GroupDescription: "附加选项:"; Flags: checkedonce
Name: "autostart"; Description: "开机自动启动（最小化到托盘）"; GroupDescription: "附加选项:"

[Files]
; PyInstaller 输出的整个目录（已包含 bin/dws-core 和 resources/icon）
Source: "dist\DingTalkSync\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; 开始菜单
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\resources\dingtalk_sync.ico"
Name: "{group}\卸载 {#MyAppName}"; Filename: "{uninstallexe}"
; 桌面快捷方式
Name: "{userdesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\resources\dingtalk_sync.ico"; Tasks: desktopicon

[Registry]
; 开机自启（最小化模式）
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "DingTalkSync"; ValueData: """{app}\{#MyAppExeName}"" --minimized"; Flags: uninsdeletevalue; Tasks: autostart

[Run]
; 安装完成后可选启动
Filename: "{app}\{#MyAppExeName}"; Description: "立即启动 {#MyAppName}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; 卸载时清理运行时数据（可选，默认保留）
; Type: filesandordirs; Name: "{app}\_sync_state"
; Type: filesandordirs; Name: "{app}\_images"
