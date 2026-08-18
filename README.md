# Deep Research Agent — Windows 零成本安裝教學

> 給第一次接觸 Hermes、API、MCP 的人。
> 目標是從一台乾淨的 Windows 電腦開始，一步一步裝到可以使用 Deep-Research-Agent 搜尋 OpenAlex、Semantic Scholar、Exa、Scopus。
>
> **最後更新：2026-08-17**
>
> 本教學以 **Windows 10 / Windows 11 原生環境**為主，不需要 WSL、不需要 Docker。

---

# 0. 我們最後要裝成什麼？

完成後架構大概是：

```text
Windows 10 / 11
      │
      ▼
Hermes Agent
      │
      ├── OpenRouter 免費 LLM
      │
      ├── Deep Science Writer Skill
      ├── Remi Reviewer Skill
      │
      ├── OpenAlex API
      ├── Semantic Scholar API
      ├── Exa MCP
      └── Scopus MCP
```

可以做到：

```text
研究問題
   ↓
自動建立搜尋策略
   ↓
OpenAlex 大量找文獻
   ↓
Scopus / Semantic Scholar / Exa 補資料
   ↓
文獻去重與篩選
   ↓
全文閱讀
   ↓
Evidence table
   ↓
研究缺口
   ↓
文獻綜整
   ↓
APA 7th Word 報告
```

---

# 1. 費用先說清楚

本教學的目標是：

```text
NT$0 優先
```

但「免費」不代表無限使用。

| 服務                  | 免費方式         | 主要限制              |
| ------------------- | ------------ | ----------------- |
| Hermes Agent        | 開源           | 免費                |
| Deep-Research-Agent | MIT License  | 免費                |
| OpenRouter          | Free models  | 有 request limit   |
| OpenAlex            | Free API key | 每日免費 API 額度       |
| Semantic Scholar    | Free API key | 初始約 1 request/sec |
| Exa MCP             | Free MCP     | 有免費 rate limit    |
| Scopus API          | Academic API | 受 quota / 機構權限影響  |

因此本教學後面會額外設定 **Economy Mode**，避免 Agent 一次把所有免費額度燒光。

---

# 2. 安裝 Hermes Agent

官方文件：

* https://hermes-agent.nousresearch.com/docs/getting-started/installation
* https://hermes-agent.nousresearch.com/docs/user-guide/windows-native

## 2.1 開 PowerShell

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

**不用系統管理員權限。**

---

## 2.2 安裝 Hermes

因為我們打算自己設定免費模型，所以先跳過 Hermes 的預設 Setup。

貼上：

```powershell
& ([scriptblock]::Create((irm https://hermes-agent.nousresearch.com/install.ps1))) -SkipSetup
```

安裝程式會處理 Hermes 所需的 Python、uv、Node.js、Git 等環境。

安裝完成後：

**把 PowerShell 關掉，再重新開一次。**

---

## 2.3 檢查 Hermes

輸入：

```powershell
hermes doctor
```

如果它提示設定需要升級，可以再跑：

```powershell
hermes doctor --fix
```

正常情況應該可以看到：

```text
Python Environment        ✓
Virtual environment       ✓
Git                       ✓
Node.js                   ✓
Playwright Chromium       ✓
```

有些 optional 工具顯示黃色警告沒有關係。

例如：

```text
docker not found
discord.py not installed
telegram not installed
```

目前都不用處理。

---

# 3. 設定免費 LLM：OpenRouter

OpenRouter：

* API Key：https://openrouter.ai/keys
* Free Models：https://openrouter.ai/models?pricing=free
* Free Router：https://openrouter.ai/openrouter/free
* 官方文件：https://openrouter.ai/docs/guides/routing/routers/free-router

## 3.1 建立 OpenRouter API Key

到：

https://openrouter.ai/keys

登入後建立 API key。

名稱可以填：

```text
Hermes
```

或：

```text
Hermes-MyLaptop
```

複製產生的 key。

通常長得像：

```text
sk-or-v1-xxxxxxxxxxxxxxxxxxxxxxxx
```

⚠️ **API key 不要貼到 Discord、LINE、GitHub、README 或聊天機器人裡。**

---

## 3.2 Hermes 選 OpenRouter

PowerShell：

```powershell
hermes model
```

找到：

```text
OpenRouter
```

選它。

Hermes 會問：

```text
OPENROUTER_API_KEY:
```

貼上剛才的 API key。

---

## 3.3 選免費模型

只選有：

```text
:free
```

的模型。

例如我們實際測試過：

```text
nvidia/nemotron-3-super-120b-a12b:free
```

如果未來這個模型不在免費列表，就改選其他：

```text
xxxxx:free
```

或選：

```text
Enter custom model name
```

輸入：

```text
openrouter/free
```

### 注意

免費模型有時候非常塞。

例如：

```text
nvidia/nemotron-3-ultra-550b-a55b:free
```

可能等超過一兩分鐘都沒有輸出。

如果：

```text
60～120 秒完全沒有任何 token
```

不用硬等，換一個比較小的免費模型。

---

## 3.4 測試 Hermes

執行：

```powershell
hermes
```

輸入：

```text
Reply exactly: Hermes is working.
```

如果得到：

```text
Hermes is working.
```

第一階段完成。

退出可以輸入：

```text
/exit
```

或：

```text
Ctrl+C
```

---

# 4. 安裝 Deep-Research-Agent

GitHub：

https://github.com/CYC2002tommy/Deep-Research-Agent

不要使用：

```text
hermes skills install ...
```

我們直接照專案作者 README 的方式 clone 整個 repo。

