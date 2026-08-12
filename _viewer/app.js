/* 钉钉聊天记录浏览 - 纯前端，无外部依赖 */
(function () {
  "use strict";

  // ============ 配置 ============
  // "我"的名字（会话中匹配到该名字的发送人靠右显示）。可按需修改。
  const SELF_NAMES = ["汪德嘉", "DJ Wang"];
  // 数据根目录：本页面在 _viewer/ 下，数据在其上一级
  const DATA_BASE = new URL("../", location.href).href;
  const BATCH = 300; // 每批渲染的消息数

  // ============ 工具 ============
  // 与同步脚本 safe_filename 保持一致：[<>:"/\|?*] -> _ 并去首尾空格
  function sanitize(name) {
    return String(name).replace(/[<>:"/\\|?*]/g, "_").trim();
  }
  function isSelf(sender) {
    return SELF_NAMES.some((n) => sender && sender.indexOf(n) !== -1);
  }
  function encodePath(relPath) {
    return relPath.split("/").map(encodeURIComponent).join("/");
  }
  const PALETTE = ["#1a6dff","#00b96b","#ff7a45","#722ed1","#eb2f96",
    "#13c2c2","#fa8c16","#2f54eb","#a0d911","#f5222d","#08979c","#d48806"];
  function colorFor(str) {
    let h = 0;
    for (let i = 0; i < str.length; i++) h = (h * 31 + str.charCodeAt(i)) >>> 0;
    return PALETTE[h % PALETTE.length];
  }
  function initials(name) {
    if (!name) return "?";
    const clean = name.replace(/\s+/g, "");
    // 中文取最后一个字，英文取首字母
    if (/[\u4e00-\u9fa5]/.test(clean)) return clean.slice(-1);
    return clean.slice(0, 1).toUpperCase();
  }
  function escapeHtml(s) {
    return String(s).replace(/[&<>"]/g, (c) =>
      ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c]));
  }

  // ============ CSV 解析（支持引号内换行/逗号/双引号转义，去除 BOM）============
  function parseCSV(text) {
    if (text.charCodeAt(0) === 0xfeff) text = text.slice(1);
    const rows = [];
    let row = [], field = "", inQuotes = false;
    for (let i = 0; i < text.length; i++) {
      const c = text[i];
      if (inQuotes) {
        if (c === '"') {
          if (text[i + 1] === '"') { field += '"'; i++; }
          else inQuotes = false;
        } else field += c;
      } else {
        if (c === '"') inQuotes = true;
        else if (c === ",") { row.push(field); field = ""; }
        else if (c === "\r") { /* skip */ }
        else if (c === "\n") { row.push(field); rows.push(row); row = []; field = ""; }
        else field += c;
      }
    }
    if (field.length > 0 || row.length > 0) { row.push(field); rows.push(row); }
    return rows;
  }

  // ============ 内容 HTML 净化 ============
  const ALLOWED_TAGS = new Set(["BR","FONT","B","STRONG","I","EM","SPAN","HR","U","P","DIV","BLOCKQUOTE","SUP","SUB","SMALL","A"]);
  // 仅允许安全协议的链接（http/https/dingtalk），阻断 javascript: 等
  function safeHref(u) {
    if (!u) return "";
    const s = String(u).trim();
    if (/^(https?:|dingtalk:|mailto:)/i.test(s)) return s;
    try {
      const p = new URL(s, location.href);
      if (p.protocol === "http:" || p.protocol === "https:" || p.protocol === "dingtalk:") return p.href;
    } catch (e) {}
    return "";
  }
  function sanitizeNode(node) {
    const children = Array.from(node.childNodes);
    for (const child of children) {
      if (child.nodeType === 1) {
        if (!ALLOWED_TAGS.has(child.tagName)) {
          // 不允许的标签：保留其文本内容，去掉标签本身
          const text = document.createTextNode(child.textContent);
          node.replaceChild(text, child);
          continue;
        }
        // 清理属性
        for (const attr of Array.from(child.attributes)) {
          const n = attr.name.toLowerCase();
          if (child.tagName === "A") {
            // 链接只保留安全 href / target / rel / class
            if (n === "href") {
              const safe = safeHref(attr.value);
              if (safe) child.setAttribute("href", safe);
              else child.removeAttribute("href");
              continue;
            }
            if (n === "target" || n === "rel" || n === "class") continue;
            child.removeAttribute(attr.name);
            continue;
          }
          if (child.tagName === "SPAN") {
            // 保留 class（emoji / @提醒 等样式）与 color 样式
            if (n === "class") continue;
            if (n === "style") {
              const m = /color\s*:\s*[^;]+/i.exec(attr.value);
              child.setAttribute("style", m ? m[0] : "");
              if (!m) child.removeAttribute("style");
              continue;
            }
            child.removeAttribute(attr.name);
            continue;
          }
          if (n === "color") continue;
          if (n === "style") {
            // 只保留 color 相关样式
            const m = /color\s*:\s*[^;]+/i.exec(attr.value);
            child.setAttribute("style", m ? m[0] : "");
            if (!m) child.removeAttribute("style");
            continue;
          }
          child.removeAttribute(attr.name);
        }
        sanitizeNode(child);
      }
    }
  }
  // 钉钉表情：[] 内的中文名 -> unicode（未收录的名字保持原样文字）
  const EMOJI_DICT = {
    "微笑":"😊","笑哭":"😂","捂脸哭":"😭","抱拳":"🤝","傻笑":"😁","火箭":"🚀","赞":"👍",
    "投降":"🏳️","狗子":"🐶","偷笑":"🤭","呲牙":"😬","钉子":"📌","憨笑":"😊","尴尬":"😅",
    "捂眼睛":"🙈","感谢":"🙏","送花花":"💐","二哈":"🐺","握手":"🤝","忍者":"🥷","大笑":"😆",
    "流鼻血":"🤤","飞吻":"😘","加油":"💪","衰":"😞","鞠躬":"🙇","鲜花":"🌹","对勾":"✅",
    "恭喜":"🎉","流泪":"😢","比心":"💗","流汗":"😓","暗中观察":"👀","可爱":"🥰","魔法棒":"🪄",
    "自信":"😎","回头":"↩️","思考":"🤔","疑问":"❓","幼苗":"🌱","嘿嘿":"😏","让人头大":"😵",
    "发呆":"😶","鼓掌":"👏","爱意":"💕","冷笑":"😒","红包":"🧧","烟花":"🎆","生日快乐":"🎂",
    "哼":"😤","茶":"🍵","快哭了":"🥺","元气满满":"✨","捧脸":"🤲","惊讶":"😲","对不起":"🙇",
    "大哭":"😭","撒花":"🎉","惊喜":"🎁"
  };
  // 内联富文本：链接([]()/裸链) -> 超链接；[表情名] -> emoji；@提醒 -> 高亮
  function renderInline(raw) {
    const s = String(raw);
    const RE = /(\[[^\]]+\]\((https?:\/\/|dingtalk:\/\/|mailto:)[^)\s]+\))|(https?:\/\/[^\s<>"'）)]+)|(dingtalk:\/\/[^\s<>"'）)]+)|(\[([一-龥A-Za-z0-9_]{1,6})\](?!\())|(@(?:所有人|[一-龥]{2,4}))/g;
    let out = "", last = 0, mm;
    while ((mm = RE.exec(s)) !== null) {
      if (mm.index > last) out += escapeHtml(s.slice(last, mm.index));
      if (mm[1] !== undefined) {                 // markdown 链接 [text](url)
        const lm = /\[([^\]]+)\]\(([^)\s]+)\)/.exec(mm[1]);
        const txt = lm ? lm[1] : "链接", url = lm ? lm[2] : "";
        const href = safeHref(url);
        out += href ? `<a href="${escapeHtml(href)}" target="_blank" rel="noopener">${escapeHtml(txt)}</a>` : escapeHtml(mm[1]);
      } else if (mm[3] !== undefined) {          // 裸 https 链接
        const href = safeHref(mm[3]);
        out += `<a href="${escapeHtml(href)}" target="_blank" rel="noopener">${escapeHtml(mm[3])}</a>`;
      } else if (mm[4] !== undefined) {          // 裸 dingtalk:// 链接
        out += `<a href="${escapeHtml(safeHref(mm[4]))}" target="_blank" rel="noopener">🔗 钉钉链接</a>`;
      } else if (mm[5] !== undefined) {          // [表情名]
        const name = mm[6];
        out += EMOJI_DICT[name] ? `<span class="emoji">${EMOJI_DICT[name]}</span>` : escapeHtml(mm[5]);
      } else if (mm[7] !== undefined) {          // @提醒
        out += `<span class="at">${escapeHtml(mm[7])}</span>`;
      }
      last = RE.lastIndex;
    }
    if (last < s.length) out += escapeHtml(s.slice(last));
    return out;
  }
  function renderRichText(raw, kw) {
    // 归一化换行 + 轻量 markdown（标题/分隔线）+ 内联解析（链接/表情/@）
    let s = String(raw);
    s = s.replace(/<br\s*\/?>/gi, "\n");
    const lines = s.split("\n").map((line) => {
      if (/^\s*-{3,}\s*$/.test(line)) return "<hr>";
      const h = /^\s*(#{1,6})\s+(.*)$/.exec(line);
      if (h) return "<b>" + renderInline(h[2]) + "</b>";
      return renderInline(line);
    });
    s = lines.join("<br>");
    const tpl = document.createElement("template");
    tpl.innerHTML = s;
    sanitizeNode(tpl.content);
    if (kw) highlightText(tpl.content, kw);
    return tpl.innerHTML;
  }
  function highlightText(root, kw) {
    if (!kw) return;
    const lower = kw.toLowerCase();
    const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, null, false);
    const nodes = [];
    let n;
    while ((n = walker.nextNode())) nodes.push(n);
    for (const node of nodes) {
      const text = node.nodeValue;
      const idx = text.toLowerCase().indexOf(lower);
      if (idx === -1) continue;
      const span = document.createElement("span");
      const before = document.createTextNode(text.slice(0, idx));
      const hit = document.createElement("span");
      hit.className = "search-highlight";
      hit.textContent = text.slice(idx, idx + kw.length);
      const after = document.createTextNode(text.slice(idx + kw.length));
      span.appendChild(before);
      span.appendChild(hit);
      span.appendChild(after);
      node.parentNode.replaceChild(span, node);
    }
  }

  // ============ 状态 ============
  let convs = [];
  let fileIndex = new Map(); // key: title/date/filename -> {path,sizeText}
  let fileIndexByTitleName = new Map(); // key: title\u0000filename -> {path,sizeText}
  let imageIndex = {};       // mediaId(归一@) -> 图片相对路径
  let imageByKey = {};       // 会话\x00时间\x00发送人 -> [相对路径]（mediaId 对不上时兜底）
  let imageByOpen = {};      // openMessageId -> 相对路径（chat 导出带 openMessageId 时直接命中）
  let scheduleIndex = [];    // 旧：聊天里的日程占位（保留，未使用）
  let calendarIndex = [];    // 日程/会议（来自 _calendar_export，真实数据）
  let todoIndex = [];        // 待办（来自 _todo_export）
  let minutesIndex = [];     // 听记/会议纪要（来自 _minutes_export）
  let contactsIndex = [];    // 通讯录（来自 _contacts_export）
  let activeConv = null;
  let currentFilter = "all";
  let currentTab = "chat"; // chat | files | schedule | minutes | todo
  let currentMsgs = [];    // 当前会话去重排序后的全部消息
  let chatSearchKw = "";
  let filesSearchKw = "";
  let calSearchKw = "";
  let minSearchKw = "";
  let todoSearchKw = "";
  let contactsSearchKw = "";
  let todoFilter = "all";    // all | 未完成 | 已完成
  let calView = "month";     // month | list
  let calMonth = new Date(); // 日历当前显示的月份

  // ============ 加载数据 ============
  async function boot() {
    let convIndex = {};
    try {
      const [convRes, idxRes, convIdxRes, imgIdxRes, schedRes, calRes, todoRes, minRes, contactsRes] = await Promise.allSettled([
        fetch(DATA_BASE + "_all_convs.json").then((r) => r.json()),
        fetch("files_index.json").then((r) => r.json()),
        fetch("conv_index.json").then((r) => r.json()),
        fetch("image_index.json").then((r) => r.json()),
        fetch("schedule_index.json").then((r) => r.json()),
        fetch("calendar_index.json").then((r) => r.json()),
        fetch("todo_index.json").then((r) => r.json()),
        fetch("minutes_index.json").then((r) => r.json()),
        fetch("contacts_index.json").then((r) => r.json()),
      ]);
      if (convRes.status === "fulfilled") convs = convRes.value || [];
      if (idxRes.status === "fulfilled" && idxRes.value && idxRes.value.files) {
        for (const f of idxRes.value.files) {
          fileIndex.set(f.path, f);
          fileIndexByTitleName.set(f.title + "\u0000" + f.filename, f);
        }
      }
      if (convIdxRes.status === "fulfilled" && convIdxRes.value && convIdxRes.value.convs) {
        convIndex = convIdxRes.value.convs;
      }
      if (imgIdxRes.status === "fulfilled" && imgIdxRes.value && imgIdxRes.value.images) {
        imageIndex = imgIdxRes.value.images;
        imageByKey = imgIdxRes.value.byKey || {};
        imageByOpen = imgIdxRes.value.byOpen || {};
      }
      if (schedRes.status === "fulfilled" && schedRes.value && schedRes.value.items) {
        scheduleIndex = schedRes.value.items;
      }
      if (calRes.status === "fulfilled" && calRes.value && calRes.value.events) {
        calendarIndex = calRes.value.events;
      }
      if (todoRes.status === "fulfilled" && todoRes.value && todoRes.value.todos) {
        todoIndex = todoRes.value.todos;
      }
      if (minRes.status === "fulfilled" && minRes.value && minRes.value.minutes) {
        minutesIndex = minRes.value.minutes;
      }
      if (contactsRes.status === "fulfilled" && contactsRes.value && contactsRes.value.contacts) {
        contactsIndex = contactsRes.value.contacts;
      }
    } catch (e) {
      console.error(e);
    }
    // 为会话附加 csv 文件名（清洗后）+ 最新时间/预览
    convs.forEach((c) => {
      c._csv = sanitize(c.title) + ".csv";
      c._dir = sanitize(c.title);
      const ci = convIndex[c._dir] || null;
      c._lastTime = ci ? (ci.lastTime || "") : "";
      c._preview = ci ? (ci.preview || "") : "";
      c._pinyin = ci ? (ci.pinyin || "") : "";
      c._py = ci ? (ci.py || "") : "";
    });
    // 按最近聊天时间倒序（无记录的排到最后，其中保持原顺序）
    convs.forEach((c, i) => { c._i = i; });
    convs.sort((a, b) => {
      if (a._lastTime && b._lastTime) {
        if (a._lastTime > b._lastTime) return -1;
        if (a._lastTime < b._lastTime) return 1;
        return a._i - b._i;
      }
      if (a._lastTime) return -1;
      if (b._lastTime) return 1;
      return a._i - b._i;
    });
    renderConvList();
    document.getElementById("footer-ver").textContent =
      `v0.1 · 共 ${convs.length} 会话 · ${fileIndex.size} 文件 · ${calendarIndex.length} 日程 · ${minutesIndex.length} 听记 · ${todoIndex.length} 待办 · ${contactsIndex.length} 联系人`;
  }

  // ============ 会话列表 ============
  function filteredConvs() {
    const kw = document.getElementById("search").value.trim().toLowerCase();
    return convs.filter((c) => {
      if (currentFilter === "group" && c.singleChat) return false;
      if (currentFilter === "single" && !c.singleChat) return false;
      if (kw) {
        // 标题 / 拼音全拼 / 首字母，任一包含即命中
        const hit = c.title.toLowerCase().indexOf(kw) !== -1 ||
          (c._pinyin && c._pinyin.indexOf(kw) !== -1) ||
          (c._py && c._py.indexOf(kw) !== -1);
        if (!hit) return false;
      }
      return true;
    });
  }
  function renderConvList() {
    const ul = document.getElementById("conv-list");
    const list = filteredConvs();
    ul.innerHTML = "";
    if (!list.length) {
      ul.innerHTML = '<li class="loading">没有匹配的会话</li>';
      return;
    }
    for (const c of list) {
      const li = document.createElement("li");
      li.className = "conv-item" + (activeConv === c ? " active" : "");
      const color = colorFor(c.title);
      const preview = c._preview
        ? escapeHtml(c._preview)
        : (c.singleChat ? "点击查看聊天记录" : "群聊 · 点击查看");
      const timeLabel = convTimeLabel(c._lastTime);
      li.innerHTML =
        `<div class="avatar${c.singleChat ? "" : " group"}" style="background:${color}">${escapeHtml(initials(c.title))}</div>` +
        `<div class="conv-meta">` +
          `<div class="conv-line1">` +
            `<div class="conv-name">${escapeHtml(c.title)}` +
              `<span class="conv-badge">${c.singleChat ? "单聊" : "群聊"}</span></div>` +
            `<div class="conv-time">${escapeHtml(timeLabel)}</div>` +
          `</div>` +
          `<div class="conv-desc">${preview}</div>` +
        `</div>`;
      li.addEventListener("click", () => openConv(c));
      ul.appendChild(li);
    }
  }

  // ============ 打开会话 ============
  async function openConv(c) {
    activeConv = c;
    currentTab = "chat";
    chatSearchKw = "";
    filesSearchKw = "";
    document.getElementById("chat-search").value = "";
    document.getElementById("files-search").value = "";
    updateChatTabs();
    renderConvList();

    const header = document.getElementById("chat-header");
    const emptyState = document.getElementById("empty-state");
    header.classList.remove("hidden");
    emptyState.classList.add("hidden");
    document.getElementById("chat-title").textContent = c.title;
    document.getElementById("chat-sub").textContent = c.singleChat ? "单聊" : "群聊";

    showPanel("chat");
    document.getElementById("panel-chat").innerHTML = '<div class="loading">加载中…</div>';

    let text;
    try {
      const res = await fetch(DATA_BASE + "_chat_export/" + encodeURIComponent(c._csv));
      if (!res.ok) throw new Error("HTTP " + res.status);
      const buf = await res.arrayBuffer();
      text = new TextDecoder("utf-8").decode(buf);
    } catch (e) {
      currentMsgs = [];
      document.getElementById("panel-chat").innerHTML = `<div class="loading">未找到该会话的聊天记录导出文件（${escapeHtml(c._csv)}）</div>`;
      renderFilesPanel();
      return;
    }

    const rows = parseCSV(text);
    // 去表头
    if (rows.length && rows[0][0] && rows[0][0].indexOf("时间") !== -1) rows.shift();
    // 增量导出可能产生重复行与乱序，需去重 + 按时间升序排列
    const seen = new Set();
    const msgs = rows
      .filter((r) => r.length >= 4)
      .filter((r) => {
        const k = r[0] + "\u0001" + r[1] + "\u0001" + r[2] + "\u0001" + r[3];
        if (seen.has(k)) return false;
        seen.add(k);
        return true;
      })
      .map((r, i) => ({ time: r[0], sender: r[1], type: r[2], content: r[3], _i: i }))
      .sort((a, b) => {
        // 时间格式为 YYYY-MM-DD HH:MM:SS，字符串比较即可正确排序；相等则保持原顺序
        if (a.time < b.time) return -1;
        if (a.time > b.time) return 1;
        return a._i - b._i;
      });

    if (activeConv !== c) return; // 期间切换了会话
    currentMsgs = msgs;
    renderMessages(c, msgs);
    renderFilesPanel();
  }

  function showPanel(name) {
    currentTab = name;
    const isGlobal = name === "schedule" || name === "minutes" || name === "todo" || name === "contacts";
    const hasConv = !!activeConv;
    document.getElementById("panel-chat").classList.toggle("hidden", name !== "chat");
    document.getElementById("panel-files").classList.toggle("hidden", name !== "files");
    document.getElementById("panel-schedule").classList.toggle("hidden", name !== "schedule");
    document.getElementById("panel-minutes").classList.toggle("hidden", name !== "minutes");
    document.getElementById("panel-todo").classList.toggle("hidden", name !== "todo");
    document.getElementById("panel-contacts").classList.toggle("hidden", name !== "contacts");
    // 全局面板不需要会话即可看；聊天/文件无会话时回退到空状态
    const emptyState = document.getElementById("empty-state");
    if (isGlobal) {
      emptyState.classList.add("hidden");
    } else if (!hasConv) {
      emptyState.classList.remove("hidden");
    } else {
      emptyState.classList.add("hidden");
    }
    document.getElementById("chat-search").style.display = name === "chat" ? "" : "none";
    if (name === "schedule") renderSchedulePanel();
    else if (name === "minutes") renderMinutesPanel();
    else if (name === "todo") renderTodoPanel();
    else if (name === "contacts") renderContactsPanel();
    updateChatTabs();
  }

  function openConvByTitle(title) {
    const c = convs.find((x) => sanitize(x.title) === title || x.title === title);
    if (c) openConv(c);
  }
  // ============ 日程 / 会议面板（日历视图 + 列表视图） ============
  function sameDay(a, b) {
    return a.getFullYear() === b.getFullYear() && a.getMonth() === b.getMonth() && a.getDate() === b.getDate();
  }
  function formatCalMonth(d) {
    return `${d.getFullYear()}年${d.getMonth() + 1}月`;
  }
  function filterCalendarEvents() {
    const kw = calSearchKw.trim().toLowerCase();
    if (!kw) return calendarIndex;
    return calendarIndex.filter((e) =>
      (e.summary || "").toLowerCase().includes(kw) ||
      (e.organizer || "").toLowerCase().includes(kw) ||
      (e.location || "").toLowerCase().includes(kw) ||
      (e.meetingRoom || "").toLowerCase().includes(kw) ||
      (e.attendees || []).join(" ").toLowerCase().includes(kw));
  }
  function renderSchedulePanel() {
    const monthWrap = document.getElementById("cal-month-wrap");
    const listEl = document.getElementById("cal-list");
    const detailEl = document.getElementById("cal-detail");
    const titleEl = document.getElementById("cal-title");
    const kw = calSearchKw.trim();
    titleEl.textContent = formatCalMonth(calMonth) + (kw ? ` · 筛选“${kw}”` : "");
    document.querySelectorAll(".cal-view").forEach((b) => b.classList.toggle("active", b.dataset.view === calView));
    if (calView === "month") {
      monthWrap.classList.remove("hidden");
      listEl.classList.add("hidden");
      renderCalendarMonth();
    } else {
      monthWrap.classList.add("hidden");
      listEl.classList.remove("hidden");
      renderCalendarList();
    }
    // 切换视图时隐藏详情，但保留详情更自然
    if (kw) detailEl.classList.add("hidden");
  }
  function renderCalendarMonth() {
    const grid = document.getElementById("cal-grid");
    const year = calMonth.getFullYear();
    const month = calMonth.getMonth();
    const first = new Date(year, month, 1);
    const start = new Date(first);
    start.setDate(start.getDate() - first.getDay()); // 周日开始
    const last = new Date(year, month + 1, 0);
    const end = new Date(last);
    end.setDate(end.getDate() + (6 - last.getDay()));

    const events = filterCalendarEvents();
    const eventsByDay = {};
    for (const e of events) {
      if (!e.startDate) continue;
      (eventsByDay[e.startDate] = eventsByDay[e.startDate] || []).push(e);
    }

    const today = new Date();
    const key = (d) => `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(d.getDate()).padStart(2, "0")}`;
    let html = "";
    for (let d = new Date(start); d <= end; d.setDate(d.getDate() + 1)) {
      const ymd = key(d);
      const isCurMonth = d.getMonth() === month;
      const isToday = sameDay(d, today);
      const dayEvents = eventsByDay[ymd] || [];
      // 排序：全天在前，然后按开始时间
      dayEvents.sort((a, b) => {
        if (a.isAllDay && !b.isAllDay) return -1;
        if (!a.isAllDay && b.isAllDay) return 1;
        return (a.startClock || "").localeCompare(b.startClock || "");
      });
      const more = dayEvents.length > 4 ? dayEvents.length - 3 : 0;
      const visible = dayEvents.slice(0, more ? 3 : 4);
      const kw = calSearchKw.trim().toLowerCase();
      const h = (s) => kw ? highlightInHtml(escapeHtml(s), kw) : escapeHtml(s);
      let eventsHtml = "";
      for (const e of visible) {
        const time = e.isAllDay ? "全天" : (e.startClock || "");
        const title = e.summary || "(无主题)";
        const color = colorFor(e.organizer || e.summary || "x");
        const cancelled = e.status === "cancelled" ? " cancelled" : "";
        eventsHtml +=
          `<div class="cal-event${cancelled}" data-id="${escapeHtml(e.id)}" style="--ev-color:${color}">` +
            `<span class="cal-ev-time">${escapeHtml(time)}</span>` +
            `<span class="cal-ev-title">${h(title)}</span>` +
          `</div>`;
      }
      if (more) {
        eventsHtml += `<div class="cal-more" data-date="${ymd}">+${more} 项</div>`;
      }
      html +=
        `<div class="cal-day${isCurMonth ? "" : " other"}${isToday ? " today" : ""}" data-date="${ymd}">` +
          `<div class="cal-day-num">${d.getDate()}</div>` +
          `<div class="cal-day-events">${eventsHtml}</div>` +
        `</div>`;
    }
    grid.innerHTML = html;
    grid.querySelectorAll(".cal-event").forEach((el) => {
      el.addEventListener("click", (ev) => { ev.stopPropagation(); showCalDetail(el.dataset.id); });
    });
    grid.querySelectorAll(".cal-more").forEach((el) => {
      el.addEventListener("click", (ev) => { ev.stopPropagation(); switchCalList(el.dataset.date); });
    });
  }
  function renderCalendarList() {
    const list = document.getElementById("cal-list");
    const evs = filterCalendarEvents();
    if (!evs.length) {
      list.innerHTML = '<div class="schedule-empty">没有匹配的日程 / 会议</div>';
      return;
    }
    const groups = {};
    for (const e of evs) {
      const d = e.startDate || "未知日期";
      (groups[d] = groups[d] || []).push(e);
    }
    const dates = Object.keys(groups).sort();
    const kw = calSearchKw.trim().toLowerCase();
    const h = (s) => kw ? highlightInHtml(escapeHtml(s), kw) : escapeHtml(s);
    let html = `<div class="schedule-head">共 ${evs.length} 条日程 / 会议（按日期分组）</div>`;
    for (const d of dates) {
      html += `<div class="schedule-date">${escapeHtml(d)}</div><div class="schedule-list">`;
      for (const e of groups[d].sort((a, b) => (a.startClock || "").localeCompare(b.startClock || ""))) {
        const when = e.isAllDay ? "全天" : (e.startClock || "") + (e.endClock ? " – " + e.endClock : "");
        const place = [e.meetingRoom, e.location].filter(Boolean).join(" · ") || "地点未填写";
        const code = e.onlineMeetingCode ? `<span class="cal-code">入会码 ${escapeHtml(e.onlineMeetingCode)}</span>` : "";
        const att = e.attendeeCount ? `<span class="cal-att">${escapeHtml(e.attendeeCount)} 人</span>` : "";
        const statusCls = e.status === "cancelled" ? " cancelled" : "";
        html +=
          `<div class="schedule-item${statusCls}" data-id="${escapeHtml(e.id)}">` +
            `<div class="schedule-time">${escapeHtml(when)}</div>` +
            `<div class="schedule-main">` +
              `<div class="schedule-title">${h(e.summary || "(无主题)")}</div>` +
              `<div class="schedule-meta">` +
                `<span class="cal-org">组织者 ${h(e.organizer || "—")}</span>` +
                `<span class="cal-place">📍 ${h(place)}</span>` +
                att + code +
              `</div>` +
            `</div>` +
          `</div>`;
      }
      html += "</div>";
    }
    list.innerHTML = html;
    list.querySelectorAll(".schedule-item").forEach((item) => {
      item.addEventListener("click", () => showCalDetail(item.dataset.id));
    });
  }
  function showCalDetail(id) {
    const ev = calendarIndex.find((e) => e.id === id);
    if (!ev) return;
    const detailEl = document.getElementById("cal-detail");
    const when = ev.isAllDay
      ? `${ev.startDate} 全天`
      : `${ev.startDate} ${ev.startClock || ""} – ${ev.endClock || ""}`;
    const place = [ev.meetingRoom, ev.location].filter(Boolean).join(" · ") || "地点未填写";
    const att = (ev.attendees || []).join("、") || "—";
    const kw = calSearchKw.trim().toLowerCase();
    const h = (s) => kw ? highlightInHtml(escapeHtml(s), kw) : escapeHtml(s);
    detailEl.classList.remove("hidden");
    detailEl.innerHTML =
      `<div class="cal-detail-card">` +
        `<div class="cal-detail-head">` +
          `<div class="cal-detail-title">${h(ev.summary || "(无主题)")}</div>` +
          `<button class="cal-detail-close" aria-label="关闭">×</button>` +
        `</div>` +
        `<div class="cal-detail-body">` +
          `<div class="cal-detail-row"><span class="cal-detail-label">时间</span><span class="cal-detail-value">${escapeHtml(when)}</span></div>` +
          `<div class="cal-detail-row"><span class="cal-detail-label">组织者</span><span class="cal-detail-value">${h(ev.organizer || "—")}</span></div>` +
          `<div class="cal-detail-row"><span class="cal-detail-label">地点</span><span class="cal-detail-value">${h(place)}</span></div>` +
          (ev.onlineMeetingCode ? `<div class="cal-detail-row"><span class="cal-detail-label">入会码</span><span class="cal-detail-value">${escapeHtml(ev.onlineMeetingCode)}</span></div>` : "") +
          `<div class="cal-detail-row"><span class="cal-detail-label">参与人</span><span class="cal-detail-value">${h(att)}</span></div>` +
          (ev.description ? `<div class="cal-detail-desc">${h(ev.description)}</div>` : "") +
        `</div>` +
      `</div>`;
    detailEl.querySelector(".cal-detail-close").addEventListener("click", () => detailEl.classList.add("hidden"));
  }
  function switchCalList(date) {
    calView = "list";
    document.getElementById("cal-search").value = date;
    calSearchKw = date;
    renderSchedulePanel();
  }

  // ============ 听记 / 会议纪要面板 ============
  function renderMinutesMarkdown(raw) {
    // 听记摘要是含 <time>、**加粗**、![图]、[链接]、> 引用的 markdown
    let s = String(raw || "");
    // 1) 去掉 <time ...>inner</time>，保留内部文字
    s = s.replace(/<time\b[^>]*>([\s\S]*?)<\/time>/gi, "$1");
    // 2) 去掉其余未知 HTML 标签（转义前处理，避免破坏）
    s = s.replace(/<(?!\/?a\b|\/?img\b|\/?br\b)[^>]+>/gi, "");
    // 3) 转义（此时已无真正需要的标签，只剩我们要转换的标记）
    s = escapeHtml(s);
    // 4) 行级转换
    const lines = s.split("\n").map((line) => {
      const q = /^&gt;\s?(.*)$/.exec(line);   // 引用
      if (q) return `<div class="min-quote">${line.replace(/^&gt;\s?/, "")}</div>`;
      let out = line
        .replace(/\*\*([^*]+)\*\*/g, "<b>$1</b>")
        .replace(/!\[([^\]]*)\]\(([^)\s]+)\)/g, (m, alt, url) => {
          const href = safeHref(url);
          return href ? `<img class="min-img" src="${escapeHtml(href)}" alt="${escapeHtml(alt)}" loading="lazy" onerror="this.style.display=&#39;none&#39;" />` : "";
        })
        .replace(/\[([^\]]+)\]\(([^)\s]+)\)/g, (m, txt, url) => {
          const href = safeHref(url);
          return href ? `<a href="${escapeHtml(href)}" target="_blank" rel="noopener">${txt}</a>` : txt;
        });
      return out || "<br>";
    });
    return lines.join("");
  }
  function renderMinutesPanel() {
    const panel = document.getElementById("panel-minutes");
    const list = document.getElementById("min-list");
    const kw = minSearchKw.trim().toLowerCase();
    let items = minutesIndex;
    if (kw) {
      items = items.filter((m) =>
        (m.title || "").toLowerCase().includes(kw) ||
        (m.summary || "").toLowerCase().includes(kw) ||
        (m.keywords || []).join(" ").toLowerCase().includes(kw));
    }
    if (!items.length) {
      list.innerHTML = '<div class="schedule-empty">没有匹配的听记 / 会议纪要</div>';
      return;
    }
    let html = `<div class="schedule-head">共 ${items.length} 条听记 / 会议纪要（点击展开详情）</div><div class="min-wrap">`;
    for (const m of items) {
      const kwTags = (m.keywords || []).map((k) => `<span class="min-kw">${escapeHtml(k)}</span>`).join("");
      const actions = (m.actions || []).map((a) => `<li>${escapeHtml(a)}</li>`).join("");
      const dur = m.durationText ? ` · ⏱ ${escapeHtml(m.durationText)}` : "";
      const link = m.url
        ? `<a class="min-origin" href="${escapeHtml(safeHref(m.url))}" target="_blank" rel="noopener">查看钉钉原听记 ›</a>`
        : "";
      html +=
        `<div class="min-card" data-uuid="${escapeHtml(m.taskUuid)}">` +
          `<div class="min-card-head">` +
            `<div class="min-card-title">📝 ${escapeHtml(m.title || "(无标题)")}</div>` +
            `<div class="min-card-sub">${escapeHtml(m.startTime || "")}${dur}</div>` +
          `</div>` +
          (kwTags ? `<div class="min-kws">${kwTags}</div>` : "") +
          `<div class="min-detail hidden">` +
            `<div class="min-summary">${renderMinutesMarkdown(m.summary)}</div>` +
            (actions ? `<div class="min-actions-title">提取待办：</div><ul class="min-actions">${actions}</ul>` : "") +
            (link ? `<div class="min-link">${link}</div>` : "") +
          `</div>` +
        `</div>`;
    }
    html += "</div>";
    list.innerHTML = html;
    list.querySelectorAll(".min-card").forEach((card) => {
      card.querySelector(".min-card-head").addEventListener("click", () => {
        card.querySelector(".min-detail").classList.toggle("hidden");
      });
    });
  }
  // ============ 待办面板 ============
  function renderTodoPanel() {
    const panel = document.getElementById("panel-todo");
    const list = document.getElementById("todo-list");
    const kw = todoSearchKw.trim().toLowerCase();
    let items = todoIndex;
    if (todoFilter !== "all") items = items.filter((t) => t.status === todoFilter);
    if (kw) items = items.filter((t) => (t.subject || "").toLowerCase().includes(kw));
    if (!items.length) {
      list.innerHTML = '<div class="schedule-empty">没有匹配的待办</div>';
      return;
    }
    let html = `<div class="schedule-head">共 ${items.length} 条待办</div><div class="todo-wrap">`;
    for (const t of items) {
      const done = t.status === "已完成";
      const pri = t.priorityLabel ? `<span class="todo-pri pri-${escapeHtml(t.priorityLabel)}">${escapeHtml(t.priorityLabel)}</span>` : "";
      const due = t.dueTime ? `<span class="todo-due">🕒 ${escapeHtml(t.dueTime)}</span>` : "";
      html +=
        `<div class="todo-card ${done ? "done" : ""}">` +
          `<div class="todo-main">` +
            `<div class="todo-subject">${escapeHtml(t.subject || "(无主题)")}</div>` +
            `<div class="todo-meta">` + pri + due +
              `<span class="todo-status">${escapeHtml(t.status)}</span>` +
            `</div>` +
          `</div>` +
        `</div>`;
    }
    html += "</div>";
    list.innerHTML = html;
  }

  // ============ 通讯录面板 ============
  function contactDetailHtml(c) {
    const row = (label, val) =>
      val ? `<div class="cd-row"><span class="cd-label">${escapeHtml(label)}</span><span class="cd-val">${escapeHtml(val)}</span></div>` : "";
    return row("工号", c.jobNumber) + row("职位", c.title) + row("部门", c.departments) +
      row("组织", c.orgName) + row("邮箱", c.email) + row("手机", c.mobile) +
      (c.namePy ? `<div class="cd-row"><span class="cd-label">拼音</span><span class="cd-val">${escapeHtml(c.namePy + " / " + c.nameInitials)}</span></div>` : "");
  }
  function renderContactsPanel() {
    const panel = document.getElementById("panel-contacts");
    const list = document.getElementById("contacts-list");
    const countEl = document.getElementById("contacts-count");
    const kw = contactsSearchKw.trim().toLowerCase();
    let arr = contactsIndex;
    if (kw) {
      arr = arr.filter((c) =>
        (c.name && c.name.toLowerCase().indexOf(kw) !== -1) ||
        (c.namePy && c.namePy.indexOf(kw) !== -1) ||
        (c.nameInitials && c.nameInitials.indexOf(kw) !== -1) ||
        (c.departments && c.departments.toLowerCase().indexOf(kw) !== -1) ||
        (c.title && c.title.toLowerCase().indexOf(kw) !== -1) ||
        (c.jobNumber && c.jobNumber.toLowerCase().indexOf(kw) !== -1)
      );
    }
    countEl.textContent = `共 ${contactsIndex.length} 位 · 匹配 ${arr.length} 位`;
    list.innerHTML = "";
    if (!arr.length) {
      list.innerHTML = '<div class="files-empty">没有匹配的通讯录</div>';
      return;
    }
    const CAP = kw ? 300 : 200;
    const shown = arr.slice(0, CAP);
    const frag = document.createDocumentFragment();
    for (const c of shown) {
      const card = document.createElement("div");
      card.className = "contact-card";
      const color = colorFor(c.name || "?");
      card.innerHTML =
        `<div class="avatar group" style="background:${color}">${escapeHtml(initials(c.name || "?"))}</div>` +
        `<div class="contact-main">` +
          `<div class="contact-name">${escapeHtml(c.name || "(未命名)")}` +
            (c.isAdmin ? '<span class="contact-admin">管理员</span>' : "") + `</div>` +
          `<div class="contact-sub">${escapeHtml((c.title || "") + (c.departments ? " · " + c.departments : ""))}</div>` +
        `</div>`;
      const detail = document.createElement("div");
      detail.className = "contact-detail hidden";
      detail.innerHTML = contactDetailHtml(c);
      card.addEventListener("click", () => detail.classList.toggle("hidden"));
      frag.appendChild(card);
      frag.appendChild(detail);
    }
    list.appendChild(frag);
    if (arr.length > CAP) {
      const more = document.createElement("div");
      more.className = "contacts-more";
      more.textContent = `仅显示前 ${CAP} 位，输入更精确的关键词以缩小范围`;
      list.appendChild(more);
    }
  }
  function updateChatTabs() {
    document.querySelectorAll("#chat-tabs .chat-tab").forEach((t) => {
      t.classList.toggle("active", t.dataset.tab === currentTab);
    });
  }

  // ============ 渲染消息 ============
  function renderMessages(conv, msgs, kw) {
    const body = document.getElementById("chat-body"); // 滚动容器
    const panel = document.getElementById("panel-chat");
    panel.innerHTML = "";
    let rendered = 0; // 已渲染数量（从末尾往前）

    const container = document.createElement("div");
    panel.appendChild(container);

    function renderBatch() {
      const total = msgs.length;
      const end = total - rendered;
      const start = Math.max(0, end - BATCH);
      const slice = msgs.slice(start, end);

      const frag = document.createDocumentFragment();
      let lastDate = start > 0 ? (msgs[start - 1].time || "").slice(0, 10) : null;
      for (let i = 0; i < slice.length; i++) {
        const m = slice[i];
        const date = (m.time || "").slice(0, 10);
        if (date && date !== lastDate) {
          frag.appendChild(dateSep(date));
          lastDate = date;
        }
        const el = renderMsg(conv, m, kw);
        if (el) frag.appendChild(el);
      }
      // 预置到容器最前
      const oldH = body.scrollHeight;
      container.insertBefore(frag, container.firstChild);
      rendered += slice.length;

      updateLoadMore();
      return oldH;
    }

    let loadMoreWrap = null;
    function updateLoadMore() {
      if (loadMoreWrap) { loadMoreWrap.remove(); loadMoreWrap = null; }
      if (rendered < msgs.length) {
        loadMoreWrap = document.createElement("div");
        loadMoreWrap.className = "load-more";
        const btn = document.createElement("button");
        btn.textContent = `加载更早的消息（剩余 ${msgs.length - rendered} 条）`;
        btn.addEventListener("click", () => {
          const oldH = renderBatch();
          // 保持视图位置
          body.scrollTop += body.scrollHeight - oldH;
        });
        loadMoreWrap.appendChild(btn);
        container.insertBefore(loadMoreWrap, container.firstChild);
      }
    }

    if (!msgs.length) {
      panel.innerHTML = '<div class="loading">该会话暂无消息记录</div>';
      return;
    }
    renderBatch();
    // 滚动到底部（最新消息）
    body.scrollTop = body.scrollHeight;
  }

  function dateSep(date) {
    const d = document.createElement("div");
    d.className = "date-sep";
    d.innerHTML = `<span>${escapeHtml(formatDate(date))}</span>`;
    return d;
  }
  function formatDate(date) {
    const t = new Date(date + "T00:00:00");
    if (isNaN(t)) return date;
    const wk = ["日","一","二","三","四","五","六"][t.getDay()];
    return `${date} 周${wk}`;
  }
  function timeOf(ts) {
    const m = /\d{4}-\d{2}-\d{2}\s+(\d{2}:\d{2})/.exec(ts || "");
    return m ? m[1] : "";
  }
  // 会话列表右上角时间：今天→HH:MM，昨天→昨天，今年→MM-DD，更早→YYYY-MM-DD
  function convTimeLabel(ts) {
    if (!ts) return "";
    const m = /(\d{4})-(\d{2})-(\d{2})\s+(\d{2}:\d{2})/.exec(ts);
    if (!m) return (ts || "").slice(0, 10);
    const date = m[1] + "-" + m[2] + "-" + m[3];
    const now = new Date();
    const pad = (n) => String(n).padStart(2, "0");
    const today = now.getFullYear() + "-" + pad(now.getMonth() + 1) + "-" + pad(now.getDate());
    const y = new Date(now.getTime() - 86400000);
    const yStr = y.getFullYear() + "-" + pad(y.getMonth() + 1) + "-" + pad(y.getDate());
    if (date === today) return m[4];
    if (date === yStr) return "昨天";
    if (m[1] === String(now.getFullYear())) return m[2] + "-" + m[3];
    return date;
  }

  function renderMsg(conv, m, kw) {
    if (m.type === "empty" || (!m.content && m.type === "text")) return null;
    const self = isSelf(m.sender);
    const row = document.createElement("div");
    row.className = "msg" + (self ? " self" : "");

    // 头像
    const av = document.createElement("div");
    av.className = "msg-avatar";
    av.style.background = colorFor(m.sender || "?");
    av.textContent = initials(m.sender);
    row.appendChild(av);

    const col = document.createElement("div");
    col.className = "msg-col";

    // 群聊且非本人显示发送人
    if (!conv.singleChat && !self) {
      const sn = document.createElement("div");
      sn.className = "msg-sender";
      sn.textContent = m.sender;
      col.appendChild(sn);
    }

    const bubble = document.createElement("div");
    bubble.className = "bubble";
    fillBubble(bubble, conv, m, kw);
    col.appendChild(bubble);

    const tm = document.createElement("div");
    tm.className = "msg-time";
    tm.textContent = timeOf(m.time);
    col.appendChild(tm);

    row.appendChild(col);
    return row;
  }

  function fillBubble(bubble, conv, m, kw) {
    if (m.type === "file") {
      bubble.appendChild(fileCard(conv, m, kw));
      return;
    }
    if (m.type === "calendar") {
      const cal = parseCalendar(m.content);
      if (cal) {
        bubble.appendChild(renderMeetingCard(cal, kw));
      } else {
        bubble.innerHTML = '<span class="cal-chip">📅 日程消息</span>';
      }
      return;
    }
    if (m.type === "image") {
      // 图片未下载，用占位；保留其中夹带的文字
      const parts = String(m.content).split(/\[图片\]/);
      const frag = document.createDocumentFragment();
      parts.forEach((p, idx) => {
        if (idx > 0) {
          const chip = document.createElement("span");
          chip.className = "img-chip";
          chip.innerHTML = "🖼️ 图片";
          frag.appendChild(chip);
        }
        const t = p.trim();
        if (t) {
          const span = document.createElement("span");
          span.innerHTML = renderRichText(t, kw);
          frag.appendChild(document.createElement("br"));
          frag.appendChild(span);
        }
      });
      bubble.appendChild(frag);
      return;
    }
    // text（默认）
    // 1) 含图片消息标记 [图片消息](mediaId=xxx) —— 渲染缩略图 + 夹带文字
    if (/\[图片消息\]\(mediaId=/.test(m.content)) {
      bubble.appendChild(imageContent(conv, m, kw));
      return;
    }
    // 2) 钉钉运动卡片
    if (isSportsCard(m.content)) {
      bubble.appendChild(renderSportsCard(m.content, kw));
      return;
    }
    // 3) 文件更新通知
    const upd = parseFileUpdate(m.content);
    if (upd) {
      bubble.appendChild(renderUpdateCard(upd, kw));
      return;
    }
    // 4) 尝试解析成会议卡片
    const meeting = parseMeeting(m.content);
    if (meeting) {
      bubble.appendChild(renderMeetingCard(meeting, kw));
      return;
    }
    bubble.innerHTML = renderRichText(m.content, kw);
  }

  // 归一化 mediaId：$ 前缀转 @
  function normMediaId(mid) {
    mid = (mid || "").trim();
    if (mid.startsWith("$")) mid = "@" + mid.slice(1);
    return mid;
  }
  // 渲染含 [图片消息](mediaId=xxx) 的文本：图片缩略图（已同步）或占位（未同步），穿插文字
  function imageContent(conv, m, kw) {
    const raw = m.content;
    const frag = document.createDocumentFragment();
    const re = /\[图片消息\]\(([^)]+)\)/g; // 参数串：可能含 mediaId= 与 openMessageId=
    let last = 0, mm;
    const s = String(raw);
    // 兜底桶：按 会话+时间+发送人 匹配（用于 mediaId 对不上的已下载图片）
    const bucketKey = (conv._dir || "") + "\x00" + (m.time || "") + "\x00" + (m.sender || "");
    const bucket = imageByKey[bucketKey] || [];
    let bucketPtr = 0;
    const pushText = (t) => {
      const trimmed = t.replace(/^\s+|\s+$/g, "");
      if (!trimmed) return;
      const span = document.createElement("div");
      span.className = "img-caption";
      span.innerHTML = renderRichText(trimmed, kw);
      frag.appendChild(span);
    };
    while ((mm = re.exec(s)) !== null) {
      pushText(s.slice(last, mm.index));
      last = re.lastIndex;
      const inner = mm[1];
      const midM = /mediaId=([^&\s)]+)/.exec(inner);
      const omidM = /openMessageId=([^&\s)]+)/.exec(inner);
      const mid = midM ? normMediaId(midM[1]) : "";
      const omid = omidM ? normMediaId(omidM[1]) : "";
      let rel = imageIndex[mid] || (omid && imageByOpen[omid]) || null;
      if (!rel) {
        // mediaId / openMessageId 都未命中 -> 用 会话+时间+发送人 兜底桶按顺序取
        while (bucketPtr < bucket.length && rel == null) {
          const cand = bucket[bucketPtr++];
          rel = cand;
        }
      }
      if (rel) {
        const a = document.createElement("a");
        a.href = DATA_BASE + encodePath(rel);
        a.target = "_blank";
        a.rel = "noopener";
        a.className = "chat-img-link";
        const img = document.createElement("img");
        img.className = "chat-img";
        img.loading = "lazy";
        img.src = DATA_BASE + encodePath(rel);
        img.alt = "图片";
        a.appendChild(img);
        frag.appendChild(a);
      } else {
        const chip = document.createElement("div");
        chip.className = "img-chip";
        chip.innerHTML = "🖼️ 图片（未同步）";
        frag.appendChild(chip);
      }
    }
    pushText(s.slice(last));
    return frag;
  }

  function fileExt(name) {
    const m = /\.([a-z0-9]+)$/i.exec(name || "");
    return m ? m[1].toLowerCase() : "";
  }
  function fileEmoji(ext) {
    if (["xls","xlsx","xlsm","csv"].includes(ext)) return "📊";
    if (["doc","docx"].includes(ext)) return "📄";
    if (["ppt","pptx"].includes(ext)) return "📽️";
    if (ext === "pdf") return "📕";
    if (["zip","7z","rar","gz","tar"].includes(ext)) return "🗜️";
    if (["png","jpg","jpeg","gif","bmp","svg","webp"].includes(ext)) return "🖼️";
    if (["mp4","avi","mov","mkv"].includes(ext)) return "🎬";
    if (["txt","md","log"].includes(ext)) return "📝";
    return "📎";
  }
  // ============ OnlyOffice 在线预览 ============
  const OO_DOC_TYPES = {
    doc: "text", docx: "text", docm: "text", dotx: "text", dotm: "text",
    odt: "text", rtf: "text", txt: "text", html: "text", htm: "text", epub: "text", mht: "text",
    xls: "spreadsheet", xlsx: "spreadsheet", xlsm: "spreadsheet", xltx: "spreadsheet", xltm: "spreadsheet",
    ods: "spreadsheet", csv: "spreadsheet", fods: "spreadsheet",
    ppt: "presentation", pptx: "presentation", potx: "presentation", potm: "presentation",
    ppsx: "presentation", ppsm: "presentation", odp: "presentation", fodp: "presentation",
    pdf: "pdf"
  };
  function onlyofficeSupported(ext) { return !!OO_DOC_TYPES[ext]; }
  // 生成 OnlyOffice 所需的稳定、唯一的文档 key（仅含字母数字，避免中文/特殊字符）
  function onlyOfficeKey(relPath) {
    let h = 0x811c9dc5;
    const s = relPath || "";
    for (let i = 0; i < s.length; i++) {
      h ^= s.charCodeAt(i);
      h = (h * 0x01000193) >>> 0; // FNV-1a 32-bit
    }
    const tail = s.replace(/[^a-z0-9]/gi, "").slice(-10);
    return "v1_" + h.toString(36) + "_" + tail;
  }
  function getOnlyOfficeBase() {
    let v = "";
    try { v = (localStorage.getItem("oo_url") || "").trim(); } catch (e) {}
    if (!v) v = "http://10.10.10.6:8080";
    return v.replace(/\/+$/, "");
  }
  // OnlyOffice JWT 密钥默认值（服务端 local.json 的 secret.inbox.string）。
  // 内网个人工具，直接内置默认值即可开箱即用；用户也可在「系统设置」里覆盖。
  const OO_SECRET_DEFAULT = "9aVyem7tOqnl0R6YAIgs2BnC8iBrGY65";
  function getOnlyOfficeSecret() {
    try {
      const s = (localStorage.getItem("oo_secret") || "").trim();
      if (s) return s;
    } catch (e) {}
    return OO_SECRET_DEFAULT;
  }
  // 对完整 config 做 OnlyOffice 所需的 JWT(HS256) 签名，返回 token 字符串。
  // 用纯 JS 实现 HMAC-SHA256 —— 不依赖 crypto.subtle（后者在非安全上下文 http://IP 下为 undefined，会导致签名静默失败）。
  function _b64url(str) {
    const bytes = new TextEncoder().encode(str);
    let bin = "";
    for (let i = 0; i < bytes.length; i++) bin += String.fromCharCode(bytes[i]);
    return btoa(bin).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
  }
  function _b64urlBytes(bytes) {
    let bin = "";
    for (let i = 0; i < bytes.length; i++) bin += String.fromCharCode(bytes[i]);
    return btoa(bin).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
  }
  // UTF-8 字符串 → 字节数组
  function _utf8(str) {
    const out = [];
    for (let i = 0; i < str.length; i++) {
      let c = str.charCodeAt(i);
      if (c < 0x80) out.push(c);
      else if (c < 0x800) out.push(0xc0 | (c >> 6), 0x80 | (c & 0x3f));
      else if (c >= 0xd800 && c < 0xdc00) {
        i++;
        const c2 = 0x10000 + (((c & 0x3ff) << 10) | (str.charCodeAt(i) & 0x3ff));
        out.push(0xf0 | (c2 >> 18), 0x80 | ((c2 >> 12) & 0x3f), 0x80 | ((c2 >> 6) & 0x3f), 0x80 | (c2 & 0x3f));
      } else out.push(0xe0 | (c >> 12), 0x80 | ((c >> 6) & 0x3f), 0x80 | (c & 0x3f));
    }
    return out;
  }
  // SHA-256（输入/输出均为 0..255 字节数组）
  function _sha256(msg) {
    const K = [0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2];
    let H = [0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19];
    const m = msg.slice();
    m.push(0x80);
    while (m.length % 64 !== 56) m.push(0);
  const bitLen = msg.length * 8;
  // 64-bit big-endian length: high 32 bits (0 for our sizes) + low 32 bits.
  // NOTE: JS `>>>` reduces the shift count mod 32, so i*8 for i>=4 is wrong.
  m.push(0, 0, 0, 0);
  m.push((bitLen >>> 24) & 0xff, (bitLen >>> 16) & 0xff, (bitLen >>> 8) & 0xff, bitLen & 0xff);
    const w = new Array(64);
    for (let i = 0; i < m.length; i += 64) {
      for (let t = 0; t < 16; t++) {
        w[t] = (m[i + 4 * t] << 24) | (m[i + 4 * t + 1] << 16) | (m[i + 4 * t + 2] << 8) | m[i + 4 * t + 3];
      }
      for (let t = 16; t < 64; t++) {
        const x15 = w[t - 15], x2 = w[t - 2];
        const s0 = ((x15 >>> 7) | (x15 << 25)) ^ ((x15 >>> 18) | (x15 << 14)) ^ (x15 >>> 3);
        const s1 = ((x2 >>> 17) | (x2 << 15)) ^ ((x2 >>> 19) | (x2 << 13)) ^ (x2 >>> 10);
        w[t] = (w[t - 16] + s0 + w[t - 7] + s1) | 0;
      }
      let a = H[0], b = H[1], c = H[2], d = H[3], e = H[4], f = H[5], g = H[6], h = H[7];
      for (let t = 0; t < 64; t++) {
        const S1 = ((e >>> 6) | (e << 26)) ^ ((e >>> 11) | (e << 21)) ^ ((e >>> 25) | (e << 7));
        const ch = (e & f) ^ (~e & g);
        const t1 = (h + S1 + ch + K[t] + w[t]) | 0;
        const S0 = ((a >>> 2) | (a << 30)) ^ ((a >>> 13) | (a << 19)) ^ ((a >>> 22) | (a << 10));
        const maj = (a & b) ^ (a & c) ^ (b & c);
        const t2 = (S0 + maj) | 0;
        h = g; g = f; f = e; e = (d + t1) | 0; d = c; c = b; b = a; a = (t1 + t2) | 0;
      }
      H[0] = (H[0] + a) | 0; H[1] = (H[1] + b) | 0; H[2] = (H[2] + c) | 0; H[3] = (H[3] + d) | 0;
      H[4] = (H[4] + e) | 0; H[5] = (H[5] + f) | 0; H[6] = (H[6] + g) | 0; H[7] = (H[7] + h) | 0;
    }
    const out = [];
    for (let i = 0; i < 8; i++) {
      out.push((H[i] >>> 24) & 0xff, (H[i] >>> 16) & 0xff, (H[i] >>> 8) & 0xff, H[i] & 0xff);
    }
    return out;
  }
  function _hmacSha256(keyStr, msgStr) {
    let key = _utf8(keyStr);
    if (key.length > 64) key = _sha256(key);
    const k = new Array(64).fill(0);
    for (let i = 0; i < key.length; i++) k[i] = key[i];
    const ipad = k.map((b) => b ^ 0x36);
    const opad = k.map((b) => b ^ 0x5c);
    const inner = _sha256(ipad.concat(_utf8(msgStr)));
    return _sha256(opad.concat(inner));
  }
  function signOnlyOfficeToken(config, secret) {
    const header = _b64url(JSON.stringify({ alg: "HS256", typ: "JWT" }));
    const payload = _b64url(JSON.stringify(config));
    const data = header + "." + payload;
    const sig = _b64urlBytes(_hmacSha256(secret, data));
    return data + "." + sig;
  }
  let _ooApiLoading = null;
  function loadOnlyOfficeApi(base) {
    if (window.DocsAPI) return Promise.resolve();
    if (_ooApiLoading) return _ooApiLoading;
    _ooApiLoading = new Promise((resolve, reject) => {
      const s = document.createElement("script");
      s.src = base + "/web-apps/apps/api/documents/api.js";
      s.onload = () => resolve();
      s.onerror = () => { _ooApiLoading = null; reject(new Error("OnlyOffice API 加载失败")); };
      document.head.appendChild(s);
    });
    return _ooApiLoading;
  }
  let _ooEditor = null;
  async function openOnlyOffice(relPath, title, ext) {
    if (!onlyofficeSupported(ext)) {
      alert("OnlyOffice 暂不支持预览该类型文件：" + ext);
      return;
    }
    const base = getOnlyOfficeBase();
    const fileUrl = DATA_BASE + encodePath(relPath);
    const modal = document.getElementById("oo-modal");
    const editorEl = document.getElementById("oo-editor");
    document.getElementById("oo-title").textContent = title;
    editorEl.innerHTML = '<div class="oo-loading">正在连接 OnlyOffice 并加载文档…</div>';
    modal.classList.remove("hidden");
    modal.setAttribute("aria-hidden", "false");
    try {
      await loadOnlyOfficeApi(base);
    } catch (e) {
      editorEl.innerHTML =
        '<div class="oo-error">无法连接 OnlyOffice 服务：<br>' + escapeHtml(base) +
        '<br>请确认该地址可达、且 Document Server 已正常运行（端口 8080）。</div>';
      return;
    }
    editorEl.innerHTML = "";
    try {
      const config = {
        document: {
          fileType: ext,
          key: onlyOfficeKey(relPath),
          title: title,
          url: fileUrl
        },
        documentType: OO_DOC_TYPES[ext],
        editorConfig: { mode: "view", lang: "zh-CN", customization: { autosave: false, chat: false } },
        events: {
          onError: (e) => {
            console.error("OnlyOffice error:", e);
            const msg = (e && (e.message || e.error)) ? String(e.message || e.error) : String(e);
            editorEl.innerHTML = '<div class="oo-error">OnlyOffice 返回错误：<br>' + escapeHtml(msg) +
              '<br><br>若提示「令牌格式不正确」，请在左侧栏「JWT 密钥」填入 OnlyOffice 的服务端密钥，或到 OnlyOffice 关闭 JWT 保护。</div>';
          }
        },
        height: "100%",
        width: "100%"
      };
      const secret = getOnlyOfficeSecret();
      if (secret) {
        try { config.token = await signOnlyOfficeToken(config, secret); }
        catch (e) { console.warn("OnlyOffice token 签名失败：", e); }
      }
      _ooEditor = new window.DocsAPI.DocEditor("oo-editor", config);
    } catch (e) {
      editorEl.innerHTML = '<div class="oo-error">OnlyOffice 初始化失败：' + escapeHtml(String(e)) + "</div>";
    }
  }
  function closeOnlyOffice() {
    const modal = document.getElementById("oo-modal");
    modal.classList.add("hidden");
    modal.setAttribute("aria-hidden", "true");
    const editorEl = document.getElementById("oo-editor");
    if (_ooEditor && typeof _ooEditor.destroy === "function") {
      try { _ooEditor.destroy(); } catch (e) {}
    }
    _ooEditor = null;
    editorEl.innerHTML = "";
  }

  function fileCard(conv, m, kw) {
    // 解析 [文件] 文件名 fileId: xxx
    let fname = "";
    const mm = /^\s*\[文件\]\s*([\s\S]*?)\s*fileId:/.exec(m.content);
    if (mm) fname = mm[1].trim();
    else fname = String(m.content).replace(/^\s*\[文件\]\s*/, "").trim();

    const date = (m.time || "").slice(0, 10);
    const safeName = sanitize(fname);
    const relByDate = conv._dir + "/" + date + "/" + safeName;

    // 查找本地是否已下载：优先按 精确路径，其次按 标题+文件名
    let found = fileIndex.get(relByDate) ||
                fileIndexByTitleName.get(conv._dir + "\u0000" + safeName) || null;

    const ext = fileExt(fname);
    const relPath = found ? found.path : relByDate;
    const wrap = document.createElement("div");
    wrap.className = "file-card-wrap";
    const card = document.createElement("a");
    card.href = DATA_BASE + encodePath(relPath);
    card.target = "_blank";
    card.rel = "noopener";
    card.className = "file-card" + (found ? "" : " missing");
    if (!found) {
      card.addEventListener("click", (e) => {
        // 未在索引中，尝试直接打开；若不存在浏览器会 404
      });
    }
    const nameHtml = kw ? highlightInHtml(escapeHtml(fname || "未知文件"), kw) : escapeHtml(fname || "未知文件");
    const pathHtml = relPath ? `<div class="file-path" title="${escapeHtml(relPath)}">📁 ${escapeHtml(relPath)}</div>` : "";
    card.innerHTML =
      `<div class="file-icon">${fileEmoji(ext)}</div>` +
      `<div class="file-info">` +
        `<div class="file-name">${nameHtml}</div>` +
        `<div class="file-status ${found ? "ok" : "missing"}">${
          found ? "已下载 · " + (found.sizeText || "点击打开")
                : "未下载/已过期 · 点击尝试"}</div>` +
        pathHtml +
      `</div>`;
    wrap.appendChild(card);
    if (found && onlyofficeSupported(ext)) {
      const btn = document.createElement("button");
      btn.type = "button";
      btn.className = "file-preview-btn";
      btn.textContent = "在线预览";
      btn.title = "用 OnlyOffice 在线预览";
      btn.addEventListener("click", (e) => {
        e.preventDefault();
        e.stopPropagation();
        openOnlyOffice(relPath, fname, ext);
      });
      wrap.appendChild(btn);
    }
    return wrap;
  }

  // ============ 会议/日程解析与卡片 ============
  function parseCalendar(raw) {
    const t = String(raw).trim();
    // 简单 [日程]标题 格式
    const m = /^\[日程\]\s*(.+)$/.exec(t);
    if (m) {
      return { subject: m[1].trim(), time: "", roomCode: "", url: "", status: "unknown" };
    }
    return null;
  }
  function parseMeeting(raw) {
    const t = String(raw).trim();

    // 模式1：结构化文本（带JSON），常见于 calendar/日程 消息
    const jsonMatch = t.match(/\{[\s\S]*?"videoConferenceId"[\s\S]*?\}/);
    if (jsonMatch) {
      try {
        const data = JSON.parse(jsonMatch[0]);
        const lines = t.split(/\n/).map((l) => l.trim()).filter((l) => l && !/^\d+$/.test(l) && l !== "Asia/Shanghai");
        // 取第一个看起来像会议主题的行（非 URL、非 JSON、非时区）
        const subject = lines.find((l) => !/^https?:\/\//.test(l) && !/^dingtalk:/.test(l) && !l.startsWith("{")) || "钉钉会议";
        const ts = t.match(/(\d{13})/g);
        let timeStr = "";
        if (ts && ts.length >= 2) {
          timeStr = formatTsRange(parseInt(ts[0]), parseInt(ts[1]));
        }
        return {
          subject,
          time: timeStr,
          roomCode: data.roomCode || "",
          url: data.url || "",
          status: "unknown"
        };
      } catch (e) {}
    }

    // 模式2：分享入会链接卡片
    const shareMatch = /加入钉钉会议[\s\S]*?(https?:\/\/meeting\.dingtalk\.com\/j\/[a-zA-Z0-9]+)/i.exec(t);
    if (shareMatch) {
      return { subject: "加入钉钉会议", time: "", roomCode: "", url: shareMatch[1], status: "unknown" };
    }

    // 模式3：主题/时间/会议号/入会链接（最常见）
    const subjectMatch = t.match(/主题[\s：:](.+?)(?:\n|$)/);
    const timeMatch = t.match(/时间[\s：:](.+?)(?:\n|$)/);
    const roomMatch = t.match(/会议号[\s：:]\s*(\d[\d\s]*\d)(?:\n|$)/);
    const linkMatch = t.match(/(https?:\/\/meeting\.dingtalk\.com\/j\/[a-zA-Z0-9]+)/);
    if (subjectMatch || roomMatch || linkMatch) {
      return {
        subject: subjectMatch ? subjectMatch[1].trim() : "钉钉会议",
        time: timeMatch ? timeMatch[1].trim() : "",
        roomCode: roomMatch ? roomMatch[1].trim() : "",
        url: linkMatch ? linkMatch[1] : "",
        status: "unknown"
      };
    }

    return null;
  }
  function formatTsRange(start, end) {
    try {
      const a = new Date(start), b = new Date(end);
      const pad = (n) => String(n).padStart(2, "0");
      const fmt = (d) => `${pad(d.getMonth()+1)}月${pad(d.getDate())}日 ${["日","一","二","三","四","五","六"][d.getDay()]} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
      return `${fmt(a)} - ${pad(b.getHours())}:${pad(b.getMinutes())}`;
    } catch (e) { return ""; }
  }
  function renderMeetingCard(m, kw) {
    const card = document.createElement("div");
    card.className = "meeting-card";
    let statusClass = "unknown";
    let statusText = "";
    let btnText = "加入会议";
    let joinable = false;
    if (m.status === "ended") { statusClass = "ended"; statusText = "会议已结束"; btnText = "已结束"; }
    else if (m.status === "ongoing") { statusClass = "ongoing"; statusText = "会议进行中"; joinable = true; }
    else if (m.status === "upcoming") { statusClass = "upcoming"; statusText = "会议即将开始"; joinable = true; }

    const subjHtml = kw ? highlightInHtml(escapeHtml(m.subject || "钉钉会议"), kw) : escapeHtml(m.subject || "钉钉会议");
    const roomHtml = m.roomCode ? `<div class="meeting-row"><span class="icon">🎥</span><span>会议号：${escapeHtml(m.roomCode)}</span></div>` : "";
    const timeHtml = m.time ? `<div class="meeting-row"><span class="icon">🕐</span><span>${escapeHtml(m.time)}</span></div>` : "";
    const linkHtml = m.url ? `<div class="meeting-row"><span class="icon">🔗</span><a href="${escapeHtml(m.url)}" target="_blank" rel="noopener">加入钉钉视频会议</a></div>` : "";
    const statusHtml = statusText ? `<div class="meeting-status ${statusClass}">${escapeHtml(statusText)}</div>` : "";
    const btnHtml = m.url
      ? `<a class="meeting-action ${joinable ? "joinable" : ""}" href="${escapeHtml(m.url)}" target="_blank" rel="noopener">${escapeHtml(btnText)}</a>`
      : `<button class="meeting-action" disabled>${escapeHtml(btnText)}</button>`;

    card.innerHTML =
      `<div class="meeting-header">📅 日程</div>` +
      `<div class="meeting-body">` +
        `<div class="meeting-title">${subjHtml}</div>` +
        timeHtml +
        roomHtml +
        linkHtml +
        statusHtml +
        btnHtml +
      `</div>`;
    return card;
  }
  function highlightInHtml(html, kw) {
    if (!kw) return html;
    const lower = kw.toLowerCase();
    // 在纯文本段落中简单替换（不处理标签边界，html 已经 escape 过）
    const parts = html.split(new RegExp("(" + escapeRegExp(kw) + ")", "gi"));
    return parts.map((p, i) =>
      i % 2 === 1 ? `<span class="search-highlight">${p}</span>` : p
    ).join("");
  }
  function escapeRegExp(s) {
    return s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  }

  // ============ 钉钉运动卡片 ============
  // 特征：内容以 lippi-health-PushRankMsgToConversation: 开头，且含 sport 链接
  function isSportsCard(content) {
    const t = String(content);
    return /^lippi-health-PushRankMsgToConversation:/i.test(t) && /sport/i.test(t);
  }
  function parseSportsTitle(content) {
    const m = /zh_Hans"\s*:\s*"([^"]+)"/.exec(content);
    return m ? m[1] : "";
  }
  function renderSportsCard(content, kw) {
    const card = document.createElement("div");
    card.className = "sports-card";
    const linkM = /(dingtalk:\/\/[^\s"']+)/.exec(content);
    const title = parseSportsTitle(content);
    const titleHtml = kw && title ? highlightInHtml(escapeHtml(title), kw) : escapeHtml(title);
    const linkHtml = linkM
      ? `<a class="sports-link" href="${escapeHtml(safeHref(linkM[1]))}" target="_blank" rel="noopener">查看钉钉运动 ›</a>`
      : "";
    card.innerHTML =
      `<div class="sports-head">🏃 钉钉运动</div>` +
      (title ? `<div class="sports-title">${titleHtml}</div>` : "") +
      linkHtml;
    return card;
  }

  // ============ 文件更新通知卡片 ============
  // 特征：含「我更新了 【文件名】」+「XX 上传的文件：[name](url)」
  function parseFileUpdate(content) {
    const t = String(content);
    if (!/我更新了/.test(t)) return null;
    const fM = /我更新了\s*[【\[](.+?)[】\]]/.exec(t);
    const fname = fM ? fM[1].trim() : "文件";
    const uM = /([一-龥A-Za-z0-9_（）()\s]+?)上传的文件/.exec(t);
    const uploader = uM ? uM[1].trim() : "";
    const linkM = /\[([^\]]+)\]\((https?:\/\/[^)\s]+)\)/.exec(t);
    const url = linkM ? linkM[2] : "";
    const linkName = linkM ? linkM[1] : fname;
    return { fname, uploader, url, linkName };
  }
  function renderUpdateCard(u, kw) {
    const card = document.createElement("div");
    card.className = "update-card";
    const linkHtml = u.url
      ? `<a class="update-link" href="${escapeHtml(safeHref(u.url))}" target="_blank" rel="noopener">查看 / 下载 ›</a>`
      : "";
    const who = u.uploader
      ? `<b>${kw ? highlightInHtml(escapeHtml(u.uploader), kw) : escapeHtml(u.uploader)}</b> 更新了文件：`
      : "更新了文件：";
    const fileHtml = kw ? highlightInHtml(escapeHtml(u.fname), kw) : escapeHtml(u.fname);
    card.innerHTML =
      `<div class="update-head">📝 文件已更新</div>` +
      `<div class="update-body">${who}<span class="update-file">${fileHtml}</span></div>` +
      linkHtml;
    return card;
  }

  // ============ 文件面板 ============
  function renderFilesPanel() {
    const panel = document.getElementById("panel-files");
    const listEl = document.getElementById("files-list");
    const countEl = document.getElementById("files-count");
    if (!activeConv) { panel.classList.add("hidden"); return; }

    // 按标题聚合本会话文件
    const files = [];
    for (const f of fileIndex.values()) {
      if (f.title === activeConv.title) files.push(f);
    }
    files.sort((a, b) => (a.date > b.date ? -1 : a.date < b.date ? 1 : 0));

    const kw = filesSearchKw.trim().toLowerCase();
    const filtered = kw ? files.filter((f) => f.filename.toLowerCase().indexOf(kw) !== -1) : files;

    countEl.textContent = `共 ${files.length} 个文件${kw ? "，筛选后 " + filtered.length + " 个" : ""}`;
    listEl.innerHTML = "";

    if (!filtered.length) {
      listEl.innerHTML = `<div class="files-empty">${files.length ? "没有匹配的文件" : "该会话暂无已下载文件"}</div>`;
      return;
    }

    const frag = document.createDocumentFragment();
    for (const f of filtered) {
      const ext = fileExt(f.filename);
      const wrap = document.createElement("div");
      wrap.className = "file-row-wrap";
      const a = document.createElement("a");
      a.className = "file-row";
      a.href = DATA_BASE + encodePath(f.path);
      a.target = "_blank";
      a.rel = "noopener";
      const nameHtml = kw ? highlightInHtml(escapeHtml(f.filename), kw) : escapeHtml(f.filename);
      a.innerHTML =
        `<div class="file-icon">${fileEmoji(ext)}</div>` +
        `<div class="file-info">` +
          `<div class="file-name">${nameHtml}</div>` +
          `<div class="file-meta">${escapeHtml(f.date)} · ${escapeHtml(f.sizeText || "未知大小")}</div>` +
        `</div>`;
      wrap.appendChild(a);
      if (onlyofficeSupported(ext)) {
        const btn = document.createElement("button");
        btn.type = "button";
        btn.className = "file-preview-btn";
        btn.textContent = "在线预览";
        btn.title = "用 OnlyOffice 在线预览";
        btn.addEventListener("click", (e) => {
          e.preventDefault();
          e.stopPropagation();
          openOnlyOffice(f.path, f.filename, ext);
        });
        wrap.appendChild(btn);
      }
      frag.appendChild(wrap);
    }
    listEl.appendChild(frag);
  }

  // ============ 聊天记录搜索（文字 / 日期） ============
  const DATE_RE = /(\d{4})[-/.](\d{1,2})[-/.](\d{1,2})|(\d{1,2})[-/.](\d{1,2})/;
  function matchDateQuery(q) {
    const m = q.match(DATE_RE);
    if (!m) return null;
    let y, mo, d;
    if (m[1]) { y = +m[1]; mo = +m[2]; d = +m[3]; }
    else { y = new Date().getFullYear(); mo = +m[4]; d = +m[5]; }
    if (mo < 1 || mo > 12 || d < 1 || d > 31) return null;
    return { date: `${y}-${String(mo).padStart(2, "0")}-${String(d).padStart(2, "0")}`, raw: m[0] };
  }
  function applyChatSearch() {
    chatSearchKw = document.getElementById("chat-search").value.trim();
    if (!activeConv) return;
    const raw = chatSearchKw;
    const kw = raw.toLowerCase();
    const dm = matchDateQuery(raw);
    let filtered;
    let mode = "text";
    if (dm) {
      mode = "date";
      // 按日期筛选当天消息；若日期外还有其它文字，再叠加文字过滤
      const textKw = raw.replace(dm.raw, "").trim().toLowerCase();
      filtered = currentMsgs.filter((m) => String(m.time).indexOf(dm.date) === 0);
      if (textKw) {
        filtered = filtered.filter((m) =>
          String(m.content).toLowerCase().indexOf(textKw) !== -1 ||
          String(m.sender).toLowerCase().indexOf(textKw) !== -1);
      }
    } else {
      filtered = kw
        ? currentMsgs.filter((m) =>
            String(m.content).toLowerCase().indexOf(kw) !== -1 ||
            String(m.sender).toLowerCase().indexOf(kw) !== -1
          )
        : currentMsgs;
    }
    renderMessages(activeConv, filtered, raw);
    // 搜索时显示结果数提示
    const panel = document.getElementById("panel-chat");
    if (raw && filtered.length && filtered.length < currentMsgs.length) {
      const tip = document.createElement("div");
      tip.className = "sys-msg";
      tip.id = "search-tip";
      tip.textContent = mode === "date"
        ? `日期 ${dm.date} 共 ${filtered.length} 条 / 全部 ${currentMsgs.length} 条`
        : `找到 ${filtered.length} 条匹配记录 / 共 ${currentMsgs.length} 条`;
      panel.insertBefore(tip, panel.firstChild);
    }
  }

  // ============ 事件绑定 ============
  document.getElementById("search").addEventListener("input", renderConvList);
  document.querySelectorAll(".filter-tabs .tab").forEach((tab) => {
    tab.addEventListener("click", () => {
      document.querySelectorAll(".filter-tabs .tab").forEach((t) => t.classList.remove("active"));
      tab.classList.add("active");
      currentFilter = tab.dataset.filter;
      renderConvList();
    });
  });

  // 聊天记录标签切换
  document.querySelectorAll("#chat-tabs .chat-tab").forEach((tab) => {
    tab.addEventListener("click", () => {
      showPanel(tab.dataset.tab);
    });
  });

  // 聊天记录搜索
  const chatSearchInput = document.getElementById("chat-search");
  chatSearchInput.addEventListener("input", applyChatSearch);
  chatSearchInput.addEventListener("keydown", (e) => {
    if (e.key === "Escape") {
      chatSearchInput.value = "";
      applyChatSearch();
    }
  });

  // 文件面板搜索
  const filesSearchInput = document.getElementById("files-search");
  filesSearchInput.addEventListener("input", () => {
    filesSearchKw = filesSearchInput.value;
    renderFilesPanel();
  });
  filesSearchInput.addEventListener("keydown", (e) => {
    if (e.key === "Escape") {
      filesSearchInput.value = "";
      filesSearchKw = "";
      renderFilesPanel();
    }
  });

  // 日程面板搜索
  const calSearchInput = document.getElementById("cal-search");
  calSearchInput.addEventListener("input", () => {
    calSearchKw = calSearchInput.value;
    renderSchedulePanel();
  });
  calSearchInput.addEventListener("keydown", (e) => {
    if (e.key === "Escape") {
      calSearchInput.value = "";
      calSearchKw = "";
      renderSchedulePanel();
    }
  });
  // 日历导航与视图切换
  document.getElementById("cal-today").addEventListener("click", () => { calMonth = new Date(); renderSchedulePanel(); });
  document.getElementById("cal-prev").addEventListener("click", () => { calMonth = new Date(calMonth.getFullYear(), calMonth.getMonth() - 1, 1); renderSchedulePanel(); });
  document.getElementById("cal-next").addEventListener("click", () => { calMonth = new Date(calMonth.getFullYear(), calMonth.getMonth() + 1, 1); renderSchedulePanel(); });
  document.querySelectorAll(".cal-view").forEach((btn) => {
    btn.addEventListener("click", () => { calView = btn.dataset.view; renderSchedulePanel(); });
  });
  // 听记面板搜索
  const minSearchInput = document.getElementById("min-search");
  minSearchInput.addEventListener("input", () => {
    minSearchKw = minSearchInput.value;
    renderMinutesPanel();
  });
  // 待办面板搜索 + 状态筛选
  const todoSearchInput = document.getElementById("todo-search");
  todoSearchInput.addEventListener("input", () => {
    todoSearchKw = todoSearchInput.value;
    renderTodoPanel();
  });
  document.querySelectorAll("#todo-filters .todo-filter").forEach((btn) => {
    btn.addEventListener("click", () => {
      document.querySelectorAll("#todo-filters .todo-filter").forEach((b) => b.classList.remove("active"));
      btn.classList.add("active");
      todoFilter = btn.dataset.st;
      renderTodoPanel();
    });
  });

  // 通讯录搜索
  const contactsSearchInput = document.getElementById("contacts-search");
  contactsSearchInput.addEventListener("input", () => {
    contactsSearchKw = contactsSearchInput.value;
    renderContactsPanel();
  });

  // 系统设置（二级菜单 / 弹窗）：OnlyOffice 地址 + JWT 密钥
  const settingsEntry = document.getElementById("settings-entry");
  const settingsModal = document.getElementById("settings-modal");
  const setOoUrl = document.getElementById("set-oo-url");
  const setOoSecret = document.getElementById("set-oo-secret");
  let _ooSaved = "", _ooSecretSaved = "";
  try { _ooSaved = (localStorage.getItem("oo_url") || "").trim(); } catch (e) {}
  try { _ooSecretSaved = (localStorage.getItem("oo_secret") || "").trim(); } catch (e) {}
  if (_ooSaved) setOoUrl.value = _ooSaved;
  if (_ooSecretSaved) setOoSecret.value = _ooSecretSaved;
  // 首次使用：把默认 JWT 密钥写入 localStorage 并回填输入框，保证开箱即用
  else {
    _ooSecretSaved = OO_SECRET_DEFAULT;
    try { localStorage.setItem("oo_secret", _ooSecretSaved); } catch (e) {}
    setOoSecret.value = _ooSecretSaved;
  }
  function openSettings() {
    settingsModal.classList.remove("hidden");
    settingsModal.setAttribute("aria-hidden", "false");
  }
  function closeSettings() {
    settingsModal.classList.add("hidden");
    settingsModal.setAttribute("aria-hidden", "true");
  }
  settingsEntry.addEventListener("click", openSettings);
  document.getElementById("settings-close").addEventListener("click", closeSettings);
  settingsModal.addEventListener("click", (e) => { if (e.target.id === "settings-modal") closeSettings(); });
  setOoUrl.addEventListener("change", () => {
    const v = setOoUrl.value.trim();
    try { if (v) localStorage.setItem("oo_url", v); else localStorage.removeItem("oo_url"); } catch (e) {}
  });
  setOoSecret.addEventListener("change", () => {
    const v = setOoSecret.value.trim();
    try { if (v) localStorage.setItem("oo_secret", v); else localStorage.removeItem("oo_secret"); } catch (e) {}
  });
  document.getElementById("oo-close").addEventListener("click", closeOnlyOffice);
  document.getElementById("oo-modal").addEventListener("click", (e) => {
    if (e.target.id === "oo-modal") closeOnlyOffice();
  });
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape") {
      const m = document.getElementById("oo-modal");
      if (!m.classList.contains("hidden")) closeOnlyOffice();
    }
  });

  boot();
})();
