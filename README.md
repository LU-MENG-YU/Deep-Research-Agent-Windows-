<a id="top"></a>

# Deep Research Agent — Windows 零成本安裝與使用完整教學

> 適用：Windows 10 / 11  
> 目標：從零開始安裝 Hermes、Deep-Research-Agent、OpenRouter、OpenAlex、Semantic Scholar、Exa、Scopus、NotebookLM，並設定本地文獻保存、免費額度保護、桌面版啟動與完整研究工作流。  
> 最後整理：2026-08-19（NotebookLM 改採本地整理＋手動匯入）
>
> 這份教學是「新手照著做就能裝」版本。  
> 所有 API Key 都不要貼到 GitHub、Discord、LINE 或公開截圖。
>
> **這一版的規則：凡是教你「檢查某個指令」，後面一定附「如果沒有，要怎麼安裝或修復」。不要看到 `node -v`、`git --version`、`uv --version` 失敗還直接往下做。**

---

<a id="toc"></a>

# 目錄

1. [最後會裝成什麼](#sec-1)
2. [先看費用與免費限制](#sec-2)
3. [Hermes：桌面版與終端機版的關係](#sec-3)
4. [安裝 Hermes](#sec-4)
5. [設定免費 LLM：OpenRouter](#sec-5)
6. [安裝 Deep-Research-Agent](#sec-6)
7. [安裝 Python dependencies](#sec-7)
8. [API Key 安全與 `.env`](#sec-8)
9. [設定 OpenAlex](#sec-9)
10. [設定 Semantic Scholar](#sec-10)
11. [Semantic Scholar 限流保護](#sec-11)
12. [設定 Exa MCP](#sec-12)
13. [設定 Scopus MCP](#sec-13)
14. [建立本地研究工作區](#sec-14)
15. [設定本地文獻保存規則](#sec-15)
16. [NotebookLM 改為手動匯入](#sec-16)
17. [NotebookLM 桌面版 / PWA 怎麼使用](#sec-17)
18. [測試本地 PDF / Markdown → NotebookLM](#sec-18)
19. [設定「核心文獻整理給 NotebookLM」](#sec-19)
20. [加入 Economy Mode](#sec-20)
21. [完整 Economy Mode 規則](#sec-21)
22. [確認 Skill 還正常](#sec-22)
23. [第一次測試：只跑 Phase 0](#sec-23)
24. [正式放行 Phase 0.5](#sec-24)
25. [完整文獻保存與 NotebookLM 流程](#sec-25)
26. [OpenRouter 50 次/日怎麼省](#sec-26)
27. [建立 Hermes Desktop 一鍵啟動 BAT](#sec-27)
28. [常見錯誤與排除](#sec-28)
29. [完整健康檢查](#sec-29)
30. [最終完成檢查表](#sec-30)
31. [官方與專案連結](#sec-31)
32. [使用原則與學術倫理](#sec-32)

---

<a id="sec-1"></a>

# 1. 最後會裝成什麼

完成後大概是：

```text
Windows 10 / 11
      │
      ▼
Hermes Agent
      │
      ├── Hermes Desktop / CLI
      │
      ├── OpenRouter 免費 LLM
      │
      ├── deep-science-writer
      ├── remi
      │
      ├── OpenAlex API
      ├── Semantic Scholar API
      ├── Exa MCP
      └── Scopus MCP

NotebookLM / Gemini Notebook
→ 由使用者手動匯入本地整理好的核心文獻
```

研究資料則另外保存在：

```text
Documents\
└─ DeepResearch\
   ├─ cache\
   ├─ evidence\
   ├─ papers\
   ├─ assets\
   ├─ reports\
   └─ notebooklm\
```

整體工作流：

```text
研究問題
   ↓
Phase 0 研究藍圖
   ↓
人工批准
   ↓
OpenAlex 大量 discovery
   ↓
去重 / abstract screening
   ↓
Scopus / Semantic Scholar / Exa 補資料
   ↓
核心全文合法取得
   ↓
本地 papers\
   ↓
Evidence table / literature manifest
   ↓
整理 notebooklm_ready\
   ↓
使用者手動拖入 NotebookLM
   ↓
Gap analysis
   ↓
Remi review
   ↓
DOCX / report
```

[⬆ 回到目錄](#toc)

---

<a id="sec-2"></a>

# 2. 先看費用與免費限制

本教學的目標是：

```text
NT$0 優先
```

但免費不等於無限。

| 服務 | 免費方式 | 主要限制 |
|---|---|---|
| Hermes Agent | 開源 | 免費 |
| Deep-Research-Agent | 開源 | 免費 |
| OpenRouter | Free models | 未購買 credits 通常 50 requests/day |
| OpenAlex | 免費 API key | 每日 US$1 免費 API 額度 |
| Semantic Scholar | 免費 API key | 初始約 1 request/sec，共用於所有 endpoints |
| Exa MCP | 可先無 API key使用 | 免費 MCP 有服務端限制 |
| Scopus API | Academic API key | 各 API 有 weekly quota / throttling |
| NotebookLM | Google 免費方案 | 本 README 採手動匯入，不依賴 NotebookLM MCP |

目前 OpenRouter 官方 FAQ 說明：免費模型在未購買至少 US$10 credits 的帳號上，總共約 50 requests/day；若帳號曾購買至少 10 credits，免費模型上限提高到 1000 requests/day。

所以本教學後面會設定：

```text
Economy Mode
```

避免 Agent 自己大量呼叫模型與 API。

[⬆ 回到目錄](#toc)

---

<a id="sec-3"></a>

# 3. Hermes：桌面版與終端機版的關係

Hermes 在 Windows 可以用兩種主要入口：

```text
Hermes Desktop
```

或：

```text
PowerShell → hermes
```

底層使用的是同一套 Hermes runtime、Skills 與設定。

所以：

```text
平常查文獻 / 聊天 / 跑 Deep Research
→ Hermes Desktop

改 config / 測 MCP / 看真正 error
→ PowerShell
```

如果你已經用 PowerShell 把全部東西裝好，再執行：

```powershell
hermes desktop
```

即可開啟桌面版，不需要重裝 OpenAlex、Scopus、Skills 等。

官方文件：

https://hermes-agent.nousresearch.com/docs/getting-started/installation

https://hermes-agent.nousresearch.com/docs/user-guide/windows-native

https://hermes-agent.nousresearch.com/docs/user-guide/desktop

[⬆ 回到目錄](#toc)

---

<a id="sec-4"></a>

# 4. 安裝 Hermes

## 4.1 方法 A：Hermes Desktop 安裝器

對完全不想碰終端機的人，官方目前建議 Windows / macOS 可直接使用 Hermes Desktop installer。

官方安裝頁：

https://hermes-agent.nousresearch.com/docs/getting-started/installation

Desktop 第一次啟動會自動配置 Hermes runtime。

如果你已經用 Desktop 安裝好，仍然可以在 PowerShell 使用：

```powershell
hermes doctor
```

以及後面的所有指令。

---

## 4.2 方法 B：PowerShell 原生安裝

按：

```text
Win
```

搜尋：

```text
PowerShell
```

或：

```text
Windows Terminal
```

一般不需要系統管理員權限。

直接：

```powershell
iex (irm https://hermes-agent.nousresearch.com/install.ps1)
```

如果你想跳過第一次 setup wizard，使用：

```powershell
& ([scriptblock]::Create((irm https://hermes-agent.nousresearch.com/install.ps1))) -SkipSetup
```

安裝完成後：

```text
關閉 PowerShell
→ 重新開啟 PowerShell
```

---

## 4.3 檢查 Hermes

先執行：

```powershell
hermes doctor
```

如果有 config migration：

```powershell
hermes doctor --fix
```

Hermes 的 Windows 原生安裝器本來就會幫你處理大部分前置環境，包括：

```text
uv
Python 3.11
Node.js
Git / PortableGit
ripgrep
ffmpeg
Hermes virtual environment
```

所以正常情況下 **不需要先自己裝 Python、Node、Git 或 uv**。

官方 Windows 說明：

https://hermes-agent.nousresearch.com/docs/user-guide/windows-native

---

## 4.4 一次檢查所有後面會用到的指令

把下面整段貼進 PowerShell：

```powershell
$commands = @(
  "hermes",
  "git",
  "uv",
  "uvx",
  "node",
  "npm",
  "npx"
)

foreach ($cmd in $commands) {
    $found = Get-Command $cmd -ErrorAction SilentlyContinue

    if ($found) {
        Write-Host "[OK]      $cmd -> $($found.Source)"
    }
    else {
        Write-Host "[MISSING] $cmd"
    }
}
```

理想結果：

```text
[OK] hermes
[OK] git
[OK] uv
[OK] uvx
[OK] node
[OK] npm
[OK] npx
```

如果全部都是 `[OK]`：

```text
直接繼續下一章。
```

如果有 `[MISSING]`，不要略過。照下面修。

---

### A. `hermes` 找不到

先：

```text
1. 關掉 PowerShell
2. 重新開 PowerShell
3. 再輸入 hermes doctor
```

如果仍然找不到，重新執行官方 Windows installer：

```powershell
iex (irm https://hermes-agent.nousresearch.com/install.ps1)
```

完成後再次：

```text
關閉 PowerShell
→ 重新開啟
```

再：

```powershell
hermes doctor
```

---

### B. `git` 找不到

Hermes installer 正常會自動配置 PortableGit。

先嘗試重新跑：

```powershell
iex (irm https://hermes-agent.nousresearch.com/install.ps1)
```

如果你希望另外在 Windows 全域安裝 Git，也可以使用 Git for Windows：

https://git-scm.com/download/win

安裝時一般保持預設選項即可。

安裝完成後：

```text
關掉所有 PowerShell
→ 重新開啟
```

驗證：

```powershell
git --version
```

---

### C. `uv` 或 `uvx` 找不到

Hermes 正常會把自己的 `uv.exe` 放在：

```text
%LOCALAPPDATA%\hermes\bin\
```

先測：

```powershell
Test-Path "$env:LOCALAPPDATA\hermes\bin\uv.exe"
```

如果得到：

```text
True
```

測試 Hermes 管理的 uv：

```powershell
& "$env:LOCALAPPDATA\hermes\bin\uv.exe" --version
```

如果這個可以工作，只是 PowerShell 找不到 `uv`，最簡單的處理仍是：

```text
重新執行 Hermes installer
→ 關閉 PowerShell
→ 重新開啟
```

如果 `uv.exe` 本身也不存在，可以另外使用 Astral 官方 Windows installer：

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

官方文件：

https://docs.astral.sh/uv/getting-started/installation/

裝完後：

```text
關閉 PowerShell
→ 重新開啟
```

驗證：

```powershell
uv --version
uvx --version
```

---

### D. `node`、`npm` 或 `npx` 找不到

**不要直接去找一個「npx 安裝包」。**

它們的關係是：

```text
Node.js
  └─ npm
      └─ npx
```

Node.js 官方 Windows 安裝會一起提供 npm；目前的 `npx` 是 npm 提供的命令，不需要獨立安裝。

最先嘗試：

```powershell
iex (irm https://hermes-agent.nousresearch.com/install.ps1)
```

因為 Hermes Windows installer 本來就會配置 Node.js。

完成後：

```text
關掉 PowerShell
→ 重新開啟
```

驗證：

```powershell
node -v
npm -v
npx -v
```

如果仍然缺少，直接安裝官方 Node.js LTS：

https://nodejs.org/en/download

選：

```text
LTS
Windows
Windows Installer (.msi)
x64（一般 Intel / AMD Windows 電腦）
```

基本上保持預設選項安裝即可。Node.js 安裝完成後會一起提供 npm；npx 則由 npm 提供，不需要另外安裝。

安裝完成後：

```text
關閉所有 PowerShell
→ 重新開啟 PowerShell
```

重新驗證：

```powershell
node -v
npm -v
npx -v
```

如果 PowerShell 顯示 `npx.ps1 cannot be loaded`，先改測：

```powershell
npx.cmd -v
```

不要使用 `npm install -g npx`。

---

### E. Python 找不到要不要自己裝？

通常 **不用**。

這套流程使用的是 Hermes 自己管理的 Python：

```text
%LOCALAPPDATA%\hermes\hermes-agent\venv\
```

檢查：

```powershell
Test-Path "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\python.exe"
```

應該得到：

```text
True
```

再：

```powershell
& "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\python.exe" --version
```

如果這個檔案根本不存在，優先重新跑 Hermes installer，不要先亂裝另一套 Python：

```powershell
iex (irm https://hermes-agent.nousresearch.com/install.ps1)
```

---

### F. 「我不懂哪些 Optional warning 要處理」

先看：

```powershell
hermes doctor
```

只要：

```text
Hermes 本體
Python environment
virtual environment
Git
Node
基本 browser / terminal
```

正常，就可以先繼續。

像 Discord、Telegram、Docker 之類你根本沒要用的 optional feature，可以先不裝。

[⬆ 回到目錄](#toc)

---

<a id="sec-5"></a>

# 5. 設定免費 LLM：OpenRouter

OpenRouter：

https://openrouter.ai/

API Key：

https://openrouter.ai/keys

免費模型：

https://openrouter.ai/models?pricing=free

Free Router：

https://openrouter.ai/openrouter/free

---

## 5.1 建立 API Key

登入：

https://openrouter.ai/keys

建立一把新 key。

例如名稱：

```text
Hermes
```

API key 通常類似：

```text
sk-or-v1-xxxxxxxxxxxxxxxx
```

**不要把 key 貼到 GitHub README。**

---

## 5.2 Hermes 選 OpenRouter

```powershell
hermes model
```

選：

```text
OpenRouter
```

Hermes 問：

```text
OPENROUTER_API_KEY:
```

貼入自己的 key。

---

## 5.3 選免費模型

找模型名稱尾端：

```text
:free
```

例如：

```text
nvidia/nemotron-3-super-120b-a12b:free
```

免費模型清單會變，所以不要把單一模型當永久預設。

也可以使用：

```text
openrouter/free
```

讓 OpenRouter 自動從當下可用的免費模型選擇。

---

## 5.4 測試

```powershell
hermes
```

輸入：

```text
Reply exactly: Hermes is working.
```

如果回：

```text
Hermes is working.
```

代表模型設定成功。

---

## 5.5 免費模型很慢怎麼辦

免費 provider 在尖峰時間可能：

```text
30 秒
60 秒
甚至更久
```

都很正常。

如果長時間完全沒 output：

```text
Ctrl+C
```

換另一個 `:free` 模型。

[⬆ 回到目錄](#toc)

---

<a id="sec-6"></a>

# 6. 安裝 Deep-Research-Agent

專案：

https://github.com/CYC2002tommy/Deep-Research-Agent

---

## 6.1 先確認 Git

```powershell
git --version
```

有看到版本號，例如：

```text
git version 2.x.x
```

才繼續。

### 如果 `git` 找不到

Hermes Windows installer 正常會提供 PortableGit。

先重新跑：

```powershell
iex (irm https://hermes-agent.nousresearch.com/install.ps1)
```

關掉 PowerShell、重新開啟，再測：

```powershell
git --version
```

仍然不行，可安裝官方 Git for Windows：

https://git-scm.com/download/win

安裝完成後一定要：

```text
關閉 PowerShell
→ 重新開啟
```

---

## 6.2 Clone Deep-Research-Agent

先切到 Skills 目錄：

```powershell
cd "$env:LOCALAPPDATA\hermes\skills"
```

如果是第一次安裝：

```powershell
git clone https://github.com/CYC2002tommy/Deep-Research-Agent.git
```

### 如果出現「destination path already exists」

代表之前已經 clone 過，不要再 clone 一份。

改成：

```powershell
git -C "$env:LOCALAPPDATA\hermes\skills\Deep-Research-Agent" status
```

如果只是想更新：

```powershell
git -C "$env:LOCALAPPDATA\hermes\skills\Deep-Research-Agent" pull
```

確認：

```powershell
Get-ChildItem "$env:LOCALAPPDATA\hermes\skills\Deep-Research-Agent\skills"
```

應該看到：

```text
deep-science-writer
remi
```

再：

```powershell
hermes skills list
```

應看到兩個 skill 是：

```text
enabled
```

[⬆ 回到目錄](#toc)

---

<a id="sec-7"></a>

# 7. 安裝 Python dependencies

Deep-Research-Agent 還需要額外 Python packages。

**這裡不要用系統 Python，也不要因為 `pip` 不存在就亂補 pip。**

我們直接指定 Hermes 自己的 virtual environment。

---

## 7.1 先確認 Hermes Python 存在

```powershell
$hermesPython = "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\python.exe"

Test-Path $hermesPython
```

應該：

```text
True
```

再：

```powershell
& $hermesPython --version
```

### 如果是 `False`

Hermes 的 venv 不完整。

重新執行：

```powershell
iex (irm https://hermes-agent.nousresearch.com/install.ps1)
```

完成後重開 PowerShell，再重新測。

---

## 7.2 確認 uv

```powershell
uv --version
```

### 如果 `uv` 找不到

先看 Hermes 管理的 uv 是否存在：

```powershell
Test-Path "$env:LOCALAPPDATA\hermes\bin\uv.exe"
```

如果是：

```text
True
```

後面直接用完整路徑即可：

```powershell
& "$env:LOCALAPPDATA\hermes\bin\uv.exe" --version
```

如果是：

```text
False
```

先重新跑 Hermes installer：

```powershell
iex (irm https://hermes-agent.nousresearch.com/install.ps1)
```

仍然沒有，再使用 Astral 官方 Windows installer：

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

官方：

https://docs.astral.sh/uv/getting-started/installation/

---

## 7.3 安裝 requirements

最穩定的寫法是不依賴 PATH，直接使用 Hermes 自己的 `uv.exe`：

```powershell
$uvExe = "$env:LOCALAPPDATA\hermes\bin\uv.exe"
$hermesPython = "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\python.exe"
$requirements = "$env:LOCALAPPDATA\hermes\skills\Deep-Research-Agent\requirements.txt"

& $uvExe pip install --python $hermesPython -r $requirements
```

如果你的 `uv.exe` 是另外安裝而不是 Hermes 管理，可改：

```powershell
uv pip install --python "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\python.exe" -r "$env:LOCALAPPDATA\hermes\skills\Deep-Research-Agent\requirements.txt"
```

---

## 7.4 驗證 dependencies

```powershell
& "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\python.exe" -c "import docx, fitz, requests, matplotlib, seaborn, pandas, duckduckgo_search; print('Deep Research Python deps OK')"
```

成功：

```text
Deep Research Python deps OK
```

---

## 7.5 如果看到 `No module named pip`

不用補 pip。

因為我們根本不需要：

```text
python -m pip
```

繼續使用：

```text
uv pip
```

即可。

[⬆ 回到目錄](#toc)

---

<a id="sec-8"></a>

# 8. API Key 安全與 `.env`

Hermes 的環境變數檔：

```text
%LOCALAPPDATA%\hermes\.env
```

開啟：

```powershell
notepad "$env:LOCALAPPDATA\hermes\.env"
```

後面會加入：

```text
OPENALEX_API_KEY=
SEMANTIC_SCHOLAR_API_KEY=
SCOPUS_API_KEY=
```

**`.env` 等同密碼檔。**

不要：

```text
❌ 上傳 GitHub
❌ 貼 Discord
❌ 貼 LINE 群
❌ 放 README
❌ 公開截圖
```

如果自己的 repo 裡有 `.env`，`.gitignore` 至少加入：

```gitignore
.env
*.env
```

[⬆ 回到目錄](#toc)

---

<a id="sec-9"></a>

# 9. 設定 OpenAlex

官方：

https://openalex.org/

API Key：

https://openalex.org/settings/api

開發文件：

https://developers.openalex.org/

OpenAlex 很適合當：

```text
Primary Broad Discovery
```

也就是大量初篩的主力。

---

## 9.1 取得 key

登入：

https://openalex.org/settings/api

複製 key。

打開：

```powershell
notepad "$env:LOCALAPPDATA\hermes\.env"
```

加入：

```text
OPENALEX_API_KEY=你的API_KEY
```

---

## 9.2 測試額度

```powershell
$key = (Get-Content "$env:LOCALAPPDATA\hermes\.env" | Where-Object { $_ -like 'OPENALEX_API_KEY=*' }) -replace '^OPENALEX_API_KEY=',''
```

```powershell
Invoke-RestMethod "https://api.openalex.org/rate-limit?api_key=$key"
```

---

## 9.3 真正搜尋

```powershell
Invoke-RestMethod "https://api.openalex.org/works?search=stroboscopic%20visual%20training&per_page=3&api_key=$key"
```

看到：

```text
meta
results
```

就成功。

目前 OpenAlex 免費 key 為每日 US$1 API 免費使用額度；不同操作成本不同。

[⬆ 回到目錄](#toc)

---

<a id="sec-10"></a>

# 10. 設定 Semantic Scholar

官方：

https://www.semanticscholar.org/product/api

API tutorial：

https://www.semanticscholar.org/product/api/tutorial

---

## 10.1 申請 API Key

到：

https://www.semanticscholar.org/product/api

找到：

```text
Request an API Key
```

用途可以寫：

```text
I plan to use the Semantic Scholar API as part of a personal,
non-commercial academic research workflow for literature discovery,
metadata retrieval, citation analysis, and evidence synthesis.

The project is used by a single researcher. Requests will use batch
endpoints where appropriate, local caching, deduplication, and
rate-limit-aware retry logic.
```

---

## 10.2 收到 key 後

```powershell
notepad "$env:LOCALAPPDATA\hermes\.env"
```

加入：

```text
SEMANTIC_SCHOLAR_API_KEY=你的KEY
```

---

## 10.3 測試 authenticated request

```powershell
$s2key = (Get-Content "$env:LOCALAPPDATA\hermes\.env" | Where-Object { $_ -like 'SEMANTIC_SCHOLAR_API_KEY=*' }) -replace '^SEMANTIC_SCHOLAR_API_KEY=',''
$headers = @{ "x-api-key" = $s2key }
```

測試：

```powershell
Invoke-RestMethod `
  -Uri "https://api.semanticscholar.org/graph/v1/paper/DOI:10.3758/s13414-012-0344-6?fields=title,year,citationCount" `
  -Headers $headers
```

看到：

```text
paperId
title
```

就成功。

[⬆ 回到目錄](#toc)

---

<a id="sec-11"></a>

# 11. Semantic Scholar 限流保護

Semantic Scholar 官方目前說明：API key 的 introductory rate limit 約：

```text
1 request / second
```

而且是：

```text
所有 endpoints 共用
```

因此不要做：

```text
Agent A → 1 req/s
Agent B → 1 req/s
Agent C → 1 req/s
```

因為實際變成：

```text
3 req/s
```

容易得到：

```text
HTTP 429 Too Many Requests
```

---

## 正確策略

### 1. OpenAlex 先主搜

```text
OpenAlex
↓
抓 40～60+ candidates
```

### 2. 先去重

依序：

```text
DOI
PMID
OpenAlex ID
normalized title
```

### 3. S2 只補重要文獻

不要拿 S2 當第一個大量 scanner。

### 4. 優先 Batch

例如：

```text
/graph/v1/paper/batch
```

一次最多可以處理多筆 paper IDs，比逐篇 request 省很多。

### 5. 每次 request 至少間隔

```text
1.25 秒
```

### 6. 429 backoff

```text
5 秒
10 秒
20 秒
40 秒
80 秒
```

不要用多帳號、多 key、多 IP 去繞過 rate limit。

[⬆ 回到目錄](#toc)

---

<a id="sec-12"></a>

# 12. 設定 Exa MCP

Exa MCP：

https://exa.ai/mcp

Exa docs：

https://exa.ai/docs/reference/exa-mcp

先使用官方 remote MCP，不一定要自己申請 Exa API key。

開：

```powershell
notepad "$env:LOCALAPPDATA\hermes\config.yaml"
```

加入：

```yaml
mcp_servers:
  exa:
    url: "https://mcp.exa.ai/mcp?tools=web_search_exa,web_fetch_exa,web_search_advanced_exa"
    timeout: 180
    connect_timeout: 60
    supports_parallel_tool_calls: false
```

如果原本已經有：

```yaml
mcp_servers:
```

不要建立第二個。

只把 `exa:` 放進原本的 `mcp_servers:` 底下。

---

## 測試

```powershell
hermes mcp test exa
```

成功應看到：

```text
Connected
```

以及類似：

```text
web_search_exa
web_search_advanced_exa
web_fetch_exa
```

真正測試：

```powershell
hermes
```

輸入：

```text
Use the Exa MCP tool web_search_exa to find 3 scholarly sources
about stroboscopic visual training.

Return only title, year, DOI or URL, and source.
```

[⬆ 回到目錄](#toc)

---

<a id="sec-13"></a>

# 13. 設定 Scopus MCP

Elsevier Developer Portal：

https://dev.elsevier.com/

Scopus MCP：

https://github.com/qwe4559999/scopus-mcp

---

## 13.1 申請 Elsevier API Key

到：

https://dev.elsevier.com/

使用學校 / 教育機構身分比較適合。

Application Name 可填：

```text
Deep Research Agent - Academic Literature Review
```

用途：

```text
Personal non-commercial academic research project for literature
discovery, metadata retrieval, citation analysis, and evidence synthesis.
```

取得 key 後：

```powershell
notepad "$env:LOCALAPPDATA\hermes\.env"
```

加入：

```text
SCOPUS_API_KEY=你的API_KEY
```

---

## 13.2 加入 Hermes MCP

```powershell
notepad "$env:LOCALAPPDATA\hermes\config.yaml"
```

若 Exa 已經存在，完整可類似：

```yaml
mcp_servers:
  exa:
    url: "https://mcp.exa.ai/mcp?tools=web_search_exa,web_fetch_exa,web_search_advanced_exa"
    timeout: 180
    connect_timeout: 60
    supports_parallel_tool_calls: false

  scopus:
    command: "uvx"
    args:
      - "--with"
      - "mcp>=1.0,<2"
      - "scopus-mcp"
    env:
      SCOPUS_API_KEY: "${SCOPUS_API_KEY}"
    timeout: 180
    connect_timeout: 60
    supports_parallel_tool_calls: false
```

---

## 13.3 為什麼有 `mcp>=1.0,<2`

目前 `scopus-mcp` 發布版本曾遇到 MCP SDK 2.x 相容問題。

如果直接：

```text
uvx scopus-mcp
```

可能看到：

```text
Connection closed
```

目前 workaround：

```text
mcp>=1.0,<2
```

相關 PR：

https://github.com/qwe4559999/scopus-mcp/pull/12

未來上游正式修好後，這個 workaround 可能可以拿掉。

---

## 13.4 測試

```powershell
hermes mcp test scopus
```

成功應看到：

```text
Connected
```

以及目前常見工具：

```text
search_scopus
get_abstract_details
get_author_profile
get_citing_papers
get_quota_status
```

---

## 13.5 真正搜尋

```powershell
hermes
```

輸入：

```text
Use the Scopus MCP tool search_scopus to search for:

TITLE-ABS-KEY("stroboscopic visual training")

Return only the first 5 results with title, year, authors,
Scopus ID, DOI, and citation count.
```

---

## 13.6 看 quota

```text
Use the Scopus MCP get_quota_status tool and show me the current
quota limit, remaining quota, and reset time.
```

Elsevier 官方 quota 是：

```text
不同 API 各自計算
通常每 7 天重置
```

不是整把 key 只有一個統一 quota。

---

## 13.7 校外網路注意

API key：

```text
≠
institutional entitlement
```

所以可能出現：

```text
key 有效
但部分 Scopus subscriber 功能不允許
```

這可能跟：

```text
校內 IP / institution entitlement
```

有關。

官方：

https://dev.elsevier.com/tecdoc_api_authentication.html

[⬆ 回到目錄](#toc)

---

<a id="sec-14"></a>

# 14. 建立本地研究工作區

不要從 Hermes 自己的：

```text
AppData\Local\hermes\hermes-agent
```

或：

```text
venv
```

裡開始做研究。

建立：

```powershell
$root = "$env:USERPROFILE\Documents\DeepResearch"

New-Item -ItemType Directory -Force `
"$root\cache", `
"$root\evidence", `
"$root\papers", `
"$root\assets", `
"$root\reports", `
"$root\notebooklm" | Out-Null
```

完成後：

```text
DeepResearch\
├─ cache\
├─ evidence\
├─ papers\
├─ assets\
├─ reports\
└─ notebooklm\
```

---

## 各資料夾用途

```text
cache\
→ API cache / 暫存 JSON

evidence\
→ literature_manifest.csv
→ screening table
→ evidence table
→ metadata verification

papers\
→ 合法取得的原始 PDF

assets\
→ 圖表 / 圖片 / 流程圖

reports\
→ Phase 0 / Phase 0.5 / final reports / DOCX

notebooklm\
→ NotebookLM upload log / notebook source list
```

---

## 研究時固定從這裡開 Hermes

```powershell
cd "$env:USERPROFILE\Documents\DeepResearch"
hermes
```

這樣可以避免 Hermes 在不適合的工作目錄載入不必要的 `AGENTS.md`。

[⬆ 回到目錄](#toc)

---

<a id="sec-15"></a>

# 15. 設定本地文獻保存規則

## 15.1 PDF 命名

建議：

```text
YEAR_FirstAuthor_ShortTitle.pdf
```

例如：

```text
2014_Baker_Digital_24h_Dietary_Recall_Athletes.pdf
```

不要：

```text
download.pdf
document(2).pdf
paper.pdf
```

---

## 15.2 建立 literature manifest

建議：

```text
Documents\DeepResearch\evidence\literature_manifest.csv
```

欄位：

```text
title
authors
year
journal
doi
openalex_id
scopus_id
semantic_scholar_id
source_database
screening_status
verification_level
oa_url
local_pdf
notebooklm_notebook
notebooklm_uploaded
notes
```

其中：

```text
verification_level
```

只建議使用：

```text
metadata
abstract
full_text
```

**找到 DOI 不代表已全文驗證。**

---

## 15.3 把本地保存規則加進 Skill

開：

```powershell
$skill = "$env:LOCALAPPDATA\hermes\skills\Deep-Research-Agent\skills\deep-science-writer\SKILL.md"
notepad $skill
```

在 `LOCAL RUNTIME POLICY` 裡加入：

```markdown
### Local Literature Storage

- Resolve the current Windows user home directory from `%USERPROFILE%`.
- Use `%USERPROFILE%/Documents/DeepResearch/` as the research workspace.
- Never hard-code another username or require a `D:/` drive.

- Store literature metadata and screening records under:
  `%USERPROFILE%/Documents/DeepResearch/evidence/`

- Store legally obtained full-text papers under:
  `%USERPROFILE%/Documents/DeepResearch/papers/`

- Store generated reports under:
  `%USERPROFILE%/Documents/DeepResearch/reports/`

- Maintain:
  `%USERPROFILE%/Documents/DeepResearch/evidence/literature_manifest.csv`

- For every screened or retained paper, record at minimum:
  title, authors, year, journal, DOI, source database,
  screening decision, verification level, OA URL,
  local PDF path, NotebookLM notebook, and NotebookLM upload status.

- Verification levels MUST be explicitly distinguished:
  metadata / abstract / full_text.

- Never mark a paper as full-text verified unless the actual full text
  was successfully obtained and read.

- Save each legally obtained paper as an individual file.
- Recommended PDF filename:
  `YEAR_FirstAuthor_ShortTitle.pdf`

- Deduplicate papers by DOI first, then normalized title.

- If full text cannot legally be obtained, keep metadata and DOI/URL
  in the manifest and mark local_pdf as unavailable.
  Do not fabricate a local file.
```

---

## 15.4 原 repo 的 Unpaywall script 注意

目前 repo 內的：

```text
skills/deep-science-writer/scripts/node/fetch_unpaywall_oa.js
```

比較像作者自己的示範腳本。

不要直接假設它會自動處理你的所有文獻。

公開版本曾包含：

```text
硬編碼 DOI 清單
硬編碼 email
固定輸出檔
```

比較安全的做法：

```text
搜尋 / 篩選
↓
確認 OA 或合法 institutional access
↓
下載真正取得的 PDF
↓
存進 papers\
↓
更新 literature_manifest.csv
```

如果未來要全自動 OA downloader，建議另外寫一個從 manifest / DOI list 讀取的通用 script。

[⬆ 回到目錄](#toc)

---

<a id="sec-16"></a>

# 16. NotebookLM 改為手動匯入

目前這份 README **不再把 NotebookLM MCP 當成必要元件**。

原因：

```text
NotebookLM MCP
→ 需要第三方 browser session
→ 認證可能過期
→ Agent 可能自動 retry
→ 容易浪費 OpenRouter 免費 request
```

而真正研究上需要的是：

```text
找到文獻
↓
合法取得全文
↓
本地保存
↓
篩選出核心文獻
↓
人工拖進 NotebookLM
```

這樣更穩，也更容易除錯。

---

## 16.1 NotebookLM 還需要安裝 MCP 嗎？

**不用。**

如果目標只是把 Hermes 找到並下載的核心 PDF 丟進 NotebookLM 做跨文獻整理，完全不需要：

```text
notebooklm-mcp-server
auth
refresh_auth
Hermes NotebookLM MCP
```

本 README 後續預設：

```text
NotebookLM MCP = 關閉 / 不使用
```

---

## 16.2 如果之前已經設定過 NotebookLM MCP

可以先留著，不必急著移除。只要不要在研究 Prompt 裡要求：

```text
upload to NotebookLM
create notebook
use notebooklm MCP
```

如果想完全停用，開：

```powershell
notepad "$env:LOCALAPPDATA\hermes\config.yaml"
```

找到 `notebooklm:` 區塊並移除。

> 如果 `mcp_servers:` 裡還有 Exa / Scopus，不要把整個 `mcp_servers:` 刪掉。

---

## 16.3 Node / npm / npx 還需要嗎？

對於**目前這套手動 NotebookLM 流程**，NotebookLM 不再需要 Node.js / npm / npx。

但 Hermes 本身或其他 MCP 仍可能使用 Node.js，所以 README 前面保留 Node.js 檢查與修復方式。

---

## 16.4 每個研究專案建立自己的資料夾

建議：

```text
Documents\
└─ DeepResearch\
   └─ <ProjectName>\
      ├─ cache\
      ├─ evidence\
      ├─ papers\
      ├─ reports\
      └─ notebooklm_ready\
```

其中：

```text
papers\
→ 所有合法取得、準備 deep-read 的全文

notebooklm_ready\
→ 最後真正要手動丟進 NotebookLM 的核心文獻
```

---

## 16.5 建立專案資料夾範例

```powershell
$project = "$env:USERPROFILE\Documents\DeepResearch\Athlete_Nutrition_Platform"

New-Item -ItemType Directory -Force `
"$project\cache", `
"$project\evidence", `
"$project\papers", `
"$project\reports", `
"$project\notebooklm_ready" | Out-Null
```

確認：

```powershell
Get-ChildItem $project
```

應看到：

```text
cache
evidence
papers
reports
notebooklm_ready
```

---

## 16.6 `notebooklm_ready` 的用途

它只是最後核心文獻的待匯入區，不是第二份完整 archive。

例如：

```text
papers\
├─ 2021_Author_A.pdf
├─ 2022_Author_B.pdf
├─ 2023_Author_C.pdf
├─ 2024_Author_D.pdf
└─ 2025_Author_E.pdf

notebooklm_ready\
├─ 2022_Author_B.pdf
├─ 2024_Author_D.pdf
└─ 2025_Author_E.pdf
```

代表只有 B、D、E 是最後希望放進 NotebookLM 的核心來源。

---

## 16.7 不要把候選文獻全部丟 NotebookLM

正確：

```text
40～60 candidates
↓
abstract screening
↓
8～12 deep-read
↓
最後 retained / cited papers
↓
notebooklm_ready
↓
人工上傳
```

[⬆ 回到目錄](#toc)

---

<a id="sec-17"></a>

# 17. NotebookLM 桌面版 / PWA 怎麼使用

如果已經有 NotebookLM 網頁、桌面捷徑、Chrome / Edge PWA 或獨立視窗版，直接照平常方式用。

新的流程：

```text
Hermes
↓
把 PDF 整理到本地 notebooklm_ready\
↓
你開 NotebookLM
↓
一次選取核心文獻
↓
拖進 notebook
```

Hermes 不需要控制 NotebookLM 視窗，也不需要綁定 Google session。

## 17.1 手動匯入方式

完成研究篩選後：

```text
打開 notebooklm_ready\
↓
Ctrl+A
↓
拖到 NotebookLM
```

或在 NotebookLM 使用 `Add source → Upload`。

好處：

```text
看得到實際上傳了哪些檔案
不會因 Agent retry 重複建立來源
NotebookLM 認證問題不影響文獻搜尋
不消耗 Hermes LLM request 處理登入錯誤
```

[⬆ 回到目錄](#toc)

---

<a id="sec-18"></a>

# 18. 測試本地 PDF / Markdown → NotebookLM

現在不測 MCP，只測本地檔案整理與人工上傳。

## 18.1 建立測試檔

```powershell
$project = "$env:USERPROFILE\Documents\DeepResearch\NotebookLM_Test"

New-Item -ItemType Directory -Force `
"$project\papers", `
"$project\notebooklm_ready" | Out-Null

Set-Content `
"$project\notebooklm_ready\notebooklm_test.md" `
"# NotebookLM Test`nThis file was prepared locally for manual NotebookLM upload."
```

確認：

```powershell
Test-Path "$project\notebooklm_ready\notebooklm_test.md"
```

應該是 `True`。

## 18.2 手動丟進 NotebookLM

打開：

https://notebooklm.google.com/

建立測試 notebook：

```text
Hermes NotebookLM Test
```

然後：

```text
Add source
→ Upload
→ 選 notebooklm_test.md
```

或直接把檔案拖進 NotebookLM。

如果能成功，本地整理 → NotebookLM 這條鏈就成立。

## 18.3 正式研究時換成 PDF

```text
notebooklm_ready\
├─ 2023_Author_Title.pdf
├─ 2024_Author_Title.pdf
└─ 2025_Author_Title.pdf
```

一次多選後拖進 NotebookLM 即可。

[⬆ 回到目錄](#toc)

---

<a id="sec-19"></a>

# 19. 設定「核心文獻整理給 NotebookLM」

現在不做自動上傳，改成：

```text
Hermes 自動整理本地檔案
↓
使用者人工上傳 NotebookLM
```

## 19.1 在 SKILL.md 加入本地 Archive 規則

開：

```powershell
$skill = "$env:LOCALAPPDATA\hermes\skills\Deep-Research-Agent\skills\deep-science-writer\SKILL.md"
notepad $skill
```

加入：

```markdown
### Local Literature Archive — Primary Workflow

The local filesystem is the PRIMARY literature archive.

NotebookLM is NOT part of the automated research pipeline.

Research root:
`%USERPROFILE%/Documents/DeepResearch/`

For each research project, create a dedicated project folder:
`%USERPROFILE%/Documents/DeepResearch/<ProjectName>/`

Inside it create:
- `papers/`
- `evidence/`
- `reports/`
- `cache/`
- `notebooklm_ready/`

For every paper selected for deep reading:
1. Verify metadata first.
2. Deduplicate by DOI, then normalized title.
3. Attempt to obtain full text only through legitimate access:
   - open-access publisher copy;
   - institutional repository;
   - OpenAlex / Unpaywall OA location;
   - legitimate institutional access.
4. If a PDF is legally available, download and save it under:
   `<ProjectName>/papers/`
5. Use filename format:
   `YEAR_FirstAuthor_ShortTitle.pdf`
6. Record the local PDF path in:
   `<ProjectName>/evidence/literature_manifest.csv`
7. Never mark a paper as full-text verified unless the actual file
   was successfully downloaded and read.

If full text is unavailable:
- preserve title, authors, DOI, journal, year, URL and database IDs;
- set `local_pdf = unavailable`;
- set verification level to `metadata` or `abstract`;
- do not fabricate or generate a replacement PDF.

For NotebookLM:
- do NOT invoke NotebookLM MCP;
- do NOT create notebooks;
- do NOT upload sources automatically;
- do NOT allow NotebookLM failure to block research.

After screening and full-text verification:
- copy ONLY the retained deep-read / final evidence papers into:
  `<ProjectName>/notebooklm_ready/`
- keep every paper as an individual file;
- do not copy excluded candidates;
- do not copy duplicate DOI/title records.

The user will manually upload files from `notebooklm_ready/`
to NotebookLM later.
```

## 19.2 讓 Hermes 產生 NotebookLM 清單

建議另外輸出：

```text
<ProjectName>\evidence\notebooklm_sources.txt
```

內容記錄：作者、年份、檔名、DOI、verification level。

## 19.3 manifest 加兩個欄位

```text
notebooklm_ready
notebooklm_uploaded_manual
```

例如：

```text
notebooklm_ready = yes
notebooklm_uploaded_manual = no
```

人工上傳後可改成：

```text
notebooklm_uploaded_manual = yes
```

[⬆ 回到目錄](#toc)

---

<a id="sec-20"></a>

# 20. 加入 Economy Mode

原始 Deep-Research-Agent 比較偏重：

```text
100+ candidates
20～30+ full texts
多 Agent
多 API
```

完全免費模型很容易撞：

```text
OpenRouter daily cap
Semantic Scholar 1 RPS
長 context
```

所以建議加 Economy Mode。

---

## 20.1 先備份 SKILL

```powershell
$skill = "$env:LOCALAPPDATA\hermes\skills\Deep-Research-Agent\skills\deep-science-writer\SKILL.md"

Copy-Item $skill "$skill.original.bak"

notepad $skill
```

找到：

```markdown
# Deep Science Writer (End-to-End Pipeline)
```

在它後面加入下一節完整規則。

[⬆ 回到目錄](#toc)

---

<a id="sec-21"></a>

# 21. 完整 Economy Mode 規則

把以下內容貼進 `SKILL.md`：

```markdown
## LOCAL RUNTIME POLICY — WINDOWS / ECONOMY MODE

This local policy overrides conflicting rules later in this skill.

### Environment
- Platform: Windows.
- Resolve the current user home directory from `%USERPROFILE%`.
- Research workspace:
  `%USERPROFILE%/Documents/DeepResearch/`
- Never hard-code another username.
- Never require a `D:/` drive.
- Store outputs, caches, evidence records and downloaded papers under
  the DeepResearch workspace.

### Economy Mode
Economy Mode is enabled by default.

For normal exploratory research:
- Initial candidate pool: approximately 40–60 papers.
- Targeted full-text set: approximately 8–12 high-relevance papers.
- Expand further only after explicit user approval.
- Reuse previously retrieved data before issuing new API requests.
- Cache API responses whenever practical.
- Avoid repeated searches that answer the same question.

### OpenAlex
- Use OpenAlex as the primary broad-discovery source.
- Perform high-volume first-pass searching here.
- Deduplicate using DOI, PMID, OpenAlex ID, or normalized title.
- Cache results locally.

### Semantic Scholar
- Semantic Scholar is supplemental, not the primary high-volume discovery source.
- Prefer batch/bulk endpoints.
- Never issue concurrent Semantic Scholar API requests.
- Maintain at least 1.25 seconds between requests.
- Query only papers remaining after OpenAlex deduplication when possible.
- Cache responses by DOI or Semantic Scholar Paper ID.
- Request only required fields.

On HTTP 429:
1. Stop sending Semantic Scholar requests.
2. Wait 5 seconds.
3. Retry.
4. If another 429 occurs, wait 10, 20, 40, then 80 seconds.
5. Never attempt to bypass rate limits using multiple accounts,
   API keys, or IP addresses.

### Scopus
- Use Scopus primarily for detailed metadata, indexing verification,
  citation information, and cross-checking.
- Avoid repeating broad searches already adequately covered by OpenAlex.
- Reuse cached MCP responses.
- Check API quota during large jobs.

### Exa
- Use Exa for supplementary scholarly web discovery,
  open-access discovery, institutional repositories, and missing URLs.
- Do not repeatedly search information already available from
  OpenAlex, Scopus, or Semantic Scholar.

### Parallelism
- Maximum default LLM subagent concurrency in Economy Mode: 2.
- Do not allow parallel Semantic Scholar requests.
- Prefer scripts and batch API calls over spawning many LLM workers.
- Full multi-agent research requires explicit user approval.

### Full Text
Use this order:
1. Legitimate open-access publisher copy.
2. Institutional repository.
3. OpenAlex / Unpaywall open-access location.
4. Legitimate institutional access.
5. Ask the user to obtain or provide the paper.

Do not bypass paywalls, authentication controls,
robots restrictions, or other access controls.

If full text is unavailable, record it as unavailable.

Never claim full-text verification when only metadata or abstract was available.

### Evidence Integrity
- A valid DOI proves a publication exists;
  it does not prove that a claim is supported.
- Distinguish metadata verification, abstract verification,
  and full-text verification.
- Never fabricate methods, results, sample sizes,
  effect sizes, authors, years, or conclusions.

### Local Literature Storage
- Store metadata and screening records under:
  `%USERPROFILE%/Documents/DeepResearch/evidence/`
- Store legally obtained full-text papers under:
  `%USERPROFILE%/Documents/DeepResearch/papers/`
- Store generated reports under:
  `%USERPROFILE%/Documents/DeepResearch/reports/`
- Maintain:
  `%USERPROFILE%/Documents/DeepResearch/evidence/literature_manifest.csv`
- Use verification levels:
  metadata / abstract / full_text.
- Save retained papers individually.
- Recommended filename:
  `YEAR_FirstAuthor_ShortTitle.pdf`
- Deduplicate by DOI first, then normalized title.

### NotebookLM

NotebookLM is disabled from the automated workflow by default.

- Do not invoke NotebookLM MCP.
- Do not create notebooks automatically.
- Do not upload sources automatically.
- After screening and full-text verification, copy retained core papers
  to `<ProjectName>/notebooklm_ready/`.
- The user will manually upload those files to NotebookLM.
- NotebookLM must never block literature retrieval, verification,
  local archiving, or evidence synthesis.

### Optional Integrations
The following must not block basic research:
- Zotero
- NotebookLM
- Obsidian
- visualization tools

Skip optional integrations when not configured.
```

[⬆ 回到目錄](#toc)

---

<a id="sec-22"></a>

# 22. 確認 Skill 還正常

```powershell
hermes skills list
```

確認：

```text
deep-science-writer
remi
```

仍為：

```text
enabled
```

[⬆ 回到目錄](#toc)

---

<a id="sec-23"></a>

# 23. 第一次測試：只跑 Phase 0

先：

```powershell
cd "$env:USERPROFILE\Documents\DeepResearch"
hermes
```

貼：

```text
Please use the deep-science-writer skill in ECONOMY MODE to research
the effects of stroboscopic visual training on sports performance.

Focus on:
- trained or competitive athletes
- perceptual and cognitive outcomes
- reaction and visual-attention outcomes
- motor or sport-specific performance
- evidence of transfer to actual sport performance
- methodological limitations and research gaps

Use OpenAlex as the primary broad-discovery database,
with Scopus, Exa, and Semantic Scholar as complementary sources.

For this turn, execute Phase 0 ONLY.

1. Clarify the research scope if necessary.
2. Propose search concepts and keyword combinations.
3. Define inclusion and exclusion criteria.
4. Explain how each database will be used.
5. Propose the structure of the review.
6. Estimate candidate and full-text paper counts.

STOP after presenting the blueprint.

Do NOT begin Phase 0.5.
Do NOT launch large-scale retrieval.
Do NOT launch multiple research subagents.
Wait for explicit approval.
```

正常應該規劃：

```text
40～60 candidates
8～12 deep-read papers
```

然後停下來問你是否批准。

如果它直接開始大量 call API：

```text
Ctrl+C
```

先修 Skill。

[⬆ 回到目錄](#toc)

---

<a id="sec-24"></a>

# 24. 正式放行 Phase 0.5

如果 Blueprint 沒問題：

```text
I approve this research blueprint.

Proceed to Phase 0.5 in ECONOMY MODE.

Follow the local runtime policy strictly:
- use OpenAlex as the primary broad-discovery source;
- respect Semantic Scholar rate limits and caching rules;
- avoid duplicate API requests;
- do not bypass paywalls or access controls;
- store all outputs under my Documents/DeepResearch workspace;
- save legally obtained deep-read papers locally;
- update the literature manifest;
- place retained deep-read/full-text papers into the project's
  `notebooklm_ready/` folder for manual NotebookLM upload;
- stop after Phase 0.5 and wait for my approval.
```

第一次正式使用建議：

```text
一個 Phase 一個 Phase 放行
```

不要一按就讓它跑到 DOCX。

[⬆ 回到目錄](#toc)

---

<a id="sec-25"></a>

# 25. 完整文獻保存與 NotebookLM 流程

```text
                 OpenAlex
                    │
             broad discovery
                    │
                    ▼
          dedup + abstract screening
                    │
        ┌───────────┼────────────┐
        ▼           ▼            ▼
     Scopus   Semantic Scholar   Exa
        │           │            │
        └───────────┼────────────┘
                    │
                    ▼
       evidence/literature_manifest.csv
                    │
                    ▼
            selected deep reads
                    │
        ┌───────────┴───────────┐
        ▼                       ▼
  papers/*.pdf              reports/*.md
        │
        ▼
 final retained / cited papers
        │
        ▼
 notebooklm_ready/*.pdf
        │
        ▼
 使用者手動拖進 NotebookLM
```

`papers\` 是完整本地 archive。

`notebooklm_ready\` 只是最後核心文獻的待上傳區。

NotebookLM 不是唯一備份，也不是研究 pipeline 的必要依賴。

[⬆ 回到目錄](#toc)

---

<a id="sec-26"></a>

# 26. OpenRouter 50 次/日怎麼省

OpenRouter 免費模型的限制跟 Semantic Scholar 不一樣。

這是：

```text
LLM inference request 限制
```

不是文獻 API。

未購買 credits 的 Free model account 通常：

```text
50 requests/day
```

所以：

```text
1 個 Deep Research 任務
≠
1 次 request
```

Agent 可能：

```text
看 prompt          1 次
看 tool output     1 次
決定下一步         1 次
再 call tool       1 次
再 reasoning       1 次
subagent            多次
```

一天很容易用完。

---

## 正確省法

### 1. 不要每天一直重裝 / 重測

安裝完成後，不需要一直：

```text
測 OpenAlex
測 Scopus
測 Exa
測 S2
```

### 2. Phase 結束就存檔

例如：

```text
phase0.md
phase0.5.md
literature_manifest.csv
```

### 3. context 太長就開新 session

不要永遠在：

```text
100k+ tokens
```

的同一個聊天跑。

### 4. 不要為小修正整輪重跑

應該：

```text
保留已驗證結果
只補錯誤 / 不足
```

### 5. API retrieval 能用 script 就不要讓 LLM 一篇一篇操作

理想：

```text
Python / Node script
↓
抓 metadata
↓
去重
↓
產生 CSV/JSON
↓
一次交給 LLM 分析
```

而不是：

```text
每抓一篇
→ LLM reasoning
→ 再抓一篇
→ LLM reasoning
```

### 6. 不要以為換另一個 `:free` 模型就會重置 50/day

這個 cap 是：

```text
OpenRouter account free-model quota
```

不是單一模型 quota。

[⬆ 回到目錄](#toc)

---

<a id="sec-27"></a>

# 27. 建立 Hermes Desktop 一鍵啟動 BAT

桌面建立：

```text
Start_Hermes_Desktop.bat
```

內容：

```bat
@echo off
setlocal

set "WORKDIR=%USERPROFILE%\Documents\DeepResearch"

if not exist "%WORKDIR%" (
    mkdir "%WORKDIR%"
)

where hermes >nul 2>&1
if errorlevel 1 (
    echo Hermes was not found in PATH.
    echo Please confirm that Hermes is installed.
    pause
    exit /b 1
)

cd /d "%WORKDIR%"
hermes desktop

endlocal
exit /b
```

以後直接：

```text
雙擊 BAT
↓
切到 DeepResearch 工作區
↓
開 Hermes Desktop
```

這樣不需要每天手動進 PowerShell。

[⬆ 回到目錄](#toc)

---

<a id="sec-28"></a>

# 28. 常見錯誤與排除

## 28.1 `No module named pip`

不要補 pip。

用：

```powershell
uv pip install ...
```

---

## 28.2 `hermes skills install` 抓不到 repo

改：

```powershell
cd "$env:LOCALAPPDATA\hermes\skills"
git clone https://github.com/CYC2002tommy/Deep-Research-Agent.git
```

---

## 28.3 Semantic Scholar 429

停下。

不要狂 retry。

依：

```text
5 → 10 → 20 → 40 → 80 秒
```

並確認：

```text
OpenAlex 主搜
S2 補資料
```

---

## 28.4 OpenRouter 429：`free-models-per-day`

如果 log 有：

```text
X-RateLimit-Limit: 50
X-RateLimit-Remaining: 0
```

代表：

```text
今天 Free-model quota 用完
```

不是 Semantic Scholar 問題。

不要用 2 秒、5 秒 backoff 硬 retry。

等 daily reset。

---

## 28.5 Scopus `Connection closed`

確認 config：

```yaml
args:
  - "--with"
  - "mcp>=1.0,<2"
  - "scopus-mcp"
```

仍然不行：

```powershell
uvx --with "mcp>=1.0,<2" scopus-mcp
```

直接看真正 traceback。

---

## 28.6 Scopus key 有效但功能被拒

可能是：

```text
institutional entitlement
```

校內網路與家中網路可能不同。

---

## 28.7 Exa MCP 429

代表免費 remote MCP 暫時撞 limit。

先等，不要 loop 狂打。

---

## 28.8 `AGENTS.md TRUNCATED`

先：

```powershell
cd "$env:USERPROFILE\Documents\DeepResearch"
```

再：

```powershell
hermes
```

不要從 Hermes venv / source directory 開研究 session。

---

## 28.9 NotebookLM `node` / `npm` / `npx` 找不到

先：

```powershell
node -v
npm -v
npx -v
```

如果缺少：

### 第一選擇

重新跑 Hermes installer：

```powershell
iex (irm https://hermes-agent.nousresearch.com/install.ps1)
```

重開 PowerShell再測。

### 第二選擇

安裝 Node.js LTS：

https://nodejs.org/en/download

安裝完成後重新開 PowerShell：

```powershell
node -v
npm -v
npx -v
```

### 如果只有 `npx.ps1` 被 PowerShell 擋

```powershell
npx.cmd -v
```

如果 `.cmd` 正常，不需要另外安裝 npx。

**不要使用：**

```text
npm install -g npx
```

新版 npx 本來就是 npm 提供。

---

## 28.10 NotebookLM MCP `Connection closed`

手動：

```powershell
npx -y notebooklm-mcp-server start
```

看真正錯誤。

---

## 28.11 NotebookLM 登入失效

```powershell
npx -y notebooklm-mcp-server refresh_auth
```

---

## 28.12 NotebookLM 本地 PDF 找不到

```powershell
Test-Path "$env:USERPROFILE\Documents\DeepResearch\papers\paper.pdf"
```

如果：

```text
False
```

代表路徑錯。

---

## 28.13 NotebookLM source 匯入失敗

常見：

```text
檔案超過 200 MB
內容超過 500,000 words
PDF copy-protected
notebook source 數量已滿
```

---

## 28.14 有 DOI，但沒有 PDF

正常。

manifest：

```text
local_pdf = unavailable
verification_level = metadata 或 abstract
notebooklm_uploaded = no
```

不要製造假 PDF。

---

## 28.15 Agent 找到正確論文卻寫錯作者 / 樣本數

不要只驗 DOI 是否活著。

核心文獻應建立 verification table：

```text
Exact title
Authors
Year
Journal
DOI
Study type
Sample size
Population
Comparator
Outcomes
Statistics
Main findings
Limitations
Verification level
Verification source
```

並清楚區分：

```text
VERIFIED METADATA
VERIFIED ABSTRACT
VERIFIED FULL TEXT
INFERENCE
```

[⬆ 回到目錄](#toc)

---

<a id="sec-29"></a>

# 29. 完整健康檢查

## Hermes

```powershell
hermes doctor
```

## Skills

```powershell
hermes skills list
```

## Exa

```powershell
hermes mcp test exa
```

## Scopus

```powershell
hermes mcp test scopus
```

## NotebookLM

NotebookLM 採手動匯入，不需要 MCP health check。

確認各專案有 `notebooklm_ready` 即可。


## OpenAlex

```powershell
$key = (Get-Content "$env:LOCALAPPDATA\hermes\.env" | Where-Object { $_ -like 'OPENALEX_API_KEY=*' }) -replace '^OPENALEX_API_KEY=',''

Invoke-RestMethod "https://api.openalex.org/rate-limit?api_key=$key"
```

## Semantic Scholar

```powershell
$s2key = (Get-Content "$env:LOCALAPPDATA\hermes\.env" | Where-Object { $_ -like 'SEMANTIC_SCHOLAR_API_KEY=*' }) -replace '^SEMANTIC_SCHOLAR_API_KEY=',''

$headers = @{ "x-api-key" = $s2key }

Invoke-RestMethod `
  -Uri "https://api.semanticscholar.org/graph/v1/paper/DOI:10.3758/s13414-012-0344-6?fields=title,year,citationCount" `
  -Headers $headers
```

## 工作區

```powershell
Get-ChildItem "$env:USERPROFILE\Documents\DeepResearch"
```

應有：

```text
cache
evidence
papers
assets
reports
notebooklm
```

[⬆ 回到目錄](#toc)

---

<a id="sec-30"></a>

# 30. 最終完成檢查表

## Hermes / LLM

- [ ] Hermes 已安裝
- [ ] `hermes doctor` 正常
- [ ] Hermes Desktop 可開
- [ ] OpenRouter API key 已設定
- [ ] 免費模型可回答

## Deep Research Agent

- [ ] Deep-Research-Agent 已 clone
- [ ] `deep-science-writer` enabled
- [ ] `remi` enabled
- [ ] Python dependencies OK
- [ ] Economy Mode 已加入

## 文獻 API

- [ ] OpenAlex API 成功
- [ ] Semantic Scholar API 成功
- [ ] Semantic Scholar 1.25 秒 / backoff 規則已加入
- [ ] Exa MCP Connected
- [ ] Scopus MCP Connected
- [ ] Scopus 真實搜尋成功
- [ ] Scopus quota 可讀

## 本地保存

- [ ] `Documents\DeepResearch` 存在
- [ ] `cache` 存在
- [ ] `evidence` 存在
- [ ] `papers` 存在
- [ ] `assets` 存在
- [ ] `reports` 存在
- [ ] `notebooklm` 存在
- [ ] `literature_manifest.csv` 規則已加入
- [ ] verification level 規則已加入

## NotebookLM

- [ ] Node.js / npm / npx 都正常
- [ ] `notebooklm_ready` 已建立
- [ ] 測試檔可人工上傳 NotebookLM
- [ ] broad candidates 不會全部上傳
- [ ] deep-read / retained papers 會個別放進 `notebooklm_ready`
- [ ] manifest 會記錄 `notebooklm_ready` 與人工上傳狀態

## 研究工作流

- [ ] Phase 0 可以正常停下等批准
- [ ] Economy Mode 約 40–60 candidates
- [ ] 約 8–12 deep reads
- [ ] 不會把 DOI existence 當 claim verification
- [ ] 全文 unavailable 會如實標記
- [ ] Phase 完成後會存檔

全部打勾：

```text
可以正式開始 Deep Research。
```

[⬆ 回到目錄](#toc)

---

<a id="sec-31"></a>

# 31. 官方與專案連結

## Hermes Agent

https://hermes-agent.nousresearch.com/

https://hermes-agent.nousresearch.com/docs/getting-started/installation

https://hermes-agent.nousresearch.com/docs/user-guide/windows-native

https://hermes-agent.nousresearch.com/docs/user-guide/desktop

## Deep-Research-Agent

https://github.com/CYC2002tommy/Deep-Research-Agent

## OpenRouter

https://openrouter.ai/

https://openrouter.ai/keys

https://openrouter.ai/models?pricing=free

https://openrouter.ai/openrouter/free

https://openrouter.ai/docs/faq

## OpenAlex

https://openalex.org/

https://openalex.org/settings/api

https://developers.openalex.org/

## Semantic Scholar

https://www.semanticscholar.org/product/api

https://www.semanticscholar.org/product/api/tutorial

https://api.semanticscholar.org/api-docs/

## Exa

https://exa.ai/mcp

https://exa.ai/docs/reference/exa-mcp

## Elsevier / Scopus

https://dev.elsevier.com/

https://dev.elsevier.com/api_key_settings.html

https://dev.elsevier.com/tecdoc_api_authentication.html

## Scopus MCP

https://github.com/qwe4559999/scopus-mcp

https://github.com/qwe4559999/scopus-mcp/pull/12

## NotebookLM

https://notebooklm.google.com/

https://support.google.com/notebooklm/answer/16215270

https://support.google.com/notebooklm/answer/16269187

## NotebookLM MCP（可選，不是本 README 必要元件）

https://github.com/moodRobotics/notebooklm-mcp-server

[⬆ 回到目錄](#toc)

---

<a id="sec-32"></a>

# 32. 使用原則與學術倫理

不要把 Deep Research 理解成：

```text
按一下
→ AI 幫你寫完論文
```

比較合理：

```text
AI 幫忙處理大量機械工作
        ↓
搜尋
去重
metadata
整理
全文 extraction
evidence table
gap mapping
        ↓
研究者自己做判斷
```

特別注意：

```text
DOI 存在
≠
作者年份一定正確
≠
樣本數一定正確
≠
研究設計一定正確
≠
文章支持 Agent 寫的那句話
```

最後仍應由研究者人工確認：

```text
原始論文
Methods
Results
sample
statistics
研究情境
限制
```

另外：

```text
能下載
≠
有權重新散布
```

本地保存、NotebookLM 上傳與自動下載都應遵守：

```text
學校授權
出版社條款
著作權
Google / NotebookLM 使用規範
```

不要使用本流程去繞過：

```text
付費牆
登入限制
存取控制
anti-bot protection
```

遇到無法合法取得的全文：

```text
記錄 unavailable
```

不要假裝已讀全文。

---

# 完成

```text
搜尋
→ 去重
→ 篩選
→ 本地保存
→ 全文驗證
→ 整理 notebooklm_ready
→ 人工匯入 NotebookLM
→ Evidence synthesis
→ 人工判斷
```

這才是整套流程。

[⬆ 回到目錄](#toc)