PowerShell：

```powershell
cd "$env:LOCALAPPDATA\hermes\skills"
```

下載：

```powershell
git clone https://github.com/CYC2002tommy/Deep-Research-Agent.git
```

完成後檢查：

```powershell
Get-ChildItem "$env:LOCALAPPDATA\hermes\skills\Deep-Research-Agent\skills"
```

應該有：

```text
deep-science-writer
remi
```

接著：

```powershell
hermes skills list
```

應該看到：

```text
deep-science-writer   local   enabled
remi                  local   enabled
```

看到這兩個就表示 Skill 安裝成功。

---

# 5. 安裝 Python dependencies

Deep-Research-Agent 還需要：

```text
python-docx
PyMuPDF
requests
matplotlib
seaborn
pandas
duckduckgo_search
```

Hermes 的 Python 環境不一定有 `pip`。

所以不要使用：

```powershell
python -m pip
```

如果看到：

```text
No module named pip
```

不是壞掉。

直接使用 Hermes 已安裝的 `uv`。

貼：

```powershell
uv pip install --python "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\python.exe" -r "$env:LOCALAPPDATA\hermes\skills\Deep-Research-Agent\requirements.txt"
```

完成後測試：

```powershell
& "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\python.exe" -c "import docx, fitz, requests, matplotlib, seaborn, pandas, duckduckgo_search; print('Deep Research Python deps OK')"
```

如果看到：

```text
Deep Research Python deps OK
```

完成。

---

# 6. 設定 API Key 檔案

Hermes 的 key 放在：

```text
%LOCALAPPDATA%\hermes\.env
```

開啟：

```powershell
notepad "$env:LOCALAPPDATA\hermes\.env"
```

之後我們會慢慢加入：

```text
OPENALEX_API_KEY=
SEMANTIC_SCHOLAR_API_KEY=
SCOPUS_API_KEY=
```

⚠️ `.env` 是密碼檔。

**永遠不要上傳 GitHub。**

---

# 7. OpenAlex

OpenAlex：

* 官網：https://openalex.org/
* API Key：https://openalex.org/settings/api
* API 文件：https://developers.openalex.org/

OpenAlex 建議當作**大量文獻 discovery 的主力**。

---

## 7.1 取得 API key

登入：

https://openalex.org/settings/api

複製 API key。

開：

```powershell
notepad "$env:LOCALAPPDATA\hermes\.env"
```

加入：

```text
OPENALEX_API_KEY=你的API_KEY
```

例如：

```text
OPENALEX_API_KEY=xxxxxxxxxxxxxxxx
```

不要加引號。

---

## 7.2 測試 OpenAlex 額度

PowerShell：

```powershell
$key = (Get-Content "$env:LOCALAPPDATA\hermes\.env" | Where-Object { $_ -like 'OPENALEX_API_KEY=*' }) -replace '^OPENALEX_API_KEY=',''
```

再：

```powershell
Invoke-RestMethod "https://api.openalex.org/rate-limit?api_key=$key"
```

正常會看到：

```text
daily_budget_usd
daily_used_usd
daily_remaining_usd
```

---

## 7.3 真正搜尋論文

例如：

```powershell
Invoke-RestMethod "https://api.openalex.org/works?search=stroboscopic%20visual%20training&per_page=3&api_key=$key"
```

如果看到：

```text
meta
results
```

就表示成功。

---

# 8. Semantic Scholar

官方：

https://www.semanticscholar.org/product/api

API key **不是登入帳號後直接產生**。

要按：

```text
Request an API Key
```

填申請表。

---

## 8.1 先測匿名 API

在申請 API key 前，可以先跑：

```powershell
Invoke-RestMethod "https://api.semanticscholar.org/graph/v1/paper/search?query=stroboscopic%20visual%20training&limit=3&fields=title,year,authors,abstract,citationCount,url,openAccessPdf"
```

如果成功，就可以在申請表勾：

```text
I have already successfully made unauthenticated requests
```

---

## 8.2 API Key 申請表範例

如果它問：

### How do you plan to use Semantic Scholar API in your project?

可以貼：

```text
I plan to use the Semantic Scholar API as part of a personal, non-commercial academic research workflow for literature discovery and evidence synthesis, primarily in sports science and related research areas. The API will be used to search for relevant scholarly papers and retrieve metadata such as titles, authors, publication years, abstracts, citation counts, references, citations, DOIs, URLs, and open-access PDF information. The project is used by a single researcher. Requests will be structured efficiently using search and batch endpoints where appropriate, with local caching to avoid duplicate requests. I will respect the API rate limit and implement exponential backoff for rate-limit or transient errors.
```

### Which endpoints do you plan to use?

```text
/graph/v1/paper/search
/graph/v1/paper/{paper_id}
/graph/v1/paper/batch
/graph/v1/paper/{paper_id}/citations
/graph/v1/paper/{paper_id}/references
```

### Requests per day

個人研究可以先填：

```text
200
```

---

## 8.3 收到 key 後

開：

```powershell
notepad "$env:LOCALAPPDATA\hermes\.env"
```

加入：

```text
SEMANTIC_SCHOLAR_API_KEY=你的KEY
```

---

## 8.4 測試 authenticated request

```powershell
$s2key = (Get-Content "$env:LOCALAPPDATA\hermes\.env" | Where-Object { $_ -like 'SEMANTIC_SCHOLAR_API_KEY=*' }) -replace '^SEMANTIC_SCHOLAR_API_KEY=',''
```

```powershell
$headers = @{ "x-api-key" = $s2key }
```

