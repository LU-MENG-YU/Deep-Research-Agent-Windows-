<a id="top"></a>

# Deep Research Agent — Windows 零成本安裝與使用完整教學

> 適用：Windows 10 / 11  
> 目標：從零開始安裝 Hermes、Deep-Research-Agent、OpenRouter、OpenAlex、Semantic Scholar、Exa、Scopus、NotebookLM，並設定本地文獻保存、免費額度保護、桌面版啟動與完整研究工作流。  
> 最後整理：2026-08-18
>
> 這份教學是「新手照著做就能裝」版本。  
> 所有 API Key 都不要貼到 GitHub、Discord、LINE 或公開截圖。

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
16. [設定 NotebookLM MCP](#sec-16)
17. [已經裝好 NotebookLM 桌面版 / PWA 怎麼辦](#sec-17)
18. [測試本地檔案 → NotebookLM](#sec-18)
19. [設定「核心文獻自動導入 NotebookLM」](#sec-19)
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
      ├── Scopus MCP
      └── NotebookLM MCP
              │
              ▼
      NotebookLM / Gemini Notebook
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
NotebookLM 個別上傳核心文獻
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
| NotebookLM | Google 免費方案 | Free plan 有 notebook / source / daily query 等限制 |

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

```powershell
hermes doctor
```

如果有 config migration：

```powershell
hermes doctor --fix
```

常見正常項目：

```text
Python Environment
Virtual environment
Git
Node.js
ripgrep
Playwright Chromium
```

部分 optional 工具沒裝不代表 Hermes 壞掉。

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

PowerShell：

```powershell
cd "$env:LOCALAPPDATA\hermes\skills"
```

clone：

```powershell
git clone https://github.com/CYC2002tommy/Deep-Research-Agent.git
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

Deep-Research-Agent 需要 Python packages。

不要假設 Hermes venv 裡一定有 pip。

直接使用 `uv`：

```powershell
uv pip install --python "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\python.exe" -r "$env:LOCALAPPDATA\hermes\skills\Deep-Research-Agent\requirements.txt"
```

測試：

```powershell
& "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\python.exe" -c "import docx, fitz, requests, matplotlib, seaborn, pandas, duckduckgo_search; print('Deep Research Python deps OK')"
```

成功應看到：

```text
Deep Research Python deps OK
```

若：

```text
No module named pip
```

不用補 pip。

繼續用：

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

# 16. 設定 NotebookLM MCP

NotebookLM：

https://notebooklm.google.com/

這裡使用第三方 MCP：

https://github.com/moodRobotics/notebooklm-mcp-server

注意：

```text
這不是 Google 官方 NotebookLM API
```

它是第三方工具透過持久化 browser session 來操作 NotebookLM。

---

## 16.1 確認 Node / npx

```powershell
node -v
npx -v
```

都有版本號再繼續。

---

## 16.2 第一次登入

```powershell
npx -y notebooklm-mcp-server auth
```

瀏覽器會開啟：

```text
登入 Google
↓
進 NotebookLM
↓
確認看得到自己的 notebooks
↓
完成後關閉瀏覽器
```

如果之後 session 過期：

```powershell
npx -y notebooklm-mcp-server refresh_auth
```

---

## 16.3 加入 Hermes MCP

打開：

```powershell
notepad "$env:LOCALAPPDATA\hermes\config.yaml"
```

完整例子：

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

  notebooklm:
    command: "npx"
    args:
      - "-y"
      - "notebooklm-mcp-server"
      - "start"
    timeout: 300
    connect_timeout: 60
    supports_parallel_tool_calls: false
```

不要建立兩個：

```yaml
mcp_servers:
```

NotebookLM 有建立 notebook / 上傳來源等寫入操作，因此建議：

```yaml
supports_parallel_tool_calls: false
```

---

## 16.4 測試 MCP

```powershell
hermes mcp test notebooklm
```

只要：

```text
Connected
```

並能 discover tools 即可。

工具名稱 / 數量可能因版本更新而變。

---

## 16.5 第一次只讀測試

```powershell
cd "$env:USERPROFILE\Documents\DeepResearch"
hermes
```

輸入：

```text
Use the NotebookLM MCP to list my existing notebooks.

Do not create, rename, upload, modify, or delete anything.
Return notebook titles only.
```

如果能列出 notebook：

```text
Hermes → NotebookLM MCP → Google account
```

成功。

[⬆ 回到目錄](#toc)

---

<a id="sec-17"></a>

# 17. 已經裝好 NotebookLM 桌面版 / PWA 怎麼辦

不用移除，也不用重裝。

如果你電腦上已經有：

```text
NotebookLM 的桌面捷徑
Chrome / Edge 安裝的 PWA
獨立視窗版
```

照樣可以使用。

Hermes 並不是去操作你目前看到的那個 NotebookLM 視窗。

架構是：

```text
你平常人工使用
NotebookLM 桌面捷徑 / PWA / Browser
            │
            └──── 同一 Google 帳號

Hermes 自動化
Hermes → notebooklm-mcp-server → 獨立 browser session
            │
            └──── 同一 Google 帳號
```

也就是：

```text
有沒有裝桌面版都可以
```

MCP 登入時仍然會自己建立 / 保存 browser session。

平常要看內容時可以繼續用原本熟悉的 NotebookLM 介面。

[⬆ 回到目錄](#toc)

---

<a id="sec-18"></a>

# 18. 測試本地檔案 → NotebookLM

先建立一個無關緊要的測試檔：

```powershell
Set-Content `
"$env:USERPROFILE\Documents\DeepResearch\papers\notebooklm_test.md" `
"# NotebookLM Test`nThis file was uploaded by Hermes for testing."
```

進 Hermes：

```powershell
cd "$env:USERPROFILE\Documents\DeepResearch"
hermes
```

輸入：

```text
Use the NotebookLM MCP.

Create a notebook named:
Hermes NotebookLM Test

Then upload this local file as one individual source:

%USERPROFILE%/Documents/DeepResearch/papers/notebooklm_test.md

After upload, verify that the notebook and source exist.

Do not delete or modify any other notebook.
```

如果 MCP 不會解析 `%USERPROFILE%`，先在 PowerShell：

```powershell
$env:USERPROFILE
```

例如得到：

```text
C:\Users\student
```

再把 prompt 改成：

```text
C:/Users/student/Documents/DeepResearch/papers/notebooklm_test.md
```

最後到：

https://notebooklm.google.com/

人工確認一次。

[⬆ 回到目錄](#toc)

---

<a id="sec-19"></a>

# 19. 設定「核心文獻自動導入 NotebookLM」

**不要把 broad search 找到的所有候選文獻全部丟 NotebookLM。**

建議：

```text
OpenAlex 40～60 candidates
        ↓
去重
        ↓
abstract screening
        ↓
Scopus / S2 / Exa cross-check
        ↓
8～12 篇核心 deep-read 文獻
        ↓
本地 papers\
        ↓
NotebookLM
```

NotebookLM 建議放：

```text
✓ deep-read papers
✓ final evidence base
✓ 最終實際引用文獻
✓ 使用者指定的重要文獻
```

不要放：

```text
✗ 被排除候選
✗ 重複 DOI
✗ 只有 title 的 metadata
✗ 搜尋結果頁
✗ 無法取得卻假裝存在的 PDF
```

---

## 19.1 在 SKILL.md 加入規則

```markdown
### NotebookLM Literature Archiving

NotebookLM integration is enabled only when the `notebooklm`
MCP server is connected and authenticated.

Do NOT upload the entire broad-discovery candidate pool to NotebookLM.

Upload only:
- papers selected for deep reading;
- papers retained in the final evidence base;
- papers cited in the final report;
- papers explicitly requested by the user.

Before uploading:
1. Deduplicate by DOI, then normalized title.
2. Verify paper metadata.
3. Prefer an actual legally obtained local full-text PDF.
4. Confirm the local file exists.
5. Record the local path in `evidence/literature_manifest.csv`.

For each research project:
- Create or reuse ONE NotebookLM notebook dedicated to that project.
- Use a descriptive notebook name:
  `DeepResearch - <Research Topic>`
- Add each paper as an INDIVIDUAL source.
- Never combine multiple papers into one source solely to save source slots.

Preferred upload order:
1. Local legally obtained full-text PDF
2. Legitimate open-access PDF/web URL
3. Verified abstract/text only when full text is genuinely unavailable,
   and clearly label it as abstract-only.

After successful upload:
- update `notebooklm_uploaded = yes`
  in `evidence/literature_manifest.csv`;
- record the NotebookLM notebook name;
- verify that the source actually exists.

If NotebookLM authentication or ingestion fails:
- preserve local files and evidence records;
- continue the research workflow;
- do not allow NotebookLM failure to block the literature review.

NotebookLM is a knowledge-management destination,
not a substitute for DOI verification or full-text evidence verification.
```

---

## 19.2 NotebookLM 免費方案限制

目前 Google 官方列出的 Free plan 常見限制：

```text
100 notebooks
50 sources / notebook
50 chat queries / day
3 audio generations / day
```

每個 source：

```text
最多 500,000 words
本地 upload 最多 200 MB
```

Google 官方說明：

https://support.google.com/notebooklm/answer/16269187

來源格式：

https://support.google.com/notebooklm/answer/16215270

Deep Research 最常用：

```text
PDF
DOCX
TXT
Markdown
CSV
PPTX
Web URL
ePub
YouTube URL
```

若有完整 PDF：

```text
優先上傳 PDF
```

不要把付費牆 landing page 當成已匯入全文。

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

### NotebookLM Literature Archiving
NotebookLM integration is active only when the `notebooklm`
MCP server is connected and authenticated.

Do NOT upload the broad-discovery candidate pool.

Upload only:
- deep-read papers;
- final evidence-base papers;
- final cited papers;
- papers explicitly requested by the user.

Before upload:
1. Deduplicate by DOI/title.
2. Verify metadata.
3. Prefer legally obtained local full-text PDF.
4. Confirm local file exists.
5. Record the local path in `literature_manifest.csv`.

For each research project:
- Create or reuse one dedicated NotebookLM notebook.
- Suggested name:
  `DeepResearch - <Research Topic>`
- Keep each paper as an individual source.

After successful upload:
- record notebook name;
- set `notebooklm_uploaded = yes`;
- verify the source exists.

NotebookLM failure must NOT block the research workflow.

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
- upload retained deep-read/full-text papers to the project NotebookLM
  only if NotebookLM MCP is connected;
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

推薦架構：

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
 NotebookLM MCP
        │
        ▼
 DeepResearch - <Topic>
        │
        ├─ Paper 1
        ├─ Paper 2
        ├─ Paper 3
        └─ ...
```

其中：

```text
本地 papers\
```

才是主要 archive。

NotebookLM 是：

```text
跨文獻問答
摘要
Audio Overview
研究整理
```

不要把 NotebookLM 當唯一備份。

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

## 28.9 NotebookLM `npx` 找不到

```powershell
node -v
npx -v
hermes doctor
```

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

```powershell
hermes mcp test notebooklm
```

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

- [ ] Node / npx 正常
- [ ] NotebookLM MCP 已 auth
- [ ] `hermes mcp test notebooklm` Connected
- [ ] Hermes 可以 list notebooks
- [ ] 測試本地檔案可上傳
- [ ] broad candidates 不會全部上傳
- [ ] deep-read paper 每篇 individual source
- [ ] manifest 會記錄 notebook / upload status

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

## NotebookLM MCP

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
→ NotebookLM 個別建檔
→ Evidence synthesis
→ 人工判斷
```

這才是整套流程。

[⬆ 回到目錄](#toc)
