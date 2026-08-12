#!/bin/bash
set +e
OK=0
FAIL=0
EXPIRE=0
TOTAL=297
PROGRESS_FILE="D:/myfiles/钉钉同步/_sync_state/downloaded.json"

echo "Starting download of $TOTAL files..."

# [1/297] 东方日升新能源股份有限公司网络拓扑图20201126.vsdx
mkdir -p "D:/myfiles/钉钉同步/钟建宇/2021-10-08"
RESULT=$(dws drive download --file-id "43904666122" --space-id "5151492543" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/钟建宇/2021-10-08/东方日升新能源股份有限公司网络拓扑图20201126.vsdx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/钟建宇/2021-10-08/东方日升新能源股份有限公司网络拓扑图20201126.vsdx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [1/297] OK: 东方日升新能源股份有限公司网络拓扑图20201126.vsdx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [1/297] FAIL: 东方日升新能源股份有限公司网络拓扑图20201126.vsdx (empty file)"
      rm -f "D:/myfiles/钉钉同步/钟建宇/2021-10-08/东方日升新能源股份有限公司网络拓扑图20201126.vsdx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [1/297] FAIL: 东方日升新能源股份有限公司网络拓扑图20201126.vsdx (curl error)"
    rm -f "D:/myfiles/钉钉同步/钟建宇/2021-10-08/东方日升新能源股份有限公司网络拓扑图20201126.vsdx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [1/297] EXPIRED: 东方日升新能源股份有限公司网络拓扑图20201126.vsdx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [2/297] RestCloud系统二次开发手册V4.5.pdf
mkdir -p "D:/myfiles/钉钉同步/APIS集成开发运维群/2023-02-14"
RESULT=$(dws drive download --file-id "96345079925" --space-id "6478132054" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/APIS集成开发运维群/2023-02-14/RestCloud系统二次开发手册V4.5.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/APIS集成开发运维群/2023-02-14/RestCloud系统二次开发手册V4.5.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [2/297] OK: RestCloud系统二次开发手册V4.5.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [2/297] FAIL: RestCloud系统二次开发手册V4.5.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/APIS集成开发运维群/2023-02-14/RestCloud系统二次开发手册V4.5.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [2/297] FAIL: RestCloud系统二次开发手册V4.5.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/APIS集成开发运维群/2023-02-14/RestCloud系统二次开发手册V4.5.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [2/297] EXPIRED: RestCloud系统二次开发手册V4.5.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [3/297] 聚光硅业邮箱开通人员名单.xlsx
mkdir -p "D:/myfiles/钉钉同步/张津泽/2021-05-07"
RESULT=$(dws drive download --file-id "34566182525" --space-id "2724214635" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/张津泽/2021-05-07/聚光硅业邮箱开通人员名单.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/张津泽/2021-05-07/聚光硅业邮箱开通人员名单.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [3/297] OK: 聚光硅业邮箱开通人员名单.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [3/297] FAIL: 聚光硅业邮箱开通人员名单.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/张津泽/2021-05-07/聚光硅业邮箱开通人员名单.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [3/297] FAIL: 聚光硅业邮箱开通人员名单.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/张津泽/2021-05-07/聚光硅业邮箱开通人员名单.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [3/297] EXPIRED: 聚光硅业邮箱开通人员名单.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [4/297] regedomain.bat
mkdir -p "D:/myfiles/钉钉同步/张津泽/2021-04-20"
RESULT=$(dws drive download --file-id "33681371656" --space-id "2724214635" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/张津泽/2021-04-20/regedomain.bat" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/张津泽/2021-04-20/regedomain.bat" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [4/297] OK: regedomain.bat ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [4/297] FAIL: regedomain.bat (empty file)"
      rm -f "D:/myfiles/钉钉同步/张津泽/2021-04-20/regedomain.bat"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [4/297] FAIL: regedomain.bat (curl error)"
    rm -f "D:/myfiles/钉钉同步/张津泽/2021-04-20/regedomain.bat"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [4/297] EXPIRED: regedomain.bat"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [5/297] 客户端域问题恢复脚本.txt
mkdir -p "D:/myfiles/钉钉同步/张津泽/2021-04-20"
RESULT=$(dws drive download --file-id "33681017933" --space-id "2724214635" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/张津泽/2021-04-20/客户端域问题恢复脚本.txt" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/张津泽/2021-04-20/客户端域问题恢复脚本.txt" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [5/297] OK: 客户端域问题恢复脚本.txt ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [5/297] FAIL: 客户端域问题恢复脚本.txt (empty file)"
      rm -f "D:/myfiles/钉钉同步/张津泽/2021-04-20/客户端域问题恢复脚本.txt"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [5/297] FAIL: 客户端域问题恢复脚本.txt (curl error)"
    rm -f "D:/myfiles/钉钉同步/张津泽/2021-04-20/客户端域问题恢复脚本.txt"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [5/297] EXPIRED: 客户端域问题恢复脚本.txt"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [6/297] umail合同.pdf
mkdir -p "D:/myfiles/钉钉同步/张津泽/2021-04-09"
RESULT=$(dws drive download --file-id "33084921388" --space-id "2724214635" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/张津泽/2021-04-09/umail合同.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/张津泽/2021-04-09/umail合同.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [6/297] OK: umail合同.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [6/297] FAIL: umail合同.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/张津泽/2021-04-09/umail合同.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [6/297] FAIL: umail合同.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/张津泽/2021-04-09/umail合同.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [6/297] EXPIRED: umail合同.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [7/297] 阿里英文官网续费 20210401.pdf
mkdir -p "D:/myfiles/钉钉同步/张津泽/2021-04-09"
RESULT=$(dws drive download --file-id "33081594527" --space-id "2724214635" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/张津泽/2021-04-09/阿里英文官网续费 20210401.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/张津泽/2021-04-09/阿里英文官网续费 20210401.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [7/297] OK: 阿里英文官网续费 20210401.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [7/297] FAIL: 阿里英文官网续费 20210401.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/张津泽/2021-04-09/阿里英文官网续费 20210401.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [7/297] FAIL: 阿里英文官网续费 20210401.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/张津泽/2021-04-09/阿里英文官网续费 20210401.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [7/297] EXPIRED: 阿里英文官网续费 20210401.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [8/297] EdgeRouter_ER-X_QSG_V06_CN.pdf
mkdir -p "D:/myfiles/钉钉同步/许明胜/2021-05-26"
RESULT=$(dws drive download --file-id "35596809999" --space-id "4262480333" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/许明胜/2021-05-26/EdgeRouter_ER-X_QSG_V06_CN.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/许明胜/2021-05-26/EdgeRouter_ER-X_QSG_V06_CN.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [8/297] OK: EdgeRouter_ER-X_QSG_V06_CN.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [8/297] FAIL: EdgeRouter_ER-X_QSG_V06_CN.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/许明胜/2021-05-26/EdgeRouter_ER-X_QSG_V06_CN.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [8/297] FAIL: EdgeRouter_ER-X_QSG_V06_CN.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/许明胜/2021-05-26/EdgeRouter_ER-X_QSG_V06_CN.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [8/297] EXPIRED: EdgeRouter_ER-X_QSG_V06_CN.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [9/297] UPWAN-Client-Risen.exe
mkdir -p "D:/myfiles/钉钉同步/许明胜/2021-05-26"
RESULT=$(dws drive download --file-id "35596736338" --space-id "4262480333" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/许明胜/2021-05-26/UPWAN-Client-Risen.exe" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/许明胜/2021-05-26/UPWAN-Client-Risen.exe" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [9/297] OK: UPWAN-Client-Risen.exe ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [9/297] FAIL: UPWAN-Client-Risen.exe (empty file)"
      rm -f "D:/myfiles/钉钉同步/许明胜/2021-05-26/UPWAN-Client-Risen.exe"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [9/297] FAIL: UPWAN-Client-Risen.exe (curl error)"
    rm -f "D:/myfiles/钉钉同步/许明胜/2021-05-26/UPWAN-Client-Risen.exe"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [9/297] EXPIRED: UPWAN-Client-Risen.exe"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [10/297] Enterprise VPN Client Configuration Description_8.pdf
mkdir -p "D:/myfiles/钉钉同步/许明胜/2021-05-26"
RESULT=$(dws drive download --file-id "35596736276" --space-id "4262480333" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/许明胜/2021-05-26/Enterprise VPN Client Configuration Description_8.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/许明胜/2021-05-26/Enterprise VPN Client Configuration Description_8.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [10/297] OK: Enterprise VPN Client Configuration Description_8.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [10/297] FAIL: Enterprise VPN Client Configuration Description_8.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/许明胜/2021-05-26/Enterprise VPN Client Configuration Description_8.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [10/297] FAIL: Enterprise VPN Client Configuration Description_8.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/许明胜/2021-05-26/Enterprise VPN Client Configuration Description_8.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [10/297] EXPIRED: Enterprise VPN Client Configuration Description_8.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [11/297] 企业VPN客户端配置说明.pdf
mkdir -p "D:/myfiles/钉钉同步/许明胜/2021-05-26"
RESULT=$(dws drive download --file-id "35596666183" --space-id "4262480333" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/许明胜/2021-05-26/企业VPN客户端配置说明.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/许明胜/2021-05-26/企业VPN客户端配置说明.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [11/297] OK: 企业VPN客户端配置说明.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [11/297] FAIL: 企业VPN客户端配置说明.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/许明胜/2021-05-26/企业VPN客户端配置说明.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [11/297] FAIL: 企业VPN客户端配置说明.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/许明胜/2021-05-26/企业VPN客户端配置说明.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [11/297] EXPIRED: 企业VPN客户端配置说明.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [12/297] SLA中文简体.docx
mkdir -p "D:/myfiles/钉钉同步/许明胜/2021-05-25"
RESULT=$(dws drive download --file-id "35536117203" --space-id "4262480333" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/许明胜/2021-05-25/SLA中文简体.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/许明胜/2021-05-25/SLA中文简体.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [12/297] OK: SLA中文简体.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [12/297] FAIL: SLA中文简体.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/许明胜/2021-05-25/SLA中文简体.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [12/297] FAIL: SLA中文简体.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/许明胜/2021-05-25/SLA中文简体.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [12/297] EXPIRED: SLA中文简体.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [13/297] 3437834__risen.com_iis.zip
mkdir -p "D:/myfiles/钉钉同步/许明胜/2021-05-24"
RESULT=$(dws drive download --file-id "35457604211" --space-id "4262480333" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/许明胜/2021-05-24/3437834__risen.com_iis.zip" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/许明胜/2021-05-24/3437834__risen.com_iis.zip" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [13/297] OK: 3437834__risen.com_iis.zip ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [13/297] FAIL: 3437834__risen.com_iis.zip (empty file)"
      rm -f "D:/myfiles/钉钉同步/许明胜/2021-05-24/3437834__risen.com_iis.zip"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [13/297] FAIL: 3437834__risen.com_iis.zip (curl error)"
    rm -f "D:/myfiles/钉钉同步/许明胜/2021-05-24/3437834__risen.com_iis.zip"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [13/297] EXPIRED: 3437834__risen.com_iis.zip"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [14/297] 滁州基地弱电项目评定会议纪要.xlsx
mkdir -p "D:/myfiles/钉钉同步/许明胜/2021-04-08"
RESULT=$(dws drive download --file-id "33030184578" --space-id "4262480333" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/许明胜/2021-04-08/滁州基地弱电项目评定会议纪要.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/许明胜/2021-04-08/滁州基地弱电项目评定会议纪要.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [14/297] OK: 滁州基地弱电项目评定会议纪要.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [14/297] FAIL: 滁州基地弱电项目评定会议纪要.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/许明胜/2021-04-08/滁州基地弱电项目评定会议纪要.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [14/297] FAIL: 滁州基地弱电项目评定会议纪要.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/许明胜/2021-04-08/滁州基地弱电项目评定会议纪要.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [14/297] EXPIRED: 滁州基地弱电项目评定会议纪要.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [15/297] modulemes-re-info.log
mkdir -p "D:/myfiles/钉钉同步/滁州自研MES实施/2024-11-21"
RESULT=$(dws drive download --file-id "160743691586" --space-id "25440379287" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/滁州自研MES实施/2024-11-21/modulemes-re-info.log" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/滁州自研MES实施/2024-11-21/modulemes-re-info.log" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [15/297] OK: modulemes-re-info.log ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [15/297] FAIL: modulemes-re-info.log (empty file)"
      rm -f "D:/myfiles/钉钉同步/滁州自研MES实施/2024-11-21/modulemes-re-info.log"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [15/297] FAIL: modulemes-re-info.log (curl error)"
    rm -f "D:/myfiles/钉钉同步/滁州自研MES实施/2024-11-21/modulemes-re-info.log"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [15/297] EXPIRED: modulemes-re-info.log"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [16/297] 组件MES服务器架构-滁州V1.1.xlsx
mkdir -p "D:/myfiles/钉钉同步/滁州自研MES实施/2024-11-21"
RESULT=$(dws drive download --file-id "160672756803" --space-id "25440379287" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/滁州自研MES实施/2024-11-21/组件MES服务器架构-滁州V1.1.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/滁州自研MES实施/2024-11-21/组件MES服务器架构-滁州V1.1.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [16/297] OK: 组件MES服务器架构-滁州V1.1.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [16/297] FAIL: 组件MES服务器架构-滁州V1.1.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/滁州自研MES实施/2024-11-21/组件MES服务器架构-滁州V1.1.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [16/297] FAIL: 组件MES服务器架构-滁州V1.1.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/滁州自研MES实施/2024-11-21/组件MES服务器架构-滁州V1.1.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [16/297] EXPIRED: 组件MES服务器架构-滁州V1.1.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [17/297] 组件车间组织编码(1).xlsx
mkdir -p "D:/myfiles/钉钉同步/滁州自研MES实施/2024-11-07"
RESULT=$(dws drive download --file-id "159182458254" --space-id "25440379287" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/滁州自研MES实施/2024-11-07/组件车间组织编码(1).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/滁州自研MES实施/2024-11-07/组件车间组织编码(1).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [17/297] OK: 组件车间组织编码(1).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [17/297] FAIL: 组件车间组织编码(1).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/滁州自研MES实施/2024-11-07/组件车间组织编码(1).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [17/297] FAIL: 组件车间组织编码(1).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/滁州自研MES实施/2024-11-07/组件车间组织编码(1).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [17/297] EXPIRED: 组件车间组织编码(1).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [18/297] 阿里云运维架构实践秘籍.pptx
mkdir -p "D:/myfiles/钉钉同步/王瑾/2023-12-18"
RESULT=$(dws drive download --file-id "126043947243" --space-id "22784128032" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/王瑾/2023-12-18/阿里云运维架构实践秘籍.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/王瑾/2023-12-18/阿里云运维架构实践秘籍.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [18/297] OK: 阿里云运维架构实践秘籍.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [18/297] FAIL: 阿里云运维架构实践秘籍.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/王瑾/2023-12-18/阿里云运维架构实践秘籍.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [18/297] FAIL: 阿里云运维架构实践秘籍.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/王瑾/2023-12-18/阿里云运维架构实践秘籍.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [18/297] EXPIRED: 阿里云运维架构实践秘籍.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [19/297] 团建签到表 - 模板.xls
mkdir -p "D:/myfiles/钉钉同步/王瑾/2023-12-13"
RESULT=$(dws drive download --file-id "LeBq413JAwppqgaAUkpqOLDlWDOnGvpb" --space-id "22784128032" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/王瑾/2023-12-13/团建签到表 - 模板.xls" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/王瑾/2023-12-13/团建签到表 - 模板.xls" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [19/297] OK: 团建签到表 - 模板.xls ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [19/297] FAIL: 团建签到表 - 模板.xls (empty file)"
      rm -f "D:/myfiles/钉钉同步/王瑾/2023-12-13/团建签到表 - 模板.xls"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [19/297] FAIL: 团建签到表 - 模板.xls (curl error)"
    rm -f "D:/myfiles/钉钉同步/王瑾/2023-12-13/团建签到表 - 模板.xls"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [19/297] EXPIRED: 团建签到表 - 模板.xls"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [20/297] 发票承诺函.docx
mkdir -p "D:/myfiles/钉钉同步/王瑾/2023-12-13"
RESULT=$(dws drive download --file-id "0eMKjyp81311ZEqAtoaZyMEXVxAZB1Gv" --space-id "22784128032" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/王瑾/2023-12-13/发票承诺函.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/王瑾/2023-12-13/发票承诺函.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [20/297] OK: 发票承诺函.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [20/297] FAIL: 发票承诺函.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/王瑾/2023-12-13/发票承诺函.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [20/297] FAIL: 发票承诺函.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/王瑾/2023-12-13/发票承诺函.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [20/297] EXPIRED: 发票承诺函.docx"
  EXPIRE=$((EXPIRE+1))
fi
echo "Progress: 20/$TOTAL done"
sleep 0.2

# [21/297] 端午节值班表6.19-6.21.xlsx
mkdir -p "D:/myfiles/钉钉同步/IT各组负责人群/2026-06-04"
RESULT=$(dws drive download --file-id "y20BglGWO23knzGvF0A6j5wZ8A7depqY" --space-id "27744167514" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/IT各组负责人群/2026-06-04/端午节值班表6.19-6.21.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/IT各组负责人群/2026-06-04/端午节值班表6.19-6.21.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [21/297] OK: 端午节值班表6.19-6.21.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [21/297] FAIL: 端午节值班表6.19-6.21.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/IT各组负责人群/2026-06-04/端午节值班表6.19-6.21.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [21/297] FAIL: 端午节值班表6.19-6.21.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/IT各组负责人群/2026-06-04/端午节值班表6.19-6.21.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [21/297] EXPIRED: 端午节值班表6.19-6.21.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [22/297] 证书收集-2026.5.6.xlsx
mkdir -p "D:/myfiles/钉钉同步/IT各组负责人群/2026-05-06"
RESULT=$(dws drive download --file-id "1R7q3QmWeekOnGlyfZmKnyOaWxkXOEP2" --space-id "27744167514" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/IT各组负责人群/2026-05-06/证书收集-2026.5.6.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/IT各组负责人群/2026-05-06/证书收集-2026.5.6.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [22/297] OK: 证书收集-2026.5.6.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [22/297] FAIL: 证书收集-2026.5.6.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/IT各组负责人群/2026-05-06/证书收集-2026.5.6.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [22/297] FAIL: 证书收集-2026.5.6.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/IT各组负责人群/2026-05-06/证书收集-2026.5.6.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [22/297] EXPIRED: 证书收集-2026.5.6.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [23/297] 五一劳动节值班表5.1—5.5.xlsx
mkdir -p "D:/myfiles/钉钉同步/IT各组负责人群/2026-04-20"
RESULT=$(dws drive download --file-id "Amq4vjg8904PxBZXFPovzlQ6J3kdP0wQ" --space-id "27744167514" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/IT各组负责人群/2026-04-20/五一劳动节值班表5.1—5.5.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/IT各组负责人群/2026-04-20/五一劳动节值班表5.1—5.5.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [23/297] OK: 五一劳动节值班表5.1—5.5.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [23/297] FAIL: 五一劳动节值班表5.1—5.5.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/IT各组负责人群/2026-04-20/五一劳动节值班表5.1—5.5.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [23/297] FAIL: 五一劳动节值班表5.1—5.5.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/IT各组负责人群/2026-04-20/五一劳动节值班表5.1—5.5.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [23/297] EXPIRED: 五一劳动节值班表5.1—5.5.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [24/297] 流程与信息中心-清明节值班表.xlsx
mkdir -p "D:/myfiles/钉钉同步/IT各组负责人群/2026-03-23"
RESULT=$(dws drive download --file-id "3NwLYZXWyn54GZrQCQk2l2zzVkyEqBQm" --space-id "27744167514" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/IT各组负责人群/2026-03-23/流程与信息中心-清明节值班表.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/IT各组负责人群/2026-03-23/流程与信息中心-清明节值班表.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [24/297] OK: 流程与信息中心-清明节值班表.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [24/297] FAIL: 流程与信息中心-清明节值班表.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/IT各组负责人群/2026-03-23/流程与信息中心-清明节值班表.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [24/297] FAIL: 流程与信息中心-清明节值班表.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/IT各组负责人群/2026-03-23/流程与信息中心-清明节值班表.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [24/297] EXPIRED: 流程与信息中心-清明节值班表.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [25/297] 信息化需求汇总（2025需求梳理）.xlsx
mkdir -p "D:/myfiles/钉钉同步/IT各组负责人群/2026-02-01"
RESULT=$(dws drive download --file-id "NkDwLng8ZLAn4yQzhMR3BQq6VKMEvZBY" --space-id "27744167514" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/IT各组负责人群/2026-02-01/信息化需求汇总（2025需求梳理）.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/IT各组负责人群/2026-02-01/信息化需求汇总（2025需求梳理）.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [25/297] OK: 信息化需求汇总（2025需求梳理）.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [25/297] FAIL: 信息化需求汇总（2025需求梳理）.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/IT各组负责人群/2026-02-01/信息化需求汇总（2025需求梳理）.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [25/297] FAIL: 信息化需求汇总（2025需求梳理）.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/IT各组负责人群/2026-02-01/信息化需求汇总（2025需求梳理）.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [25/297] EXPIRED: 信息化需求汇总（2025需求梳理）.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [26/297] 流程与信息中心-休假汇总-2026.xlsx
mkdir -p "D:/myfiles/钉钉同步/IT各组负责人群/2026-01-28"
RESULT=$(dws drive download --file-id "MyQA2dXW7eG25qoNfkxE0ONrJzlwrZgb" --space-id "27744167514" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/IT各组负责人群/2026-01-28/流程与信息中心-休假汇总-2026.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/IT各组负责人群/2026-01-28/流程与信息中心-休假汇总-2026.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [26/297] OK: 流程与信息中心-休假汇总-2026.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [26/297] FAIL: 流程与信息中心-休假汇总-2026.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/IT各组负责人群/2026-01-28/流程与信息中心-休假汇总-2026.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [26/297] FAIL: 流程与信息中心-休假汇总-2026.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/IT各组负责人群/2026-01-28/流程与信息中心-休假汇总-2026.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [26/297] EXPIRED: 流程与信息中心-休假汇总-2026.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [27/297] 2026资产预算表单-流程与信息中心.xlsx
mkdir -p "D:/myfiles/钉钉同步/IT各组负责人群/2025-11-25"
RESULT=$(dws drive download --file-id "NkDwLng8ZLAn4yQzhew9QLRjVKMEvZBY" --space-id "27744167514" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/IT各组负责人群/2025-11-25/2026资产预算表单-流程与信息中心.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/IT各组负责人群/2025-11-25/2026资产预算表单-流程与信息中心.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [27/297] OK: 2026资产预算表单-流程与信息中心.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [27/297] FAIL: 2026资产预算表单-流程与信息中心.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/IT各组负责人群/2025-11-25/2026资产预算表单-流程与信息中心.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [27/297] FAIL: 2026资产预算表单-流程与信息中心.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/IT各组负责人群/2025-11-25/2026资产预算表单-流程与信息中心.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [27/297] EXPIRED: 2026资产预算表单-流程与信息中心.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [28/297] 2026年全面预算编制流程与信息中心（总部）_20251117.xlsx
mkdir -p "D:/myfiles/钉钉同步/IT各组负责人群/2025-11-17"
RESULT=$(dws drive download --file-id "200920398322" --space-id "27744167514" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/IT各组负责人群/2025-11-17/2026年全面预算编制流程与信息中心（总部）_20251117.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/IT各组负责人群/2025-11-17/2026年全面预算编制流程与信息中心（总部）_20251117.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [28/297] OK: 2026年全面预算编制流程与信息中心（总部）_20251117.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [28/297] FAIL: 2026年全面预算编制流程与信息中心（总部）_20251117.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/IT各组负责人群/2025-11-17/2026年全面预算编制流程与信息中心（总部）_20251117.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [28/297] FAIL: 2026年全面预算编制流程与信息中心（总部）_20251117.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/IT各组负责人群/2025-11-17/2026年全面预算编制流程与信息中心（总部）_20251117.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [28/297] EXPIRED: 2026年全面预算编制流程与信息中心（总部）_20251117.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [29/297] AD域控对接账号有效期盘点.xlsx
mkdir -p "D:/myfiles/钉钉同步/IT各组负责人群/2025-11-12"
RESULT=$(dws drive download --file-id "pYLaezmVNeYNl2G4fg4yMOxZWrMqPxX6" --space-id "27744167514" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/IT各组负责人群/2025-11-12/AD域控对接账号有效期盘点.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/IT各组负责人群/2025-11-12/AD域控对接账号有效期盘点.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [29/297] OK: AD域控对接账号有效期盘点.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [29/297] FAIL: AD域控对接账号有效期盘点.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/IT各组负责人群/2025-11-12/AD域控对接账号有效期盘点.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [29/297] FAIL: AD域控对接账号有效期盘点.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/IT各组负责人群/2025-11-12/AD域控对接账号有效期盘点.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [29/297] EXPIRED: AD域控对接账号有效期盘点.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [30/297] 项目周例会纪要20260601.xlsx
mkdir -p "D:/myfiles/钉钉同步/会议纪要内容确认/2026-06-01"
RESULT=$(dws drive download --file-id "7QG4Yx2JpLkmBAo5TglQXAK9J9dEq3XD" --space-id "28915766417" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/会议纪要内容确认/2026-06-01/项目周例会纪要20260601.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/会议纪要内容确认/2026-06-01/项目周例会纪要20260601.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [30/297] OK: 项目周例会纪要20260601.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [30/297] FAIL: 项目周例会纪要20260601.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/会议纪要内容确认/2026-06-01/项目周例会纪要20260601.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [30/297] FAIL: 项目周例会纪要20260601.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/会议纪要内容确认/2026-06-01/项目周例会纪要20260601.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [30/297] EXPIRED: 项目周例会纪要20260601.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [31/297] 项目周例会纪要20260525.xlsx
mkdir -p "D:/myfiles/钉钉同步/会议纪要内容确认/2026-05-25"
RESULT=$(dws drive download --file-id "7QG4Yx2JpLkmBAo5TgBo4wzEJ9dEq3XD" --space-id "28915766417" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/会议纪要内容确认/2026-05-25/项目周例会纪要20260525.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/会议纪要内容确认/2026-05-25/项目周例会纪要20260525.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [31/297] OK: 项目周例会纪要20260525.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [31/297] FAIL: 项目周例会纪要20260525.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/会议纪要内容确认/2026-05-25/项目周例会纪要20260525.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [31/297] FAIL: 项目周例会纪要20260525.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/会议纪要内容确认/2026-05-25/项目周例会纪要20260525.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [31/297] EXPIRED: 项目周例会纪要20260525.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [32/297] 电池图片存储需求.xlsx
mkdir -p "D:/myfiles/钉钉同步/胡延骏/2021-04-21"
RESULT=$(dws drive download --file-id "33729097976" --space-id "4658921784" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/胡延骏/2021-04-21/电池图片存储需求.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/胡延骏/2021-04-21/电池图片存储需求.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [32/297] OK: 电池图片存储需求.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [32/297] FAIL: 电池图片存储需求.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/胡延骏/2021-04-21/电池图片存储需求.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [32/297] FAIL: 电池图片存储需求.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/胡延骏/2021-04-21/电池图片存储需求.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [32/297] EXPIRED: 电池图片存储需求.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [33/297] 车间测试数据存储RFQ(1).docx
mkdir -p "D:/myfiles/钉钉同步/胡延骏/2021-04-20"
RESULT=$(dws drive download --file-id "33697197653" --space-id "4658921784" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/胡延骏/2021-04-20/车间测试数据存储RFQ(1).docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/胡延骏/2021-04-20/车间测试数据存储RFQ(1).docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [33/297] OK: 车间测试数据存储RFQ(1).docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [33/297] FAIL: 车间测试数据存储RFQ(1).docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/胡延骏/2021-04-20/车间测试数据存储RFQ(1).docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [33/297] FAIL: 车间测试数据存储RFQ(1).docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/胡延骏/2021-04-20/车间测试数据存储RFQ(1).docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [33/297] EXPIRED: 车间测试数据存储RFQ(1).docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [34/297] 车间测试数据存储RFQ.pdf
mkdir -p "D:/myfiles/钉钉同步/胡延骏/2021-04-20"
RESULT=$(dws drive download --file-id "33695525662" --space-id "4658921784" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/胡延骏/2021-04-20/车间测试数据存储RFQ.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/胡延骏/2021-04-20/车间测试数据存储RFQ.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [34/297] OK: 车间测试数据存储RFQ.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [34/297] FAIL: 车间测试数据存储RFQ.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/胡延骏/2021-04-20/车间测试数据存储RFQ.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [34/297] FAIL: 车间测试数据存储RFQ.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/胡延骏/2021-04-20/车间测试数据存储RFQ.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [34/297] EXPIRED: 车间测试数据存储RFQ.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [35/297] 2026东方日升钓鱼demo.docx
mkdir -p "D:/myfiles/钉钉同步/郑晓阳/2026-04-27"
RESULT=$(dws drive download --file-id "b9Y4gmKWrPY2O3yktjB4pONQJGXn6lpz" --space-id "27813199972" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/郑晓阳/2026-04-27/2026东方日升钓鱼demo.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/郑晓阳/2026-04-27/2026东方日升钓鱼demo.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [35/297] OK: 2026东方日升钓鱼demo.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [35/297] FAIL: 2026东方日升钓鱼demo.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/郑晓阳/2026-04-27/2026东方日升钓鱼demo.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [35/297] FAIL: 2026东方日升钓鱼demo.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/郑晓阳/2026-04-27/2026东方日升钓鱼demo.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [35/297] EXPIRED: 2026东方日升钓鱼demo.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [36/297] 东方日升AE新一代防毒墙需求分析报告.docx
mkdir -p "D:/myfiles/钉钉同步/郑晓阳/2026-04-15"
RESULT=$(dws drive download --file-id "yQod3RxJKGR4ZdxLI4xLjypNJkb4Mw9r" --space-id "27813199972" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/郑晓阳/2026-04-15/东方日升AE新一代防毒墙需求分析报告.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/郑晓阳/2026-04-15/东方日升AE新一代防毒墙需求分析报告.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [36/297] OK: 东方日升AE新一代防毒墙需求分析报告.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [36/297] FAIL: 东方日升AE新一代防毒墙需求分析报告.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/郑晓阳/2026-04-15/东方日升AE新一代防毒墙需求分析报告.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [36/297] FAIL: 东方日升AE新一代防毒墙需求分析报告.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/郑晓阳/2026-04-15/东方日升AE新一代防毒墙需求分析报告.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [36/297] EXPIRED: 东方日升AE新一代防毒墙需求分析报告.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [37/297] 一阶段需收集资料清单0724.xlsx
mkdir -p "D:/myfiles/钉钉同步/ISO27001_27701项目交流-东方日升/2025-07-24"
RESULT=$(dws drive download --file-id "1R7q3QmWeeRdp6MjF7jKLw62WxkXOEP2" --space-id "26939053196" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/ISO27001_27701项目交流-东方日升/2025-07-24/一阶段需收集资料清单0724.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/ISO27001_27701项目交流-东方日升/2025-07-24/一阶段需收集资料清单0724.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [37/297] OK: 一阶段需收集资料清单0724.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [37/297] FAIL: 一阶段需收集资料清单0724.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/ISO27001_27701项目交流-东方日升/2025-07-24/一阶段需收集资料清单0724.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [37/297] FAIL: 一阶段需收集资料清单0724.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/ISO27001_27701项目交流-东方日升/2025-07-24/一阶段需收集资料清单0724.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [37/297] EXPIRED: 一阶段需收集资料清单0724.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [38/297] _399_convocatoriaalmacenamientofeder21-27_coad (1).pdf
mkdir -p "D:/myfiles/钉钉同步/ISO27001_27701项目交流-东方日升/2025-07-23"
RESULT=$(dws drive download --file-id "1OQX0akWmxPGl6geCYDdxdLX8GlDd3mE" --space-id "26939053196" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/ISO27001_27701项目交流-东方日升/2025-07-23/_399_convocatoriaalmacenamientofeder21-27_coad (1).pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/ISO27001_27701项目交流-东方日升/2025-07-23/_399_convocatoriaalmacenamientofeder21-27_coad (1).pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [38/297] OK: _399_convocatoriaalmacenamientofeder21-27_coad (1).pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [38/297] FAIL: _399_convocatoriaalmacenamientofeder21-27_coad (1).pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/ISO27001_27701项目交流-东方日升/2025-07-23/_399_convocatoriaalmacenamientofeder21-27_coad (1).pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [38/297] FAIL: _399_convocatoriaalmacenamientofeder21-27_coad (1).pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/ISO27001_27701项目交流-东方日升/2025-07-23/_399_convocatoriaalmacenamientofeder21-27_coad (1).pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [38/297] EXPIRED: _399_convocatoriaalmacenamientofeder21-27_coad (1).pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [39/297] 东方日升组织架构图-对外版.pdf
mkdir -p "D:/myfiles/钉钉同步/ISO27001_27701项目交流-东方日升/2025-07-23"
RESULT=$(dws drive download --file-id "l6Pm2Db8D4nPe6myHqOAPzwd8xLq0Ee4" --space-id "26939053196" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/ISO27001_27701项目交流-东方日升/2025-07-23/东方日升组织架构图-对外版.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/ISO27001_27701项目交流-东方日升/2025-07-23/东方日升组织架构图-对外版.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [39/297] OK: 东方日升组织架构图-对外版.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [39/297] FAIL: 东方日升组织架构图-对外版.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/ISO27001_27701项目交流-东方日升/2025-07-23/东方日升组织架构图-对外版.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [39/297] FAIL: 东方日升组织架构图-对外版.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/ISO27001_27701项目交流-东方日升/2025-07-23/东方日升组织架构图-对外版.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [39/297] EXPIRED: 东方日升组织架构图-对外版.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [40/297] PQP_BESS_Annex 1_Application Form(1)(1)(2).docx
mkdir -p "D:/myfiles/钉钉同步/AKUO/2026-05-15"
RESULT=$(dws drive download --file-id "nYMoO1rWxazpReNnczojvZo3V47Z3je9" --space-id "28672435774" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/AKUO/2026-05-15/PQP_BESS_Annex 1_Application Form(1)(1)(2).docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/AKUO/2026-05-15/PQP_BESS_Annex 1_Application Form(1)(1)(2).docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [40/297] OK: PQP_BESS_Annex 1_Application Form(1)(1)(2).docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [40/297] FAIL: PQP_BESS_Annex 1_Application Form(1)(1)(2).docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/AKUO/2026-05-15/PQP_BESS_Annex 1_Application Form(1)(1)(2).docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [40/297] FAIL: PQP_BESS_Annex 1_Application Form(1)(1)(2).docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/AKUO/2026-05-15/PQP_BESS_Annex 1_Application Form(1)(1)(2).docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [40/297] EXPIRED: PQP_BESS_Annex 1_Application Form(1)(1)(2).docx"
  EXPIRE=$((EXPIRE+1))
fi
echo "Progress: 40/$TOTAL done"
sleep 0.2

# [41/297] PQP_BESS_Annex 1_Application Form(1)(1)(1).docx
mkdir -p "D:/myfiles/钉钉同步/AKUO/2026-05-05"
RESULT=$(dws drive download --file-id "LeBq413JAw6qvpLltr04Bp1RWDOnGvpb" --space-id "28672435774" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/AKUO/2026-05-05/PQP_BESS_Annex 1_Application Form(1)(1)(1).docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/AKUO/2026-05-05/PQP_BESS_Annex 1_Application Form(1)(1)(1).docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [41/297] OK: PQP_BESS_Annex 1_Application Form(1)(1)(1).docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [41/297] FAIL: PQP_BESS_Annex 1_Application Form(1)(1)(1).docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/AKUO/2026-05-05/PQP_BESS_Annex 1_Application Form(1)(1)(1).docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [41/297] FAIL: PQP_BESS_Annex 1_Application Form(1)(1)(1).docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/AKUO/2026-05-05/PQP_BESS_Annex 1_Application Form(1)(1)(1).docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [41/297] EXPIRED: PQP_BESS_Annex 1_Application Form(1)(1)(1).docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [42/297] PQP_BESS_Annex 1_Application Form(1)(1).docx
mkdir -p "D:/myfiles/钉钉同步/AKUO/2026-04-16"
RESULT=$(dws drive download --file-id "LeBq413JAw6qvpLltreABMD4WDOnGvpb" --space-id "28672435774" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/AKUO/2026-04-16/PQP_BESS_Annex 1_Application Form(1)(1).docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/AKUO/2026-04-16/PQP_BESS_Annex 1_Application Form(1)(1).docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [42/297] OK: PQP_BESS_Annex 1_Application Form(1)(1).docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [42/297] FAIL: PQP_BESS_Annex 1_Application Form(1)(1).docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/AKUO/2026-04-16/PQP_BESS_Annex 1_Application Form(1)(1).docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [42/297] FAIL: PQP_BESS_Annex 1_Application Form(1)(1).docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/AKUO/2026-04-16/PQP_BESS_Annex 1_Application Form(1)(1).docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [42/297] EXPIRED: PQP_BESS_Annex 1_Application Form(1)(1).docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [43/297] PQP_BESS_Annex 1_Application Form(2).docx
mkdir -p "D:/myfiles/钉钉同步/AKUO/2026-04-16"
RESULT=$(dws drive download --file-id "dxXB52LJqnMD2R4XCMlO6bBk8qjMp697" --space-id "28672435774" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/AKUO/2026-04-16/PQP_BESS_Annex 1_Application Form(2).docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/AKUO/2026-04-16/PQP_BESS_Annex 1_Application Form(2).docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [43/297] OK: PQP_BESS_Annex 1_Application Form(2).docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [43/297] FAIL: PQP_BESS_Annex 1_Application Form(2).docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/AKUO/2026-04-16/PQP_BESS_Annex 1_Application Form(2).docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [43/297] FAIL: PQP_BESS_Annex 1_Application Form(2).docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/AKUO/2026-04-16/PQP_BESS_Annex 1_Application Form(2).docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [43/297] EXPIRED: PQP_BESS_Annex 1_Application Form(2).docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [44/297] PQP_BESS_Annex 1_Application Form(1).docx
mkdir -p "D:/myfiles/钉钉同步/AKUO/2026-04-15"
RESULT=$(dws drive download --file-id "LeBq413JAw6qvpLltrgYgQBlWDOnGvpb" --space-id "28672435774" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/AKUO/2026-04-15/PQP_BESS_Annex 1_Application Form(1).docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/AKUO/2026-04-15/PQP_BESS_Annex 1_Application Form(1).docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [44/297] OK: PQP_BESS_Annex 1_Application Form(1).docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [44/297] FAIL: PQP_BESS_Annex 1_Application Form(1).docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/AKUO/2026-04-15/PQP_BESS_Annex 1_Application Form(1).docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [44/297] FAIL: PQP_BESS_Annex 1_Application Form(1).docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/AKUO/2026-04-15/PQP_BESS_Annex 1_Application Form(1).docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [44/297] EXPIRED: PQP_BESS_Annex 1_Application Form(1).docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [45/297] _PQP_BESS_Annex 5_Suppliers Conduct Code.pdf
mkdir -p "D:/myfiles/钉钉同步/AKUO/2026-04-14"
RESULT=$(dws drive download --file-id "7dx2rn0JbYB1GDgEu6pkDMLLVMGjLRb3" --space-id "28672435774" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/AKUO/2026-04-14/_PQP_BESS_Annex 5_Suppliers Conduct Code.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/AKUO/2026-04-14/_PQP_BESS_Annex 5_Suppliers Conduct Code.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [45/297] OK: _PQP_BESS_Annex 5_Suppliers Conduct Code.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [45/297] FAIL: _PQP_BESS_Annex 5_Suppliers Conduct Code.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/AKUO/2026-04-14/_PQP_BESS_Annex 5_Suppliers Conduct Code.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [45/297] FAIL: _PQP_BESS_Annex 5_Suppliers Conduct Code.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/AKUO/2026-04-14/_PQP_BESS_Annex 5_Suppliers Conduct Code.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [45/297] EXPIRED: _PQP_BESS_Annex 5_Suppliers Conduct Code.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [46/297] PQP_BESS_Annex 4_Termsheet.xlsx
mkdir -p "D:/myfiles/钉钉同步/AKUO/2026-04-14"
RESULT=$(dws drive download --file-id "Amq4vjg890BYQmLlCQAyK9rdJ3kdP0wQ" --space-id "28672435774" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/AKUO/2026-04-14/PQP_BESS_Annex 4_Termsheet.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/AKUO/2026-04-14/PQP_BESS_Annex 4_Termsheet.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [46/297] OK: PQP_BESS_Annex 4_Termsheet.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [46/297] FAIL: PQP_BESS_Annex 4_Termsheet.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/AKUO/2026-04-14/PQP_BESS_Annex 4_Termsheet.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [46/297] FAIL: PQP_BESS_Annex 4_Termsheet.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/AKUO/2026-04-14/PQP_BESS_Annex 4_Termsheet.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [46/297] EXPIRED: PQP_BESS_Annex 4_Termsheet.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [47/297] PQP_BESS_Annex 3_Supply chain.xlsx
mkdir -p "D:/myfiles/钉钉同步/AKUO/2026-04-14"
RESULT=$(dws drive download --file-id "yQod3RxJKGk12rqlSOXvqByLJkb4Mw9r" --space-id "28672435774" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/AKUO/2026-04-14/PQP_BESS_Annex 3_Supply chain.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/AKUO/2026-04-14/PQP_BESS_Annex 3_Supply chain.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [47/297] OK: PQP_BESS_Annex 3_Supply chain.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [47/297] FAIL: PQP_BESS_Annex 3_Supply chain.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/AKUO/2026-04-14/PQP_BESS_Annex 3_Supply chain.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [47/297] FAIL: PQP_BESS_Annex 3_Supply chain.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/AKUO/2026-04-14/PQP_BESS_Annex 3_Supply chain.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [47/297] EXPIRED: PQP_BESS_Annex 3_Supply chain.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [48/297] PQP_BESS_Annex 1_Application Form.docx
mkdir -p "D:/myfiles/钉钉同步/AKUO/2026-04-14"
RESULT=$(dws drive download --file-id "R4GpnMqJzGazb7XRSqe1QkRA8Ke0xjE3" --space-id "28672435774" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/AKUO/2026-04-14/PQP_BESS_Annex 1_Application Form.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/AKUO/2026-04-14/PQP_BESS_Annex 1_Application Form.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [48/297] OK: PQP_BESS_Annex 1_Application Form.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [48/297] FAIL: PQP_BESS_Annex 1_Application Form.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/AKUO/2026-04-14/PQP_BESS_Annex 1_Application Form.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [48/297] FAIL: PQP_BESS_Annex 1_Application Form.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/AKUO/2026-04-14/PQP_BESS_Annex 1_Application Form.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [48/297] EXPIRED: PQP_BESS_Annex 1_Application Form.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [49/297] PQP_BESS_Pre-Qualification Package instructions.pdf
mkdir -p "D:/myfiles/钉钉同步/AKUO/2026-04-14"
RESULT=$(dws drive download --file-id "MyQA2dXW7eq0Q1LlHMm0Rbv3JzlwrZgb" --space-id "28672435774" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/AKUO/2026-04-14/PQP_BESS_Pre-Qualification Package instructions.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/AKUO/2026-04-14/PQP_BESS_Pre-Qualification Package instructions.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [49/297] OK: PQP_BESS_Pre-Qualification Package instructions.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [49/297] FAIL: PQP_BESS_Pre-Qualification Package instructions.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/AKUO/2026-04-14/PQP_BESS_Pre-Qualification Package instructions.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [49/297] FAIL: PQP_BESS_Pre-Qualification Package instructions.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/AKUO/2026-04-14/PQP_BESS_Pre-Qualification Package instructions.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [49/297] EXPIRED: PQP_BESS_Pre-Qualification Package instructions.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [50/297] 网络故障登记表.xlsx
mkdir -p "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-11-24"
RESULT=$(dws drive download --file-id "AR4GpnMqJzBdMqBZIgnk6ApAJKe0xjE3" --space-id "5132577432" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-11-24/网络故障登记表.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-11-24/网络故障登记表.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [50/297] OK: 网络故障登记表.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [50/297] FAIL: 网络故障登记表.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-11-24/网络故障登记表.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [50/297] FAIL: 网络故障登记表.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-11-24/网络故障登记表.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [50/297] EXPIRED: 网络故障登记表.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [51/297] 软件商城名单.xlsx
mkdir -p "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-23"
RESULT=$(dws drive download --file-id "YMyQA2dXW7Dj9GDZCDq3PRxwVzlwrZgb" --space-id "5132577432" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-23/软件商城名单.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-23/软件商城名单.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [51/297] OK: 软件商城名单.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [51/297] FAIL: 软件商城名单.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-23/软件商城名单.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [51/297] FAIL: 软件商城名单.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-23/软件商城名单.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [51/297] EXPIRED: 软件商城名单.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [52/297] 6.2.1.95zBox_installer.exe
mkdir -p "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-15"
RESULT=$(dws drive download --file-id "YQBnd5ExVE7Kwz7yc76yO1378yeZqMmz" --space-id "5132577432" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-15/6.2.1.95zBox_installer.exe" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-15/6.2.1.95zBox_installer.exe" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [52/297] OK: 6.2.1.95zBox_installer.exe ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [52/297] FAIL: 6.2.1.95zBox_installer.exe (empty file)"
      rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-15/6.2.1.95zBox_installer.exe"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [52/297] FAIL: 6.2.1.95zBox_installer.exe (curl error)"
    rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-15/6.2.1.95zBox_installer.exe"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [52/297] EXPIRED: 6.2.1.95zBox_installer.exe"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [53/297] zBox_installer6.2.1.95(1).exe
mkdir -p "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-12"
RESULT=$(dws drive download --file-id "gwva2dxOW440KB43U40BNrO7Wbkz3BRL" --space-id "5132577432" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-12/zBox_installer6.2.1.95(1).exe" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-12/zBox_installer6.2.1.95(1).exe" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [53/297] OK: zBox_installer6.2.1.95(1).exe ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [53/297] FAIL: zBox_installer6.2.1.95(1).exe (empty file)"
      rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-12/zBox_installer6.2.1.95(1).exe"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [53/297] FAIL: zBox_installer6.2.1.95(1).exe (curl error)"
    rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-12/zBox_installer6.2.1.95(1).exe"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [53/297] EXPIRED: zBox_installer6.2.1.95(1).exe"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [54/297] 20250702使用7-zip制作单文件自运行安装包.pptx
mkdir -p "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-11"
RESULT=$(dws drive download --file-id "lyQod3RxJKyA3RyNcPG125gdWkb4Mw9r" --space-id "5132577432" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-11/20250702使用7-zip制作单文件自运行安装包.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-11/20250702使用7-zip制作单文件自运行安装包.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [54/297] OK: 20250702使用7-zip制作单文件自运行安装包.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [54/297] FAIL: 20250702使用7-zip制作单文件自运行安装包.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-11/20250702使用7-zip制作单文件自运行安装包.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [54/297] FAIL: 20250702使用7-zip制作单文件自运行安装包.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-11/20250702使用7-zip制作单文件自运行安装包.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [54/297] EXPIRED: 20250702使用7-zip制作单文件自运行安装包.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [55/297] 20241001普通用户提权解决方案.pptx
mkdir -p "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-11"
RESULT=$(dws drive download --file-id "MNDoBb60VLxer0xkHxPPev9DVlemrZQ3" --space-id "5132577432" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-11/20241001普通用户提权解决方案.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-11/20241001普通用户提权解决方案.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [55/297] OK: 20241001普通用户提权解决方案.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [55/297] FAIL: 20241001普通用户提权解决方案.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-11/20241001普通用户提权解决方案.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [55/297] FAIL: 20241001普通用户提权解决方案.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-11/20241001普通用户提权解决方案.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [55/297] EXPIRED: 20241001普通用户提权解决方案.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [56/297] 构建终端安全基础：Windows权限管控与运维实践.pptx
mkdir -p "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-11"
RESULT=$(dws drive download --file-id "dQPGYqjpJYjGgEjdH2ooZNeN8akx1Z5N" --space-id "5132577432" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-11/构建终端安全基础：Windows权限管控与运维实践.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-11/构建终端安全基础：Windows权限管控与运维实践.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [56/297] OK: 构建终端安全基础：Windows权限管控与运维实践.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [56/297] FAIL: 构建终端安全基础：Windows权限管控与运维实践.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-11/构建终端安全基础：Windows权限管控与运维实践.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [56/297] FAIL: 构建终端安全基础：Windows权限管控与运维实践.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-11/构建终端安全基础：Windows权限管控与运维实践.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [56/297] EXPIRED: 构建终端安全基础：Windows权限管控与运维实践.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [57/297] zBox_installer6.2.1.95.exe
mkdir -p "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-05"
RESULT=$(dws drive download --file-id "YQBnd5ExVE7Kwz7yc7k0EEGZ8yeZqMmz" --space-id "5132577432" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-05/zBox_installer6.2.1.95.exe" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-05/zBox_installer6.2.1.95.exe" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [57/297] OK: zBox_installer6.2.1.95.exe ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [57/297] FAIL: zBox_installer6.2.1.95.exe (empty file)"
      rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-05/zBox_installer6.2.1.95.exe"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [57/297] FAIL: zBox_installer6.2.1.95.exe (curl error)"
    rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-09-05/zBox_installer6.2.1.95.exe"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [57/297] EXPIRED: zBox_installer6.2.1.95.exe"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [58/297] 电脑缓解卡顿的操作步骤.docx
mkdir -p "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-08-26"
RESULT=$(dws drive download --file-id "N7dx2rn0JbmeZMmotqjpnyMMVMGjLRb3" --space-id "5132577432" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-08-26/电脑缓解卡顿的操作步骤.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-08-26/电脑缓解卡顿的操作步骤.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [58/297] OK: 电脑缓解卡顿的操作步骤.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [58/297] FAIL: 电脑缓解卡顿的操作步骤.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-08-26/电脑缓解卡顿的操作步骤.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [58/297] FAIL: 电脑缓解卡顿的操作步骤.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-08-26/电脑缓解卡顿的操作步骤.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [58/297] EXPIRED: 电脑缓解卡顿的操作步骤.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [59/297] Office未授权问题登记.xlsx
mkdir -p "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-08-26"
RESULT=$(dws drive download --file-id "amweZ92PV69qvA9pI9YqR6EyWxEKBD6p" --space-id "5132577432" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-08-26/Office未授权问题登记.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-08-26/Office未授权问题登记.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [59/297] OK: Office未授权问题登记.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [59/297] FAIL: Office未授权问题登记.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-08-26/Office未授权问题登记.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [59/297] FAIL: Office未授权问题登记.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/集团桌面运维对接群/2025-08-26/Office未授权问题登记.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [59/297] EXPIRED: Office未授权问题登记.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [60/297] 场景环节.xlsx
mkdir -p "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-28"
RESULT=$(dws drive download --file-id "4lgGw3P8vRbd6NjoSpZEMP2p85daZ90D" --space-id "28891907429" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-28/场景环节.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-28/场景环节.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [60/297] OK: 场景环节.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [60/297] FAIL: 场景环节.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-28/场景环节.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [60/297] FAIL: 场景环节.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-28/场景环节.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [60/297] EXPIRED: 场景环节.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
echo "Progress: 60/$TOTAL done"
sleep 0.2

# [61/297] 南滨智能工厂申报填写统计表(1).xlsx
mkdir -p "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-22"
RESULT=$(dws drive download --file-id "QBnd5ExVEvkbgre4T2bmkXq5JyeZqMmz" --space-id "28891907429" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-22/南滨智能工厂申报填写统计表(1).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-22/南滨智能工厂申报填写统计表(1).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [61/297] OK: 南滨智能工厂申报填写统计表(1).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [61/297] FAIL: 南滨智能工厂申报填写统计表(1).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-22/南滨智能工厂申报填写统计表(1).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [61/297] FAIL: 南滨智能工厂申报填写统计表(1).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-22/南滨智能工厂申报填写统计表(1).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [61/297] EXPIRED: 南滨智能工厂申报填写统计表(1).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [62/297] 南滨智能工厂申报填写统计表.xlsx
mkdir -p "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21"
RESULT=$(dws drive download --file-id "bva6QBXJwa3d0kNoC29lq2BzWn4qY5Pr" --space-id "28891907429" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21/南滨智能工厂申报填写统计表.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21/南滨智能工厂申报填写统计表.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [62/297] OK: 南滨智能工厂申报填写统计表.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [62/297] FAIL: 南滨智能工厂申报填写统计表.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21/南滨智能工厂申报填写统计表.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [62/297] FAIL: 南滨智能工厂申报填写统计表.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21/南滨智能工厂申报填写统计表.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [62/297] EXPIRED: 南滨智能工厂申报填写统计表.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [63/297] 卓越级智能工厂项目申报书（光伏科技）.doc
mkdir -p "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21"
RESULT=$(dws drive download --file-id "mweZ92PV6MYowEbdFK92Y4D4WxEKBD6p" --space-id "28891907429" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21/卓越级智能工厂项目申报书（光伏科技）.doc" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21/卓越级智能工厂项目申报书（光伏科技）.doc" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [63/297] OK: 卓越级智能工厂项目申报书（光伏科技）.doc ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [63/297] FAIL: 卓越级智能工厂项目申报书（光伏科技）.doc (empty file)"
      rm -f "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21/卓越级智能工厂项目申报书（光伏科技）.doc"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [63/297] FAIL: 卓越级智能工厂项目申报书（光伏科技）.doc (curl error)"
    rm -f "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21/卓越级智能工厂项目申报书（光伏科技）.doc"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [63/297] EXPIRED: 卓越级智能工厂项目申报书（光伏科技）.doc"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [64/297] 《智能制造典型场景参考指引（2025年版）》.pdf
mkdir -p "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21"
RESULT=$(dws drive download --file-id "9bN7RYPWdMwpKarBFk3mdAkYVZd1wyK0" --space-id "28891907429" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21/《智能制造典型场景参考指引（2025年版）》.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21/《智能制造典型场景参考指引（2025年版）》.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [64/297] OK: 《智能制造典型场景参考指引（2025年版）》.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [64/297] FAIL: 《智能制造典型场景参考指引（2025年版）》.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21/《智能制造典型场景参考指引（2025年版）》.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [64/297] FAIL: 《智能制造典型场景参考指引（2025年版）》.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21/《智能制造典型场景参考指引（2025年版）》.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [64/297] EXPIRED: 《智能制造典型场景参考指引（2025年版）》.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [65/297] 东方日升（宁波）光伏科技有限公司-浙江省-电子信息-卓越级智能工厂项目申报书.pdf
mkdir -p "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21"
RESULT=$(dws drive download --file-id "np9zOoBVBY93vMEdCLEygmADW1DK0g6l" --space-id "28891907429" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21/东方日升（宁波）光伏科技有限公司-浙江省-电子信息-卓越级智能工厂项目申报书.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21/东方日升（宁波）光伏科技有限公司-浙江省-电子信息-卓越级智能工厂项目申报书.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [65/297] OK: 东方日升（宁波）光伏科技有限公司-浙江省-电子信息-卓越级智能工厂项目申报书.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [65/297] FAIL: 东方日升（宁波）光伏科技有限公司-浙江省-电子信息-卓越级智能工厂项目申报书.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21/东方日升（宁波）光伏科技有限公司-浙江省-电子信息-卓越级智能工厂项目申报书.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [65/297] FAIL: 东方日升（宁波）光伏科技有限公司-浙江省-电子信息-卓越级智能工厂项目申报书.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/2026年南滨基地申报国家级卓越工厂项目/2026-05-21/东方日升（宁波）光伏科技有限公司-浙江省-电子信息-卓越级智能工厂项目申报书.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [65/297] EXPIRED: 东方日升（宁波）光伏科技有限公司-浙江省-电子信息-卓越级智能工厂项目申报书.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [66/297] 20230403东方日升机柜定点.xlsx
mkdir -p "D:/myfiles/钉钉同步/刘鹏程/2023-06-27"
RESULT=$(dws drive download --file-id "108474277900" --space-id "21272127035" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/刘鹏程/2023-06-27/20230403东方日升机柜定点.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/刘鹏程/2023-06-27/20230403东方日升机柜定点.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [66/297] OK: 20230403东方日升机柜定点.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [66/297] FAIL: 20230403东方日升机柜定点.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/刘鹏程/2023-06-27/20230403东方日升机柜定点.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [66/297] FAIL: 20230403东方日升机柜定点.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/刘鹏程/2023-06-27/20230403东方日升机柜定点.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [66/297] EXPIRED: 20230403东方日升机柜定点.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [67/297] 设备问题记录.docx
mkdir -p "D:/myfiles/钉钉同步/刘鹏程/2023-05-28"
RESULT=$(dws drive download --file-id "105753287829" --space-id "21272127035" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/刘鹏程/2023-05-28/设备问题记录.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/刘鹏程/2023-05-28/设备问题记录.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [67/297] OK: 设备问题记录.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [67/297] FAIL: 设备问题记录.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/刘鹏程/2023-05-28/设备问题记录.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [67/297] FAIL: 设备问题记录.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/刘鹏程/2023-05-28/设备问题记录.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [67/297] EXPIRED: 设备问题记录.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [68/297] Follow-Up  on the Rectification Measures.docx
mkdir -p "D:/myfiles/钉钉同步/澳洲官网侵权/2026-05-26"
RESULT=$(dws drive download --file-id "9E05BDRVQ2jR9gnAIyyRZPl2J63zgkYA" --space-id "26434073170" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/澳洲官网侵权/2026-05-26/Follow-Up  on the Rectification Measures.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/澳洲官网侵权/2026-05-26/Follow-Up  on the Rectification Measures.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [68/297] OK: Follow-Up  on the Rectification Measures.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [68/297] FAIL: Follow-Up  on the Rectification Measures.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/澳洲官网侵权/2026-05-26/Follow-Up  on the Rectification Measures.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [68/297] FAIL: Follow-Up  on the Rectification Measures.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/澳洲官网侵权/2026-05-26/Follow-Up  on the Rectification Measures.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [68/297] EXPIRED: Follow-Up  on the Rectification Measures.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [69/297] 联软平台问题登记.xlsx
mkdir -p "D:/myfiles/钉钉同步/联软管理平台沟通群/2026-05-26"
RESULT=$(dws drive download --file-id "pGBa2Lm8ayKpMbmpFED2AGwn8gN7R35y" --space-id "21519806901" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/联软管理平台沟通群/2026-05-26/联软平台问题登记.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/联软管理平台沟通群/2026-05-26/联软平台问题登记.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [69/297] OK: 联软平台问题登记.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [69/297] FAIL: 联软平台问题登记.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/联软管理平台沟通群/2026-05-26/联软平台问题登记.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [69/297] FAIL: 联软平台问题登记.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/联软管理平台沟通群/2026-05-26/联软平台问题登记.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [69/297] EXPIRED: 联软平台问题登记.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [70/297] LV7000产品-CNVD通报漏洞修复方案V1.0.pdf
mkdir -p "D:/myfiles/钉钉同步/联软管理平台沟通群/2024-04-15"
RESULT=$(dws drive download --file-id "dxXB52LJq0m5YLK5uyP3MZKDVqjMp697" --space-id "21519806901" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/联软管理平台沟通群/2024-04-15/LV7000产品-CNVD通报漏洞修复方案V1.0.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/联软管理平台沟通群/2024-04-15/LV7000产品-CNVD通报漏洞修复方案V1.0.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [70/297] OK: LV7000产品-CNVD通报漏洞修复方案V1.0.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [70/297] FAIL: LV7000产品-CNVD通报漏洞修复方案V1.0.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/联软管理平台沟通群/2024-04-15/LV7000产品-CNVD通报漏洞修复方案V1.0.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [70/297] FAIL: LV7000产品-CNVD通报漏洞修复方案V1.0.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/联软管理平台沟通群/2024-04-15/LV7000产品-CNVD通报漏洞修复方案V1.0.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [70/297] EXPIRED: LV7000产品-CNVD通报漏洞修复方案V1.0.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [71/297] 统一认证的问题修复.docx
mkdir -p "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-12-14"
RESULT=$(dws drive download --file-id "125708450016" --space-id "21519806901" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-12-14/统一认证的问题修复.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-12-14/统一认证的问题修复.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [71/297] OK: 统一认证的问题修复.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [71/297] FAIL: 统一认证的问题修复.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-12-14/统一认证的问题修复.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [71/297] FAIL: 统一认证的问题修复.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-12-14/统一认证的问题修复.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [71/297] EXPIRED: 统一认证的问题修复.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [72/297] LVAKB351000035200005(例外微信进程).zip
mkdir -p "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-11-15"
RESULT=$(dws drive download --file-id "7dx2rn0JbA42jdn2udkAgABjVMGjLRb3" --space-id "21519806901" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-11-15/LVAKB351000035200005(例外微信进程).zip" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-11-15/LVAKB351000035200005(例外微信进程).zip" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [72/297] OK: LVAKB351000035200005(例外微信进程).zip ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [72/297] FAIL: LVAKB351000035200005(例外微信进程).zip (empty file)"
      rm -f "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-11-15/LVAKB351000035200005(例外微信进程).zip"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [72/297] FAIL: LVAKB351000035200005(例外微信进程).zip (curl error)"
    rm -f "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-11-15/LVAKB351000035200005(例外微信进程).zip"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [72/297] EXPIRED: LVAKB351000035200005(例外微信进程).zip"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [73/297] 关于微信弹出安全告警的统一回复函.pdf
mkdir -p "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-11-15"
RESULT=$(dws drive download --file-id "LeBq413JA2XK03mKTMal6DZj8DOnGvpb" --space-id "21519806901" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-11-15/关于微信弹出安全告警的统一回复函.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-11-15/关于微信弹出安全告警的统一回复函.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [73/297] OK: 关于微信弹出安全告警的统一回复函.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [73/297] FAIL: 关于微信弹出安全告警的统一回复函.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-11-15/关于微信弹出安全告警的统一回复函.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [73/297] FAIL: 关于微信弹出安全告警的统一回复函.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-11-15/关于微信弹出安全告警的统一回复函.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [73/297] EXPIRED: 关于微信弹出安全告警的统一回复函.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [74/297] LVAKB351072035107207W（漫游认证补丁kb）.rar
mkdir -p "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-06-02"
RESULT=$(dws drive download --file-id "106303530657" --space-id "21519806901" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-06-02/LVAKB351072035107207W（漫游认证补丁kb）.rar" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-06-02/LVAKB351072035107207W（漫游认证补丁kb）.rar" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [74/297] OK: LVAKB351072035107207W（漫游认证补丁kb）.rar ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [74/297] FAIL: LVAKB351072035107207W（漫游认证补丁kb）.rar (empty file)"
      rm -f "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-06-02/LVAKB351072035107207W（漫游认证补丁kb）.rar"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [74/297] FAIL: LVAKB351072035107207W（漫游认证补丁kb）.rar (curl error)"
    rm -f "D:/myfiles/钉钉同步/联软管理平台沟通群/2023-06-02/LVAKB351072035107207W（漫游认证补丁kb）.rar"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [74/297] EXPIRED: LVAKB351072035107207W（漫游认证补丁kb）.rar"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [75/297] 数智能源中心需求汇总-5.23.xlsx
mkdir -p "D:/myfiles/钉钉同步/523集团战略落地会业务问题反馈跟进/2026-05-25"
RESULT=$(dws drive download --file-id "wva2dxOW4Y7aE2jAh0AyrGONVbkz3BRL" --space-id "28911214460" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/523集团战略落地会业务问题反馈跟进/2026-05-25/数智能源中心需求汇总-5.23.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/523集团战略落地会业务问题反馈跟进/2026-05-25/数智能源中心需求汇总-5.23.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [75/297] OK: 数智能源中心需求汇总-5.23.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [75/297] FAIL: 数智能源中心需求汇总-5.23.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/523集团战略落地会业务问题反馈跟进/2026-05-25/数智能源中心需求汇总-5.23.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [75/297] FAIL: 数智能源中心需求汇总-5.23.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/523集团战略落地会业务问题反馈跟进/2026-05-25/数智能源中心需求汇总-5.23.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [75/297] EXPIRED: 数智能源中心需求汇总-5.23.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [76/297] 《2026年度组织绩效目标》草案--电力数字中心.xlsx
mkdir -p "D:/myfiles/钉钉同步/2026年能源数智中心组织绩效目标拆解沟通/2026-05-21"
RESULT=$(dws drive download --file-id "dxXB52LJqnpkGePMiM3RDYoY8qjMp697" --space-id "28891635209" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/2026年能源数智中心组织绩效目标拆解沟通/2026-05-21/《2026年度组织绩效目标》草案--电力数字中心.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/2026年能源数智中心组织绩效目标拆解沟通/2026-05-21/《2026年度组织绩效目标》草案--电力数字中心.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [76/297] OK: 《2026年度组织绩效目标》草案--电力数字中心.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [76/297] FAIL: 《2026年度组织绩效目标》草案--电力数字中心.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/2026年能源数智中心组织绩效目标拆解沟通/2026-05-21/《2026年度组织绩效目标》草案--电力数字中心.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [76/297] FAIL: 《2026年度组织绩效目标》草案--电力数字中心.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/2026年能源数智中心组织绩效目标拆解沟通/2026-05-21/《2026年度组织绩效目标》草案--电力数字中心.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [76/297] EXPIRED: 《2026年度组织绩效目标》草案--电力数字中心.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [77/297] 《2026年度组织绩效目标》草案--能源数智中心-胡&汪.xlsx
mkdir -p "D:/myfiles/钉钉同步/2026年能源数智中心组织绩效目标拆解沟通/2026-05-21"
RESULT=$(dws drive download --file-id "nYMoO1rWxaxOGbrzUzbLbKLdV47Z3je9" --space-id "28891635209" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/2026年能源数智中心组织绩效目标拆解沟通/2026-05-21/《2026年度组织绩效目标》草案--能源数智中心-胡&汪.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/2026年能源数智中心组织绩效目标拆解沟通/2026-05-21/《2026年度组织绩效目标》草案--能源数智中心-胡&汪.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [77/297] OK: 《2026年度组织绩效目标》草案--能源数智中心-胡&汪.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [77/297] FAIL: 《2026年度组织绩效目标》草案--能源数智中心-胡&汪.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/2026年能源数智中心组织绩效目标拆解沟通/2026-05-21/《2026年度组织绩效目标》草案--能源数智中心-胡&汪.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [77/297] FAIL: 《2026年度组织绩效目标》草案--能源数智中心-胡&汪.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/2026年能源数智中心组织绩效目标拆解沟通/2026-05-21/《2026年度组织绩效目标》草案--能源数智中心-胡&汪.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [77/297] EXPIRED: 《2026年度组织绩效目标》草案--能源数智中心-胡&汪.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [78/297] 《2026年度组织绩效目标》草案--能源数智中心.xlsx
mkdir -p "D:/myfiles/钉钉同步/2026年能源数智中心组织绩效目标拆解沟通/2026-05-21"
RESULT=$(dws drive download --file-id "1DKw2zgV2PZ57yKxcPQKZmlX8B5r9YAn" --space-id "28891635209" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/2026年能源数智中心组织绩效目标拆解沟通/2026-05-21/《2026年度组织绩效目标》草案--能源数智中心.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/2026年能源数智中心组织绩效目标拆解沟通/2026-05-21/《2026年度组织绩效目标》草案--能源数智中心.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [78/297] OK: 《2026年度组织绩效目标》草案--能源数智中心.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [78/297] FAIL: 《2026年度组织绩效目标》草案--能源数智中心.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/2026年能源数智中心组织绩效目标拆解沟通/2026-05-21/《2026年度组织绩效目标》草案--能源数智中心.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [78/297] FAIL: 《2026年度组织绩效目标》草案--能源数智中心.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/2026年能源数智中心组织绩效目标拆解沟通/2026-05-21/《2026年度组织绩效目标》草案--能源数智中心.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [78/297] EXPIRED: 《2026年度组织绩效目标》草案--能源数智中心.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [79/297] 东方日升新能源股份有限公司-隐患通报.pdf
mkdir -p "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-05-21"
RESULT=$(dws drive download --file-id "dxXB52LJqnmgr6DEFM3EGa0v8qjMp697" --space-id "28739077566" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-05-21/东方日升新能源股份有限公司-隐患通报.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-05-21/东方日升新能源股份有限公司-隐患通报.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [79/297] OK: 东方日升新能源股份有限公司-隐患通报.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [79/297] FAIL: 东方日升新能源股份有限公司-隐患通报.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-05-21/东方日升新能源股份有限公司-隐患通报.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [79/297] FAIL: 东方日升新能源股份有限公司-隐患通报.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-05-21/东方日升新能源股份有限公司-隐患通报.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [79/297] EXPIRED: 东方日升新能源股份有限公司-隐患通报.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [80/297] 集团公网&公有云业务发布台账.xlsx
mkdir -p "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-29"
RESULT=$(dws drive download --file-id "9bN7RYPWdM9LO610fk9maQE7VZd1wyK0" --space-id "28739077566" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-29/集团公网&公有云业务发布台账.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-29/集团公网&公有云业务发布台账.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [80/297] OK: 集团公网&公有云业务发布台账.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [80/297] FAIL: 集团公网&公有云业务发布台账.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-29/集团公网&公有云业务发布台账.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [80/297] FAIL: 集团公网&公有云业务发布台账.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-29/集团公网&公有云业务发布台账.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [80/297] EXPIRED: 集团公网&公有云业务发布台账.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
echo "Progress: 80/$TOTAL done"
sleep 0.2

# [81/297] 433-集团周期性内网扫描-综述报告.docx
mkdir -p "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-29"
RESULT=$(dws drive download --file-id "y20BglGWO2yDgr1EH0X5Gjwv8A7depqY" --space-id "28739077566" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-29/433-集团周期性内网扫描-综述报告.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-29/433-集团周期性内网扫描-综述报告.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [81/297] OK: 433-集团周期性内网扫描-综述报告.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [81/297] FAIL: 433-集团周期性内网扫描-综述报告.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-29/433-集团周期性内网扫描-综述报告.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [81/297] FAIL: 433-集团周期性内网扫描-综述报告.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-29/433-集团周期性内网扫描-综述报告.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [81/297] EXPIRED: 433-集团周期性内网扫描-综述报告.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [82/297] 2026-04-27_信息安全专项工作分工表_V4_.xlsx
mkdir -p "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-29"
RESULT=$(dws drive download --file-id "4lgGw3P8vRrXmKkDFpeYD99D85daZ90D" --space-id "28739077566" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-29/2026-04-27_信息安全专项工作分工表_V4_.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-29/2026-04-27_信息安全专项工作分工表_V4_.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [82/297] OK: 2026-04-27_信息安全专项工作分工表_V4_.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [82/297] FAIL: 2026-04-27_信息安全专项工作分工表_V4_.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-29/2026-04-27_信息安全专项工作分工表_V4_.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [82/297] FAIL: 2026-04-27_信息安全专项工作分工表_V4_.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-29/2026-04-27_信息安全专项工作分工表_V4_.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [82/297] EXPIRED: 2026-04-27_信息安全专项工作分工表_V4_.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [83/297] 点点云智能科技有限公司-渗透测试报告（3个）.pdf
mkdir -p "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-24"
RESULT=$(dws drive download --file-id "LeBq413JAwXEAQqRfrE6qobmWDOnGvpb" --space-id "28739077566" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-24/点点云智能科技有限公司-渗透测试报告（3个）.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-24/点点云智能科技有限公司-渗透测试报告（3个）.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [83/297] OK: 点点云智能科技有限公司-渗透测试报告（3个）.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [83/297] FAIL: 点点云智能科技有限公司-渗透测试报告（3个）.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-24/点点云智能科技有限公司-渗透测试报告（3个）.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [83/297] FAIL: 点点云智能科技有限公司-渗透测试报告（3个）.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/信息安全日常事件沟通/2026-04-24/点点云智能科技有限公司-渗透测试报告（3个）.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [83/297] EXPIRED: 点点云智能科技有限公司-渗透测试报告（3个）.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [84/297] 海外NC项目调研提纲--财务.doc
mkdir -p "D:/myfiles/钉钉同步/海外NC推广验证/2026-05-13"
RESULT=$(dws drive download --file-id "dxXB52LJqnvNYD7kCMagbX0D8qjMp697" --space-id "28217698264" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/海外NC推广验证/2026-05-13/海外NC项目调研提纲--财务.doc" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/海外NC推广验证/2026-05-13/海外NC项目调研提纲--财务.doc" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [84/297] OK: 海外NC项目调研提纲--财务.doc ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [84/297] FAIL: 海外NC项目调研提纲--财务.doc (empty file)"
      rm -f "D:/myfiles/钉钉同步/海外NC推广验证/2026-05-13/海外NC项目调研提纲--财务.doc"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [84/297] FAIL: 海外NC项目调研提纲--财务.doc (curl error)"
    rm -f "D:/myfiles/钉钉同步/海外NC推广验证/2026-05-13/海外NC项目调研提纲--财务.doc"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [84/297] EXPIRED: 海外NC项目调研提纲--财务.doc"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [85/297] 集团会计科目列表 中文-英文-西语 标注8.30.xlsx
mkdir -p "D:/myfiles/钉钉同步/海外NC推广验证/2026-05-13"
RESULT=$(dws drive download --file-id "G53mjyd80paO9zRnFgXNLKpb86zbX04v" --space-id "28217698264" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/海外NC推广验证/2026-05-13/集团会计科目列表 中文-英文-西语 标注8.30.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/海外NC推广验证/2026-05-13/集团会计科目列表 中文-英文-西语 标注8.30.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [85/297] OK: 集团会计科目列表 中文-英文-西语 标注8.30.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [85/297] FAIL: 集团会计科目列表 中文-英文-西语 标注8.30.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/海外NC推广验证/2026-05-13/集团会计科目列表 中文-英文-西语 标注8.30.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [85/297] FAIL: 集团会计科目列表 中文-英文-西语 标注8.30.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/海外NC推广验证/2026-05-13/集团会计科目列表 中文-英文-西语 标注8.30.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [85/297] EXPIRED: 集团会计科目列表 中文-英文-西语 标注8.30.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [86/297] DIARIO ABRIL 2025 RISEN.XLSX
mkdir -p "D:/myfiles/钉钉同步/海外NC推广验证/2026-05-13"
RESULT=$(dws drive download --file-id "X6GRezwJlAe2n179hrXYEMG98dqbropQ" --space-id "28217698264" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/海外NC推广验证/2026-05-13/DIARIO ABRIL 2025 RISEN.XLSX" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/海外NC推广验证/2026-05-13/DIARIO ABRIL 2025 RISEN.XLSX" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [86/297] OK: DIARIO ABRIL 2025 RISEN.XLSX ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [86/297] FAIL: DIARIO ABRIL 2025 RISEN.XLSX (empty file)"
      rm -f "D:/myfiles/钉钉同步/海外NC推广验证/2026-05-13/DIARIO ABRIL 2025 RISEN.XLSX"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [86/297] FAIL: DIARIO ABRIL 2025 RISEN.XLSX (curl error)"
    rm -f "D:/myfiles/钉钉同步/海外NC推广验证/2026-05-13/DIARIO ABRIL 2025 RISEN.XLSX"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [86/297] EXPIRED: DIARIO ABRIL 2025 RISEN.XLSX"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [87/297] 日升储能售后服务器推荐配置及价格估算.xlsx
mkdir -p "D:/myfiles/钉钉同步/储能售后系统部署迁移沟通/2026-05-07"
RESULT=$(dws drive download --file-id "G53mjyd80pGAGlxXTg52v6Bm86zbX04v" --space-id "28804010355" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/储能售后系统部署迁移沟通/2026-05-07/日升储能售后服务器推荐配置及价格估算.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/储能售后系统部署迁移沟通/2026-05-07/日升储能售后服务器推荐配置及价格估算.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [87/297] OK: 日升储能售后服务器推荐配置及价格估算.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [87/297] FAIL: 日升储能售后服务器推荐配置及价格估算.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/储能售后系统部署迁移沟通/2026-05-07/日升储能售后服务器推荐配置及价格估算.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [87/297] FAIL: 日升储能售后服务器推荐配置及价格估算.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/储能售后系统部署迁移沟通/2026-05-07/日升储能售后服务器推荐配置及价格估算.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [87/297] EXPIRED: 日升储能售后服务器推荐配置及价格估算.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [88/297] 042221-13453-01.dmp
mkdir -p "D:/myfiles/钉钉同步/基础架构/2021-04-23"
RESULT=$(dws drive download --file-id "KGZLxjv9VG3p99zRsGYE0eAQV6EDybno" --space-id "2735238845" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/基础架构/2021-04-23/042221-13453-01.dmp" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/基础架构/2021-04-23/042221-13453-01.dmp" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [88/297] OK: 042221-13453-01.dmp ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [88/297] FAIL: 042221-13453-01.dmp (empty file)"
      rm -f "D:/myfiles/钉钉同步/基础架构/2021-04-23/042221-13453-01.dmp"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [88/297] FAIL: 042221-13453-01.dmp (curl error)"
    rm -f "D:/myfiles/钉钉同步/基础架构/2021-04-23/042221-13453-01.dmp"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [88/297] EXPIRED: 042221-13453-01.dmp"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [89/297] 关于东方日升新能源股份有限公司态势感知产品验收报告-安刻科技有限公司(2).pdf
mkdir -p "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21"
RESULT=$(dws drive download --file-id "ndMj49yWjXK3RLRkFMkrZOa2J3pmz5aA" --space-id "27565564794" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/关于东方日升新能源股份有限公司态势感知产品验收报告-安刻科技有限公司(2).pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/关于东方日升新能源股份有限公司态势感知产品验收报告-安刻科技有限公司(2).pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [89/297] OK: 关于东方日升新能源股份有限公司态势感知产品验收报告-安刻科技有限公司(2).pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [89/297] FAIL: 关于东方日升新能源股份有限公司态势感知产品验收报告-安刻科技有限公司(2).pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/关于东方日升新能源股份有限公司态势感知产品验收报告-安刻科技有限公司(2).pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [89/297] FAIL: 关于东方日升新能源股份有限公司态势感知产品验收报告-安刻科技有限公司(2).pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/关于东方日升新能源股份有限公司态势感知产品验收报告-安刻科技有限公司(2).pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [89/297] EXPIRED: 关于东方日升新能源股份有限公司态势感知产品验收报告-安刻科技有限公司(2).pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [90/297] 常州金坛基地_登陆尝试告警梳理.xlsx
mkdir -p "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21"
RESULT=$(dws drive download --file-id "14dA3GK8gjBRmLmMIrM64X3pJ9ekBD76" --space-id "27565564794" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/常州金坛基地_登陆尝试告警梳理.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/常州金坛基地_登陆尝试告警梳理.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [90/297] OK: 常州金坛基地_登陆尝试告警梳理.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [90/297] FAIL: 常州金坛基地_登陆尝试告警梳理.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/常州金坛基地_登陆尝试告警梳理.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [90/297] FAIL: 常州金坛基地_登陆尝试告警梳理.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/常州金坛基地_登陆尝试告警梳理.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [90/297] EXPIRED: 常州金坛基地_登陆尝试告警梳理.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [91/297] 20251021弱口令梳理-登陆尝试的告警梳理.xlsx
mkdir -p "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21"
RESULT=$(dws drive download --file-id "7dx2rn0JbYPDpLp4sQ403AdvVMGjLRb3" --space-id "27565564794" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/20251021弱口令梳理-登陆尝试的告警梳理.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/20251021弱口令梳理-登陆尝试的告警梳理.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [91/297] OK: 20251021弱口令梳理-登陆尝试的告警梳理.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [91/297] FAIL: 20251021弱口令梳理-登陆尝试的告警梳理.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/20251021弱口令梳理-登陆尝试的告警梳理.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [91/297] FAIL: 20251021弱口令梳理-登陆尝试的告警梳理.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/20251021弱口令梳理-登陆尝试的告警梳理.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [91/297] EXPIRED: 20251021弱口令梳理-登陆尝试的告警梳理.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [92/297] 义乌苏溪基地_登陆尝试告警梳理.xlsx
mkdir -p "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21"
RESULT=$(dws drive download --file-id "wva2dxOW4YmLzXz1s72oXBvYVbkz3BRL" --space-id "27565564794" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/义乌苏溪基地_登陆尝试告警梳理.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/义乌苏溪基地_登陆尝试告警梳理.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [92/297] OK: 义乌苏溪基地_登陆尝试告警梳理.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [92/297] FAIL: 义乌苏溪基地_登陆尝试告警梳理.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/义乌苏溪基地_登陆尝试告警梳理.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [92/297] FAIL: 义乌苏溪基地_登陆尝试告警梳理.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/义乌苏溪基地_登陆尝试告警梳理.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [92/297] EXPIRED: 义乌苏溪基地_登陆尝试告警梳理.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [93/297] 安徽滁州基地_登陆尝试告警梳理.xlsx
mkdir -p "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21"
RESULT=$(dws drive download --file-id "dxXB52LJqnjR1g1mU9d147Rl8qjMp697" --space-id "27565564794" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/安徽滁州基地_登陆尝试告警梳理.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/安徽滁州基地_登陆尝试告警梳理.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [93/297] OK: 安徽滁州基地_登陆尝试告警梳理.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [93/297] FAIL: 安徽滁州基地_登陆尝试告警梳理.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/安徽滁州基地_登陆尝试告警梳理.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [93/297] FAIL: 安徽滁州基地_登陆尝试告警梳理.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-21/安徽滁州基地_登陆尝试告警梳理.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [93/297] EXPIRED: 安徽滁州基地_登陆尝试告警梳理.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [94/297] 20251015弱口令梳理-登陆成功的告警梳理.xlsx
mkdir -p "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-15"
RESULT=$(dws drive download --file-id "QPGYqjpJYr7PvovAtRy6KKGk8akx1Z5N" --space-id "27565564794" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-15/20251015弱口令梳理-登陆成功的告警梳理.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-15/20251015弱口令梳理-登陆成功的告警梳理.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [94/297] OK: 20251015弱口令梳理-登陆成功的告警梳理.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [94/297] FAIL: 20251015弱口令梳理-登陆成功的告警梳理.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-15/20251015弱口令梳理-登陆成功的告警梳理.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [94/297] FAIL: 20251015弱口令梳理-登陆成功的告警梳理.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/【信息安全部】工作沟通同步群/2025-10-15/20251015弱口令梳理-登陆成功的告警梳理.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [94/297] EXPIRED: 20251015弱口令梳理-登陆成功的告警梳理.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [95/297] 0917停用简道云应用清单.xlsx
mkdir -p "D:/myfiles/钉钉同步/简道云开发者群/2025-09-17"
RESULT=$(dws drive download --file-id "9bN7RYPWdMmxbdZEC3Rp0DqyVZd1wyK0" --space-id "24079717246" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/简道云开发者群/2025-09-17/0917停用简道云应用清单.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/简道云开发者群/2025-09-17/0917停用简道云应用清单.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [95/297] OK: 0917停用简道云应用清单.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [95/297] FAIL: 0917停用简道云应用清单.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/简道云开发者群/2025-09-17/0917停用简道云应用清单.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [95/297] FAIL: 0917停用简道云应用清单.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/简道云开发者群/2025-09-17/0917停用简道云应用清单.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [95/297] EXPIRED: 0917停用简道云应用清单.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [96/297] 简道云预删除资源清单.xlsx
mkdir -p "D:/myfiles/钉钉同步/简道云开发者群/2025-09-03"
RESULT=$(dws drive download --file-id "1zknDm0WRad09RnLsgZ7jPXj8BQEx5rG" --space-id "24079717246" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/简道云开发者群/2025-09-03/简道云预删除资源清单.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/简道云开发者群/2025-09-03/简道云预删除资源清单.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [96/297] OK: 简道云预删除资源清单.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [96/297] FAIL: 简道云预删除资源清单.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/简道云开发者群/2025-09-03/简道云预删除资源清单.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [96/297] FAIL: 简道云预删除资源清单.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/简道云开发者群/2025-09-03/简道云预删除资源清单.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [96/297] EXPIRED: 简道云预删除资源清单.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [97/297] 智能助手清单.xlsx
mkdir -p "D:/myfiles/钉钉同步/简道云开发者群/2024-12-19"
RESULT=$(dws drive download --file-id "7QG4Yx2JpLmzEp5YIoYmAqxrJ9dEq3XD" --space-id "24079717246" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/简道云开发者群/2024-12-19/智能助手清单.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/简道云开发者群/2024-12-19/智能助手清单.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [97/297] OK: 智能助手清单.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [97/297] FAIL: 智能助手清单.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/简道云开发者群/2024-12-19/智能助手清单.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [97/297] FAIL: 智能助手清单.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/简道云开发者群/2024-12-19/智能助手清单.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [97/297] EXPIRED: 智能助手清单.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [98/297] 简道云分类变更.xlsx
mkdir -p "D:/myfiles/钉钉同步/简道云开发者群/2024-09-12"
RESULT=$(dws drive download --file-id "yQod3RxJKGdz72XMcg5mLPY9Jkb4Mw9r" --space-id "24079717246" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/简道云开发者群/2024-09-12/简道云分类变更.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/简道云开发者群/2024-09-12/简道云分类变更.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [98/297] OK: 简道云分类变更.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [98/297] FAIL: 简道云分类变更.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/简道云开发者群/2024-09-12/简道云分类变更.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [98/297] FAIL: 简道云分类变更.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/简道云开发者群/2024-09-12/简道云分类变更.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [98/297] EXPIRED: 简道云分类变更.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [99/297] 简道云应用状态变更清单.xlsx
mkdir -p "D:/myfiles/钉钉同步/简道云开发者群/2024-09-12"
RESULT=$(dws drive download --file-id "yQod3RxJKGdz72XMcg5BYY5lJkb4Mw9r" --space-id "24079717246" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/简道云开发者群/2024-09-12/简道云应用状态变更清单.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/简道云开发者群/2024-09-12/简道云应用状态变更清单.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [99/297] OK: 简道云应用状态变更清单.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [99/297] FAIL: 简道云应用状态变更清单.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/简道云开发者群/2024-09-12/简道云应用状态变更清单.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [99/297] FAIL: 简道云应用状态变更清单.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/简道云开发者群/2024-09-12/简道云应用状态变更清单.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [99/297] EXPIRED: 简道云应用状态变更清单.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [100/297] 简道云主数据管理.docx
mkdir -p "D:/myfiles/钉钉同步/简道云开发者群/2024-04-22"
RESULT=$(dws drive download --file-id "DnRL6jAJMGdX0Z27cy0AKQ5LWyMoPYe1" --space-id "24079717246" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/简道云开发者群/2024-04-22/简道云主数据管理.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/简道云开发者群/2024-04-22/简道云主数据管理.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [100/297] OK: 简道云主数据管理.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [100/297] FAIL: 简道云主数据管理.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/简道云开发者群/2024-04-22/简道云主数据管理.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [100/297] FAIL: 简道云主数据管理.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/简道云开发者群/2024-04-22/简道云主数据管理.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [100/297] EXPIRED: 简道云主数据管理.docx"
  EXPIRE=$((EXPIRE+1))
fi
echo "Progress: 100/$TOTAL done"
sleep 0.2

# [101/297] 三门湾数据中心配置推荐V2.xlsx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2023-03-20"
RESULT=$(dws drive download --file-id "99448925134" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2023-03-20/三门湾数据中心配置推荐V2.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2023-03-20/三门湾数据中心配置推荐V2.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [101/297] OK: 三门湾数据中心配置推荐V2.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [101/297] FAIL: 三门湾数据中心配置推荐V2.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2023-03-20/三门湾数据中心配置推荐V2.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [101/297] FAIL: 三门湾数据中心配置推荐V2.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2023-03-20/三门湾数据中心配置推荐V2.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [101/297] EXPIRED: 三门湾数据中心配置推荐V2.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [102/297] 三门湾服务器相关选型.xlsx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2023-03-20"
RESULT=$(dws drive download --file-id "99442779855" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2023-03-20/三门湾服务器相关选型.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2023-03-20/三门湾服务器相关选型.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [102/297] OK: 三门湾服务器相关选型.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [102/297] FAIL: 三门湾服务器相关选型.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2023-03-20/三门湾服务器相关选型.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [102/297] FAIL: 三门湾服务器相关选型.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2023-03-20/三门湾服务器相关选型.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [102/297] EXPIRED: 三门湾服务器相关选型.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [103/297] WK10-基础架构部-汪德嘉.pptx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2023-03-16"
RESULT=$(dws drive download --file-id "99167533407" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2023-03-16/WK10-基础架构部-汪德嘉.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2023-03-16/WK10-基础架构部-汪德嘉.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [103/297] OK: WK10-基础架构部-汪德嘉.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [103/297] FAIL: WK10-基础架构部-汪德嘉.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2023-03-16/WK10-基础架构部-汪德嘉.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [103/297] FAIL: WK10-基础架构部-汪德嘉.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2023-03-16/WK10-基础架构部-汪德嘉.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [103/297] EXPIRED: WK10-基础架构部-汪德嘉.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [104/297] MES图片存储分布式改造方案.pptx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-11-07"
RESULT=$(dws drive download --file-id "72978242539" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-11-07/MES图片存储分布式改造方案.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-11-07/MES图片存储分布式改造方案.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [104/297] OK: MES图片存储分布式改造方案.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [104/297] FAIL: MES图片存储分布式改造方案.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-11-07/MES图片存储分布式改造方案.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [104/297] FAIL: MES图片存储分布式改造方案.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-11-07/MES图片存储分布式改造方案.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [104/297] EXPIRED: MES图片存储分布式改造方案.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [105/297] 2023规划.xlsx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-11-02"
RESULT=$(dws drive download --file-id "72555810250" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-11-02/2023规划.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-11-02/2023规划.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [105/297] OK: 2023规划.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [105/297] FAIL: 2023规划.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-11-02/2023规划.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [105/297] FAIL: 2023规划.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-11-02/2023规划.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [105/297] EXPIRED: 2023规划.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [106/297] 东方日升机房搬迁项目及网络实施项目整体计划表-20220929.xlsx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-30"
RESULT=$(dws drive download --file-id "69837461374" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-30/东方日升机房搬迁项目及网络实施项目整体计划表-20220929.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-30/东方日升机房搬迁项目及网络实施项目整体计划表-20220929.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [106/297] OK: 东方日升机房搬迁项目及网络实施项目整体计划表-20220929.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [106/297] FAIL: 东方日升机房搬迁项目及网络实施项目整体计划表-20220929.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-30/东方日升机房搬迁项目及网络实施项目整体计划表-20220929.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [106/297] FAIL: 东方日升机房搬迁项目及网络实施项目整体计划表-20220929.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-30/东方日升机房搬迁项目及网络实施项目整体计划表-20220929.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [106/297] EXPIRED: 东方日升机房搬迁项目及网络实施项目整体计划表-20220929.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [107/297] Windows_Update_MiniTool.zip
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-20"
RESULT=$(dws drive download --file-id "68951760661" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-20/Windows_Update_MiniTool.zip" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-20/Windows_Update_MiniTool.zip" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [107/297] OK: Windows_Update_MiniTool.zip ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [107/297] FAIL: Windows_Update_MiniTool.zip (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-20/Windows_Update_MiniTool.zip"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [107/297] FAIL: Windows_Update_MiniTool.zip (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-20/Windows_Update_MiniTool.zip"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [107/297] EXPIRED: Windows_Update_MiniTool.zip"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [108/297] WK36-基础架构部-汪德嘉.pptx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-13"
RESULT=$(dws drive download --file-id "68351144980" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-13/WK36-基础架构部-汪德嘉.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-13/WK36-基础架构部-汪德嘉.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [108/297] OK: WK36-基础架构部-汪德嘉.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [108/297] FAIL: WK36-基础架构部-汪德嘉.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-13/WK36-基础架构部-汪德嘉.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [108/297] FAIL: WK36-基础架构部-汪德嘉.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-13/WK36-基础架构部-汪德嘉.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [108/297] EXPIRED: WK36-基础架构部-汪德嘉.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [109/297] 宁海东方日升监控信息(1).xlsx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-06"
RESULT=$(dws drive download --file-id "67899202782" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-06/宁海东方日升监控信息(1).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-06/宁海东方日升监控信息(1).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [109/297] OK: 宁海东方日升监控信息(1).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [109/297] FAIL: 宁海东方日升监控信息(1).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-06/宁海东方日升监控信息(1).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [109/297] FAIL: 宁海东方日升监控信息(1).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-09-06/宁海东方日升监控信息(1).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [109/297] EXPIRED: 宁海东方日升监控信息(1).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [110/297] 01绩效面谈及绩效改进计划表 - 模板(1).xlsx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-29"
RESULT=$(dws drive download --file-id "67079719704" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-29/01绩效面谈及绩效改进计划表 - 模板(1).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-29/01绩效面谈及绩效改进计划表 - 模板(1).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [110/297] OK: 01绩效面谈及绩效改进计划表 - 模板(1).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [110/297] FAIL: 01绩效面谈及绩效改进计划表 - 模板(1).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-29/01绩效面谈及绩效改进计划表 - 模板(1).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [110/297] FAIL: 01绩效面谈及绩效改进计划表 - 模板(1).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-29/01绩效面谈及绩效改进计划表 - 模板(1).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [110/297] EXPIRED: 01绩效面谈及绩效改进计划表 - 模板(1).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [111/297] 01绩效面谈及绩效改进计划表 - 模板.xlsx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-29"
RESULT=$(dws drive download --file-id "67075557662" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-29/01绩效面谈及绩效改进计划表 - 模板.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-29/01绩效面谈及绩效改进计划表 - 模板.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [111/297] OK: 01绩效面谈及绩效改进计划表 - 模板.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [111/297] FAIL: 01绩效面谈及绩效改进计划表 - 模板.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-29/01绩效面谈及绩效改进计划表 - 模板.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [111/297] FAIL: 01绩效面谈及绩效改进计划表 - 模板.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-29/01绩效面谈及绩效改进计划表 - 模板.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [111/297] EXPIRED: 01绩效面谈及绩效改进计划表 - 模板.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [112/297] 网络安全整改汇报.pptx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-25"
RESULT=$(dws drive download --file-id "66751129265" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-25/网络安全整改汇报.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-25/网络安全整改汇报.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [112/297] OK: 网络安全整改汇报.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [112/297] FAIL: 网络安全整改汇报.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-25/网络安全整改汇报.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [112/297] FAIL: 网络安全整改汇报.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-25/网络安全整改汇报.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [112/297] EXPIRED: 网络安全整改汇报.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [113/297] 网络安全大纲.docx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-24"
RESULT=$(dws drive download --file-id "66722976795" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-24/网络安全大纲.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-24/网络安全大纲.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [113/297] OK: 网络安全大纲.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [113/297] FAIL: 网络安全大纲.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-24/网络安全大纲.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [113/297] FAIL: 网络安全大纲.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-08-24/网络安全大纲.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [113/297] EXPIRED: 网络安全大纲.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [114/297] 2东方日升新能源股份有限公司综合管线图.dwg
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-07-26"
RESULT=$(dws drive download --file-id "64735758328" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-07-26/2东方日升新能源股份有限公司综合管线图.dwg" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-07-26/2东方日升新能源股份有限公司综合管线图.dwg" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [114/297] OK: 2东方日升新能源股份有限公司综合管线图.dwg ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [114/297] FAIL: 2东方日升新能源股份有限公司综合管线图.dwg (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-07-26/2东方日升新能源股份有限公司综合管线图.dwg"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [114/297] FAIL: 2东方日升新能源股份有限公司综合管线图.dwg (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-07-26/2东方日升新能源股份有限公司综合管线图.dwg"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [114/297] EXPIRED: 2东方日升新能源股份有限公司综合管线图.dwg"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [115/297] 云桌面降本.pptx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-07-06"
RESULT=$(dws drive download --file-id "63382460503" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-07-06/云桌面降本.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-07-06/云桌面降本.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [115/297] OK: 云桌面降本.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [115/297] FAIL: 云桌面降本.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-07-06/云桌面降本.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [115/297] FAIL: 云桌面降本.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-07-06/云桌面降本.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [115/297] EXPIRED: 云桌面降本.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [116/297] 东方日升项目技术规格书（最新） 20220426(1)(1).docx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-06-13"
RESULT=$(dws drive download --file-id "61574730188" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-06-13/东方日升项目技术规格书（最新） 20220426(1)(1).docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-06-13/东方日升项目技术规格书（最新） 20220426(1)(1).docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [116/297] OK: 东方日升项目技术规格书（最新） 20220426(1)(1).docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [116/297] FAIL: 东方日升项目技术规格书（最新） 20220426(1)(1).docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-06-13/东方日升项目技术规格书（最新） 20220426(1)(1).docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [116/297] FAIL: 东方日升项目技术规格书（最新） 20220426(1)(1).docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-06-13/东方日升项目技术规格书（最新） 20220426(1)(1).docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [116/297] EXPIRED: 东方日升项目技术规格书（最新） 20220426(1)(1).docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [117/297] 东方日升项目技术规格书（最新） 20220426(1).docx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-06-13"
RESULT=$(dws drive download --file-id "61559226690" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-06-13/东方日升项目技术规格书（最新） 20220426(1).docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-06-13/东方日升项目技术规格书（最新） 20220426(1).docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [117/297] OK: 东方日升项目技术规格书（最新） 20220426(1).docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [117/297] FAIL: 东方日升项目技术规格书（最新） 20220426(1).docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-06-13/东方日升项目技术规格书（最新） 20220426(1).docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [117/297] FAIL: 东方日升项目技术规格书（最新） 20220426(1).docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-06-13/东方日升项目技术规格书（最新） 20220426(1).docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [117/297] EXPIRED: 东方日升项目技术规格书（最新） 20220426(1).docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [118/297] 新建文本文档.txt
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-05-17"
RESULT=$(dws drive download --file-id "59499151471" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-05-17/新建文本文档.txt" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-05-17/新建文本文档.txt" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [118/297] OK: 新建文本文档.txt ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [118/297] FAIL: 新建文本文档.txt (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-05-17/新建文本文档.txt"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [118/297] FAIL: 新建文本文档.txt (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-05-17/新建文本文档.txt"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [118/297] EXPIRED: 新建文本文档.txt"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [119/297] 施工进度日报3.docx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-03-14"
RESULT=$(dws drive download --file-id "Obva6QBXJwm5aLnltOZ2ppEGWn4qY5Pr" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-03-14/施工进度日报3.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-03-14/施工进度日报3.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [119/297] OK: 施工进度日报3.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [119/297] FAIL: 施工进度日报3.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-03-14/施工进度日报3.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [119/297] FAIL: 施工进度日报3.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2022-03-14/施工进度日报3.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [119/297] EXPIRED: 施工进度日报3.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [120/297] Visio-Risen MES Proposal Drawing Rev3.0.pdf
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-11-25"
RESULT=$(dws drive download --file-id "47218792379" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-11-25/Visio-Risen MES Proposal Drawing Rev3.0.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-11-25/Visio-Risen MES Proposal Drawing Rev3.0.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [120/297] OK: Visio-Risen MES Proposal Drawing Rev3.0.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [120/297] FAIL: Visio-Risen MES Proposal Drawing Rev3.0.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-11-25/Visio-Risen MES Proposal Drawing Rev3.0.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [120/297] FAIL: Visio-Risen MES Proposal Drawing Rev3.0.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-11-25/Visio-Risen MES Proposal Drawing Rev3.0.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [120/297] EXPIRED: Visio-Risen MES Proposal Drawing Rev3.0.pdf"
  EXPIRE=$((EXPIRE+1))
fi
echo "Progress: 120/$TOTAL done"
sleep 0.2

# [121/297] MES Diagram.pdf
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-11-25"
RESULT=$(dws drive download --file-id "47218763644" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-11-25/MES Diagram.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-11-25/MES Diagram.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [121/297] OK: MES Diagram.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [121/297] FAIL: MES Diagram.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-11-25/MES Diagram.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [121/297] FAIL: MES Diagram.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-11-25/MES Diagram.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [121/297] EXPIRED: MES Diagram.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [122/297] RISEN - MES Infra.pdf
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-11-25"
RESULT=$(dws drive download --file-id "47218811249" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-11-25/RISEN - MES Infra.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-11-25/RISEN - MES Infra.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [122/297] OK: RISEN - MES Infra.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [122/297] FAIL: RISEN - MES Infra.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-11-25/RISEN - MES Infra.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [122/297] FAIL: RISEN - MES Infra.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-11-25/RISEN - MES Infra.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [122/297] EXPIRED: RISEN - MES Infra.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [123/297] 工作簿1(2).xlsx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-10-11"
RESULT=$(dws drive download --file-id "44156619790" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-10-11/工作簿1(2).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-10-11/工作簿1(2).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [123/297] OK: 工作簿1(2).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [123/297] FAIL: 工作簿1(2).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-10-11/工作簿1(2).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [123/297] FAIL: 工作簿1(2).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-10-11/工作簿1(2).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [123/297] EXPIRED: 工作簿1(2).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [124/297] 工作簿1(1).xlsx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-05-07"
RESULT=$(dws drive download --file-id "34533165265" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-05-07/工作簿1(1).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-05-07/工作簿1(1).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [124/297] OK: 工作簿1(1).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [124/297] FAIL: 工作簿1(1).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-05-07/工作簿1(1).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [124/297] FAIL: 工作簿1(1).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-05-07/工作簿1(1).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [124/297] EXPIRED: 工作簿1(1).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [125/297] 工作簿1.xlsx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-05-07"
RESULT=$(dws drive download --file-id "34532951416" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-05-07/工作簿1.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-05-07/工作簿1.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [125/297] OK: 工作簿1.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [125/297] FAIL: 工作簿1.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-05-07/工作簿1.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [125/297] FAIL: 工作簿1.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-05-07/工作簿1.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [125/297] EXPIRED: 工作簿1.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [126/297] 云桌面需求调研表.xlsx
mkdir -p "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-04-24"
RESULT=$(dws drive download --file-id "33938926985" --space-id "4366800249" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-04-24/云桌面需求调研表.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-04-24/云桌面需求调研表.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [126/297] OK: 云桌面需求调研表.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [126/297] FAIL: 云桌面需求调研表.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-04-24/云桌面需求调研表.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [126/297] FAIL: 云桌面需求调研表.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/汪德嘉 DJ Wang/2021-04-24/云桌面需求调研表.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [126/297] EXPIRED: 云桌面需求调研表.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [127/297] itop-10.10.11.129.zip
mkdir -p "D:/myfiles/钉钉同步/王腾川/2022-09-15"
RESULT=$(dws drive download --file-id "68570405702" --space-id "4272123455" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/王腾川/2022-09-15/itop-10.10.11.129.zip" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/王腾川/2022-09-15/itop-10.10.11.129.zip" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [127/297] OK: itop-10.10.11.129.zip ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [127/297] FAIL: itop-10.10.11.129.zip (empty file)"
      rm -f "D:/myfiles/钉钉同步/王腾川/2022-09-15/itop-10.10.11.129.zip"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [127/297] FAIL: itop-10.10.11.129.zip (curl error)"
    rm -f "D:/myfiles/钉钉同步/王腾川/2022-09-15/itop-10.10.11.129.zip"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [127/297] EXPIRED: itop-10.10.11.129.zip"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [128/297] To Risen - Data Source List 数据源表单 - Consilio - June 2022.xlsx
mkdir -p "D:/myfiles/钉钉同步/王腾川/2022-06-15"
RESULT=$(dws drive download --file-id "61751138941" --space-id "4272123455" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/王腾川/2022-06-15/To Risen - Data Source List 数据源表单 - Consilio - June 2022.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/王腾川/2022-06-15/To Risen - Data Source List 数据源表单 - Consilio - June 2022.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [128/297] OK: To Risen - Data Source List 数据源表单 - Consilio - June 2022.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [128/297] FAIL: To Risen - Data Source List 数据源表单 - Consilio - June 2022.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/王腾川/2022-06-15/To Risen - Data Source List 数据源表单 - Consilio - June 2022.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [128/297] FAIL: To Risen - Data Source List 数据源表单 - Consilio - June 2022.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/王腾川/2022-06-15/To Risen - Data Source List 数据源表单 - Consilio - June 2022.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [128/297] EXPIRED: To Risen - Data Source List 数据源表单 - Consilio - June 2022.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [129/297] 1.docx
mkdir -p "D:/myfiles/钉钉同步/王腾川/2022-06-14"
RESULT=$(dws drive download --file-id "61670135620" --space-id "4272123455" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/王腾川/2022-06-14/1.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/王腾川/2022-06-14/1.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [129/297] OK: 1.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [129/297] FAIL: 1.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/王腾川/2022-06-14/1.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [129/297] FAIL: 1.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/王腾川/2022-06-14/1.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [129/297] EXPIRED: 1.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [130/297] Mac助手安装、卸载及使用操作手册.docx
mkdir -p "D:/myfiles/钉钉同步/王腾川/2021-12-30"
RESULT=$(dws drive download --file-id "49595826001" --space-id "4272123455" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/王腾川/2021-12-30/Mac助手安装、卸载及使用操作手册.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/王腾川/2021-12-30/Mac助手安装、卸载及使用操作手册.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [130/297] OK: Mac助手安装、卸载及使用操作手册.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [130/297] FAIL: Mac助手安装、卸载及使用操作手册.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/王腾川/2021-12-30/Mac助手安装、卸载及使用操作手册.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [130/297] FAIL: Mac助手安装、卸载及使用操作手册.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/王腾川/2021-12-30/Mac助手安装、卸载及使用操作手册.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [130/297] EXPIRED: Mac助手安装、卸载及使用操作手册.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [131/297] 信息安全培训.pptx
mkdir -p "D:/myfiles/钉钉同步/王腾川/2021-10-11"
RESULT=$(dws drive download --file-id "44095009906" --space-id "4272123455" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/王腾川/2021-10-11/信息安全培训.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/王腾川/2021-10-11/信息安全培训.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [131/297] OK: 信息安全培训.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [131/297] FAIL: 信息安全培训.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/王腾川/2021-10-11/信息安全培训.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [131/297] FAIL: 信息安全培训.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/王腾川/2021-10-11/信息安全培训.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [131/297] EXPIRED: 信息安全培训.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [132/297] favicon.ico
mkdir -p "D:/myfiles/钉钉同步/王腾川/2021-04-16"
RESULT=$(dws drive download --file-id "33480516771" --space-id "4272123455" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/王腾川/2021-04-16/favicon.ico" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/王腾川/2021-04-16/favicon.ico" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [132/297] OK: favicon.ico ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [132/297] FAIL: favicon.ico (empty file)"
      rm -f "D:/myfiles/钉钉同步/王腾川/2021-04-16/favicon.ico"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [132/297] FAIL: favicon.ico (curl error)"
    rm -f "D:/myfiles/钉钉同步/王腾川/2021-04-16/favicon.ico"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [132/297] EXPIRED: favicon.ico"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [133/297] 浙江双宇电子科技有限公司_11月安全隐患整改报告_v0.1_20251120.pdf
mkdir -p "D:/myfiles/钉钉同步/陈鑫/2025-11-20"
RESULT=$(dws drive download --file-id "dxXB52LJqnjNn26oS9ZvxeAN8qjMp697" --space-id "27556331825" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/陈鑫/2025-11-20/浙江双宇电子科技有限公司_11月安全隐患整改报告_v0.1_20251120.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/陈鑫/2025-11-20/浙江双宇电子科技有限公司_11月安全隐患整改报告_v0.1_20251120.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [133/297] OK: 浙江双宇电子科技有限公司_11月安全隐患整改报告_v0.1_20251120.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [133/297] FAIL: 浙江双宇电子科技有限公司_11月安全隐患整改报告_v0.1_20251120.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/陈鑫/2025-11-20/浙江双宇电子科技有限公司_11月安全隐患整改报告_v0.1_20251120.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [133/297] FAIL: 浙江双宇电子科技有限公司_11月安全隐患整改报告_v0.1_20251120.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/陈鑫/2025-11-20/浙江双宇电子科技有限公司_11月安全隐患整改报告_v0.1_20251120.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [133/297] EXPIRED: 浙江双宇电子科技有限公司_11月安全隐患整改报告_v0.1_20251120.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [134/297] 东方日升新能源股份有限公司_11月安全隐患整改报告_v0.1_20251119.pdf
mkdir -p "D:/myfiles/钉钉同步/陈鑫/2025-11-19"
RESULT=$(dws drive download --file-id "gpG2NdyVX3nz3x50Hy7L5EzaWMwvDqPk" --space-id "27556331825" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/陈鑫/2025-11-19/东方日升新能源股份有限公司_11月安全隐患整改报告_v0.1_20251119.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/陈鑫/2025-11-19/东方日升新能源股份有限公司_11月安全隐患整改报告_v0.1_20251119.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [134/297] OK: 东方日升新能源股份有限公司_11月安全隐患整改报告_v0.1_20251119.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [134/297] FAIL: 东方日升新能源股份有限公司_11月安全隐患整改报告_v0.1_20251119.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/陈鑫/2025-11-19/东方日升新能源股份有限公司_11月安全隐患整改报告_v0.1_20251119.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [134/297] FAIL: 东方日升新能源股份有限公司_11月安全隐患整改报告_v0.1_20251119.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/陈鑫/2025-11-19/东方日升新能源股份有限公司_11月安全隐患整改报告_v0.1_20251119.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [134/297] EXPIRED: 东方日升新能源股份有限公司_11月安全隐患整改报告_v0.1_20251119.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [135/297] 东方日升新能源股份有限公司_11月安全隐患整改报告_v0.1_20251119.docx
mkdir -p "D:/myfiles/钉钉同步/陈鑫/2025-11-19"
RESULT=$(dws drive download --file-id "Exel2BLV5znpzQadSLplDew5Jgk9rpMq" --space-id "27556331825" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/陈鑫/2025-11-19/东方日升新能源股份有限公司_11月安全隐患整改报告_v0.1_20251119.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/陈鑫/2025-11-19/东方日升新能源股份有限公司_11月安全隐患整改报告_v0.1_20251119.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [135/297] OK: 东方日升新能源股份有限公司_11月安全隐患整改报告_v0.1_20251119.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [135/297] FAIL: 东方日升新能源股份有限公司_11月安全隐患整改报告_v0.1_20251119.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/陈鑫/2025-11-19/东方日升新能源股份有限公司_11月安全隐患整改报告_v0.1_20251119.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [135/297] FAIL: 东方日升新能源股份有限公司_11月安全隐患整改报告_v0.1_20251119.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/陈鑫/2025-11-19/东方日升新能源股份有限公司_11月安全隐患整改报告_v0.1_20251119.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [135/297] EXPIRED: 东方日升新能源股份有限公司_11月安全隐患整改报告_v0.1_20251119.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [136/297] 口令控制策略RS03-IT-006-2021 A1[2025]_v0.1_20251119.doc
mkdir -p "D:/myfiles/钉钉同步/陈鑫/2025-11-19"
RESULT=$(dws drive download --file-id "pYLaezmVNejkeaAXTgP4ngj4WrMqPxX6" --space-id "27556331825" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/陈鑫/2025-11-19/口令控制策略RS03-IT-006-2021 A1[2025]_v0.1_20251119.doc" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/陈鑫/2025-11-19/口令控制策略RS03-IT-006-2021 A1[2025]_v0.1_20251119.doc" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [136/297] OK: 口令控制策略RS03-IT-006-2021 A1[2025]_v0.1_20251119.doc ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [136/297] FAIL: 口令控制策略RS03-IT-006-2021 A1[2025]_v0.1_20251119.doc (empty file)"
      rm -f "D:/myfiles/钉钉同步/陈鑫/2025-11-19/口令控制策略RS03-IT-006-2021 A1[2025]_v0.1_20251119.doc"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [136/297] FAIL: 口令控制策略RS03-IT-006-2021 A1[2025]_v0.1_20251119.doc (curl error)"
    rm -f "D:/myfiles/钉钉同步/陈鑫/2025-11-19/口令控制策略RS03-IT-006-2021 A1[2025]_v0.1_20251119.doc"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [136/297] EXPIRED: 口令控制策略RS03-IT-006-2021 A1[2025]_v0.1_20251119.doc"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [137/297] 东方日升弱口令告警梳理.xlsx
mkdir -p "D:/myfiles/钉钉同步/陈鑫/2025-10-15"
RESULT=$(dws drive download --file-id "b9Y4gmKWrPNaPr6ocpgpaljvJGXn6lpz" --space-id "27556331825" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/陈鑫/2025-10-15/东方日升弱口令告警梳理.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/陈鑫/2025-10-15/东方日升弱口令告警梳理.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [137/297] OK: 东方日升弱口令告警梳理.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [137/297] FAIL: 东方日升弱口令告警梳理.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/陈鑫/2025-10-15/东方日升弱口令告警梳理.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [137/297] FAIL: 东方日升弱口令告警梳理.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/陈鑫/2025-10-15/东方日升弱口令告警梳理.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [137/297] EXPIRED: 东方日升弱口令告警梳理.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [138/297] 7东方日升集团总部信息中心2021年（费用）预算表-信息管理部&系统集成部0421.xlsx
mkdir -p "D:/myfiles/钉钉同步/李广会/2021-04-22"
RESULT=$(dws drive download --file-id "33784921070" --space-id "3167223952" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/李广会/2021-04-22/7东方日升集团总部信息中心2021年（费用）预算表-信息管理部&系统集成部0421.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/李广会/2021-04-22/7东方日升集团总部信息中心2021年（费用）预算表-信息管理部&系统集成部0421.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [138/297] OK: 7东方日升集团总部信息中心2021年（费用）预算表-信息管理部&系统集成部0421.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [138/297] FAIL: 7东方日升集团总部信息中心2021年（费用）预算表-信息管理部&系统集成部0421.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/李广会/2021-04-22/7东方日升集团总部信息中心2021年（费用）预算表-信息管理部&系统集成部0421.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [138/297] FAIL: 7东方日升集团总部信息中心2021年（费用）预算表-信息管理部&系统集成部0421.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/李广会/2021-04-22/7东方日升集团总部信息中心2021年（费用）预算表-信息管理部&系统集成部0421.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [138/297] EXPIRED: 7东方日升集团总部信息中心2021年（费用）预算表-信息管理部&系统集成部0421.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [139/297] 东方日升协议采购_（H3C）(1).xls
mkdir -p "D:/myfiles/钉钉同步/薛傲晖/2023-02-20"
RESULT=$(dws drive download --file-id "96836340858" --space-id "7994686935" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/薛傲晖/2023-02-20/东方日升协议采购_（H3C）(1).xls" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/薛傲晖/2023-02-20/东方日升协议采购_（H3C）(1).xls" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [139/297] OK: 东方日升协议采购_（H3C）(1).xls ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [139/297] FAIL: 东方日升协议采购_（H3C）(1).xls (empty file)"
      rm -f "D:/myfiles/钉钉同步/薛傲晖/2023-02-20/东方日升协议采购_（H3C）(1).xls"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [139/297] FAIL: 东方日升协议采购_（H3C）(1).xls (curl error)"
    rm -f "D:/myfiles/钉钉同步/薛傲晖/2023-02-20/东方日升协议采购_（H3C）(1).xls"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [139/297] EXPIRED: 东方日升协议采购_（H3C）(1).xls"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [140/297] 东方日升协议框架（H3C）(1).pdf
mkdir -p "D:/myfiles/钉钉同步/薛傲晖/2023-02-20"
RESULT=$(dws drive download --file-id "96836435819" --space-id "7994686935" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/薛傲晖/2023-02-20/东方日升协议框架（H3C）(1).pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/薛傲晖/2023-02-20/东方日升协议框架（H3C）(1).pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [140/297] OK: 东方日升协议框架（H3C）(1).pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [140/297] FAIL: 东方日升协议框架（H3C）(1).pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/薛傲晖/2023-02-20/东方日升协议框架（H3C）(1).pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [140/297] FAIL: 东方日升协议框架（H3C）(1).pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/薛傲晖/2023-02-20/东方日升协议框架（H3C）(1).pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [140/297] EXPIRED: 东方日升协议框架（H3C）(1).pdf"
  EXPIRE=$((EXPIRE+1))
fi
echo "Progress: 140/$TOTAL done"
sleep 0.2

# [141/297] 漏洞评估系统-产品对比(2).xlsx
mkdir -p "D:/myfiles/钉钉同步/薛傲晖/2023-02-20"
RESULT=$(dws drive download --file-id "96832399566" --space-id "7994686935" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/薛傲晖/2023-02-20/漏洞评估系统-产品对比(2).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/薛傲晖/2023-02-20/漏洞评估系统-产品对比(2).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [141/297] OK: 漏洞评估系统-产品对比(2).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [141/297] FAIL: 漏洞评估系统-产品对比(2).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/薛傲晖/2023-02-20/漏洞评估系统-产品对比(2).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [141/297] FAIL: 漏洞评估系统-产品对比(2).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/薛傲晖/2023-02-20/漏洞评估系统-产品对比(2).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [141/297] EXPIRED: 漏洞评估系统-产品对比(2).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [142/297] 东方日升协议采购_（H3C）.xls
mkdir -p "D:/myfiles/钉钉同步/薛傲晖/2022-12-13"
RESULT=$(dws drive download --file-id "92085965223" --space-id "7994686935" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/薛傲晖/2022-12-13/东方日升协议采购_（H3C）.xls" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/薛傲晖/2022-12-13/东方日升协议采购_（H3C）.xls" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [142/297] OK: 东方日升协议采购_（H3C）.xls ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [142/297] FAIL: 东方日升协议采购_（H3C）.xls (empty file)"
      rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-12-13/东方日升协议采购_（H3C）.xls"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [142/297] FAIL: 东方日升协议采购_（H3C）.xls (curl error)"
    rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-12-13/东方日升协议采购_（H3C）.xls"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [142/297] EXPIRED: 东方日升协议采购_（H3C）.xls"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [143/297] 东方日升协议框架（H3C）.pdf
mkdir -p "D:/myfiles/钉钉同步/薛傲晖/2022-12-13"
RESULT=$(dws drive download --file-id "92086010750" --space-id "7994686935" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/薛傲晖/2022-12-13/东方日升协议框架（H3C）.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/薛傲晖/2022-12-13/东方日升协议框架（H3C）.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [143/297] OK: 东方日升协议框架（H3C）.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [143/297] FAIL: 东方日升协议框架（H3C）.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-12-13/东方日升协议框架（H3C）.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [143/297] FAIL: 东方日升协议框架（H3C）.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-12-13/东方日升协议框架（H3C）.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [143/297] EXPIRED: 东方日升协议框架（H3C）.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [144/297] 2022-2023阿里云vpn网关续费合同-双章.pdf
mkdir -p "D:/myfiles/钉钉同步/薛傲晖/2022-11-16"
RESULT=$(dws drive download --file-id "73798451940" --space-id "7994686935" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/薛傲晖/2022-11-16/2022-2023阿里云vpn网关续费合同-双章.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/薛傲晖/2022-11-16/2022-2023阿里云vpn网关续费合同-双章.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [144/297] OK: 2022-2023阿里云vpn网关续费合同-双章.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [144/297] FAIL: 2022-2023阿里云vpn网关续费合同-双章.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-11-16/2022-2023阿里云vpn网关续费合同-双章.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [144/297] FAIL: 2022-2023阿里云vpn网关续费合同-双章.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-11-16/2022-2023阿里云vpn网关续费合同-双章.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [144/297] EXPIRED: 2022-2023阿里云vpn网关续费合同-双章.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [145/297] 东方日升中心机房竣工验收报告.pdf
mkdir -p "D:/myfiles/钉钉同步/薛傲晖/2022-10-12"
RESULT=$(dws drive download --file-id "70613668971" --space-id "7994686935" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/薛傲晖/2022-10-12/东方日升中心机房竣工验收报告.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/薛傲晖/2022-10-12/东方日升中心机房竣工验收报告.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [145/297] OK: 东方日升中心机房竣工验收报告.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [145/297] FAIL: 东方日升中心机房竣工验收报告.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-10-12/东方日升中心机房竣工验收报告.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [145/297] FAIL: 东方日升中心机房竣工验收报告.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-10-12/东方日升中心机房竣工验收报告.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [145/297] EXPIRED: 东方日升中心机房竣工验收报告.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [146/297] 东方日升中心机房到货签收.pdf
mkdir -p "D:/myfiles/钉钉同步/薛傲晖/2022-10-12"
RESULT=$(dws drive download --file-id "70613542651" --space-id "7994686935" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/薛傲晖/2022-10-12/东方日升中心机房到货签收.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/薛傲晖/2022-10-12/东方日升中心机房到货签收.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [146/297] OK: 东方日升中心机房到货签收.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [146/297] FAIL: 东方日升中心机房到货签收.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-10-12/东方日升中心机房到货签收.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [146/297] FAIL: 东方日升中心机房到货签收.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-10-12/东方日升中心机房到货签收.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [146/297] EXPIRED: 东方日升中心机房到货签收.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [147/297] 东方日升出库单9.23_签字.pdf
mkdir -p "D:/myfiles/钉钉同步/薛傲晖/2022-10-10"
RESULT=$(dws drive download --file-id "70442354581" --space-id "7994686935" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/薛傲晖/2022-10-10/东方日升出库单9.23_签字.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/薛傲晖/2022-10-10/东方日升出库单9.23_签字.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [147/297] OK: 东方日升出库单9.23_签字.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [147/297] FAIL: 东方日升出库单9.23_签字.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-10-10/东方日升出库单9.23_签字.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [147/297] FAIL: 东方日升出库单9.23_签字.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-10-10/东方日升出库单9.23_签字.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [147/297] EXPIRED: 东方日升出库单9.23_签字.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [148/297] 东方日升出库单9.7-签字.pdf
mkdir -p "D:/myfiles/钉钉同步/薛傲晖/2022-10-10"
RESULT=$(dws drive download --file-id "70442340385" --space-id "7994686935" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/薛傲晖/2022-10-10/东方日升出库单9.7-签字.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/薛傲晖/2022-10-10/东方日升出库单9.7-签字.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [148/297] OK: 东方日升出库单9.7-签字.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [148/297] FAIL: 东方日升出库单9.7-签字.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-10-10/东方日升出库单9.7-签字.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [148/297] FAIL: 东方日升出库单9.7-签字.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-10-10/东方日升出库单9.7-签字.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [148/297] EXPIRED: 东方日升出库单9.7-签字.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [149/297] 东方日升出库单9.23_0001.pdf
mkdir -p "D:/myfiles/钉钉同步/薛傲晖/2022-10-10"
RESULT=$(dws drive download --file-id "70437484446" --space-id "7994686935" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/薛傲晖/2022-10-10/东方日升出库单9.23_0001.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/薛傲晖/2022-10-10/东方日升出库单9.23_0001.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [149/297] OK: 东方日升出库单9.23_0001.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [149/297] FAIL: 东方日升出库单9.23_0001.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-10-10/东方日升出库单9.23_0001.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [149/297] FAIL: 东方日升出库单9.23_0001.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-10-10/东方日升出库单9.23_0001.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [149/297] EXPIRED: 东方日升出库单9.23_0001.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [150/297] 晨鼎销售合同.pdf
mkdir -p "D:/myfiles/钉钉同步/薛傲晖/2022-07-29"
RESULT=$(dws drive download --file-id "64930837891" --space-id "7994686935" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/薛傲晖/2022-07-29/晨鼎销售合同.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/薛傲晖/2022-07-29/晨鼎销售合同.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [150/297] OK: 晨鼎销售合同.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [150/297] FAIL: 晨鼎销售合同.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-07-29/晨鼎销售合同.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [150/297] FAIL: 晨鼎销售合同.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-07-29/晨鼎销售合同.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [150/297] EXPIRED: 晨鼎销售合同.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [151/297] 晨鼎服务合同.pdf
mkdir -p "D:/myfiles/钉钉同步/薛傲晖/2022-07-29"
RESULT=$(dws drive download --file-id "64930763903" --space-id "7994686935" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/薛傲晖/2022-07-29/晨鼎服务合同.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/薛傲晖/2022-07-29/晨鼎服务合同.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [151/297] OK: 晨鼎服务合同.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [151/297] FAIL: 晨鼎服务合同.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-07-29/晨鼎服务合同.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [151/297] FAIL: 晨鼎服务合同.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-07-29/晨鼎服务合同.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [151/297] EXPIRED: 晨鼎服务合同.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [152/297] 中心机房到货签收汇总表.pdf
mkdir -p "D:/myfiles/钉钉同步/薛傲晖/2022-07-04"
RESULT=$(dws drive download --file-id "63163061515" --space-id "7994686935" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/薛傲晖/2022-07-04/中心机房到货签收汇总表.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/薛傲晖/2022-07-04/中心机房到货签收汇总表.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [152/297] OK: 中心机房到货签收汇总表.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [152/297] FAIL: 中心机房到货签收汇总表.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-07-04/中心机房到货签收汇总表.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [152/297] FAIL: 中心机房到货签收汇总表.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-07-04/中心机房到货签收汇总表.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [152/297] EXPIRED: 中心机房到货签收汇总表.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [153/297] 供应商名录_20220609093208的副本(1).xlsx
mkdir -p "D:/myfiles/钉钉同步/薛傲晖/2022-06-27"
RESULT=$(dws drive download --file-id "62619749256" --space-id "7994686935" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/薛傲晖/2022-06-27/供应商名录_20220609093208的副本(1).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/薛傲晖/2022-06-27/供应商名录_20220609093208的副本(1).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [153/297] OK: 供应商名录_20220609093208的副本(1).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [153/297] FAIL: 供应商名录_20220609093208的副本(1).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-06-27/供应商名录_20220609093208的副本(1).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [153/297] FAIL: 供应商名录_20220609093208的副本(1).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-06-27/供应商名录_20220609093208的副本(1).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [153/297] EXPIRED: 供应商名录_20220609093208的副本(1).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [154/297] 供应商名录_20220609093208的副本.xlsx
mkdir -p "D:/myfiles/钉钉同步/薛傲晖/2022-06-23"
RESULT=$(dws drive download --file-id "62423562213" --space-id "7994686935" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/薛傲晖/2022-06-23/供应商名录_20220609093208的副本.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/薛傲晖/2022-06-23/供应商名录_20220609093208的副本.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [154/297] OK: 供应商名录_20220609093208的副本.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [154/297] FAIL: 供应商名录_20220609093208的副本.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-06-23/供应商名录_20220609093208的副本.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [154/297] FAIL: 供应商名录_20220609093208的副本.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/薛傲晖/2022-06-23/供应商名录_20220609093208的副本.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [154/297] EXPIRED: 供应商名录_20220609093208的副本.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [155/297] 安全服务授权书-20240911.docx
mkdir -p "D:/myfiles/钉钉同步/池铭航/2025-09-29"
RESULT=$(dws drive download --file-id "1OQX0akWmx5Z5YYPSaxG1emp8GlDd3mE" --space-id "27416517951" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/池铭航/2025-09-29/安全服务授权书-20240911.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/池铭航/2025-09-29/安全服务授权书-20240911.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [155/297] OK: 安全服务授权书-20240911.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [155/297] FAIL: 安全服务授权书-20240911.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/池铭航/2025-09-29/安全服务授权书-20240911.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [155/297] FAIL: 安全服务授权书-20240911.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/池铭航/2025-09-29/安全服务授权书-20240911.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [155/297] EXPIRED: 安全服务授权书-20240911.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [156/297] syl_can_tool_v1.3.93(1).7z
mkdir -p "D:/myfiles/钉钉同步/欧洲一体机项目交付沟通群/2025-07-24"
RESULT=$(dws drive download --file-id "nYMoO1rWxaQpXbzoTKlBn03BV47Z3je9" --space-id "26857272189" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/欧洲一体机项目交付沟通群/2025-07-24/syl_can_tool_v1.3.93(1).7z" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/欧洲一体机项目交付沟通群/2025-07-24/syl_can_tool_v1.3.93(1).7z" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [156/297] OK: syl_can_tool_v1.3.93(1).7z ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [156/297] FAIL: syl_can_tool_v1.3.93(1).7z (empty file)"
      rm -f "D:/myfiles/钉钉同步/欧洲一体机项目交付沟通群/2025-07-24/syl_can_tool_v1.3.93(1).7z"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [156/297] FAIL: syl_can_tool_v1.3.93(1).7z (curl error)"
    rm -f "D:/myfiles/钉钉同步/欧洲一体机项目交付沟通群/2025-07-24/syl_can_tool_v1.3.93(1).7z"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [156/297] EXPIRED: syl_can_tool_v1.3.93(1).7z"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [157/297] 东方日升数字化项目建设汇报.pptx
mkdir -p "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22"
RESULT=$(dws drive download --file-id "R4GpnMqJzGxgNaBwsaxnAb2q8Ke0xjE3" --space-id "28724636662" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/东方日升数字化项目建设汇报.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/东方日升数字化项目建设汇报.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [157/297] OK: 东方日升数字化项目建设汇报.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [157/297] FAIL: 东方日升数字化项目建设汇报.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/东方日升数字化项目建设汇报.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [157/297] FAIL: 东方日升数字化项目建设汇报.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/东方日升数字化项目建设汇报.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [157/297] EXPIRED: 东方日升数字化项目建设汇报.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [158/297] 光储充系统AWS云服务系统架构.pptx
mkdir -p "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22"
RESULT=$(dws drive download --file-id "MyQA2dXW7eK4kqDwi5495L9oJzlwrZgb" --space-id "28724636662" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/光储充系统AWS云服务系统架构.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/光储充系统AWS云服务系统架构.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [158/297] OK: 光储充系统AWS云服务系统架构.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [158/297] FAIL: 光储充系统AWS云服务系统架构.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/光储充系统AWS云服务系统架构.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [158/297] FAIL: 光储充系统AWS云服务系统架构.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/光储充系统AWS云服务系统架构.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [158/297] EXPIRED: 光储充系统AWS云服务系统架构.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [159/297] 日升云AWS系统架构.pptx
mkdir -p "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22"
RESULT=$(dws drive download --file-id "QBnd5ExVEvZn397gH2qpqOmgJyeZqMmz" --space-id "28724636662" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/日升云AWS系统架构.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/日升云AWS系统架构.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [159/297] OK: 日升云AWS系统架构.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [159/297] FAIL: 日升云AWS系统架构.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/日升云AWS系统架构.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [159/297] FAIL: 日升云AWS系统架构.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/日升云AWS系统架构.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [159/297] EXPIRED: 日升云AWS系统架构.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [160/297] 设备管理系统.pptx
mkdir -p "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22"
RESULT=$(dws drive download --file-id "QBnd5ExVEvZn397gH2qZqvzKJyeZqMmz" --space-id "28724636662" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/设备管理系统.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/设备管理系统.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [160/297] OK: 设备管理系统.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [160/297] FAIL: 设备管理系统.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/设备管理系统.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [160/297] FAIL: 设备管理系统.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/设备管理系统.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [160/297] EXPIRED: 设备管理系统.pptx"
  EXPIRE=$((EXPIRE+1))
fi
echo "Progress: 160/$TOTAL done"
sleep 0.2

# [161/297] 资金系统.pptx
mkdir -p "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22"
RESULT=$(dws drive download --file-id "dxXB52LJqnmOEMBzIM61ek9G8qjMp697" --space-id "28724636662" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/资金系统.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/资金系统.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [161/297] OK: 资金系统.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [161/297] FAIL: 资金系统.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/资金系统.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [161/297] FAIL: 资金系统.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/资金系统.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [161/297] EXPIRED: 资金系统.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [162/297] 企业多银行银企直连系统架构.pptx
mkdir -p "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22"
RESULT=$(dws drive download --file-id "QPGYqjpJYrABk3j6CZAO1P248akx1Z5N" --space-id "28724636662" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/企业多银行银企直连系统架构.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/企业多银行银企直连系统架构.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [162/297] OK: 企业多银行银企直连系统架构.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [162/297] FAIL: 企业多银行银企直连系统架构.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/企业多银行银企直连系统架构.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [162/297] FAIL: 企业多银行银企直连系统架构.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/企业多银行银企直连系统架构.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [162/297] EXPIRED: 企业多银行银企直连系统架构.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [163/297] 宁海县数字应用项目补助（已盖章、东方日升、带附件).pdf
mkdir -p "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22"
RESULT=$(dws drive download --file-id "3NwLYZXWynyDjZBYIZbRRrz5VkyEqBQm" --space-id "28724636662" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/宁海县数字应用项目补助（已盖章、东方日升、带附件).pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/宁海县数字应用项目补助（已盖章、东方日升、带附件).pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [163/297] OK: 宁海县数字应用项目补助（已盖章、东方日升、带附件).pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [163/297] FAIL: 宁海县数字应用项目补助（已盖章、东方日升、带附件).pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/宁海县数字应用项目补助（已盖章、东方日升、带附件).pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [163/297] FAIL: 宁海县数字应用项目补助（已盖章、东方日升、带附件).pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/2026年宁海县数字化应用补贴项目/2026-04-22/宁海县数字应用项目补助（已盖章、东方日升、带附件).pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [163/297] EXPIRED: 宁海县数字应用项目补助（已盖章、东方日升、带附件).pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [164/297] navicat软件安装信息报表.xls
mkdir -p "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-25"
RESULT=$(dws drive download --file-id "177540628963" --space-id "25658381388" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-25/navicat软件安装信息报表.xls" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-25/navicat软件安装信息报表.xls" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [164/297] OK: navicat软件安装信息报表.xls ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [164/297] FAIL: navicat软件安装信息报表.xls (empty file)"
      rm -f "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-25/navicat软件安装信息报表.xls"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [164/297] FAIL: navicat软件安装信息报表.xls (curl error)"
    rm -f "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-25/navicat软件安装信息报表.xls"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [164/297] EXPIRED: navicat软件安装信息报表.xls"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [165/297] keil (2).xls
mkdir -p "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-14"
RESULT=$(dws drive download --file-id "176252707414" --space-id "25658381388" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-14/keil (2).xls" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-14/keil (2).xls" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [165/297] OK: keil (2).xls ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [165/297] FAIL: keil (2).xls (empty file)"
      rm -f "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-14/keil (2).xls"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [165/297] FAIL: keil (2).xls (curl error)"
    rm -f "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-14/keil (2).xls"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [165/297] EXPIRED: keil (2).xls"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [166/297] EPLAN.xls
mkdir -p "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-03"
RESULT=$(dws drive download --file-id "175103264456" --space-id "25658381388" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-03/EPLAN.xls" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-03/EPLAN.xls" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [166/297] OK: EPLAN.xls ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [166/297] FAIL: EPLAN.xls (empty file)"
      rm -f "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-03/EPLAN.xls"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [166/297] FAIL: EPLAN.xls (curl error)"
    rm -f "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-03/EPLAN.xls"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [166/297] EXPIRED: EPLAN.xls"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [167/297] 2_EPLAN Company Presentation.pdf
mkdir -p "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-03"
RESULT=$(dws drive download --file-id "175099762793" --space-id "25658381388" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-03/2_EPLAN Company Presentation.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-03/2_EPLAN Company Presentation.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [167/297] OK: 2_EPLAN Company Presentation.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [167/297] FAIL: 2_EPLAN Company Presentation.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-03/2_EPLAN Company Presentation.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [167/297] FAIL: 2_EPLAN Company Presentation.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/IT正版化对应群/2025-04-03/2_EPLAN Company Presentation.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [167/297] EXPIRED: 2_EPLAN Company Presentation.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [168/297] SketchUp软件安装信息报表 .xls
mkdir -p "D:/myfiles/钉钉同步/IT正版化对应群/2024-12-26"
RESULT=$(dws drive download --file-id "164722601037" --space-id "25658381388" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/IT正版化对应群/2024-12-26/SketchUp软件安装信息报表 .xls" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/IT正版化对应群/2024-12-26/SketchUp软件安装信息报表 .xls" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [168/297] OK: SketchUp软件安装信息报表 .xls ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [168/297] FAIL: SketchUp软件安装信息报表 .xls (empty file)"
      rm -f "D:/myfiles/钉钉同步/IT正版化对应群/2024-12-26/SketchUp软件安装信息报表 .xls"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [168/297] FAIL: SketchUp软件安装信息报表 .xls (curl error)"
    rm -f "D:/myfiles/钉钉同步/IT正版化对应群/2024-12-26/SketchUp软件安装信息报表 .xls"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [168/297] EXPIRED: SketchUp软件安装信息报表 .xls"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [169/297] 1683691944786关于东方日升新能源股份有限公司所属网站存在目录遍历安全漏洞通报.docx
mkdir -p "D:/myfiles/钉钉同步/尤赛赛/2023-05-17"
RESULT=$(dws drive download --file-id "GZLxjv9VGwxjLAdxclmyN9yyV6EDybno" --space-id "20188918542" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/尤赛赛/2023-05-17/1683691944786关于东方日升新能源股份有限公司所属网站存在目录遍历安全漏洞通报.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/尤赛赛/2023-05-17/1683691944786关于东方日升新能源股份有限公司所属网站存在目录遍历安全漏洞通报.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [169/297] OK: 1683691944786关于东方日升新能源股份有限公司所属网站存在目录遍历安全漏洞通报.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [169/297] FAIL: 1683691944786关于东方日升新能源股份有限公司所属网站存在目录遍历安全漏洞通报.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/尤赛赛/2023-05-17/1683691944786关于东方日升新能源股份有限公司所属网站存在目录遍历安全漏洞通报.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [169/297] FAIL: 1683691944786关于东方日升新能源股份有限公司所属网站存在目录遍历安全漏洞通报.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/尤赛赛/2023-05-17/1683691944786关于东方日升新能源股份有限公司所属网站存在目录遍历安全漏洞通报.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [169/297] EXPIRED: 1683691944786关于东方日升新能源股份有限公司所属网站存在目录遍历安全漏洞通报.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [170/297] 1683692058369处置文件模板的副本.docx
mkdir -p "D:/myfiles/钉钉同步/尤赛赛/2023-05-17"
RESULT=$(dws drive download --file-id "104743881745" --space-id "20188918542" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/尤赛赛/2023-05-17/1683692058369处置文件模板的副本.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/尤赛赛/2023-05-17/1683692058369处置文件模板的副本.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [170/297] OK: 1683692058369处置文件模板的副本.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [170/297] FAIL: 1683692058369处置文件模板的副本.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/尤赛赛/2023-05-17/1683692058369处置文件模板的副本.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [170/297] FAIL: 1683692058369处置文件模板的副本.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/尤赛赛/2023-05-17/1683692058369处置文件模板的副本.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [170/297] EXPIRED: 1683692058369处置文件模板的副本.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [171/297] 东方日升新能源股份有限公司-隐患通报.pdf
mkdir -p "D:/myfiles/钉钉同步/尤赛赛/2023-05-16"
RESULT=$(dws drive download --file-id "104625056627" --space-id "20188918542" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/尤赛赛/2023-05-16/东方日升新能源股份有限公司-隐患通报.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/尤赛赛/2023-05-16/东方日升新能源股份有限公司-隐患通报.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [171/297] OK: 东方日升新能源股份有限公司-隐患通报.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [171/297] FAIL: 东方日升新能源股份有限公司-隐患通报.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/尤赛赛/2023-05-16/东方日升新能源股份有限公司-隐患通报.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [171/297] FAIL: 东方日升新能源股份有限公司-隐患通报.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/尤赛赛/2023-05-16/东方日升新能源股份有限公司-隐患通报.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [171/297] EXPIRED: 东方日升新能源股份有限公司-隐患通报.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [172/297] 东方日升网络安全隐患告知书.pdf
mkdir -p "D:/myfiles/钉钉同步/尤赛赛/2023-05-16"
RESULT=$(dws drive download --file-id "104625162904" --space-id "20188918542" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/尤赛赛/2023-05-16/东方日升网络安全隐患告知书.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/尤赛赛/2023-05-16/东方日升网络安全隐患告知书.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [172/297] OK: 东方日升网络安全隐患告知书.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [172/297] FAIL: 东方日升网络安全隐患告知书.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/尤赛赛/2023-05-16/东方日升网络安全隐患告知书.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [172/297] FAIL: 东方日升网络安全隐患告知书.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/尤赛赛/2023-05-16/东方日升网络安全隐患告知书.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [172/297] EXPIRED: 东方日升网络安全隐患告知书.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [173/297] AC管理方案-初步.docx
mkdir -p "D:/myfiles/钉钉同步/东方日升网络交流群/2021-09-06"
RESULT=$(dws drive download --file-id "42085532023" --space-id "5065781299" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/东方日升网络交流群/2021-09-06/AC管理方案-初步.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/东方日升网络交流群/2021-09-06/AC管理方案-初步.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [173/297] OK: AC管理方案-初步.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [173/297] FAIL: AC管理方案-初步.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/东方日升网络交流群/2021-09-06/AC管理方案-初步.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [173/297] FAIL: AC管理方案-初步.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/东方日升网络交流群/2021-09-06/AC管理方案-初步.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [173/297] EXPIRED: AC管理方案-初步.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [174/297] 用户信息_2022年12月12日 10_11_24.csv
mkdir -p "D:/myfiles/钉钉同步/张兆德/2022-12-12"
RESULT=$(dws drive download --file-id "91915931611" --space-id "9030242629" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/张兆德/2022-12-12/用户信息_2022年12月12日 10_11_24.csv" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/张兆德/2022-12-12/用户信息_2022年12月12日 10_11_24.csv" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [174/297] OK: 用户信息_2022年12月12日 10_11_24.csv ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [174/297] FAIL: 用户信息_2022年12月12日 10_11_24.csv (empty file)"
      rm -f "D:/myfiles/钉钉同步/张兆德/2022-12-12/用户信息_2022年12月12日 10_11_24.csv"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [174/297] FAIL: 用户信息_2022年12月12日 10_11_24.csv (curl error)"
    rm -f "D:/myfiles/钉钉同步/张兆德/2022-12-12/用户信息_2022年12月12日 10_11_24.csv"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [174/297] EXPIRED: 用户信息_2022年12月12日 10_11_24.csv"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [175/297] ONEDNS运维培训.mp4
mkdir -p "D:/myfiles/钉钉同步/基地信息安全交流群/2024-08-30"
RESULT=$(dws drive download --file-id "GZLxjv9VGq2NyM5LhrbLY0Ow86EDybno" --space-id "24057876631" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/基地信息安全交流群/2024-08-30/ONEDNS运维培训.mp4" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/基地信息安全交流群/2024-08-30/ONEDNS运维培训.mp4" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [175/297] OK: ONEDNS运维培训.mp4 ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [175/297] FAIL: ONEDNS运维培训.mp4 (empty file)"
      rm -f "D:/myfiles/钉钉同步/基地信息安全交流群/2024-08-30/ONEDNS运维培训.mp4"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [175/297] FAIL: ONEDNS运维培训.mp4 (curl error)"
    rm -f "D:/myfiles/钉钉同步/基地信息安全交流群/2024-08-30/ONEDNS运维培训.mp4"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [175/297] EXPIRED: ONEDNS运维培训.mp4"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [176/297] osce基地名单.xlsx
mkdir -p "D:/myfiles/钉钉同步/基地信息安全交流群/2024-07-10"
RESULT=$(dws drive download --file-id "NDoBb60VLQZz5pLwu7O9Pnv5JlemrZQ3" --space-id "24057876631" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/基地信息安全交流群/2024-07-10/osce基地名单.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/基地信息安全交流群/2024-07-10/osce基地名单.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [176/297] OK: osce基地名单.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [176/297] FAIL: osce基地名单.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/基地信息安全交流群/2024-07-10/osce基地名单.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [176/297] FAIL: osce基地名单.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/基地信息安全交流群/2024-07-10/osce基地名单.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [176/297] EXPIRED: osce基地名单.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [177/297] OneDNS_威胁定位处置20240528154139.xlsx
mkdir -p "D:/myfiles/钉钉同步/基地信息安全交流群/2024-05-28"
RESULT=$(dws drive download --file-id "7QG4Yx2JpLPpQ5wKczAEObbkJ9dEq3XD" --space-id "24057876631" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/基地信息安全交流群/2024-05-28/OneDNS_威胁定位处置20240528154139.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/基地信息安全交流群/2024-05-28/OneDNS_威胁定位处置20240528154139.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [177/297] OK: OneDNS_威胁定位处置20240528154139.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [177/297] FAIL: OneDNS_威胁定位处置20240528154139.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/基地信息安全交流群/2024-05-28/OneDNS_威胁定位处置20240528154139.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [177/297] FAIL: OneDNS_威胁定位处置20240528154139.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/基地信息安全交流群/2024-05-28/OneDNS_威胁定位处置20240528154139.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [177/297] EXPIRED: OneDNS_威胁定位处置20240528154139.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [178/297] 运维人员信息安全应急响应课程.pptx
mkdir -p "D:/myfiles/钉钉同步/基地信息安全交流群/2024-04-22"
RESULT=$(dws drive download --file-id "9E05BDRVQ2Z7DmpwfNleORy5J63zgkYA" --space-id "24057876631" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/基地信息安全交流群/2024-04-22/运维人员信息安全应急响应课程.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/基地信息安全交流群/2024-04-22/运维人员信息安全应急响应课程.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [178/297] OK: 运维人员信息安全应急响应课程.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [178/297] FAIL: 运维人员信息安全应急响应课程.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/基地信息安全交流群/2024-04-22/运维人员信息安全应急响应课程.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [178/297] FAIL: 运维人员信息安全应急响应课程.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/基地信息安全交流群/2024-04-22/运维人员信息安全应急响应课程.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [178/297] EXPIRED: 运维人员信息安全应急响应课程.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [179/297] 信息安全宣导视频-成片4.mp4
mkdir -p "D:/myfiles/钉钉同步/基地信息安全交流群/2024-04-22"
RESULT=$(dws drive download --file-id "l6Pm2Db8D4kgb95LuZk4n11w8xLq0Ee4" --space-id "24057876631" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/基地信息安全交流群/2024-04-22/信息安全宣导视频-成片4.mp4" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/基地信息安全交流群/2024-04-22/信息安全宣导视频-成片4.mp4" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [179/297] OK: 信息安全宣导视频-成片4.mp4 ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [179/297] FAIL: 信息安全宣导视频-成片4.mp4 (empty file)"
      rm -f "D:/myfiles/钉钉同步/基地信息安全交流群/2024-04-22/信息安全宣导视频-成片4.mp4"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [179/297] FAIL: 信息安全宣导视频-成片4.mp4 (curl error)"
    rm -f "D:/myfiles/钉钉同步/基地信息安全交流群/2024-04-22/信息安全宣导视频-成片4.mp4"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [179/297] EXPIRED: 信息安全宣导视频-成片4.mp4"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [180/297] IT宽带信息.xlsx
mkdir -p "D:/myfiles/钉钉同步/俞燕莹/2026-04-10"
RESULT=$(dws drive download --file-id "1R7q3QmWee7AAolAFXY2vB4yWxkXOEP2" --space-id "24430664770" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/俞燕莹/2026-04-10/IT宽带信息.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/俞燕莹/2026-04-10/IT宽带信息.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [180/297] OK: IT宽带信息.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [180/297] FAIL: IT宽带信息.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/俞燕莹/2026-04-10/IT宽带信息.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [180/297] FAIL: IT宽带信息.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/俞燕莹/2026-04-10/IT宽带信息.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [180/297] EXPIRED: IT宽带信息.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
echo "Progress: 180/$TOTAL done"
sleep 0.2

# [181/297] 2023基地人员工作执掌统计表_马来基地.xlsx
mkdir -p "D:/myfiles/钉钉同步/基地经理s/2023-03-15"
RESULT=$(dws drive download --file-id "99093927816" --space-id "5184203058" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/基地经理s/2023-03-15/2023基地人员工作执掌统计表_马来基地.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/基地经理s/2023-03-15/2023基地人员工作执掌统计表_马来基地.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [181/297] OK: 2023基地人员工作执掌统计表_马来基地.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [181/297] FAIL: 2023基地人员工作执掌统计表_马来基地.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/基地经理s/2023-03-15/2023基地人员工作执掌统计表_马来基地.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [181/297] FAIL: 2023基地人员工作执掌统计表_马来基地.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/基地经理s/2023-03-15/2023基地人员工作执掌统计表_马来基地.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [181/297] EXPIRED: 2023基地人员工作执掌统计表_马来基地.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [182/297] 2023常州基地人员工作执掌统计表.xlsx
mkdir -p "D:/myfiles/钉钉同步/基地经理s/2023-03-15"
RESULT=$(dws drive download --file-id "99093488533" --space-id "5184203058" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/基地经理s/2023-03-15/2023常州基地人员工作执掌统计表.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/基地经理s/2023-03-15/2023常州基地人员工作执掌统计表.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [182/297] OK: 2023常州基地人员工作执掌统计表.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [182/297] FAIL: 2023常州基地人员工作执掌统计表.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/基地经理s/2023-03-15/2023常州基地人员工作执掌统计表.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [182/297] FAIL: 2023常州基地人员工作执掌统计表.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/基地经理s/2023-03-15/2023常州基地人员工作执掌统计表.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [182/297] EXPIRED: 2023常州基地人员工作执掌统计表.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [183/297] 2023基地人员工作执掌统计表(1).xlsx
mkdir -p "D:/myfiles/钉钉同步/基地经理s/2023-03-15"
RESULT=$(dws drive download --file-id "99093339428" --space-id "5184203058" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/基地经理s/2023-03-15/2023基地人员工作执掌统计表(1).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/基地经理s/2023-03-15/2023基地人员工作执掌统计表(1).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [183/297] OK: 2023基地人员工作执掌统计表(1).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [183/297] FAIL: 2023基地人员工作执掌统计表(1).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/基地经理s/2023-03-15/2023基地人员工作执掌统计表(1).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [183/297] FAIL: 2023基地人员工作执掌统计表(1).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/基地经理s/2023-03-15/2023基地人员工作执掌统计表(1).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [183/297] EXPIRED: 2023基地人员工作执掌统计表(1).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [184/297] 2023基地人员工作执掌统计表-义乌.xlsx
mkdir -p "D:/myfiles/钉钉同步/基地经理s/2023-03-15"
RESULT=$(dws drive download --file-id "99067160048" --space-id "5184203058" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/基地经理s/2023-03-15/2023基地人员工作执掌统计表-义乌.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/基地经理s/2023-03-15/2023基地人员工作执掌统计表-义乌.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [184/297] OK: 2023基地人员工作执掌统计表-义乌.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [184/297] FAIL: 2023基地人员工作执掌统计表-义乌.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/基地经理s/2023-03-15/2023基地人员工作执掌统计表-义乌.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [184/297] FAIL: 2023基地人员工作执掌统计表-义乌.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/基地经理s/2023-03-15/2023基地人员工作执掌统计表-义乌.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [184/297] EXPIRED: 2023基地人员工作执掌统计表-义乌.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [185/297] IT工程类项目验收流程及标准.docx
mkdir -p "D:/myfiles/钉钉同步/基地经理s/2023-03-14"
RESULT=$(dws drive download --file-id "a9E05BDRVQqwQ7x4id5l1M4NV63zgkYA" --space-id "5184203058" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/基地经理s/2023-03-14/IT工程类项目验收流程及标准.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/基地经理s/2023-03-14/IT工程类项目验收流程及标准.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [185/297] OK: IT工程类项目验收流程及标准.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [185/297] FAIL: IT工程类项目验收流程及标准.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/基地经理s/2023-03-14/IT工程类项目验收流程及标准.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [185/297] FAIL: IT工程类项目验收流程及标准.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/基地经理s/2023-03-14/IT工程类项目验收流程及标准.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [185/297] EXPIRED: IT工程类项目验收流程及标准.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [186/297] 102自研mes事故分析报告.pptx
mkdir -p "D:/myfiles/钉钉同步/基地经理s/2023-03-14"
RESULT=$(dws drive download --file-id "qnYMoO1rWxBNeRwMh1de020nJ47Z3je9" --space-id "5184203058" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/基地经理s/2023-03-14/102自研mes事故分析报告.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/基地经理s/2023-03-14/102自研mes事故分析报告.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [186/297] OK: 102自研mes事故分析报告.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [186/297] FAIL: 102自研mes事故分析报告.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/基地经理s/2023-03-14/102自研mes事故分析报告.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [186/297] FAIL: 102自研mes事故分析报告.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/基地经理s/2023-03-14/102自研mes事故分析报告.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [186/297] EXPIRED: 102自研mes事故分析报告.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [187/297] 2023基地人员工作执掌统计表.xlsx
mkdir -p "D:/myfiles/钉钉同步/基地经理s/2023-03-10"
RESULT=$(dws drive download --file-id "98602424203" --space-id "5184203058" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/基地经理s/2023-03-10/2023基地人员工作执掌统计表.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/基地经理s/2023-03-10/2023基地人员工作执掌统计表.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [187/297] OK: 2023基地人员工作执掌统计表.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [187/297] FAIL: 2023基地人员工作执掌统计表.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/基地经理s/2023-03-10/2023基地人员工作执掌统计表.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [187/297] FAIL: 2023基地人员工作执掌统计表.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/基地经理s/2023-03-10/2023基地人员工作执掌统计表.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [187/297] EXPIRED: 2023基地人员工作执掌统计表.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [188/297] 东方日升集团信息安全现状全景报告-v1-2026年4月.docx
mkdir -p "D:/myfiles/钉钉同步/东方日升集团信息安全现状盘点/2026-04-09"
RESULT=$(dws drive download --file-id "Amq4vjg890BXlYOoTQymXqZmJ3kdP0wQ" --space-id "28645236077" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/东方日升集团信息安全现状盘点/2026-04-09/东方日升集团信息安全现状全景报告-v1-2026年4月.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/东方日升集团信息安全现状盘点/2026-04-09/东方日升集团信息安全现状全景报告-v1-2026年4月.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [188/297] OK: 东方日升集团信息安全现状全景报告-v1-2026年4月.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [188/297] FAIL: 东方日升集团信息安全现状全景报告-v1-2026年4月.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/东方日升集团信息安全现状盘点/2026-04-09/东方日升集团信息安全现状全景报告-v1-2026年4月.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [188/297] FAIL: 东方日升集团信息安全现状全景报告-v1-2026年4月.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/东方日升集团信息安全现状盘点/2026-04-09/东方日升集团信息安全现状全景报告-v1-2026年4月.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [188/297] EXPIRED: 东方日升集团信息安全现状全景报告-v1-2026年4月.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [189/297] bobhao邮箱异常简报.docx
mkdir -p "D:/myfiles/钉钉同步/章毅/2026-01-27"
RESULT=$(dws drive download --file-id "X6GRezwJlAj6nlXmuRlGP9DR8dqbropQ" --space-id "28112694580" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/章毅/2026-01-27/bobhao邮箱异常简报.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/章毅/2026-01-27/bobhao邮箱异常简报.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [189/297] OK: bobhao邮箱异常简报.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [189/297] FAIL: bobhao邮箱异常简报.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/章毅/2026-01-27/bobhao邮箱异常简报.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [189/297] FAIL: bobhao邮箱异常简报.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/章毅/2026-01-27/bobhao邮箱异常简报.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [189/297] EXPIRED: bobhao邮箱异常简报.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [190/297] 关于risen.com与enel.com邮件往来遭遇钓鱼诈骗事件的说明及应对建议.docx
mkdir -p "D:/myfiles/钉钉同步/章毅/2026-01-27"
RESULT=$(dws drive download --file-id "4lgGw3P8vRnKA40OUvLNa3n485daZ90D" --space-id "28112694580" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/章毅/2026-01-27/关于risen.com与enel.com邮件往来遭遇钓鱼诈骗事件的说明及应对建议.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/章毅/2026-01-27/关于risen.com与enel.com邮件往来遭遇钓鱼诈骗事件的说明及应对建议.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [190/297] OK: 关于risen.com与enel.com邮件往来遭遇钓鱼诈骗事件的说明及应对建议.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [190/297] FAIL: 关于risen.com与enel.com邮件往来遭遇钓鱼诈骗事件的说明及应对建议.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/章毅/2026-01-27/关于risen.com与enel.com邮件往来遭遇钓鱼诈骗事件的说明及应对建议.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [190/297] FAIL: 关于risen.com与enel.com邮件往来遭遇钓鱼诈骗事件的说明及应对建议.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/章毅/2026-01-27/关于risen.com与enel.com邮件往来遭遇钓鱼诈骗事件的说明及应对建议.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [190/297] EXPIRED: 关于risen.com与enel.com邮件往来遭遇钓鱼诈骗事件的说明及应对建议.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [191/297] 报废设备图片.docx
mkdir -p "D:/myfiles/钉钉同步/章毅/2026-01-22"
RESULT=$(dws drive download --file-id "1R7q3QmWeeK6Xg9kFzqkZvO1WxkXOEP2" --space-id "28112694580" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/章毅/2026-01-22/报废设备图片.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/章毅/2026-01-22/报废设备图片.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [191/297] OK: 报废设备图片.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [191/297] FAIL: 报废设备图片.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/章毅/2026-01-22/报废设备图片.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [191/297] FAIL: 报废设备图片.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/章毅/2026-01-22/报废设备图片.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [191/297] EXPIRED: 报废设备图片.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [192/297] 报废服务器清单(1).xlsx
mkdir -p "D:/myfiles/钉钉同步/章毅/2026-01-22"
RESULT=$(dws drive download --file-id "Exel2BLV5zQaNqGEhjy3mEpqJgk9rpMq" --space-id "28112694580" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/章毅/2026-01-22/报废服务器清单(1).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/章毅/2026-01-22/报废服务器清单(1).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [192/297] OK: 报废服务器清单(1).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [192/297] FAIL: 报废服务器清单(1).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/章毅/2026-01-22/报废服务器清单(1).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [192/297] FAIL: 报废服务器清单(1).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/章毅/2026-01-22/报废服务器清单(1).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [192/297] EXPIRED: 报废服务器清单(1).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [193/297] 东方日升shipp@risen.com.pdf（阿里分析报告）.pdf
mkdir -p "D:/myfiles/钉钉同步/章毅/2026-01-22"
RESULT=$(dws drive download --file-id "pGBa2Lm8aGAEM41gFMjDjrKnVgN7R35y" --space-id "28112694580" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/章毅/2026-01-22/东方日升shipp@risen.com.pdf（阿里分析报告）.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/章毅/2026-01-22/东方日升shipp@risen.com.pdf（阿里分析报告）.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [193/297] OK: 东方日升shipp@risen.com.pdf（阿里分析报告）.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [193/297] FAIL: 东方日升shipp@risen.com.pdf（阿里分析报告）.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/章毅/2026-01-22/东方日升shipp@risen.com.pdf（阿里分析报告）.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [193/297] FAIL: 东方日升shipp@risen.com.pdf（阿里分析报告）.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/章毅/2026-01-22/东方日升shipp@risen.com.pdf（阿里分析报告）.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [193/297] EXPIRED: 东方日升shipp@risen.com.pdf（阿里分析报告）.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [194/297] 26年1月20日客户接收的诈骗邮件分析报告.docx
mkdir -p "D:/myfiles/钉钉同步/章毅/2026-01-21"
RESULT=$(dws drive download --file-id "OG9lyrgJPznBEpYyhb71RlmjWzN67Mw4" --space-id "28112694580" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/章毅/2026-01-21/26年1月20日客户接收的诈骗邮件分析报告.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/章毅/2026-01-21/26年1月20日客户接收的诈骗邮件分析报告.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [194/297] OK: 26年1月20日客户接收的诈骗邮件分析报告.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [194/297] FAIL: 26年1月20日客户接收的诈骗邮件分析报告.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/章毅/2026-01-21/26年1月20日客户接收的诈骗邮件分析报告.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [194/297] FAIL: 26年1月20日客户接收的诈骗邮件分析报告.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/章毅/2026-01-21/26年1月20日客户接收的诈骗邮件分析报告.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [194/297] EXPIRED: 26年1月20日客户接收的诈骗邮件分析报告.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [195/297] 报废服务器清单.xlsx
mkdir -p "D:/myfiles/钉钉同步/章毅/2026-01-20"
RESULT=$(dws drive download --file-id "dxXB52LJqn26YOabtp2dpaY68qjMp697" --space-id "28112694580" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/章毅/2026-01-20/报废服务器清单.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/章毅/2026-01-20/报废服务器清单.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [195/297] OK: 报废服务器清单.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [195/297] FAIL: 报废服务器清单.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/章毅/2026-01-20/报废服务器清单.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [195/297] FAIL: 报废服务器清单.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/章毅/2026-01-20/报废服务器清单.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [195/297] EXPIRED: 报废服务器清单.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [196/297] 开票信息.docx
mkdir -p "D:/myfiles/钉钉同步/蒋昂崇/2021-06-03"
RESULT=$(dws drive download --file-id "36090429897" --space-id "4150608979" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/蒋昂崇/2021-06-03/开票信息.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/蒋昂崇/2021-06-03/开票信息.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [196/297] OK: 开票信息.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [196/297] FAIL: 开票信息.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/蒋昂崇/2021-06-03/开票信息.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [196/297] FAIL: 开票信息.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/蒋昂崇/2021-06-03/开票信息.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [196/297] EXPIRED: 开票信息.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [197/297] 聚光硅业邮箱开通人员名单.xlsx
mkdir -p "D:/myfiles/钉钉同步/蒋昂崇/2021-05-07"
RESULT=$(dws drive download --file-id "34566095505" --space-id "4150608979" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/蒋昂崇/2021-05-07/聚光硅业邮箱开通人员名单.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/蒋昂崇/2021-05-07/聚光硅业邮箱开通人员名单.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [197/297] OK: 聚光硅业邮箱开通人员名单.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [197/297] FAIL: 聚光硅业邮箱开通人员名单.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/蒋昂崇/2021-05-07/聚光硅业邮箱开通人员名单.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [197/297] FAIL: 聚光硅业邮箱开通人员名单.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/蒋昂崇/2021-05-07/聚光硅业邮箱开通人员名单.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [197/297] EXPIRED: 聚光硅业邮箱开通人员名单.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [198/297] 东方日升新能源股份有限公司-渗透测试报告.doc
mkdir -p "D:/myfiles/钉钉同步/TMS服务器运维/2026-03-23"
RESULT=$(dws drive download --file-id "l6Pm2Db8D4yMn7eruGYzkx6j8xLq0Ee4" --space-id "21816581495" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/TMS服务器运维/2026-03-23/东方日升新能源股份有限公司-渗透测试报告.doc" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/TMS服务器运维/2026-03-23/东方日升新能源股份有限公司-渗透测试报告.doc" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [198/297] OK: 东方日升新能源股份有限公司-渗透测试报告.doc ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [198/297] FAIL: 东方日升新能源股份有限公司-渗透测试报告.doc (empty file)"
      rm -f "D:/myfiles/钉钉同步/TMS服务器运维/2026-03-23/东方日升新能源股份有限公司-渗透测试报告.doc"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [198/297] FAIL: 东方日升新能源股份有限公司-渗透测试报告.doc (curl error)"
    rm -f "D:/myfiles/钉钉同步/TMS服务器运维/2026-03-23/东方日升新能源股份有限公司-渗透测试报告.doc"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [198/297] EXPIRED: 东方日升新能源股份有限公司-渗透测试报告.doc"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [199/297] 访问桶域名清单.xlsx
mkdir -p "D:/myfiles/钉钉同步/TMS服务器运维/2026-02-10"
RESULT=$(dws drive download --file-id "P0MALyR8klpzxrbRcQO0N9vGW3bzYmDO" --space-id "21816581495" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/TMS服务器运维/2026-02-10/访问桶域名清单.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/TMS服务器运维/2026-02-10/访问桶域名清单.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [199/297] OK: 访问桶域名清单.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [199/297] FAIL: 访问桶域名清单.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/TMS服务器运维/2026-02-10/访问桶域名清单.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [199/297] FAIL: 访问桶域名清单.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/TMS服务器运维/2026-02-10/访问桶域名清单.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [199/297] EXPIRED: 访问桶域名清单.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [200/297] 访问桶域名清单.xlsx
mkdir -p "D:/myfiles/钉钉同步/TMS服务器运维/2026-02-10"
RESULT=$(dws drive download --file-id "9E05BDRVQ2PRqMN0fqroy53wJ63zgkYA" --space-id "21816581495" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/TMS服务器运维/2026-02-10/访问桶域名清单.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/TMS服务器运维/2026-02-10/访问桶域名清单.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [200/297] OK: 访问桶域名清单.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [200/297] FAIL: 访问桶域名清单.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/TMS服务器运维/2026-02-10/访问桶域名清单.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [200/297] FAIL: 访问桶域名清单.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/TMS服务器运维/2026-02-10/访问桶域名清单.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [200/297] EXPIRED: 访问桶域名清单.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
echo "Progress: 200/$TOTAL done"
sleep 0.2

# [201/297] 东方日升梅桥_机器人配置清单.xlsx
mkdir -p "D:/myfiles/钉钉同步/伍俊杰/2022-05-09"
RESULT=$(dws drive download --file-id "58860054555" --space-id "6778643982" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/伍俊杰/2022-05-09/东方日升梅桥_机器人配置清单.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/伍俊杰/2022-05-09/东方日升梅桥_机器人配置清单.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [201/297] OK: 东方日升梅桥_机器人配置清单.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [201/297] FAIL: 东方日升梅桥_机器人配置清单.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/伍俊杰/2022-05-09/东方日升梅桥_机器人配置清单.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [201/297] FAIL: 东方日升梅桥_机器人配置清单.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/伍俊杰/2022-05-09/东方日升梅桥_机器人配置清单.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [201/297] EXPIRED: 东方日升梅桥_机器人配置清单.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [202/297] 220506东方日升续.docx
mkdir -p "D:/myfiles/钉钉同步/伍俊杰/2022-05-07"
RESULT=$(dws drive download --file-id "58694155823" --space-id "6778643982" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/伍俊杰/2022-05-07/220506东方日升续.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/伍俊杰/2022-05-07/220506东方日升续.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [202/297] OK: 220506东方日升续.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [202/297] FAIL: 220506东方日升续.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/伍俊杰/2022-05-07/220506东方日升续.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [202/297] FAIL: 220506东方日升续.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/伍俊杰/2022-05-07/220506东方日升续.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [202/297] EXPIRED: 220506东方日升续.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [203/297] 220506东方日升续保（梦扬20220424）v2.pdf
mkdir -p "D:/myfiles/钉钉同步/伍俊杰/2022-05-07"
RESULT=$(dws drive download --file-id "58685369695" --space-id "6778643982" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/伍俊杰/2022-05-07/220506东方日升续保（梦扬20220424）v2.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/伍俊杰/2022-05-07/220506东方日升续保（梦扬20220424）v2.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [203/297] OK: 220506东方日升续保（梦扬20220424）v2.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [203/297] FAIL: 220506东方日升续保（梦扬20220424）v2.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/伍俊杰/2022-05-07/220506东方日升续保（梦扬20220424）v2.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [203/297] FAIL: 220506东方日升续保（梦扬20220424）v2.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/伍俊杰/2022-05-07/220506东方日升续保（梦扬20220424）v2.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [203/297] EXPIRED: 220506东方日升续保（梦扬20220424）v2.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [204/297] 220506东方日升续保（梦扬20220424） (1).docx
mkdir -p "D:/myfiles/钉钉同步/伍俊杰/2022-05-06"
RESULT=$(dws drive download --file-id "58592249778" --space-id "6778643982" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/伍俊杰/2022-05-06/220506东方日升续保（梦扬20220424） (1).docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/伍俊杰/2022-05-06/220506东方日升续保（梦扬20220424） (1).docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [204/297] OK: 220506东方日升续保（梦扬20220424） (1).docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [204/297] FAIL: 220506东方日升续保（梦扬20220424） (1).docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/伍俊杰/2022-05-06/220506东方日升续保（梦扬20220424） (1).docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [204/297] FAIL: 220506东方日升续保（梦扬20220424） (1).docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/伍俊杰/2022-05-06/220506东方日升续保（梦扬20220424） (1).docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [204/297] EXPIRED: 220506东方日升续保（梦扬20220424） (1).docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [205/297] 220506东方日升续保（梦扬20220424）.docx
mkdir -p "D:/myfiles/钉钉同步/伍俊杰/2022-05-06"
RESULT=$(dws drive download --file-id "58581856629" --space-id "6778643982" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/伍俊杰/2022-05-06/220506东方日升续保（梦扬20220424）.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/伍俊杰/2022-05-06/220506东方日升续保（梦扬20220424）.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [205/297] OK: 220506东方日升续保（梦扬20220424）.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [205/297] FAIL: 220506东方日升续保（梦扬20220424）.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/伍俊杰/2022-05-06/220506东方日升续保（梦扬20220424）.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [205/297] FAIL: 220506东方日升续保（梦扬20220424）.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/伍俊杰/2022-05-06/220506东方日升续保（梦扬20220424）.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [205/297] EXPIRED: 220506东方日升续保（梦扬20220424）.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [206/297] 东方日升续保（梦扬20220424）.docx
mkdir -p "D:/myfiles/钉钉同步/伍俊杰/2022-05-06"
RESULT=$(dws drive download --file-id "58573500621" --space-id "6778643982" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/伍俊杰/2022-05-06/东方日升续保（梦扬20220424）.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/伍俊杰/2022-05-06/东方日升续保（梦扬20220424）.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [206/297] OK: 东方日升续保（梦扬20220424）.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [206/297] FAIL: 东方日升续保（梦扬20220424）.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/伍俊杰/2022-05-06/东方日升续保（梦扬20220424）.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [206/297] FAIL: 东方日升续保（梦扬20220424）.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/伍俊杰/2022-05-06/东方日升续保（梦扬20220424）.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [206/297] EXPIRED: 东方日升续保（梦扬20220424）.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [207/297] 产品采购合同-东方日升机房精密空调.docx
mkdir -p "D:/myfiles/钉钉同步/伍俊杰/2022-04-24"
RESULT=$(dws drive download --file-id "57670658760" --space-id "6778643982" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/伍俊杰/2022-04-24/产品采购合同-东方日升机房精密空调.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/伍俊杰/2022-04-24/产品采购合同-东方日升机房精密空调.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [207/297] OK: 产品采购合同-东方日升机房精密空调.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [207/297] FAIL: 产品采购合同-东方日升机房精密空调.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/伍俊杰/2022-04-24/产品采购合同-东方日升机房精密空调.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [207/297] FAIL: 产品采购合同-东方日升机房精密空调.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/伍俊杰/2022-04-24/产品采购合同-东方日升机房精密空调.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [207/297] EXPIRED: 产品采购合同-东方日升机房精密空调.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [208/297] 关于20220301-20220330威胁处置报告.docx
mkdir -p "D:/myfiles/钉钉同步/徐建锋/2024-11-14"
RESULT=$(dws drive download --file-id "7QG4Yx2JpL5gx4PxFoXQjBXxJ9dEq3XD" --space-id "25386952504" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/徐建锋/2024-11-14/关于20220301-20220330威胁处置报告.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/徐建锋/2024-11-14/关于20220301-20220330威胁处置报告.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [208/297] OK: 关于20220301-20220330威胁处置报告.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [208/297] FAIL: 关于20220301-20220330威胁处置报告.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/徐建锋/2024-11-14/关于20220301-20220330威胁处置报告.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [208/297] FAIL: 关于20220301-20220330威胁处置报告.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/徐建锋/2024-11-14/关于20220301-20220330威胁处置报告.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [208/297] EXPIRED: 关于20220301-20220330威胁处置报告.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [209/297] 东方日升漏洞攻击事件应急演练报告.pdf
mkdir -p "D:/myfiles/钉钉同步/徐建锋/2024-11-14"
RESULT=$(dws drive download --file-id "159920008084" --space-id "25386952504" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/徐建锋/2024-11-14/东方日升漏洞攻击事件应急演练报告.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/徐建锋/2024-11-14/东方日升漏洞攻击事件应急演练报告.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [209/297] OK: 东方日升漏洞攻击事件应急演练报告.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [209/297] FAIL: 东方日升漏洞攻击事件应急演练报告.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/徐建锋/2024-11-14/东方日升漏洞攻击事件应急演练报告.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [209/297] FAIL: 东方日升漏洞攻击事件应急演练报告.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/徐建锋/2024-11-14/东方日升漏洞攻击事件应急演练报告.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [209/297] EXPIRED: 东方日升漏洞攻击事件应急演练报告.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [210/297] 年产10GWH 高效新型储能系统设备建设项目（一期）RFQ&技术标准V001(1).docx
mkdir -p "D:/myfiles/钉钉同步/徐建锋/2024-11-06"
RESULT=$(dws drive download --file-id "159020845740" --space-id "25386952504" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/徐建锋/2024-11-06/年产10GWH 高效新型储能系统设备建设项目（一期）RFQ&技术标准V001(1).docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/徐建锋/2024-11-06/年产10GWH 高效新型储能系统设备建设项目（一期）RFQ&技术标准V001(1).docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [210/297] OK: 年产10GWH 高效新型储能系统设备建设项目（一期）RFQ&技术标准V001(1).docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [210/297] FAIL: 年产10GWH 高效新型储能系统设备建设项目（一期）RFQ&技术标准V001(1).docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/徐建锋/2024-11-06/年产10GWH 高效新型储能系统设备建设项目（一期）RFQ&技术标准V001(1).docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [210/297] FAIL: 年产10GWH 高效新型储能系统设备建设项目（一期）RFQ&技术标准V001(1).docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/徐建锋/2024-11-06/年产10GWH 高效新型储能系统设备建设项目（一期）RFQ&技术标准V001(1).docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [210/297] EXPIRED: 年产10GWH 高效新型储能系统设备建设项目（一期）RFQ&技术标准V001(1).docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [211/297] 2023年度述职报告-系统架构-汪德嘉.pptx
mkdir -p "D:/myfiles/钉钉同步/徐建锋/2024-11-06"
RESULT=$(dws drive download --file-id "159020804709" --space-id "25386952504" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/徐建锋/2024-11-06/2023年度述职报告-系统架构-汪德嘉.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/徐建锋/2024-11-06/2023年度述职报告-系统架构-汪德嘉.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [211/297] OK: 2023年度述职报告-系统架构-汪德嘉.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [211/297] FAIL: 2023年度述职报告-系统架构-汪德嘉.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/徐建锋/2024-11-06/2023年度述职报告-系统架构-汪德嘉.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [211/297] FAIL: 2023年度述职报告-系统架构-汪德嘉.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/徐建锋/2024-11-06/2023年度述职报告-系统架构-汪德嘉.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [211/297] EXPIRED: 2023年度述职报告-系统架构-汪德嘉.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [212/297] 所有行为日志.xlsx
mkdir -p "D:/myfiles/钉钉同步/徐建锋/2024-11-06"
RESULT=$(dws drive download --file-id "158969646258" --space-id "25386952504" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/徐建锋/2024-11-06/所有行为日志.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/徐建锋/2024-11-06/所有行为日志.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [212/297] OK: 所有行为日志.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [212/297] FAIL: 所有行为日志.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/徐建锋/2024-11-06/所有行为日志.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [212/297] FAIL: 所有行为日志.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/徐建锋/2024-11-06/所有行为日志.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [212/297] EXPIRED: 所有行为日志.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [213/297] 发帖发微博日志.xlsx
mkdir -p "D:/myfiles/钉钉同步/徐建锋/2024-11-06"
RESULT=$(dws drive download --file-id "158967293284" --space-id "25386952504" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/徐建锋/2024-11-06/发帖发微博日志.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/徐建锋/2024-11-06/发帖发微博日志.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [213/297] OK: 发帖发微博日志.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [213/297] FAIL: 发帖发微博日志.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/徐建锋/2024-11-06/发帖发微博日志.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [213/297] FAIL: 发帖发微博日志.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/徐建锋/2024-11-06/发帖发微博日志.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [213/297] EXPIRED: 发帖发微博日志.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [214/297] 上网审计信息(20241104115958).zip
mkdir -p "D:/myfiles/钉钉同步/徐建锋/2024-11-04"
RESULT=$(dws drive download --file-id "158720186274" --space-id "25386952504" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/徐建锋/2024-11-04/上网审计信息(20241104115958).zip" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/徐建锋/2024-11-04/上网审计信息(20241104115958).zip" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [214/297] OK: 上网审计信息(20241104115958).zip ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [214/297] FAIL: 上网审计信息(20241104115958).zip (empty file)"
      rm -f "D:/myfiles/钉钉同步/徐建锋/2024-11-04/上网审计信息(20241104115958).zip"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [214/297] FAIL: 上网审计信息(20241104115958).zip (curl error)"
    rm -f "D:/myfiles/钉钉同步/徐建锋/2024-11-04/上网审计信息(20241104115958).zip"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [214/297] EXPIRED: 上网审计信息(20241104115958).zip"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [215/297] 非授权外连信息.xlsx
mkdir -p "D:/myfiles/钉钉同步/徐建锋/2024-11-04"
RESULT=$(dws drive download --file-id "158714937034" --space-id "25386952504" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/徐建锋/2024-11-04/非授权外连信息.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/徐建锋/2024-11-04/非授权外连信息.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [215/297] OK: 非授权外连信息.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [215/297] FAIL: 非授权外连信息.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/徐建锋/2024-11-04/非授权外连信息.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [215/297] FAIL: 非授权外连信息.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/徐建锋/2024-11-04/非授权外连信息.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [215/297] EXPIRED: 非授权外连信息.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [216/297] 储能用户11.1-11.4行为日志.xlsx
mkdir -p "D:/myfiles/钉钉同步/徐建锋/2024-11-04"
RESULT=$(dws drive download --file-id "158710220711" --space-id "25386952504" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/徐建锋/2024-11-04/储能用户11.1-11.4行为日志.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/徐建锋/2024-11-04/储能用户11.1-11.4行为日志.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [216/297] OK: 储能用户11.1-11.4行为日志.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [216/297] FAIL: 储能用户11.1-11.4行为日志.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/徐建锋/2024-11-04/储能用户11.1-11.4行为日志.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [216/297] FAIL: 储能用户11.1-11.4行为日志.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/徐建锋/2024-11-04/储能用户11.1-11.4行为日志.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [216/297] EXPIRED: 储能用户11.1-11.4行为日志.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [217/297] 信息安全管理项目.docx
mkdir -p "D:/myfiles/钉钉同步/叶阳/2025-03-27"
RESULT=$(dws drive download --file-id "ndMj49yWjXP4B6lnFz16kRy0J3pmz5aA" --space-id "24438777102" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/叶阳/2025-03-27/信息安全管理项目.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/叶阳/2025-03-27/信息安全管理项目.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [217/297] OK: 信息安全管理项目.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [217/297] FAIL: 信息安全管理项目.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/叶阳/2025-03-27/信息安全管理项目.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [217/297] FAIL: 信息安全管理项目.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/叶阳/2025-03-27/信息安全管理项目.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [217/297] EXPIRED: 信息安全管理项目.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [218/297] 东方日升2024年ESG定量数据收集清单 - 信息安全（流程与信息中心）.xlsx
mkdir -p "D:/myfiles/钉钉同步/叶阳/2025-01-07"
RESULT=$(dws drive download --file-id "166056650288" --space-id "24438777102" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/叶阳/2025-01-07/东方日升2024年ESG定量数据收集清单 - 信息安全（流程与信息中心）.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/叶阳/2025-01-07/东方日升2024年ESG定量数据收集清单 - 信息安全（流程与信息中心）.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [218/297] OK: 东方日升2024年ESG定量数据收集清单 - 信息安全（流程与信息中心）.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [218/297] FAIL: 东方日升2024年ESG定量数据收集清单 - 信息安全（流程与信息中心）.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/叶阳/2025-01-07/东方日升2024年ESG定量数据收集清单 - 信息安全（流程与信息中心）.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [218/297] FAIL: 东方日升2024年ESG定量数据收集清单 - 信息安全（流程与信息中心）.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/叶阳/2025-01-07/东方日升2024年ESG定量数据收集清单 - 信息安全（流程与信息中心）.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [218/297] EXPIRED: 东方日升2024年ESG定量数据收集清单 - 信息安全（流程与信息中心）.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [219/297] 东方日升2024年ESG定性收资清单-流程与信息中心.docx
mkdir -p "D:/myfiles/钉钉同步/叶阳/2024-12-31"
RESULT=$(dws drive download --file-id "165256247963" --space-id "24438777102" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/叶阳/2024-12-31/东方日升2024年ESG定性收资清单-流程与信息中心.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/叶阳/2024-12-31/东方日升2024年ESG定性收资清单-流程与信息中心.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [219/297] OK: 东方日升2024年ESG定性收资清单-流程与信息中心.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [219/297] FAIL: 东方日升2024年ESG定性收资清单-流程与信息中心.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/叶阳/2024-12-31/东方日升2024年ESG定性收资清单-流程与信息中心.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [219/297] FAIL: 东方日升2024年ESG定性收资清单-流程与信息中心.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/叶阳/2024-12-31/东方日升2024年ESG定性收资清单-流程与信息中心.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [219/297] EXPIRED: 东方日升2024年ESG定性收资清单-流程与信息中心.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [220/297] 报表运维清单20250307.xlsx
mkdir -p "D:/myfiles/钉钉同步/帆软报表开发群/2025-03-07"
RESULT=$(dws drive download --file-id "pGBa2Lm8aG4K0RZMs9ELqR4KVgN7R35y" --space-id "23083387383" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/帆软报表开发群/2025-03-07/报表运维清单20250307.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/帆软报表开发群/2025-03-07/报表运维清单20250307.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [220/297] OK: 报表运维清单20250307.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [220/297] FAIL: 报表运维清单20250307.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2025-03-07/报表运维清单20250307.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [220/297] FAIL: 报表运维清单20250307.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2025-03-07/报表运维清单20250307.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [220/297] EXPIRED: 报表运维清单20250307.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
echo "Progress: 220/$TOTAL done"
sleep 0.2

# [221/297] 报表运维清单20250228.xlsx
mkdir -p "D:/myfiles/钉钉同步/帆软报表开发群/2025-02-28"
RESULT=$(dws drive download --file-id "LeBq413JAwaX7190FQnebBnKWDOnGvpb" --space-id "23083387383" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/帆软报表开发群/2025-02-28/报表运维清单20250228.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/帆软报表开发群/2025-02-28/报表运维清单20250228.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [221/297] OK: 报表运维清单20250228.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [221/297] FAIL: 报表运维清单20250228.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2025-02-28/报表运维清单20250228.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [221/297] FAIL: 报表运维清单20250228.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2025-02-28/报表运维清单20250228.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [221/297] EXPIRED: 报表运维清单20250228.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [222/297] 报表运维清单20250221.xlsx
mkdir -p "D:/myfiles/钉钉同步/帆软报表开发群/2025-02-21"
RESULT=$(dws drive download --file-id "QPGYqjpJYrBA2pZeSEabO0Qb8akx1Z5N" --space-id "23083387383" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/帆软报表开发群/2025-02-21/报表运维清单20250221.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/帆软报表开发群/2025-02-21/报表运维清单20250221.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [222/297] OK: 报表运维清单20250221.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [222/297] FAIL: 报表运维清单20250221.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2025-02-21/报表运维清单20250221.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [222/297] FAIL: 报表运维清单20250221.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2025-02-21/报表运维清单20250221.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [222/297] EXPIRED: 报表运维清单20250221.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [223/297] 报表运维清单20250214.xlsx
mkdir -p "D:/myfiles/钉钉同步/帆软报表开发群/2025-02-14"
RESULT=$(dws drive download --file-id "G53mjyd80p6G4B09upDEK2pN86zbX04v" --space-id "23083387383" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/帆软报表开发群/2025-02-14/报表运维清单20250214.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/帆软报表开发群/2025-02-14/报表运维清单20250214.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [223/297] OK: 报表运维清单20250214.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [223/297] FAIL: 报表运维清单20250214.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2025-02-14/报表运维清单20250214.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [223/297] FAIL: 报表运维清单20250214.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2025-02-14/报表运维清单20250214.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [223/297] EXPIRED: 报表运维清单20250214.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [224/297] 报表运维清单20250117.xlsx
mkdir -p "D:/myfiles/钉钉同步/帆软报表开发群/2025-01-17"
RESULT=$(dws drive download --file-id "1DKw2zgV2Pld96Kgc1g40nAQ8B5r9YAn" --space-id "23083387383" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/帆软报表开发群/2025-01-17/报表运维清单20250117.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/帆软报表开发群/2025-01-17/报表运维清单20250117.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [224/297] OK: 报表运维清单20250117.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [224/297] FAIL: 报表运维清单20250117.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2025-01-17/报表运维清单20250117.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [224/297] FAIL: 报表运维清单20250117.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2025-01-17/报表运维清单20250117.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [224/297] EXPIRED: 报表运维清单20250117.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [225/297] 报表运维清单20250110.xlsx
mkdir -p "D:/myfiles/钉钉同步/帆软报表开发群/2025-01-10"
RESULT=$(dws drive download --file-id "14dA3GK8gjqMOxQ2so1pq4LqJ9ekBD76" --space-id "23083387383" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/帆软报表开发群/2025-01-10/报表运维清单20250110.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/帆软报表开发群/2025-01-10/报表运维清单20250110.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [225/297] OK: 报表运维清单20250110.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [225/297] FAIL: 报表运维清单20250110.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2025-01-10/报表运维清单20250110.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [225/297] FAIL: 报表运维清单20250110.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2025-01-10/报表运维清单20250110.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [225/297] EXPIRED: 报表运维清单20250110.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [226/297] 报表运维清单20250103.xlsx
mkdir -p "D:/myfiles/钉钉同步/帆软报表开发群/2025-01-03"
RESULT=$(dws drive download --file-id "y20BglGWO2Lyv4xAiQA1aaRA8A7depqY" --space-id "23083387383" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/帆软报表开发群/2025-01-03/报表运维清单20250103.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/帆软报表开发群/2025-01-03/报表运维清单20250103.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [226/297] OK: 报表运维清单20250103.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [226/297] FAIL: 报表运维清单20250103.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2025-01-03/报表运维清单20250103.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [226/297] FAIL: 报表运维清单20250103.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2025-01-03/报表运维清单20250103.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [226/297] EXPIRED: 报表运维清单20250103.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [227/297] 报表运维清单20241227.xlsx
mkdir -p "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-27"
RESULT=$(dws drive download --file-id "7QG4Yx2JpLwaQAxbSoqXXryEJ9dEq3XD" --space-id "23083387383" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-27/报表运维清单20241227.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-27/报表运维清单20241227.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [227/297] OK: 报表运维清单20241227.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [227/297] FAIL: 报表运维清单20241227.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-27/报表运维清单20241227.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [227/297] FAIL: 报表运维清单20241227.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-27/报表运维清单20241227.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [227/297] EXPIRED: 报表运维清单20241227.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [228/297] 报表运维清单20241220.xlsx
mkdir -p "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-20"
RESULT=$(dws drive download --file-id "GZLxjv9VGq5myBkEcO4RPvqR86EDybno" --space-id "23083387383" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-20/报表运维清单20241220.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-20/报表运维清单20241220.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [228/297] OK: 报表运维清单20241220.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [228/297] FAIL: 报表运维清单20241220.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-20/报表运维清单20241220.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [228/297] FAIL: 报表运维清单20241220.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-20/报表运维清单20241220.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [228/297] EXPIRED: 报表运维清单20241220.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [229/297] 报表运维清单20241213.xlsx
mkdir -p "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-13"
RESULT=$(dws drive download --file-id "yQod3RxJKGY0wBeEsppwAeXxJkb4Mw9r" --space-id "23083387383" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-13/报表运维清单20241213.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-13/报表运维清单20241213.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [229/297] OK: 报表运维清单20241213.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [229/297] FAIL: 报表运维清单20241213.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-13/报表运维清单20241213.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [229/297] FAIL: 报表运维清单20241213.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-13/报表运维清单20241213.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [229/297] EXPIRED: 报表运维清单20241213.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [230/297] 报表运维清单20241206.xlsx
mkdir -p "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-06"
RESULT=$(dws drive download --file-id "7QG4Yx2JpLwaQAxbSob74wq0J9dEq3XD" --space-id "23083387383" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-06/报表运维清单20241206.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-06/报表运维清单20241206.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [230/297] OK: 报表运维清单20241206.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [230/297] FAIL: 报表运维清单20241206.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-06/报表运维清单20241206.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [230/297] FAIL: 报表运维清单20241206.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2024-12-06/报表运维清单20241206.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [230/297] EXPIRED: 报表运维清单20241206.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [231/297] 报表运维清单20241122.xlsx
mkdir -p "D:/myfiles/钉钉同步/帆软报表开发群/2024-11-22"
RESULT=$(dws drive download --file-id "MyQA2dXW7e4KNBgXtEP65aqeJzlwrZgb" --space-id "23083387383" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/帆软报表开发群/2024-11-22/报表运维清单20241122.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/帆软报表开发群/2024-11-22/报表运维清单20241122.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [231/297] OK: 报表运维清单20241122.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [231/297] FAIL: 报表运维清单20241122.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2024-11-22/报表运维清单20241122.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [231/297] FAIL: 报表运维清单20241122.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2024-11-22/报表运维清单20241122.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [231/297] EXPIRED: 报表运维清单20241122.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [232/297] 报表运维清单20241115.xlsx
mkdir -p "D:/myfiles/钉钉同步/帆软报表开发群/2024-11-15"
RESULT=$(dws drive download --file-id "wva2dxOW4Yq1gevjHExYj3G2Vbkz3BRL" --space-id "23083387383" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/帆软报表开发群/2024-11-15/报表运维清单20241115.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/帆软报表开发群/2024-11-15/报表运维清单20241115.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [232/297] OK: 报表运维清单20241115.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [232/297] FAIL: 报表运维清单20241115.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2024-11-15/报表运维清单20241115.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [232/297] FAIL: 报表运维清单20241115.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2024-11-15/报表运维清单20241115.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [232/297] EXPIRED: 报表运维清单20241115.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [233/297] risen_data（10.10.8.60）.xlsx
mkdir -p "D:/myfiles/钉钉同步/帆软报表开发群/2024-09-06"
RESULT=$(dws drive download --file-id "gpG2NdyVX37EpXRLfgNo5ppOWMwvDqPk" --space-id "23083387383" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/帆软报表开发群/2024-09-06/risen_data（10.10.8.60）.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/帆软报表开发群/2024-09-06/risen_data（10.10.8.60）.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [233/297] OK: risen_data（10.10.8.60）.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [233/297] FAIL: risen_data（10.10.8.60）.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2024-09-06/risen_data（10.10.8.60）.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [233/297] FAIL: risen_data（10.10.8.60）.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2024-09-06/risen_data（10.10.8.60）.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [233/297] EXPIRED: risen_data（10.10.8.60）.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [234/297] 通过公开链接访问的报表.xlsx
mkdir -p "D:/myfiles/钉钉同步/帆软报表开发群/2024-08-28"
RESULT=$(dws drive download --file-id "QBnd5ExVEvnZYBjGfpXbXqzpJyeZqMmz" --space-id "23083387383" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/帆软报表开发群/2024-08-28/通过公开链接访问的报表.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/帆软报表开发群/2024-08-28/通过公开链接访问的报表.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [234/297] OK: 通过公开链接访问的报表.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [234/297] FAIL: 通过公开链接访问的报表.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2024-08-28/通过公开链接访问的报表.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [234/297] FAIL: 通过公开链接访问的报表.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/帆软报表开发群/2024-08-28/通过公开链接访问的报表.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [234/297] EXPIRED: 通过公开链接访问的报表.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [235/297] 钉钉画册1022-改仙乐.pdf
mkdir -p "D:/myfiles/钉钉同步/东方日升新能源股份有限公司的钉钉官方服务群/2026-03-13"
RESULT=$(dws drive download --file-id "YMyQA2dXW7xagzDBcMvDMlDGVzlwrZgb" --space-id "3677909649" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/东方日升新能源股份有限公司的钉钉官方服务群/2026-03-13/钉钉画册1022-改仙乐.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/东方日升新能源股份有限公司的钉钉官方服务群/2026-03-13/钉钉画册1022-改仙乐.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [235/297] OK: 钉钉画册1022-改仙乐.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [235/297] FAIL: 钉钉画册1022-改仙乐.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/东方日升新能源股份有限公司的钉钉官方服务群/2026-03-13/钉钉画册1022-改仙乐.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [235/297] FAIL: 钉钉画册1022-改仙乐.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/东方日升新能源股份有限公司的钉钉官方服务群/2026-03-13/钉钉画册1022-改仙乐.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [235/297] EXPIRED: 钉钉画册1022-改仙乐.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [236/297] 飓风行动降本增效方案--信息中心.xlsx
mkdir -p "D:/myfiles/钉钉同步/流程与信息中心/2021-04-14"
RESULT=$(dws drive download --file-id "EpGBa2Lm8aZl4lN9Im0b7GxnWgN7R35y" --space-id "2133342470" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/流程与信息中心/2021-04-14/飓风行动降本增效方案--信息中心.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/流程与信息中心/2021-04-14/飓风行动降本增效方案--信息中心.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [236/297] OK: 飓风行动降本增效方案--信息中心.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [236/297] FAIL: 飓风行动降本增效方案--信息中心.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/流程与信息中心/2021-04-14/飓风行动降本增效方案--信息中心.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [236/297] FAIL: 飓风行动降本增效方案--信息中心.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/流程与信息中心/2021-04-14/飓风行动降本增效方案--信息中心.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [236/297] EXPIRED: 飓风行动降本增效方案--信息中心.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [237/297] 个税汇算清缴标准申报手册.pdf
mkdir -p "D:/myfiles/钉钉同步/流程与信息中心/2021-04-13"
RESULT=$(dws drive download --file-id "MNDoBb60VLYXLXkAtbraQa2wJlemrZQ3" --space-id "2133342470" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/流程与信息中心/2021-04-13/个税汇算清缴标准申报手册.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/流程与信息中心/2021-04-13/个税汇算清缴标准申报手册.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [237/297] OK: 个税汇算清缴标准申报手册.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [237/297] FAIL: 个税汇算清缴标准申报手册.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/流程与信息中心/2021-04-13/个税汇算清缴标准申报手册.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [237/297] FAIL: 个税汇算清缴标准申报手册.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/流程与信息中心/2021-04-13/个税汇算清缴标准申报手册.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [237/297] EXPIRED: 个税汇算清缴标准申报手册.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [238/297] 信息中心人员名单.xlsx
mkdir -p "D:/myfiles/钉钉同步/流程与信息中心/2021-04-13"
RESULT=$(dws drive download --file-id "33269611900" --space-id "2133342470" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/流程与信息中心/2021-04-13/信息中心人员名单.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/流程与信息中心/2021-04-13/信息中心人员名单.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [238/297] OK: 信息中心人员名单.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [238/297] FAIL: 信息中心人员名单.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/流程与信息中心/2021-04-13/信息中心人员名单.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [238/297] FAIL: 信息中心人员名单.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/流程与信息中心/2021-04-13/信息中心人员名单.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [238/297] EXPIRED: 信息中心人员名单.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [239/297] 软件开发项目工作项配置最佳实践.pdf
mkdir -p "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-09"
RESULT=$(dws drive download --file-id "X6GRezwJlAel3j71tQ9aNNkq8dqbropQ" --space-id "28229114885" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-09/软件开发项目工作项配置最佳实践.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-09/软件开发项目工作项配置最佳实践.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [239/297] OK: 软件开发项目工作项配置最佳实践.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [239/297] FAIL: 软件开发项目工作项配置最佳实践.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-09/软件开发项目工作项配置最佳实践.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [239/297] FAIL: 软件开发项目工作项配置最佳实践.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-09/软件开发项目工作项配置最佳实践.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [239/297] EXPIRED: 软件开发项目工作项配置最佳实践.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [240/297] 日常代码仓库权限申请表单.xlsx
mkdir -p "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-09"
RESULT=$(dws drive download --file-id "l6Pm2Db8D4G5Ng3EuGZQrNb58xLq0Ee4" --space-id "28229114885" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-09/日常代码仓库权限申请表单.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-09/日常代码仓库权限申请表单.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [240/297] OK: 日常代码仓库权限申请表单.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [240/297] FAIL: 日常代码仓库权限申请表单.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-09/日常代码仓库权限申请表单.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [240/297] FAIL: 日常代码仓库权限申请表单.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-09/日常代码仓库权限申请表单.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [240/297] EXPIRED: 日常代码仓库权限申请表单.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
echo "Progress: 240/$TOTAL done"
sleep 0.2

# [241/297] Gitee项目推进计划V1.0-2026-03-02.xlsx
mkdir -p "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-02"
RESULT=$(dws drive download --file-id "PwkYGxZV3Z7q6QRrivLvMZy0WAgozOKL" --space-id "28229114885" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-02/Gitee项目推进计划V1.0-2026-03-02.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-02/Gitee项目推进计划V1.0-2026-03-02.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [241/297] OK: Gitee项目推进计划V1.0-2026-03-02.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [241/297] FAIL: Gitee项目推进计划V1.0-2026-03-02.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-02/Gitee项目推进计划V1.0-2026-03-02.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [241/297] FAIL: Gitee项目推进计划V1.0-2026-03-02.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-02/Gitee项目推进计划V1.0-2026-03-02.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [241/297] EXPIRED: Gitee项目推进计划V1.0-2026-03-02.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [242/297] Gitee项目推进计划V1.0-2026-02-09.xlsx
mkdir -p "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-09"
RESULT=$(dws drive download --file-id "QBnd5ExVEvenrMwAi0odbK59JyeZqMmz" --space-id "28229114885" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-09/Gitee项目推进计划V1.0-2026-02-09.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-09/Gitee项目推进计划V1.0-2026-02-09.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [242/297] OK: Gitee项目推进计划V1.0-2026-02-09.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [242/297] FAIL: Gitee项目推进计划V1.0-2026-02-09.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-09/Gitee项目推进计划V1.0-2026-02-09.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [242/297] FAIL: Gitee项目推进计划V1.0-2026-02-09.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-09/Gitee项目推进计划V1.0-2026-02-09.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [242/297] EXPIRED: Gitee项目推进计划V1.0-2026-02-09.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [243/297] Gitee账户.xlsx
mkdir -p "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-04"
RESULT=$(dws drive download --file-id "14dA3GK8gjlq7v51i7OyMeRmJ9ekBD76" --space-id "28229114885" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-04/Gitee账户.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-04/Gitee账户.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [243/297] OK: Gitee账户.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [243/297] FAIL: Gitee账户.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-04/Gitee账户.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [243/297] FAIL: Gitee账户.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-04/Gitee账户.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [243/297] EXPIRED: Gitee账户.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [244/297] GiteeSaaSFeaturesList.xlsx
mkdir -p "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-03"
RESULT=$(dws drive download --file-id "pYLaezmVNeMp7aL1TknAd4zrWrMqPxX6" --space-id "28229114885" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-03/GiteeSaaSFeaturesList.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-03/GiteeSaaSFeaturesList.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [244/297] OK: GiteeSaaSFeaturesList.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [244/297] FAIL: GiteeSaaSFeaturesList.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-03/GiteeSaaSFeaturesList.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [244/297] FAIL: GiteeSaaSFeaturesList.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-03/GiteeSaaSFeaturesList.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [244/297] EXPIRED: GiteeSaaSFeaturesList.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [245/297] Gitee项目推进计划V0.1.xlsx
mkdir -p "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-02"
RESULT=$(dws drive download --file-id "mweZ92PV6MbKELvRIexkroaLWxEKBD6p" --space-id "28229114885" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-02/Gitee项目推进计划V0.1.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-02/Gitee项目推进计划V0.1.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [245/297] OK: Gitee项目推进计划V0.1.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [245/297] FAIL: Gitee项目推进计划V0.1.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-02/Gitee项目推进计划V0.1.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [245/297] FAIL: Gitee项目推进计划V0.1.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-02/Gitee项目推进计划V0.1.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [245/297] EXPIRED: Gitee项目推进计划V0.1.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [246/297] [储能BU] 软件代码管理规范-202602.doc
mkdir -p "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-02"
RESULT=$(dws drive download --file-id "1OQX0akWmxdOyN3KiOxwymY58GlDd3mE" --space-id "28229114885" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-02/[储能BU] 软件代码管理规范-202602.doc" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-02/[储能BU] 软件代码管理规范-202602.doc" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [246/297] OK: [储能BU] 软件代码管理规范-202602.doc ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [246/297] FAIL: [储能BU] 软件代码管理规范-202602.doc (empty file)"
      rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-02/[储能BU] 软件代码管理规范-202602.doc"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [246/297] FAIL: [储能BU] 软件代码管理规范-202602.doc (curl error)"
    rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-02-02/[储能BU] 软件代码管理规范-202602.doc"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [246/297] EXPIRED: [储能BU] 软件代码管理规范-202602.doc"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [247/297] Gitee项目推进计划.xlsx
mkdir -p "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-01-30"
RESULT=$(dws drive download --file-id "b9Y4gmKWrP9XDr7gixXp0764JGXn6lpz" --space-id "28229114885" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-01-30/Gitee项目推进计划.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-01-30/Gitee项目推进计划.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [247/297] OK: Gitee项目推进计划.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [247/297] FAIL: Gitee项目推进计划.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-01-30/Gitee项目推进计划.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [247/297] FAIL: Gitee项目推进计划.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-01-30/Gitee项目推进计划.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [247/297] EXPIRED: Gitee项目推进计划.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [248/297] 关于规范研发资料归档及软件代码统一管控的通知.docx
mkdir -p "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-01-30"
RESULT=$(dws drive download --file-id "bva6QBXJwaNvk79Xu6xv6mpNWn4qY5Pr" --space-id "28229114885" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-01-30/关于规范研发资料归档及软件代码统一管控的通知.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-01-30/关于规范研发资料归档及软件代码统一管控的通知.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [248/297] OK: 关于规范研发资料归档及软件代码统一管控的通知.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [248/297] FAIL: 关于规范研发资料归档及软件代码统一管控的通知.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-01-30/关于规范研发资料归档及软件代码统一管控的通知.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [248/297] FAIL: 关于规范研发资料归档及软件代码统一管控的通知.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-01-30/关于规范研发资料归档及软件代码统一管控的通知.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [248/297] EXPIRED: 关于规范研发资料归档及软件代码统一管控的通知.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [249/297] 企业权限管理.pdf
mkdir -p "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-09"
RESULT=$(dws drive download --file-id "ndMj49yWjXAdbgP1cD35NY9oJ3pmz5aA" --space-id "28229114885" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-09/企业权限管理.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-09/企业权限管理.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [249/297] OK: 企业权限管理.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [249/297] FAIL: 企业权限管理.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-09/企业权限管理.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [249/297] FAIL: 企业权限管理.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/研发资料与软件代码管理推动群/2026-03-09/企业权限管理.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [249/297] EXPIRED: 企业权限管理.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [250/297] KPI_xxx.xlsx
mkdir -p "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-09"
RESULT=$(dws drive download --file-id "122210679922" --space-id "22568781986" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-09/KPI_xxx.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-09/KPI_xxx.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [250/297] OK: KPI_xxx.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [250/297] FAIL: KPI_xxx.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-09/KPI_xxx.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [250/297] FAIL: KPI_xxx.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-09/KPI_xxx.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [250/297] EXPIRED: KPI_xxx.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [251/297] 各基地基础架构设备保固统计及配件更换情况.xlsx
mkdir -p "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-07"
RESULT=$(dws drive download --file-id "0eMKjyp813YZOXLbUGPo3v5OVxAZB1Gv" --space-id "22568781986" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-07/各基地基础架构设备保固统计及配件更换情况.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-07/各基地基础架构设备保固统计及配件更换情况.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [251/297] OK: 各基地基础架构设备保固统计及配件更换情况.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [251/297] FAIL: 各基地基础架构设备保固统计及配件更换情况.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-07/各基地基础架构设备保固统计及配件更换情况.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [251/297] FAIL: 各基地基础架构设备保固统计及配件更换情况.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-07/各基地基础架构设备保固统计及配件更换情况.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [251/297] EXPIRED: 各基地基础架构设备保固统计及配件更换情况.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [252/297] 9月21日MES系统异常报告.pptx
mkdir -p "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-07"
RESULT=$(dws drive download --file-id "7QG4Yx2JpLn931qmh2RrKQm3J9dEq3XD" --space-id "22568781986" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-07/9月21日MES系统异常报告.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-07/9月21日MES系统异常报告.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [252/297] OK: 9月21日MES系统异常报告.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [252/297] FAIL: 9月21日MES系统异常报告.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-07/9月21日MES系统异常报告.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [252/297] FAIL: 9月21日MES系统异常报告.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-07/9月21日MES系统异常报告.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [252/297] EXPIRED: 9月21日MES系统异常报告.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [253/297] 5月17日组件车间PMS过站异常报告.pptx
mkdir -p "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-07"
RESULT=$(dws drive download --file-id "4lgGw3P8vRzkL1B3UPxkDaYD85daZ90D" --space-id "22568781986" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-07/5月17日组件车间PMS过站异常报告.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-07/5月17日组件车间PMS过站异常报告.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [253/297] OK: 5月17日组件车间PMS过站异常报告.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [253/297] FAIL: 5月17日组件车间PMS过站异常报告.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-07/5月17日组件车间PMS过站异常报告.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [253/297] FAIL: 5月17日组件车间PMS过站异常报告.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/光伏信息部周会群/2023-11-07/5月17日组件车间PMS过站异常报告.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [253/297] EXPIRED: 5月17日组件车间PMS过站异常报告.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [254/297] 1994820480176854-东方日升集团-20221026113849-item_consume_overview.pdf
mkdir -p "D:/myfiles/钉钉同步/姜滢/2022-10-26"
RESULT=$(dws drive download --file-id "71875590027" --space-id "5801553425" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/姜滢/2022-10-26/1994820480176854-东方日升集团-20221026113849-item_consume_overview.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/姜滢/2022-10-26/1994820480176854-东方日升集团-20221026113849-item_consume_overview.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [254/297] OK: 1994820480176854-东方日升集团-20221026113849-item_consume_overview.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [254/297] FAIL: 1994820480176854-东方日升集团-20221026113849-item_consume_overview.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/姜滢/2022-10-26/1994820480176854-东方日升集团-20221026113849-item_consume_overview.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [254/297] FAIL: 1994820480176854-东方日升集团-20221026113849-item_consume_overview.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/姜滢/2022-10-26/1994820480176854-东方日升集团-20221026113849-item_consume_overview.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [254/297] EXPIRED: 1994820480176854-东方日升集团-20221026113849-item_consume_overview.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [255/297] 1994820480176854-东方日升集团-20221026112826-item_consume_overview.pdf
mkdir -p "D:/myfiles/钉钉同步/姜滢/2022-10-26"
RESULT=$(dws drive download --file-id "71873325595" --space-id "5801553425" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/姜滢/2022-10-26/1994820480176854-东方日升集团-20221026112826-item_consume_overview.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/姜滢/2022-10-26/1994820480176854-东方日升集团-20221026112826-item_consume_overview.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [255/297] OK: 1994820480176854-东方日升集团-20221026112826-item_consume_overview.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [255/297] FAIL: 1994820480176854-东方日升集团-20221026112826-item_consume_overview.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/姜滢/2022-10-26/1994820480176854-东方日升集团-20221026112826-item_consume_overview.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [255/297] FAIL: 1994820480176854-东方日升集团-20221026112826-item_consume_overview.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/姜滢/2022-10-26/1994820480176854-东方日升集团-20221026112826-item_consume_overview.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [255/297] EXPIRED: 1994820480176854-东方日升集团-20221026112826-item_consume_overview.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [256/297] 1994820480176854-东方日升集团-20221026112555-item_consume_overview.zip
mkdir -p "D:/myfiles/钉钉同步/姜滢/2022-10-26"
RESULT=$(dws drive download --file-id "71873047780" --space-id "5801553425" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/姜滢/2022-10-26/1994820480176854-东方日升集团-20221026112555-item_consume_overview.zip" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/姜滢/2022-10-26/1994820480176854-东方日升集团-20221026112555-item_consume_overview.zip" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [256/297] OK: 1994820480176854-东方日升集团-20221026112555-item_consume_overview.zip ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [256/297] FAIL: 1994820480176854-东方日升集团-20221026112555-item_consume_overview.zip (empty file)"
      rm -f "D:/myfiles/钉钉同步/姜滢/2022-10-26/1994820480176854-东方日升集团-20221026112555-item_consume_overview.zip"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [256/297] FAIL: 1994820480176854-东方日升集团-20221026112555-item_consume_overview.zip (curl error)"
    rm -f "D:/myfiles/钉钉同步/姜滢/2022-10-26/1994820480176854-东方日升集团-20221026112555-item_consume_overview.zip"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [256/297] EXPIRED: 1994820480176854-东方日升集团-20221026112555-item_consume_overview.zip"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [257/297] 阿里云订单详情.txt
mkdir -p "D:/myfiles/钉钉同步/姜滢/2022-10-26"
RESULT=$(dws drive download --file-id "71872551066" --space-id "5801553425" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/姜滢/2022-10-26/阿里云订单详情.txt" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/姜滢/2022-10-26/阿里云订单详情.txt" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [257/297] OK: 阿里云订单详情.txt ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [257/297] FAIL: 阿里云订单详情.txt (empty file)"
      rm -f "D:/myfiles/钉钉同步/姜滢/2022-10-26/阿里云订单详情.txt"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [257/297] FAIL: 阿里云订单详情.txt (curl error)"
    rm -f "D:/myfiles/钉钉同步/姜滢/2022-10-26/阿里云订单详情.txt"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [257/297] EXPIRED: 阿里云订单详情.txt"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [258/297] 云上企业网上内容视频.mp4
mkdir -p "D:/myfiles/钉钉同步/姜滢/2022-10-26"
RESULT=$(dws drive download --file-id "71870532617" --space-id "5801553425" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/姜滢/2022-10-26/云上企业网上内容视频.mp4" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/姜滢/2022-10-26/云上企业网上内容视频.mp4" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [258/297] OK: 云上企业网上内容视频.mp4 ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [258/297] FAIL: 云上企业网上内容视频.mp4 (empty file)"
      rm -f "D:/myfiles/钉钉同步/姜滢/2022-10-26/云上企业网上内容视频.mp4"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [258/297] FAIL: 云上企业网上内容视频.mp4 (curl error)"
    rm -f "D:/myfiles/钉钉同步/姜滢/2022-10-26/云上企业网上内容视频.mp4"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [258/297] EXPIRED: 云上企业网上内容视频.mp4"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [259/297] 企业用云情况.doc
mkdir -p "D:/myfiles/钉钉同步/姜滢/2022-10-26"
RESULT=$(dws drive download --file-id "71870463122" --space-id "5801553425" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/姜滢/2022-10-26/企业用云情况.doc" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/姜滢/2022-10-26/企业用云情况.doc" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [259/297] OK: 企业用云情况.doc ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [259/297] FAIL: 企业用云情况.doc (empty file)"
      rm -f "D:/myfiles/钉钉同步/姜滢/2022-10-26/企业用云情况.doc"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [259/297] FAIL: 企业用云情况.doc (curl error)"
    rm -f "D:/myfiles/钉钉同步/姜滢/2022-10-26/企业用云情况.doc"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [259/297] EXPIRED: 企业用云情况.doc"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [260/297] 钉钉安全处置指南（员工版）.docx
mkdir -p "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-24"
RESULT=$(dws drive download --file-id "OG9lyrgJPzrAzkYRiwZeZzDxWzN67Mw4" --space-id "27084066795" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-24/钉钉安全处置指南（员工版）.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-24/钉钉安全处置指南（员工版）.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [260/297] OK: 钉钉安全处置指南（员工版）.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [260/297] FAIL: 钉钉安全处置指南（员工版）.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-24/钉钉安全处置指南（员工版）.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [260/297] FAIL: 钉钉安全处置指南（员工版）.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-24/钉钉安全处置指南（员工版）.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [260/297] EXPIRED: 钉钉安全处置指南（员工版）.docx"
  EXPIRE=$((EXPIRE+1))
fi
echo "Progress: 260/$TOTAL done"
sleep 0.2

# [261/297] 钉钉安全处置指南（管理员版）.docx
mkdir -p "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-24"
RESULT=$(dws drive download --file-id "QPGYqjpJYrNLr7l4iRDmQYMd8akx1Z5N" --space-id "27084066795" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-24/钉钉安全处置指南（管理员版）.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-24/钉钉安全处置指南（管理员版）.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [261/297] OK: 钉钉安全处置指南（管理员版）.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [261/297] FAIL: 钉钉安全处置指南（管理员版）.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-24/钉钉安全处置指南（管理员版）.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [261/297] FAIL: 钉钉安全处置指南（管理员版）.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-24/钉钉安全处置指南（管理员版）.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [261/297] EXPIRED: 钉钉安全处置指南（管理员版）.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [262/297] 【已披露】银狐事件解析、预防和钉钉平台响应方案_.docx
mkdir -p "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-09"
RESULT=$(dws drive download --file-id "R4GpnMqJzGkvGmyjUgwQn6gB8Ke0xjE3" --space-id "27084066795" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-09/【已披露】银狐事件解析、预防和钉钉平台响应方案_.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-09/【已披露】银狐事件解析、预防和钉钉平台响应方案_.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [262/297] OK: 【已披露】银狐事件解析、预防和钉钉平台响应方案_.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [262/297] FAIL: 【已披露】银狐事件解析、预防和钉钉平台响应方案_.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-09/【已披露】银狐事件解析、预防和钉钉平台响应方案_.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [262/297] FAIL: 【已披露】银狐事件解析、预防和钉钉平台响应方案_.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-09/【已披露】银狐事件解析、预防和钉钉平台响应方案_.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [262/297] EXPIRED: 【已披露】银狐事件解析、预防和钉钉平台响应方案_.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [263/297] 钉钉专属版产品新功能发布25年7-9月.docx
mkdir -p "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-09"
RESULT=$(dws drive download --file-id "4lgGw3P8vRgeR209SRwaxYaL85daZ90D" --space-id "27084066795" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-09/钉钉专属版产品新功能发布25年7-9月.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-09/钉钉专属版产品新功能发布25年7-9月.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [263/297] OK: 钉钉专属版产品新功能发布25年7-9月.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [263/297] FAIL: 钉钉专属版产品新功能发布25年7-9月.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-09/钉钉专属版产品新功能发布25年7-9月.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [263/297] FAIL: 钉钉专属版产品新功能发布25年7-9月.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/钉钉主管理员沟通群/2025-10-09/钉钉专属版产品新功能发布25年7-9月.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [263/297] EXPIRED: 钉钉专属版产品新功能发布25年7-9月.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [264/297] 2线未过站统计表(9).xlsx
mkdir -p "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-13"
RESULT=$(dws drive download --file-id "20eMKjyp81KO47poUM5aD7xpVxAZB1Gv" --space-id "5341237114" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-13/2线未过站统计表(9).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-13/2线未过站统计表(9).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [264/297] OK: 2线未过站统计表(9).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [264/297] FAIL: 2线未过站统计表(9).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-13/2线未过站统计表(9).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [264/297] FAIL: 2线未过站统计表(9).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-13/2线未过站统计表(9).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [264/297] EXPIRED: 2线未过站统计表(9).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [265/297] 1线无信息组件条码 (自动保存的)(10).xlsx
mkdir -p "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-13"
RESULT=$(dws drive download --file-id "7NkDwLng8ZkKeZ5qcERgqmwGWKMEvZBY" --space-id "5341237114" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-13/1线无信息组件条码 (自动保存的)(10).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-13/1线无信息组件条码 (自动保存的)(10).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [265/297] OK: 1线无信息组件条码 (自动保存的)(10).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [265/297] FAIL: 1线无信息组件条码 (自动保存的)(10).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-13/1线无信息组件条码 (自动保存的)(10).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [265/297] FAIL: 1线无信息组件条码 (自动保存的)(10).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-13/1线无信息组件条码 (自动保存的)(10).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [265/297] EXPIRED: 1线无信息组件条码 (自动保存的)(10).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [266/297] 2线未过站统计表(3)(2).xlsx
mkdir -p "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12"
RESULT=$(dws drive download --file-id "YndMj49yWjxmjGQ9IlvjBj5PJ3pmz5aA" --space-id "5341237114" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12/2线未过站统计表(3)(2).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12/2线未过站统计表(3)(2).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [266/297] OK: 2线未过站统计表(3)(2).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [266/297] FAIL: 2线未过站统计表(3)(2).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12/2线未过站统计表(3)(2).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [266/297] FAIL: 2线未过站统计表(3)(2).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12/2线未过站统计表(3)(2).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [266/297] EXPIRED: 2线未过站统计表(3)(2).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [267/297] 1线无信息组件条码 (自动保存的)(9).xlsx
mkdir -p "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12"
RESULT=$(dws drive download --file-id "XPwkYGxZV3vyp1zeU5QzaYblWAgozOKL" --space-id "5341237114" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12/1线无信息组件条码 (自动保存的)(9).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12/1线无信息组件条码 (自动保存的)(9).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [267/297] OK: 1线无信息组件条码 (自动保存的)(9).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [267/297] FAIL: 1线无信息组件条码 (自动保存的)(9).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12/1线无信息组件条码 (自动保存的)(9).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [267/297] FAIL: 1线无信息组件条码 (自动保存的)(9).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12/1线无信息组件条码 (自动保存的)(9).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [267/297] EXPIRED: 1线无信息组件条码 (自动保存的)(9).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [268/297] 1线无信息组件条码 (自动保存的)(7).xlsx
mkdir -p "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12"
RESULT=$(dws drive download --file-id "XPwkYGxZV3vyp1zeU5eN9bDGWAgozOKL" --space-id "5341237114" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12/1线无信息组件条码 (自动保存的)(7).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12/1线无信息组件条码 (自动保存的)(7).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [268/297] OK: 1线无信息组件条码 (自动保存的)(7).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [268/297] FAIL: 1线无信息组件条码 (自动保存的)(7).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12/1线无信息组件条码 (自动保存的)(7).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [268/297] FAIL: 1线无信息组件条码 (自动保存的)(7).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12/1线无信息组件条码 (自动保存的)(7).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [268/297] EXPIRED: 1线无信息组件条码 (自动保存的)(7).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [269/297] 2线未过站统计表(7).xlsx
mkdir -p "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12"
RESULT=$(dws drive download --file-id "ydxXB52LJqKe0G6XU6RoKdw5WqjMp697" --space-id "5341237114" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12/2线未过站统计表(7).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12/2线未过站统计表(7).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [269/297] OK: 2线未过站统计表(7).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [269/297] FAIL: 2线未过站统计表(7).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12/2线未过站统计表(7).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [269/297] FAIL: 2线未过站统计表(7).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-12/2线未过站统计表(7).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [269/297] EXPIRED: 2线未过站统计表(7).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [270/297] 2线未过站统计表(2)(1).xlsx
mkdir -p "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11"
RESULT=$(dws drive download --file-id "gwva2dxOW49yDoZlHjrYvgbkVbkz3BRL" --space-id "5341237114" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11/2线未过站统计表(2)(1).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11/2线未过站统计表(2)(1).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [270/297] OK: 2线未过站统计表(2)(1).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [270/297] FAIL: 2线未过站统计表(2)(1).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11/2线未过站统计表(2)(1).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [270/297] FAIL: 2线未过站统计表(2)(1).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11/2线未过站统计表(2)(1).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [270/297] EXPIRED: 2线未过站统计表(2)(1).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [271/297] 1线无信息).xlsx
mkdir -p "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11"
RESULT=$(dws drive download --file-id "oP0MALyR8kObwd6DHbpDx1jy83bzYmDO" --space-id "5341237114" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11/1线无信息).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11/1线无信息).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [271/297] OK: 1线无信息).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [271/297] FAIL: 1线无信息).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11/1线无信息).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [271/297] FAIL: 1线无信息).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11/1线无信息).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [271/297] EXPIRED: 1线无信息).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [272/297] 4_1线无信息组件条码 (自动保存的).xlsx
mkdir -p "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11"
RESULT=$(dws drive download --file-id "QG53mjyd80lyK7roUq9wwYeB86zbX04v" --space-id "5341237114" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11/4_1线无信息组件条码 (自动保存的).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11/4_1线无信息组件条码 (自动保存的).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [272/297] OK: 4_1线无信息组件条码 (自动保存的).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [272/297] FAIL: 4_1线无信息组件条码 (自动保存的).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11/4_1线无信息组件条码 (自动保存的).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [272/297] FAIL: 4_1线无信息组件条码 (自动保存的).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11/4_1线无信息组件条码 (自动保存的).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [272/297] EXPIRED: 4_1线无信息组件条码 (自动保存的).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [273/297] 5_2线未过站统计表.xlsx
mkdir -p "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11"
RESULT=$(dws drive download --file-id "dQPGYqjpJYNmYz5qFAeBZBok8akx1Z5N" --space-id "5341237114" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11/5_2线未过站统计表.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11/5_2线未过站统计表.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [273/297] OK: 5_2线未过站统计表.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [273/297] FAIL: 5_2线未过站统计表.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11/5_2线未过站统计表.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [273/297] FAIL: 5_2线未过站统计表.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/宁海基地MES问题反馈群/2022-01-11/5_2线未过站统计表.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [273/297] EXPIRED: 5_2线未过站统计表.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [274/297] 2.txt
mkdir -p "D:/myfiles/钉钉同步/无线频繁断网问题跟踪群/2026-02-02"
RESULT=$(dws drive download --file-id "4lgGw3P8vRnk9dd1Fv5eb2Qd85daZ90D" --space-id "28176753464" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/无线频繁断网问题跟踪群/2026-02-02/2.txt" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/无线频繁断网问题跟踪群/2026-02-02/2.txt" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [274/297] OK: 2.txt ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [274/297] FAIL: 2.txt (empty file)"
      rm -f "D:/myfiles/钉钉同步/无线频繁断网问题跟踪群/2026-02-02/2.txt"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [274/297] FAIL: 2.txt (curl error)"
    rm -f "D:/myfiles/钉钉同步/无线频繁断网问题跟踪群/2026-02-02/2.txt"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [274/297] EXPIRED: 2.txt"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [275/297] 1.txt
mkdir -p "D:/myfiles/钉钉同步/无线频繁断网问题跟踪群/2026-02-02"
RESULT=$(dws drive download --file-id "MyQA2dXW7eQ0b55mukmzO4zdJzlwrZgb" --space-id "28176753464" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/无线频繁断网问题跟踪群/2026-02-02/1.txt" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/无线频繁断网问题跟踪群/2026-02-02/1.txt" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [275/297] OK: 1.txt ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [275/297] FAIL: 1.txt (empty file)"
      rm -f "D:/myfiles/钉钉同步/无线频繁断网问题跟踪群/2026-02-02/1.txt"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [275/297] FAIL: 1.txt (curl error)"
    rm -f "D:/myfiles/钉钉同步/无线频繁断网问题跟踪群/2026-02-02/1.txt"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [275/297] EXPIRED: 1.txt"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [276/297] 3.txt
mkdir -p "D:/myfiles/钉钉同步/无线频繁断网问题跟踪群/2026-02-02"
RESULT=$(dws drive download --file-id "wva2dxOW4YQnr55zuAw2RoBNVbkz3BRL" --space-id "28176753464" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/无线频繁断网问题跟踪群/2026-02-02/3.txt" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/无线频繁断网问题跟踪群/2026-02-02/3.txt" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [276/297] OK: 3.txt ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [276/297] FAIL: 3.txt (empty file)"
      rm -f "D:/myfiles/钉钉同步/无线频繁断网问题跟踪群/2026-02-02/3.txt"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [276/297] FAIL: 3.txt (curl error)"
    rm -f "D:/myfiles/钉钉同步/无线频繁断网问题跟踪群/2026-02-02/3.txt"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [276/297] EXPIRED: 3.txt"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [277/297] 流程与信息中心-执行中项目汇总-模板.pptx
mkdir -p "D:/myfiles/钉钉同步/信息中心核心管理群/2023-12-22"
RESULT=$(dws drive download --file-id "PwkYGxZV3Zppn3wLs2a9X6OZWAgozOKL" --space-id "22108578713" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/信息中心核心管理群/2023-12-22/流程与信息中心-执行中项目汇总-模板.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/信息中心核心管理群/2023-12-22/流程与信息中心-执行中项目汇总-模板.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [277/297] OK: 流程与信息中心-执行中项目汇总-模板.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [277/297] FAIL: 流程与信息中心-执行中项目汇总-模板.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/信息中心核心管理群/2023-12-22/流程与信息中心-执行中项目汇总-模板.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [277/297] FAIL: 流程与信息中心-执行中项目汇总-模板.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/信息中心核心管理群/2023-12-22/流程与信息中心-执行中项目汇总-模板.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [277/297] EXPIRED: 流程与信息中心-执行中项目汇总-模板.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [278/297] 流程与信息中心季度评奖机制-20230808.xlsx
mkdir -p "D:/myfiles/钉钉同步/信息中心核心管理群/2023-08-15"
RESULT=$(dws drive download --file-id "Exel2BLV5zPPRpogcxELrAE2Jgk9rpMq" --space-id "22108578713" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/信息中心核心管理群/2023-08-15/流程与信息中心季度评奖机制-20230808.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/信息中心核心管理群/2023-08-15/流程与信息中心季度评奖机制-20230808.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [278/297] OK: 流程与信息中心季度评奖机制-20230808.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [278/297] FAIL: 流程与信息中心季度评奖机制-20230808.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/信息中心核心管理群/2023-08-15/流程与信息中心季度评奖机制-20230808.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [278/297] FAIL: 流程与信息中心季度评奖机制-20230808.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/信息中心核心管理群/2023-08-15/流程与信息中心季度评奖机制-20230808.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [278/297] EXPIRED: 流程与信息中心季度评奖机制-20230808.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [279/297] OceanBase数据迁移集成技术.pdf
mkdir -p "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-23"
RESULT=$(dws drive download --file-id "9bN7RYPWdMRZeNGaHqYYEoakVZd1wyK0" --space-id "27125381649" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-23/OceanBase数据迁移集成技术.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-23/OceanBase数据迁移集成技术.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [279/297] OK: OceanBase数据迁移集成技术.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [279/297] FAIL: OceanBase数据迁移集成技术.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-23/OceanBase数据迁移集成技术.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [279/297] FAIL: OceanBase数据迁移集成技术.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-23/OceanBase数据迁移集成技术.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [279/297] EXPIRED: OceanBase数据迁移集成技术.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [280/297] OceanBase运维管理_V4.0.pdf
mkdir -p "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-23"
RESULT=$(dws drive download --file-id "1zknDm0WRa4n2OAYIBjjAdbN8BQEx5rG" --space-id "27125381649" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-23/OceanBase运维管理_V4.0.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-23/OceanBase运维管理_V4.0.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [280/297] OK: OceanBase运维管理_V4.0.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [280/297] FAIL: OceanBase运维管理_V4.0.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-23/OceanBase运维管理_V4.0.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [280/297] FAIL: OceanBase运维管理_V4.0.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-23/OceanBase运维管理_V4.0.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [280/297] EXPIRED: OceanBase运维管理_V4.0.pdf"
  EXPIRE=$((EXPIRE+1))
fi
echo "Progress: 280/$TOTAL done"
sleep 0.2

# [281/297] OceanBase集群架构_V4.0.pptx
mkdir -p "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-16"
RESULT=$(dws drive download --file-id "l6Pm2Db8D4R9Z2xNSY9z7akL8xLq0Ee4" --space-id "27125381649" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-16/OceanBase集群架构_V4.0.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-16/OceanBase集群架构_V4.0.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [281/297] OK: OceanBase集群架构_V4.0.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [281/297] FAIL: OceanBase集群架构_V4.0.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-16/OceanBase集群架构_V4.0.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [281/297] FAIL: OceanBase集群架构_V4.0.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-16/OceanBase集群架构_V4.0.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [281/297] EXPIRED: OceanBase集群架构_V4.0.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [282/297] 东方日升OB数据库开发培训 20260116.pptx
mkdir -p "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-16"
RESULT=$(dws drive download --file-id "14dA3GK8gjYnGpZ7ckKZQnyMJ9ekBD76" --space-id "27125381649" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-16/东方日升OB数据库开发培训 20260116.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-16/东方日升OB数据库开发培训 20260116.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [282/297] OK: 东方日升OB数据库开发培训 20260116.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [282/297] FAIL: 东方日升OB数据库开发培训 20260116.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-16/东方日升OB数据库开发培训 20260116.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [282/297] FAIL: 东方日升OB数据库开发培训 20260116.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2026-01-16/东方日升OB数据库开发培训 20260116.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [282/297] EXPIRED: 东方日升OB数据库开发培训 20260116.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [283/297] Oracle性能分析和sql执行原理.pptx
mkdir -p "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2025-12-26"
RESULT=$(dws drive download --file-id "ZQYprEoWonqAOR24SreKzkwn81waOeDk" --space-id "27125381649" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2025-12-26/Oracle性能分析和sql执行原理.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2025-12-26/Oracle性能分析和sql执行原理.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [283/297] OK: Oracle性能分析和sql执行原理.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [283/297] FAIL: Oracle性能分析和sql执行原理.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2025-12-26/Oracle性能分析和sql执行原理.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [283/297] FAIL: Oracle性能分析和sql执行原理.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2025-12-26/Oracle性能分析和sql执行原理.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [283/297] EXPIRED: Oracle性能分析和sql执行原理.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [284/297] 培训（RAC）.pptx
mkdir -p "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2025-12-12"
RESULT=$(dws drive download --file-id "1DKw2zgV2P4M3q0EuDmOZ46y8B5r9YAn" --space-id "27125381649" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2025-12-12/培训（RAC）.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2025-12-12/培训（RAC）.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [284/297] OK: 培训（RAC）.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [284/297] FAIL: 培训（RAC）.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2025-12-12/培训（RAC）.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [284/297] FAIL: 培训（RAC）.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2025-12-12/培训（RAC）.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [284/297] EXPIRED: 培训（RAC）.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [285/297] RAC原理.pptx
mkdir -p "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2025-12-12"
RESULT=$(dws drive download --file-id "MyQA2dXW7eMpZG2EFkB7Z0rkJzlwrZgb" --space-id "27125381649" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2025-12-12/RAC原理.pptx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2025-12-12/RAC原理.pptx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [285/297] OK: RAC原理.pptx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [285/297] FAIL: RAC原理.pptx (empty file)"
      rm -f "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2025-12-12/RAC原理.pptx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [285/297] FAIL: RAC原理.pptx (curl error)"
    rm -f "D:/myfiles/钉钉同步/日升&云趣数据库运维群/2025-12-12/RAC原理.pptx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [285/297] EXPIRED: RAC原理.pptx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [286/297] 闲置资产(1).xlsx
mkdir -p "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-08-05"
RESULT=$(dws drive download --file-id "7dx2rn0JbY9P3pAGsKxO4gwXVMGjLRb3" --space-id "23385695294" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-08-05/闲置资产(1).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-08-05/闲置资产(1).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [286/297] OK: 闲置资产(1).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [286/297] FAIL: 闲置资产(1).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-08-05/闲置资产(1).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [286/297] FAIL: 闲置资产(1).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-08-05/闲置资产(1).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [286/297] EXPIRED: 闲置资产(1).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [287/297] 固阳701组件车间制造端IT设备缺失明细(1).xlsx
mkdir -p "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-05-29"
RESULT=$(dws drive download --file-id "4lgGw3P8vRl2G1PnH7qzZ9gQ85daZ90D" --space-id "23385695294" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-05-29/固阳701组件车间制造端IT设备缺失明细(1).xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-05-29/固阳701组件车间制造端IT设备缺失明细(1).xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [287/297] OK: 固阳701组件车间制造端IT设备缺失明细(1).xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [287/297] FAIL: 固阳701组件车间制造端IT设备缺失明细(1).xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-05-29/固阳701组件车间制造端IT设备缺失明细(1).xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [287/297] FAIL: 固阳701组件车间制造端IT设备缺失明细(1).xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-05-29/固阳701组件车间制造端IT设备缺失明细(1).xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [287/297] EXPIRED: 固阳701组件车间制造端IT设备缺失明细(1).xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [288/297] 闲置资产类型统计.xlsx
mkdir -p "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-05-08"
RESULT=$(dws drive download --file-id "14dA3GK8gjNBrmwvFZGNnreRJ9ekBD76" --space-id "23385695294" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-05-08/闲置资产类型统计.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-05-08/闲置资产类型统计.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [288/297] OK: 闲置资产类型统计.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [288/297] FAIL: 闲置资产类型统计.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-05-08/闲置资产类型统计.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [288/297] FAIL: 闲置资产类型统计.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-05-08/闲置资产类型统计.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [288/297] EXPIRED: 闲置资产类型统计.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [289/297] 2024年常州基地闲置IT资产统计表.xlsx
mkdir -p "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-01-29"
RESULT=$(dws drive download --file-id "QPGYqjpJYr07zvYOHgeAnmB78akx1Z5N" --space-id "23385695294" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-01-29/2024年常州基地闲置IT资产统计表.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-01-29/2024年常州基地闲置IT资产统计表.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [289/297] OK: 2024年常州基地闲置IT资产统计表.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [289/297] FAIL: 2024年常州基地闲置IT资产统计表.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-01-29/2024年常州基地闲置IT资产统计表.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [289/297] FAIL: 2024年常州基地闲置IT资产统计表.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-01-29/2024年常州基地闲置IT资产统计表.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [289/297] EXPIRED: 2024年常州基地闲置IT资产统计表.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [290/297] 2024年义乌基地闲置IT资产统计表.xlsx
mkdir -p "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-01-26"
RESULT=$(dws drive download --file-id "DnRL6jAJMGAM4o7ZCP51zkyQWyMoPYe1" --space-id "23385695294" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-01-26/2024年义乌基地闲置IT资产统计表.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-01-26/2024年义乌基地闲置IT资产统计表.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [290/297] OK: 2024年义乌基地闲置IT资产统计表.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [290/297] FAIL: 2024年义乌基地闲置IT资产统计表.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-01-26/2024年义乌基地闲置IT资产统计表.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [290/297] FAIL: 2024年义乌基地闲置IT资产统计表.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-01-26/2024年义乌基地闲置IT资产统计表.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [290/297] EXPIRED: 2024年义乌基地闲置IT资产统计表.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [291/297] 2022年xx公司闲置资产及呆滞物料统计表.xlsx
mkdir -p "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-01-26"
RESULT=$(dws drive download --file-id "X6GRezwJlADvGbLjsbmeKk3m8dqbropQ" --space-id "23385695294" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-01-26/2022年xx公司闲置资产及呆滞物料统计表.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-01-26/2022年xx公司闲置资产及呆滞物料统计表.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [291/297] OK: 2022年xx公司闲置资产及呆滞物料统计表.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [291/297] FAIL: 2022年xx公司闲置资产及呆滞物料统计表.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-01-26/2022年xx公司闲置资产及呆滞物料统计表.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [291/297] FAIL: 2022年xx公司闲置资产及呆滞物料统计表.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/集团&基地闲置IT资产沟通群/2024-01-26/2022年xx公司闲置资产及呆滞物料统计表.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [291/297] EXPIRED: 2022年xx公司闲置资产及呆滞物料统计表.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [292/297] 岗位说明书-参考模板-2025（新）.xlsx
mkdir -p "D:/myfiles/钉钉同步/2026年岗位说明书编写沟通群/2026-01-06"
RESULT=$(dws drive download --file-id "P0MALyR8klMeMoGXF2q477KoW3bzYmDO" --space-id "28061549294" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/2026年岗位说明书编写沟通群/2026-01-06/岗位说明书-参考模板-2025（新）.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/2026年岗位说明书编写沟通群/2026-01-06/岗位说明书-参考模板-2025（新）.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [292/297] OK: 岗位说明书-参考模板-2025（新）.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [292/297] FAIL: 岗位说明书-参考模板-2025（新）.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/2026年岗位说明书编写沟通群/2026-01-06/岗位说明书-参考模板-2025（新）.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [292/297] FAIL: 岗位说明书-参考模板-2025（新）.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/2026年岗位说明书编写沟通群/2026-01-06/岗位说明书-参考模板-2025（新）.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [292/297] EXPIRED: 岗位说明书-参考模板-2025（新）.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [293/297] 部门岗位清单（2025）-流程与信息中心.xlsx
mkdir -p "D:/myfiles/钉钉同步/2026年岗位说明书编写沟通群/2026-01-06"
RESULT=$(dws drive download --file-id "vNG4YZ7JnPkak1ozFr5knAwRW2LD0oRE" --space-id "28061549294" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/2026年岗位说明书编写沟通群/2026-01-06/部门岗位清单（2025）-流程与信息中心.xlsx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/2026年岗位说明书编写沟通群/2026-01-06/部门岗位清单（2025）-流程与信息中心.xlsx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [293/297] OK: 部门岗位清单（2025）-流程与信息中心.xlsx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [293/297] FAIL: 部门岗位清单（2025）-流程与信息中心.xlsx (empty file)"
      rm -f "D:/myfiles/钉钉同步/2026年岗位说明书编写沟通群/2026-01-06/部门岗位清单（2025）-流程与信息中心.xlsx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [293/297] FAIL: 部门岗位清单（2025）-流程与信息中心.xlsx (curl error)"
    rm -f "D:/myfiles/钉钉同步/2026年岗位说明书编写沟通群/2026-01-06/部门岗位清单（2025）-流程与信息中心.xlsx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [293/297] EXPIRED: 部门岗位清单（2025）-流程与信息中心.xlsx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [294/297] 385-CN-CRM储能营销信息化平台-主机扫描-20260106-64233-综述报告.docx
mkdir -p "D:/myfiles/钉钉同步/储能CRM域名发布-平台漏洞处理/2026-01-07"
RESULT=$(dws drive download --file-id "P0MALyR8klMvRZN0F2od5Xj0W3bzYmDO" --space-id "28068079800" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/储能CRM域名发布-平台漏洞处理/2026-01-07/385-CN-CRM储能营销信息化平台-主机扫描-20260106-64233-综述报告.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/储能CRM域名发布-平台漏洞处理/2026-01-07/385-CN-CRM储能营销信息化平台-主机扫描-20260106-64233-综述报告.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [294/297] OK: 385-CN-CRM储能营销信息化平台-主机扫描-20260106-64233-综述报告.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [294/297] FAIL: 385-CN-CRM储能营销信息化平台-主机扫描-20260106-64233-综述报告.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/储能CRM域名发布-平台漏洞处理/2026-01-07/385-CN-CRM储能营销信息化平台-主机扫描-20260106-64233-综述报告.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [294/297] FAIL: 385-CN-CRM储能营销信息化平台-主机扫描-20260106-64233-综述报告.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/储能CRM域名发布-平台漏洞处理/2026-01-07/385-CN-CRM储能营销信息化平台-主机扫描-20260106-64233-综述报告.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [294/297] EXPIRED: 385-CN-CRM储能营销信息化平台-主机扫描-20260106-64233-综述报告.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [295/297] 388-CN-CRM储能营销信息化平台网站扫描-20260106-31098-综述报告.docx
mkdir -p "D:/myfiles/钉钉同步/储能CRM域名发布-平台漏洞处理/2026-01-07"
RESULT=$(dws drive download --file-id "l6Pm2Db8D4gqrLZoIY7M2L9j8xLq0Ee4" --space-id "28068079800" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/储能CRM域名发布-平台漏洞处理/2026-01-07/388-CN-CRM储能营销信息化平台网站扫描-20260106-31098-综述报告.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/储能CRM域名发布-平台漏洞处理/2026-01-07/388-CN-CRM储能营销信息化平台网站扫描-20260106-31098-综述报告.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [295/297] OK: 388-CN-CRM储能营销信息化平台网站扫描-20260106-31098-综述报告.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [295/297] FAIL: 388-CN-CRM储能营销信息化平台网站扫描-20260106-31098-综述报告.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/储能CRM域名发布-平台漏洞处理/2026-01-07/388-CN-CRM储能营销信息化平台网站扫描-20260106-31098-综述报告.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [295/297] FAIL: 388-CN-CRM储能营销信息化平台网站扫描-20260106-31098-综述报告.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/储能CRM域名发布-平台漏洞处理/2026-01-07/388-CN-CRM储能营销信息化平台网站扫描-20260106-31098-综述报告.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [295/297] EXPIRED: 388-CN-CRM储能营销信息化平台网站扫描-20260106-31098-综述报告.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [296/297] RFID.docx
mkdir -p "D:/myfiles/钉钉同步/方舟波/2022-11-03"
RESULT=$(dws drive download --file-id "72671447481" --space-id "" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/方舟波/2022-11-03/RFID.docx" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/方舟波/2022-11-03/RFID.docx" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [296/297] OK: RFID.docx ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [296/297] FAIL: RFID.docx (empty file)"
      rm -f "D:/myfiles/钉钉同步/方舟波/2022-11-03/RFID.docx"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [296/297] FAIL: RFID.docx (curl error)"
    rm -f "D:/myfiles/钉钉同步/方舟波/2022-11-03/RFID.docx"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [296/297] EXPIRED: RFID.docx"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2

# [297/297] 故新智能服务器配置要求.pdf
mkdir -p "D:/myfiles/钉钉同步/张潇文/2022-06-21"
RESULT=$(dws drive download --file-id "62238308530" --space-id "7934758796" 2>&1)
URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',{}).get('downloadUrl',''))" 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  if curl -sS -L --connect-timeout 30 --max-time 120 -o "D:/myfiles/钉钉同步/张潇文/2022-06-21/故新智能服务器配置要求.pdf" "$URL" 2>/dev/null; then
    SIZE=$(stat -c%s "D:/myfiles/钉钉同步/张潇文/2022-06-21/故新智能服务器配置要求.pdf" 2>/dev/null || echo 0)
    if [ "$SIZE" -gt 0 ]; then
      echo "  [297/297] OK: 故新智能服务器配置要求.pdf ($SIZE bytes)"
      OK=$((OK+1))
    else
      echo "  [297/297] FAIL: 故新智能服务器配置要求.pdf (empty file)"
      rm -f "D:/myfiles/钉钉同步/张潇文/2022-06-21/故新智能服务器配置要求.pdf"
      FAIL=$((FAIL+1))
    fi
  else
    echo "  [297/297] FAIL: 故新智能服务器配置要求.pdf (curl error)"
    rm -f "D:/myfiles/钉钉同步/张潇文/2022-06-21/故新智能服务器配置要求.pdf"
    FAIL=$((FAIL+1))
  fi
else
  echo "  [297/297] EXPIRED: 故新智能服务器配置要求.pdf"
  EXPIRE=$((EXPIRE+1))
fi
sleep 0.2


echo ""
echo "=============================="
echo "Download complete!"
echo "  Downloaded: $OK"
echo "  Failed: $FAIL"
echo "  Expired: $EXPIRE"
echo "  Total: $TOTAL"
echo "=============================="