測：

```powershell
Invoke-RestMethod `
  -Uri "https://api.semanticscholar.org/graph/v1/paper/DOI:10.3758/s13414-012-0344-6?fields=title,year,citationCount" `
  -Headers $headers
```

有 paperId 和 title 就成功。

---

# 9. Semantic Scholar 如何避免 429

這是最重要的一段。

Semantic Scholar 新 API key 初始大約只有：

```text
1 request / second
```

而且是：

```text
所有 endpoint 共用
```

所以不要：

```text
Agent A → 1 req/s
Agent B → 1 req/s
Agent C → 1 req/s
```

這樣伺服器看到的是：

```text
3 req/s
```

然後：

```text
429 Too Many Requests
```

---

## 正確策略

### 1. OpenAlex 做大量搜尋

```text
OpenAlex
↓
先找 40～100 篇
```

### 2. 先去重

依：

```text
DOI
PMID
OpenAlex ID
normalized title
```

去重。

### 3. Semantic Scholar 只查剩下重要的 10～30 篇

### 4. 能 batch 就 batch

優先：

```text
/paper/batch
```

而不是一篇一 request。

### 5. Request 間隔至少

```text
1.25 秒
```

### 6. 遇到 429

不要狂按重新送出。

建議：

```text
第一次 429 → 等 5 秒
第二次     → 10 秒
第三次     → 20 秒
第四次     → 40 秒
第五次     → 80 秒
```

也就是：

```text
exponential backoff
```

如果你手動測到 429：

**放著幾分鐘再試。**

不要一直測。

---

# 10. Exa MCP

官方：

* https://exa.ai/mcp
* https://exa.ai/docs/reference/exa-mcp

Exa MCP 可以先不用 API key。

---

## 10.1 開 Hermes config

```powershell
notepad "$env:LOCALAPPDATA\hermes\config.yaml"
```

找到：

```yaml
mcp_servers:
```

如果沒有，就自己加。

加入：

```yaml
mcp_servers:
  exa:
    url: "https://mcp.exa.ai/mcp?tools=web_search_exa,web_fetch_exa,web_search_advanced_exa"
    timeout: 180
    connect_timeout: 60
    supports_parallel_tool_calls: false
```

⚠️ YAML 非常在意縮排。

`exa:` 前面是兩格空白。

---

## 10.2 測試 Exa

```powershell
hermes mcp test exa
```

正常應該看到：

```text
Connected
Tools discovered: 3
```

以及：

```text
web_search_exa
web_search_advanced_exa
web_fetch_exa
```

---

## 10.3 真正測一次

```powershell
hermes
```

輸入：

```text
Use the Exa MCP tool web_search_exa to find 3 scholarly sources about stroboscopic visual training. Return only title, year, DOI or URL, and source.
```

如果 Hermes 有出現：

```text
mcp__exa__web_search_exa
```

就成功。

如果 Exa 出現：

```text
429
```

代表免費 MCP 暫時撞 rate limit。

之後才考慮申請自己的 Exa API key。

---

# 11. Scopus / Elsevier API

Elsevier Developer Portal：

https://dev.elsevier.com/

Scopus MCP：

https://github.com/qwe4559999/scopus-mcp

---

## 11.1 申請 Elsevier API Key

使用學校 / 教育機構帳號比較合適。

到：

https://dev.elsevier.com/

申請 API key。

Application Name 可以填：

```text
Deep Research Agent - Academic Literature Review
```

用途：

```text
Personal non-commercial academic research project for literature discovery, metadata retrieval, citation analysis, and evidence synthesis.
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

# 12. 設定 Scopus MCP

開：

```powershell
notepad "$env:LOCALAPPDATA\hermes\config.yaml"
```

最後建議會長這樣：

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

## 為什麼 Scopus 要寫 `mcp<2`？

截至 2026-08，目前 `scopus-mcp` 有一個 MCP SDK 2.x 相容性問題。

相關 issue / PR：

https://github.com/qwe4559999/scopus-mcp/pull/12

如果直接：

```yaml
args: ["scopus-mcp"]
```

可能得到：

```text
Connection failed: Connection closed
```

所以目前暫時固定：

```text
mcp>=1.0,<2
```

未來上游修好後可能不再需要這個 workaround。

---

## 12.1 測試 Scopus MCP

```powershell
hermes mcp test scopus
```

成功時應該看到：

```text
Connected
Tools discovered: 5
```

例如：

```text
search_scopus
get_abstract_details
get_author_profile
get_citing_papers
get_quota_status
```

如果看到：

```text
Auth: none
```

不一定有問題。

因為這是：

```text
stdio MCP
```

Scopus key 是透過 environment variable 傳給 subprocess。

---

## 12.2 測 Scopus 真正搜尋

啟動：

```powershell
hermes
```

輸入：

```text
Use the Scopus MCP tool search_scopus to search for:
TITLE-ABS-KEY("stroboscopic visual training")

Return only the first 5 results with title, year, authors, Scopus ID, DOI, and citation count.
```

如果有：

```text
mcp__scopus__search_scopus
```

而且回文獻，就成功。

---

## 12.3 看 Scopus quota

在同一個 Hermes 裡：

```text
Use the Scopus MCP get_quota_status tool and show me the current quota limit, remaining quota, and reset time.
```

不同 Scopus API 的 quota 不完全相同。

所以大量研究前可以先查一次。

---

# 13. Scopus 校外連線注意

Elsevier 的：

```text
API key
```

和：

```text
institutional entitlement
```

不是完全相同的東西。

如果：

```text
key 有效
```

但某些 Scopus 功能：

```text
Unauthorized
Insufficient privileges
```

可能不是程式壞掉。

Scopus 的部分訂閱權限會依：

```text
學校 / 機構 IP
```

判定。

所以：

```text
校內網路
```

可能比：

```text
家裡網路
```

得到更多 subscriber entitlement。

官方說明：

https://dev.elsevier.com/tecdoc_api_authentication.html

---

# 14. 建立研究工作區

不要在：

```text
AppData\Local\hermes\hermes-agent
```

或：

```text
venv
```

裡面開始研究。

建立自己的資料夾：

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\Documents\DeepResearch" | Out-Null
```

再建立：

```powershell
New-Item -ItemType Directory -Force `
"$env:USERPROFILE\Documents\DeepResearch\cache", `
"$env:USERPROFILE\Documents\DeepResearch\evidence", `
"$env:USERPROFILE\Documents\DeepResearch\papers", `
"$env:USERPROFILE\Documents\DeepResearch\assets", `
"$env:USERPROFILE\Documents\DeepResearch\reports" | Out-Null
```

以後：

```powershell
cd "$env:USERPROFILE\Documents\DeepResearch"
```

再：

```powershell
hermes
```

---

## 為什麼？

如果從 Hermes 原始程式目錄啟動，有可能看到：

```text
AGENTS.md TRUNCATED
80000 chars exceeds limit...
```

代表 Hermes 把自己的開發文件當成你的 project context。

這會：

```text
浪費 context window
```

所以研究時固定從：

```text
Documents\DeepResearch
```

啟動。

---

# 15. 免費額度保護：Economy Mode

原始 Deep-Research-Agent 比較偏完整大型研究：

```text
100+ candidates
20～30+ full texts
多 Agent
多 API
```

免費模型和免費 API 很容易吃不消。

建議第一次使用先改成 Economy Mode。

---

## 15.1 備份 Skill

```powershell
$skill = "$env:LOCALAPPDATA\hermes\skills\Deep-Research-Agent\skills\deep-science-writer\SKILL.md"
```

```powershell
Copy-Item $skill "$skill.original.bak"
```

開：

```powershell
notepad $skill
```

---

## 15.2 取得自己的 Windows 使用者路徑

輸入：

```powershell
$env:USERPROFILE
```

例如：

```text
C:\Users\john
```

下面範例的：

```text
C:/Users/YOUR_USERNAME/
```

請改成自己的路徑。

---

## 15.3 在 Skill 前面加入

找到：

```markdown
# Deep Science Writer (End-to-End Pipeline)
```

在下面加入：

```markdown
## LOCAL RUNTIME POLICY — WINDOWS / ECONOMY MODE

This local policy overrides conflicting rules later in this skill.

### Environment
- Platform: Windows.
- Research workspace: `C:/Users/YOUR_USERNAME/Documents/DeepResearch/`
- Store project outputs, caches, evidence tables, papers, and reports under this workspace.
- Never require a `D:/` drive.
- Default final document:
  `C:/Users/YOUR_USERNAME/Documents/DeepResearch/reports/Research_Report.docx`

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
- Prefer `per_page=100`.
- Cache results locally.

### Semantic Scholar
- Semantic Scholar is supplemental, not the primary high-volume discovery system.
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
5. Never attempt to bypass rate limits using multiple accounts, API keys, or IP addresses.

### Scopus
- Use Scopus primarily for detailed metadata, indexing verification, citation information, and cross-checking.
- Avoid repeating broad searches already covered adequately by OpenAlex.
- Reuse cached MCP responses.
- Check API quota during large jobs.

### Exa
- Use Exa for supplementary scholarly-web discovery, open-access discovery, institutional repositories, and missing URLs.
- Do not repeatedly search information already available from OpenAlex, Scopus, or Semantic Scholar.

### Parallelism
- Maximum default LLM subagent concurrency in Economy Mode: 2.
- Do not allow parallel Semantic Scholar requests.
- Prefer scripts and batch API calls over spawning many LLM workers.
- Full multi-agent research is allowed only after explicit user approval.

### Full Text
Use this order:
1. Legitimate open-access publisher copy.
2. Institutional repository.
3. Unpaywall / OpenAlex open-access location.
4. Legitimate institutional access.
5. Ask the user to obtain or provide the paper.

Do not bypass paywalls, authentication controls, robots restrictions, or other access controls.

If full text is unavailable, record it as unavailable.

Never claim to have full-text verified a result when only an abstract was available.

### Optional Integrations
The following MUST NOT block the basic research workflow:
- Zotero
- NotebookLM
- Obsidian
- visualization tools

Skip them when they are not configured.

### Evidence Integrity
- A valid DOI proves a publication exists; it does not prove that a claim is supported.
- Distinguish metadata verification, abstract verification, and full-text verification.
- Never fabricate unavailable methods, results, sample sizes, effect sizes, or conclusions.
```

存檔。

---

# 16. 確認 Skill 還活著

```powershell
hermes skills list
```

要看到：

```text
deep-science-writer   local   enabled
remi                  local   enabled
```

---

# 17. 第一次測試：只跑 Phase 0

進工作區：

```powershell
cd "$env:USERPROFILE\Documents\DeepResearch"
```

啟動：

```powershell
hermes
```

貼：

```text
Please use the deep-science-writer skill in ECONOMY MODE to research the effects of stroboscopic visual training on sports performance.

Focus on:
- trained or competitive athletes
- perceptual and cognitive outcomes
- reaction and visual-attention outcomes
- motor or sport-specific performance
- evidence of transfer to actual sport performance
- methodological limitations and research gaps

Use OpenAlex as the primary broad-discovery database, with Scopus, Exa, and Semantic Scholar as complementary sources according to the local Economy Mode policy.

For this turn, execute Phase 0 ONLY.

1. Clarify the research scope if necessary.
2. Propose search concepts and keyword combinations.
3. Define inclusion and exclusion criteria.
4. Explain how each database will be used.
5. Propose the planned structure of the final review.
6. Estimate the number of candidate papers and full-text papers to be examined.

STOP after presenting the research blueprint.

Do NOT begin Phase 0.5.
Do NOT launch subagents.
Do NOT perform large-scale literature retrieval until I explicitly approve.
```

---

## 正常結果

它應該先給你：

```text
Research scope
Search terms
Inclusion criteria
Exclusion criteria
Database strategy
Review structure
Expected paper numbers
```

而不是立刻狂打 API。

Economy Mode 大概應該規劃：

```text
40～60 initial candidates
8～12 deep-read papers
```

最後要停下來問：

```text
Do you approve this blueprint?
```

這表示成功。

---

# 18. 正式放行 Phase 0.5

如果 Blueprint 沒問題，再回：

```text
I approve this research blueprint.

Proceed to Phase 0.5 in ECONOMY MODE.

Follow the local runtime policy strictly:
- use OpenAlex as the primary broad-discovery source;
- respect all Semantic Scholar rate limits and caching rules;
- avoid duplicate API requests;
- do not bypass paywalls or access controls;
- store all outputs under my Documents/DeepResearch workspace;
- stop after completing the Phase 0.5 Selection Rationale, Research Gap, and Topic Enhancement report;
- wait for my approval before proceeding further.
```

建議第一次：

```text
一個 Phase 一個 Phase 放行
```

不要直接讓它一路跑到底。

---

# 19. 常見錯誤

## 問題 1

```text
No module named pip
```

### 解法

不要補 pip。

使用：

```powershell
uv pip install ...
```

Hermes 本身就是由 uv 管理 Python。

---

# 問題 2

```text
Could not fetch CYC2002tommy/Deep-Research-Agent/...
```

### 解法

不要用：

```text
hermes skills install
```

直接：

```powershell
cd "$env:LOCALAPPDATA\hermes\skills"
git clone https://github.com/CYC2002tommy/Deep-Research-Agent.git
```

---

# 問題 3

Semantic Scholar：

```text
429 Too Many Requests
```

### 解法

停。

不要馬上 retry。

等：

```text
5 → 10 → 20 → 40 → 80 秒
```

而且：

```text
OpenAlex 主搜
Semantic Scholar 補資料
```

不要反過來。

---

# 問題 4

Scopus：

```text
Connection failed
Connection closed
```

先確認使用：

```yaml
args:
  - "--with"
  - "mcp>=1.0,<2"
  - "scopus-mcp"
```

如果還不行，直接手動測：

```powershell
uvx --with "mcp>=1.0,<2" scopus-mcp
```

這樣可以看到真正的 Python error。

---

# 問題 5

免費模型：

```text
waiting 150s with no output
```

不是你的電腦太爛。

免費 provider 可能正在塞車。

換其他：

```text
:free
```

模型。

---

# 問題 6

```text
AGENTS.md TRUNCATED
```

表示你可能從錯的資料夾啟動 Hermes。

先：

```powershell
cd "$env:USERPROFILE\Documents\DeepResearch"
```

再：

```powershell
hermes
```

---

# 問題 7

Scopus API key 有效，但功能被拒絕

可能是：

```text
institutional entitlement
```

問題。

尤其：

```text
校內網路
```

和：

```text
家裡網路
```

可能有差。

Elsevier 官方：

https://dev.elsevier.com/tecdoc_api_authentication.html

---

# 20. API Key 安全

API key 等同密碼。

不要：

```text
❌ 貼 Discord
❌ 貼 LINE 群
❌ 截圖公開
❌ commit 到 GitHub
❌ 寫進 README
```

集中放：

```text
%LOCALAPPDATA%\hermes\.env
```

Git repo 如果自己有 `.env`，一定在 `.gitignore` 加：

```gitignore
.env
*.env
```

---

# 21. 最終健康檢查

## Hermes

```powershell
hermes doctor
```

## Skills

```powershell
hermes skills list
```

要有：

```text
deep-science-writer
remi
```

## Exa

```powershell
hermes mcp test exa
```

要：

```text
Connected
```

## Scopus

```powershell
hermes mcp test scopus
```

要：

```text
Connected
Tools discovered: 5
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

---

# 22. 完成檢查表

* [ ] Hermes Agent 已安裝
* [ ] `hermes doctor` 正常
* [ ] OpenRouter API key 已設定
* [ ] 免費模型可以回答
* [ ] Deep-Research-Agent 已 clone
* [ ] `deep-science-writer` enabled
* [ ] `remi` enabled
* [ ] Python dependencies OK
* [ ] OpenAlex API 測試成功
* [ ] Semantic Scholar API 測試成功
* [ ] Exa MCP Connected
* [ ] Scopus MCP Connected
* [ ] Scopus 真實搜尋成功
* [ ] 建立 `Documents\DeepResearch`
* [ ] 加入 Economy Mode
* [ ] Phase 0 測試成功
* [ ] Agent 能停下等待人工批准

全部打勾：

```text
你可以開始正式玩 Deep Research 了。
```

---

# 23. 官方 / 專案文件

## Hermes Agent

https://hermes-agent.nousresearch.com/

https://hermes-agent.nousresearch.com/docs/getting-started/installation

https://hermes-agent.nousresearch.com/docs/user-guide/windows-native

https://hermes-agent.nousresearch.com/docs/user-guide/features/mcp

## Deep-Research-Agent

https://github.com/CYC2002tommy/Deep-Research-Agent

## OpenRouter

https://openrouter.ai/

https://openrouter.ai/keys

https://openrouter.ai/models?pricing=free

https://openrouter.ai/docs/guides/routing/routers/free-router

## OpenAlex

https://openalex.org/

https://openalex.org/settings/api

https://developers.openalex.org/

## Semantic Scholar

https://www.semanticscholar.org/

https://www.semanticscholar.org/product/api

https://www.semanticscholar.org/product/api/tutorial

## Exa

https://exa.ai/mcp

https://exa.ai/docs/reference/exa-mcp

## Elsevier / Scopus

https://dev.elsevier.com/

https://dev.elsevier.com/api_key_settings.html

https://dev.elsevier.com/tecdoc_api_authentication.html

## Scopus MCP

https://github.com/qwe4559999/scopus-mcp

目前 MCP 2.x 相容問題：

https://github.com/qwe4559999/scopus-mcp/pull/


NotebookLM + 本地文獻儲存

> 建議把本章插在原 README 的「建立研究工作區」之後、「Economy Mode」之前。
> 
> 本章以 Windows 10/11 + Hermes Agent + Deep-Research-Agent 為例。
> 
> NotebookLM MCP 為第三方工具，不是 Google 官方 NotebookLM API。請自行評估帳號安全與使用風險。

────────

15. 設定本地文獻儲存

Deep Research 不建議只把搜尋結果留在聊天紀錄裡。建議把每次研究產生的 metadata、DOI/URL、篩選結果、Evidence table、合法取得的全文 PDF、最終報告與 NotebookLM 匯入紀錄全部保存在固定工作區。

15.1 建立工作區

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
Documents\
└─ DeepResearch\
   ├─ cache\
   ├─ evidence\
   ├─ papers\
   ├─ assets\
   ├─ reports\
   └─ notebooklm\
```

用途：

```text
cache\      → API 回應、暫存資料
evidence\   → literature_manifest.csv、evidence tables、screening results、DOI/metadata verification
papers\     → 合法取得的 PDF 全文
assets\     → 圖表、圖片、流程圖
reports\    → Phase 0 / Phase 0.5 / final report / DOCX
notebooklm\ → NotebookLM 上傳紀錄、notebook 名稱、來源清單
```

15.2 建議的 PDF 命名

不要讓 Agent 儲存成 document.pdf、download(3).pdf 或 fulltext.pdf。

建議格式：

```text
YEAR_FirstAuthor_ShortTitle.pdf
```

例如：

```text
2014_Baker_Digital_24h_Dietary_Recall_Athletes.pdf
```

DOI 請記錄在 manifest，不要把完整 DOI 塞進 Windows 檔名，避免 / 等非法字元。

15.3 建立文獻 Manifest

建議至少維護：

```text
C:\Users\<你的帳號>\Documents\DeepResearch\evidence\literature_manifest.csv
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

verification_level 建議只使用：

```text
metadata
abstract
full_text
```

不要把「找到 DOI」等同於「已讀全文」。

────────

15.4 關於原 Repo 的 Unpaywall 範例 Script

目前 Deep-Research-Agent 公開版本中的：

```text
skills/deep-science-writer/scripts/node/fetch_unpaywall_oa.js
```

比較像作者自己的示範腳本，不建議直接當成通用下載器。

目前版本內有硬編碼：

```text
DOI 清單
作者自己的 Unpaywall email
輸出檔名
```

因此新使用者不要直接期待它會自動下載自己搜尋到的所有論文。

本 README 的做法是：

```text
Agent 搜尋與篩選
↓
合法 OA / institutional access
↓
把實際取得的 PDF 存到 papers\
↓
更新 literature_manifest.csv
↓
再選擇性送進 NotebookLM
```

如果未來要做全自動 OA downloader，建議另外寫可讀取 manifest / DOI 清單的通用腳本，不要修改或沿用硬編碼範例。

────────

16. 修改 Deep Science Writer：強制本地保存

開啟：

```powershell
$skill = "$env:LOCALAPPDATA\hermes\skills\Deep-Research-Agent\skills\deep-science-writer\SKILL.md"
notepad $skill
```

在 LOCAL RUNTIME POLICY — WINDOWS / ECONOMY MODE 區塊中追加：

```markdown
### Local Literature Storage

- The research workspace is:
  `C:/Users/YOUR_USERNAME/Documents/DeepResearch/`

- Store literature metadata and screening records under:
  `C:/Users/YOUR_USERNAME/Documents/DeepResearch/evidence/`

- Store legally obtained full-text papers under:
  `C:/Users/YOUR_USERNAME/Documents/DeepResearch/papers/`

- Store generated research reports under:
  `C:/Users/YOUR_USERNAME/Documents/DeepResearch/reports/`

- Maintain a literature manifest whenever practical:
  `C:/Users/YOUR_USERNAME/Documents/DeepResearch/evidence/literature_manifest.csv`

- For every screened or retained paper, record at minimum:
  title, authors, year, journal, DOI, source database,
  screening decision, verification level, OA URL,
  local PDF path, and NotebookLM upload status.

- Verification levels MUST be explicitly distinguished:
  metadata / abstract / full_text.

- Never mark a paper as full-text verified unless the actual full text
  was successfully obtained and read.

- Save each legally obtained paper as an individual PDF.
  Do not merge multiple papers into one PDF.

- Recommended filename format:
  `YEAR_FirstAuthor_ShortTitle.pdf`

- Deduplicate papers by DOI first, then by normalized title.

- If a full text cannot legally be obtained, keep the metadata and DOI/URL
  in the manifest and mark the PDF as unavailable.
  Do not fabricate a local file.
```

把 YOUR_USERNAME 換成自己的 Windows 使用者名稱。

查詢：

```powershell
$env:USERNAME
$env:USERPROFILE
```

────────

17. NotebookLM MCP：讓 Hermes 操作 NotebookLM

Deep-Research-Agent 原始設計的 Phase 7 會把研究文獻放進 NotebookLM。

這裡使用的是第三方 MCP：

```text
notebooklm-mcp-server
```

專案：

https://github.com/moodRobotics/notebooklm-mcp-server

Deep-Research-Agent：

https://github.com/CYC2002tommy/Deep-Research-Agent

17.1 確認 Node.js / npx

```powershell
node -v
npx -v
```

如果沒有版本號：

```powershell
hermes doctor
```

先確認 Node.js。

17.2 第一次登入 NotebookLM

```powershell
npx -y notebooklm-mcp-server auth
```

第一次可能需要下載套件。接著瀏覽器會開啟：

```text
登入 Google 帳號
↓
進入 NotebookLM
↓
確認看得到 notebooks
↓
完成後關閉瀏覽器
```

若之後登入失效：

```powershell
npx -y notebooklm-mcp-server refresh_auth
```

17.3 加入 Hermes MCP

開：

```powershell
notepad "$env:LOCALAPPDATA\hermes\config.yaml"
```

如果前面已經有：

```yaml
mcp_servers:
```

不要再建立第二個 mcp_servers:。

把 notebooklm: 加在 Exa / Scopus 同一層：

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

NotebookLM 可能會建立 notebook、加入來源，因此不建議 parallel write。

17.4 測試 NotebookLM MCP

```powershell
hermes mcp test notebooklm
```

正常應該看到：

```text
Connected
Tools discovered: ...
```

工具數量可能隨版本變動，不要用固定數字判定。

常見功能包括：

```text
notebook_list
notebook_create
notebook_add_local_file
notebook_add_url
notebook_add_text
notebook_query
```

17.5 第一次安全測試

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

能列出 notebook，代表：

```text
Hermes → NotebookLM MCP → Google Account
```

整條鏈成功。

────────

18. 測試「本地檔案 → NotebookLM」

先建立測試檔：

```powershell
Set-Content `
"$env:USERPROFILE\Documents\DeepResearch\papers\notebooklm_test.md" `
"# NotebookLM Test`nThis file was uploaded by Hermes for testing."
```

進 Hermes 後輸入：

```text
Use the NotebookLM MCP.

Create a notebook named:
Hermes NotebookLM Test

Then upload this local file as one individual source:

C:/Users/YOUR_USERNAME/Documents/DeepResearch/papers/notebooklm_test.md

After upload, verify that the notebook and source exist.

Do not delete or modify any other notebook.
```

NotebookLM：

https://notebooklm.google.com/

────────

19. 搜尋到的文獻怎麼導入 NotebookLM？

不建議把 OpenAlex 找到的 40～60 篇候選全部塞進 NotebookLM。

建議流程：

```text
OpenAlex
↓
40～60 candidate papers
↓
去重 + abstract screening
↓
Scopus / Semantic Scholar cross-check
↓
8～12 篇核心全文
↓
本地 papers\
↓
NotebookLM
```

NotebookLM 建議放：

• 已進入 deep reading 的文獻
• 最終 evidence base
• 最終有引用的文獻
• 使用者特別指定的重要文獻

不要放：

• 已排除候選文獻
• 搜尋結果頁
• 只有 title 沒內容的 metadata
• 重複 DOI
• 無法合法取得的假 PDF

────────

20. 在 SKILL.md 加入 NotebookLM 自動匯入規則

在 LOCAL RUNTIME POLICY 追加：

```markdown
### NotebookLM Literature Archiving

NotebookLM integration is enabled only when the `notebooklm` MCP server
is connected and authenticated.

Do NOT upload the entire broad-discovery candidate pool to NotebookLM.

Upload only:
- papers selected for deep reading;
- papers retained in the final evidence base;
- papers cited in the final report;
- papers explicitly requested by the user.

Before uploading:
1. Deduplicate by DOI, then normalized title.
2. Verify the paper metadata.
3. Prefer an actual legally obtained local full-text PDF.
4. Confirm the local file exists.
5. Record the local path in `evidence/literature_manifest.csv`.

For each research project:
- Create or reuse ONE NotebookLM notebook dedicated to that project.
- Use a descriptive notebook name such as:
  `DeepResearch - <Research Topic>`
- Add each paper as an INDIVIDUAL source.
- Never combine multiple papers into one source solely to save source slots.

Preferred upload order:
1. Local full-text PDF → `notebook_add_local_file`
2. Legitimate open-access PDF/web URL → `notebook_add_url`
3. Verified text/abstract only when full text is genuinely unavailable
   and the source is clearly labeled as abstract-only.

After successful upload:
- update `notebooklm_uploaded = yes`
  in `evidence/literature_manifest.csv`;
- record the NotebookLM notebook name;
- never claim upload success without verifying that the source exists.

If NotebookLM authentication fails:
- stop NotebookLM ingestion;
- preserve all local files and evidence records;
- continue the research workflow normally;
- do not block the literature review.

NotebookLM is a knowledge-management destination, not a substitute
for DOI verification or full-text evidence verification.
```

────────

21. 完整保存流程

```text
OpenAlex
   ↓
Broad discovery
   ↓
Dedup + screening
   ↓
Scopus / Semantic Scholar / Exa
   ↓
evidence/literature_manifest.csv
   ↓
Selected deep reads
   ├──────────────→ papers/*.pdf
   ├──────────────→ reports/*.md
   └──────────────→ NotebookLM MCP
                         ↓
               DeepResearch - <Topic>
                         ├─ Paper 1
                         ├─ Paper 2
                         └─ ...
```

本地資料夾才是主要 archive。

NotebookLM 用於：

```text
分析 / 問答 / 摘要 / Audio Overview / 跨文獻查詢
```

不要把 NotebookLM 當成唯一的備份位置。

────────

22. NotebookLM 免費版限制

限制可能隨 Google 政策更新。目前免費版常見限制：

```text
100 notebooks
50 sources / notebook
50 chat queries / day
3 audio generations / day
```

每個 source：

```text
最多 500,000 words
本地檔案最多 200 MB
```

因此 Economy Mode 的 8～12 deep-read papers 很適合放進單一 notebook。

官方說明：

https://support.google.com/notebooklm/answer/16215270?hl=zh-Hant

https://support.google.com/notebooklm/answer/16269187

────────

23. NotebookLM 支援來源

目前支援包含：

```text
PDF
DOCX
TXT
Markdown
CSV
PowerPoint
Google Docs
Google Slides
Google Sheets
Web URLs
ePub
YouTube URLs
部分音訊與圖片
```

Deep Research 最常用：

```text
PDF
Markdown
Web URL
```

若有完整 PDF，優先 PDF。

Google 官方說明指出，paywalled webpages 不支援直接作為網頁來源，因此不要把出版社付費牆頁面當成「已匯入全文」。

────────

24. NotebookLM MCP 常見錯誤

npx 找不到

```powershell
node -v
npx -v
hermes doctor
```

MCP Connection closed

```powershell
npx -y notebooklm-mcp-server start
```

直接看真正錯誤。

登入失效

```powershell
npx -y notebooklm-mcp-server refresh_auth
```

本地 PDF 路徑錯誤

```powershell
Test-Path "C:\Users\YOUR_USERNAME\Documents\DeepResearch\papers\paper.pdf"
```

False 代表路徑錯。

Source 無法匯入

常見原因：

```text
檔案 > 200MB
內容 > 500,000 words
PDF 有 copy protection
來源數量達上限
```

有 DOI，但沒有 PDF

在 manifest 記：

```text
local_pdf = unavailable
verification_level = metadata / abstract
notebooklm_uploaded = no
```

不要產生假 PDF。

────────

25. 正式研究 Prompt 範例

```text
For all literature retrieved during this research:

- Keep the broad candidate pool in the evidence manifest only.

- Save legally available full-text PDFs selected for deep reading under:
  C:/Users/YOUR_USERNAME/Documents/DeepResearch/papers/

- Deduplicate by DOI before downloading or uploading.

- After full-text verification, create or reuse one NotebookLM notebook
  for this research project.

- Upload each retained deep-read/full-text paper as an individual
  NotebookLM source.

- Do not upload excluded candidates.

- Do not upload a paywalled landing page and label it as full text.

- Record all local paths and NotebookLM upload status in:
  C:/Users/YOUR_USERNAME/Documents/DeepResearch/evidence/literature_manifest.csv

- NotebookLM ingestion must never block the research pipeline.
  If NotebookLM fails, keep the local archive and continue.
```

────────

26. 安全與學術注意事項

notebooklm-mcp-server 是第三方 MCP，不是 Google 官方 NotebookLM API。

它會透過 browser session 存取登入的 Google / NotebookLM 帳號。

測試階段建議不要使用高權限的主要 Google Workspace 管理員帳號；個人研究可考慮獨立研究用 Google 帳號。

另外：

```text
能下載 ≠ 有權重新散布
```

本地保存與 NotebookLM 上傳都應遵守學校授權、出版社條款、著作權與 NotebookLM 使用規範。

不要使用本流程繞過付費牆或存取控制。

────────

27. 更新後健康檢查

```powershell
Get-ChildItem "$env:USERPROFILE\Documents\DeepResearch"

hermes mcp test notebooklm
hermes mcp test exa
hermes mcp test scopus
hermes skills list
```

工作區應該有：

```text
cache
evidence
papers
assets
reports
notebooklm
```

────────

28. 更新後完成檢查表

☐ DeepResearch 本地工作區存在
☐ evidence 資料夾存在
☐ papers 資料夾存在
☐ notebooklm 資料夾存在
☐ SKILL.md 已加入 Local Literature Storage
☐ Node.js / npx 正常
☐ NotebookLM MCP 已登入
☐ hermes mcp test notebooklm Connected
☐ Hermes 可以列出 NotebookLM notebooks
☐ 測試本地檔案可以上傳
☐ SKILL.md 已加入 NotebookLM Literature Archiving
☐ broad candidate 不會全部上傳 NotebookLM
☐ deep-read paper 會個別保留 PDF
☐ NotebookLM 每篇文獻維持 individual source
☐ literature manifest 會記錄本地路徑與 NotebookLM 狀態

全部完成後：

```text
搜尋 → 篩選 → 本地保存 → 全文驗證 → NotebookLM 個別建檔
```