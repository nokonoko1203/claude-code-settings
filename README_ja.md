# Claude Code 設定ベストプラクティス

[English](./README.md) | 日本語

Claude Code の設定とカスタマイズに関するベストプラクティスを集めたリポジトリです。より良いものにするため、継続的に更新・改善していきます。

**注意:** このリポジトリの一部の設定は日本語ユーザー向けに設定されています。LLM を使用して、ご自身の環境に合わせて適宜翻訳・調整してください。

このリポジトリの設定ファイルは `~/.claude/` ディレクトリ配下に配置することを想定しています。設定ファイルを適切な場所に配置することで、Claude Code の動作をカスタマイズし、効率的な開発環境を構築できます。

## プロジェクト構造

```
claude-code-settings/
├── .mcp.json          # MCP サーバー設定ファイル
├── .textlintrc.json   # textlint 設定ファイル
├── CLAUDE.md          # ~/.claude/ に配置するグローバルユーザーガイドライン
├── LICENSE            # MIT ライセンスファイル
├── README.md          # 英語版 README
├── README_ja.md       # 日本語版 README（このファイル）
├── agents/            # カスタムエージェント定義
│   ├── backend-design-expert.md           # バックエンド/API 設計エキスパート
│   ├── backend-implementation-engineer.md # Hono + TypeScript バックエンド実装
│   ├── frontend-design-expert.md          # フロントエンド設計レビュアー
│   └── frontend-implementation-engineer.md # Svelte 5 + SvelteKit 実装
├── settings.json      # Claude Code 設定ファイル
├── skills/            # スキル定義
│   ├── bug-investigation/
│   │   └── SKILL.md   # バグ調査・分析スキル
│   ├── code-review/
│   │   └── SKILL.md   # 統合コードレビュースキル（PRレビュー + セルフレビュー + 品質チェック）
│   ├── codex/
│   │   └── SKILL.md   # Codex CLI 委譲スキル（実装/レビュー/テスト）
│   ├── design-principles/
│   │   └── SKILL.md   # デザインシステム適用スキル
│   ├── humanize-text/
│   │   └── SKILL.md   # AI 文章の自然な日本語化スキル
│   └── kill-dev-process/
│       └── SKILL.md   # 開発プロセスクリーンアップスキル
└── symlinks/          # 外部ツール設定ファイル（シンボリックリンク）
    ├── claude.json    # Claude Code ユーザー統計・設定キャッシュ
    ├── ccmanager/     # → ~/.config/ccmanager（CCManager 設定）
    │   ├── config.json     # CCManager 設定・コマンドプリセット
    │   └── init_worktree.sh # ワークツリー作成後フックスクリプト
    └── codex/         # → ~/.codex（Codex CLI 設定）
        ├── AGENTS.md  # Codex プロジェクトガイドライン
        ├── config.toml # Codex CLI 設定
        └── skills/    # Codex スキル（Claude Code スキルと同期）
            ├── bug-investigation/
            ├── code-review/
            ├── design-principles/
            ├── humanize-text/
            └── kill-dev-process/
```

## symlinks フォルダについて

`symlinks/` フォルダには、Claude Code に関連する各種外部ツールの設定ファイルが含まれています。Claude Code は頻繁に更新され、設定変更も多いため、すべての設定ファイルを1つのフォルダに集約することで編集が容易になります。関連ファイルが通常 `~/.claude/` ディレクトリ外に配置される場合でも、シンボリックリンクとしてここに配置することで一元管理できます。

実際の環境では、これらのファイルは指定された場所にシンボリックリンクとして配置されます。

```bash
# Claude Code 設定をリンク
ln -s /path/to/settings.json ~/.claude/settings.json

# ccmanager 設定をリンク
ln -s ~/.config/ccmanager ~/.claude/symlinks/ccmanager

# Codex 設定をリンク
ln -s ~/.codex ~/.claude/symlinks/codex
```

これにより、設定変更をリポジトリで管理し、複数の環境間で共有できます。

### Codex 設定（`symlinks/codex/`）

`codex/` シンボリックリンクには、`codex exec` で使用するための Codex CLI 設定が含まれます：

- **`config.toml`** - モデル選択、サンドボックスモード、MCP サーバー、モデルプロバイダーなどの Codex CLI 設定
- **`AGENTS.md`** - Codex が従うプロジェクトガイドライン（CLAUDE.md に類似するが、チーム編成など Claude Code 固有のルールは除外）
- **`skills/`** - Claude Code スキルの Codex 互換バージョン（bug-investigation、code-review、design-principles、humanize-text、kill-dev-process）

## 主な機能

### 1. カスタムエージェントとスキル

このリポジトリは、Claude Code の機能を強化する専門エージェントとスキルを提供します：

**エージェント** - 特定ドメイン向けの専門エージェント：
- バックエンド/API の設計と実装の専門知識
- フロントエンド開発とデザインレビュー

**スキル** - 一般的なタスク向けのユーザー呼び出し可能なコマンド：
- 実装ガイドラインに基づくコードレビュー
- Codex CLI への実装・レビュー・テストの委譲
- デザインシステムの適用
- 根本原因分析を含むバグ調査
- AI 文章の自然な日本語化
- 開発プロセスのクリーンアップ

### 2. インタラクティブな開発ワークフロー

Claude Code の組み込み機能である Plan Mode と AskUserQuestion を活用して：
- 対話を通じて要件を明確化
- コーディング前に詳細な実装計画を作成
- 開発全体を通じてユーザーの意図との整合性を確保
- 複雑なタスクに体系的にアプローチ

このインタラクティブなアプローチにより、実装開始前に仕様を明確にできます。

### 3. 効率的な開発ルール

- **並列処理の活用**: 複数の独立したプロセスを同時に実行
- **英語で思考し、日本語で応答**: 内部処理は英語、ユーザーへの応答は日本語
- **Context7 MCP の活用**: 常に最新のライブラリ情報を参照
- **徹底した検証**: Write/Edit 後は必ず Read で確認

### 4. Codex CLI を活用したチームワークフロー

エージェントチームは以下の構成に従います：
- **Lead + Reviewer**: 設計とレビューを担当する Claude Code エージェント
- **Implementer + Tester**: `/codex` スキル経由で Codex CLI に委譲する Claude Code エージェント

この関心の分離により、独立したレビューと実装の役割を通じて品質を確保します。

## ファイル詳細

### CLAUDE.md

グローバルユーザーガイドラインを定義します。以下の内容が含まれます：

- **トップレベルルール**: MCP 使用、テスト要件、チームワークフローを含む基本的な運用ルール
- ライブラリ情報には常に Context7 MCP を使用
- コード調査には LSP を使用して正確なナビゲーションと分析を実現
- フロントエンド機能は Playwright MCP または Chrome DevTools MCP で検証
- コンソールログ確認には Chrome DevTools MCP を使用
- 意思決定には AskUserQuestion を使用
- 一時的な設計メモは `.tmp` に作成
- 批判的に応答し忖度しないが、強引な批判はしない
- タスク発生時は常にタスク管理システムを起動
- チーム編成: Lead + Reviewer（Claude Code エージェント）と Implementer + Tester（Codex CLI via `/codex`）

### .mcp.json

使用可能な MCP（Model Context Protocol）サーバーを定義します：

| サーバー | 説明 |
| --- | --- |
| **context7** | ライブラリの最新ドキュメントとコード例 |
| **playwright** | ブラウザ自動化とテスト |
| **chrome-devtools** | Chrome DevTools 連携（コンソールログ・デバッグ） |

### settings.json

Claude Code の動作を制御する設定ファイル：

#### 環境変数設定（`env`）
```json
{
  "DISABLE_TELEMETRY": "1",                         // テレメトリを無効化
  "DISABLE_ERROR_REPORTING": "1",                   // エラーレポートを無効化
  "DISABLE_BUG_COMMAND": "1",                       // バグコマンドを無効化
  "API_TIMEOUT_MS": "600000",                       // API タイムアウト（10分）
  "DISABLE_AUTOUPDATER": "0",                       // 自動更新設定
  "CLAUDE_CODE_ENABLE_TELEMETRY": "0",              // Claude Code テレメトリ
  "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",  // 非必須トラフィックを無効化
  "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"       // 実験的エージェントチーム機能を有効化
}
```

#### パーミッション設定（`permissions`）

**allow（許可リスト）**:
- ファイル読み取り: `Read(**)`
- 特定ディレクトリへの書き込み: `Write(src/**)`, `Write(docs/**)`, `Write(.tmp/**)`
- パッケージ管理: `pnpm install`, `pnpm run test`, `pnpm run build`
- ファイル操作: `rm`
- 基本的なシェルコマンド: `ls`, `cat`, `head`, `tail`, `pwd`, `find`, `tree`, `mkdir`, `mv`
- Docker 操作: `docker compose up -d --build`
- macOS 通知: `osascript -e`

**deny（拒否リスト）**:
- 危険なコマンド: `sudo`, `rm`, `rm -rf`
- Git 操作: `git push`, `git commit`, `git reset`, `git rebase`, `git rm`, `git clean`
- セキュリティ関連: `.env.*` ファイルの読み取り、`id_rsa`、`id_ed25519`、トークン、キー
- 機密ファイルへの書き込み: `.env*`, `**/secrets/**`
- ネットワーク操作: `curl`, `wget`, `nc`
- パッケージ削除: `npm uninstall`, `npm remove`
- 直接的なデータベース操作: `psql`, `mysql`
- 特定の Serena MCP ツール: `create_text_file`, `delete_lines`, `execute_shell_command`, `replace_lines`, `replace_regex`

> **注意:** `rm` は allow と deny の両方に存在します。deny が優先されるため、`rm` コマンドには明示的な承認が必要です。

#### フック設定（`hooks`）

**PostToolUse**（ツール使用後の自動処理）
- JS/TS/JSON/TSX ファイル編集時に Prettier で自動フォーマット

**Notification**（通知設定 - macOS）
- macOS 通知システムを使用してカスタムメッセージとタイトルで通知を表示

**Stop**（作業完了時の処理）
- 「作業が完了しました」通知を表示

#### MCP サーバー有効化（`enabledMcpjsonServers`）

`.mcp.json` で定義された MCP サーバーのうち、有効化するものを制御します。`serena` はプロジェクトレベルで定義されています（グローバルの `.mcp.json` には含まれない）。

- **context7** - ライブラリの最新ドキュメントとコード例
- **playwright** - ブラウザ自動化とテスト
- **serena** - セマンティックコード分析とインテリジェントなコードナビゲーション
- **chrome-devtools** - Chrome DevTools 連携

#### その他の設定
- `cleanupPeriodDays`: 20 - 古いデータのクリーンアップ期間
- `enableAllProjectMcpServers`: true - すべてのプロジェクト固有 MCP サーバーを有効化
- `language`: "Japanese" - インターフェース言語
- `alwaysThinkingEnabled`: true - 常に思考プロセスを表示
- `enabledPlugins`: コードインテリジェンス強化のための LSP プラグイン（rust-analyzer、typescript、pyright）

### カスタムエージェント（agents/）

カスタムエージェントは、特定の開発タスク向けの専門機能を提供します。これらのエージェントは Claude Code 使用時に自動的に利用可能になり、Task ツールを通じて呼び出せます。

| エージェント                       | 説明                                                                                           |
| ---------------------------------- | ---------------------------------------------------------------------------------------------- |
| `backend-design-expert`            | 仕様優先設計と運用正確性のためのコード非依存バックエンド/API エキスパート                      |
| `backend-implementation-engineer`  | クリーンアーキテクチャで Hono + TypeScript を使用したバックエンド HTTP API を実装              |
| `frontend-design-expert`           | SPA/SSR アプリ向けのコード非依存フロントエンドレビュアー、アーキテクチャとパフォーマンスを監査 |
| `frontend-implementation-engineer` | Svelte 5 + SvelteKit + TypeScript を使用した本番対応 Web アプリを実装                          |

### 公式プラグイン

Claude Code は、コードインテリジェンスを強化するための公式 LSP（Language Server Protocol）プラグインを提供しています。これらは `settings.json` の `enabledPlugins` で設定されます。

| プラグイン           | 説明                                              |
| -------------------- | ------------------------------------------------- |
| `rust-analyzer-lsp`  | Rust 言語サーバー（コードナビゲーション・分析）   |
| `typescript-lsp`     | TypeScript/JavaScript 言語サーバー                |
| `pyright-lsp`        | Python 言語サーバー（型チェック・分析）           |

### スキル（skills/）

スキルは `/skill-name` 構文で直接呼び出せるユーザー呼び出し可能なコマンドです。

| スキル                 | 説明                                                                                    |
| ---------------------- | --------------------------------------------------------------------------------------- |
| `/bug-investigation`   | バグを体系的に調査し、根本原因分析と修正提案を含むレポートを生成                        |
| `/code-review`         | PR レビュー、セルフレビュー、品質チェックを統合した包括的コードレビュー                 |
| `/codex`               | Codex CLI にタスクを委譲（実装、レビュー、テスト、設計コンサルテーション）              |
| `/design-principles`   | Linear、Notion、Stripe にインスパイアされた精密でミニマルなデザインシステムを適用       |
| `/humanize-text`       | AI が書いた日本語を自然な人間らしい日本語に書き換え                                     |
| `/kill-dev-process`    | 開発中に残った不要なサーバー、ブラウザ、ポート占有プロセスを停止                        |

## クイックインストール（curl）

リポジトリをクローンせずに、curl を使用して設定ファイルをすばやくダウンロードしてセットアップできます。

> **警告: 既存のファイルが上書きされます！**
>
> すでに `~/.claude/CLAUDE.md`、`~/.claude/settings.json`、または `~/.claude/agents/` や `~/.claude/skills/` 内のファイルをカスタマイズしている場合、**それらは上書きされ、カスタム設定は失われます**。
>
> **これらのコマンドを実行する前に：**
> 1. 既存の `~/.claude/` ディレクトリをバックアップしてください: `cp -r ~/.claude ~/.claude.backup`
> 2. または、必要なファイルのみを選択的にダウンロードしてください

### すべてのファイルをダウンロード

```bash
# 必要なディレクトリを作成
mkdir -p ~/.claude/agents
mkdir -p ~/.claude/skills/{bug-investigation,code-review,codex,design-principles,humanize-text,kill-dev-process}

# メイン設定ファイルをダウンロード
curl -o ~/.claude/CLAUDE.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/CLAUDE.md
curl -o ~/.claude/settings.json \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/settings.json
curl -o ~/.claude/.mcp.json \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/.mcp.json

# エージェントをダウンロード
curl -o ~/.claude/agents/backend-design-expert.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/agents/backend-design-expert.md
curl -o ~/.claude/agents/backend-implementation-engineer.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/agents/backend-implementation-engineer.md
curl -o ~/.claude/agents/frontend-design-expert.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/agents/frontend-design-expert.md
curl -o ~/.claude/agents/frontend-implementation-engineer.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/agents/frontend-implementation-engineer.md

# スキルをダウンロード
curl -o ~/.claude/skills/bug-investigation/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/bug-investigation/SKILL.md
curl -o ~/.claude/skills/code-review/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/code-review/SKILL.md
curl -o ~/.claude/skills/codex/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/codex/SKILL.md
curl -o ~/.claude/skills/design-principles/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/design-principles/SKILL.md
curl -o ~/.claude/skills/humanize-text/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/humanize-text/SKILL.md
curl -o ~/.claude/skills/kill-dev-process/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/kill-dev-process/SKILL.md
```

### 個別ファイルのダウンロード

特定のファイルのみが必要な場合は、個別にダウンロードできます：

```bash
# 例: CLAUDE.md のみをダウンロード
mkdir -p ~/.claude
curl -o ~/.claude/CLAUDE.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/CLAUDE.md

# 例: 特定のスキルのみをダウンロード
mkdir -p ~/.claude/skills/code-review
curl -o ~/.claude/skills/code-review/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/code-review/SKILL.md
```

## 参考リンク

- [Claude Code 概要](https://docs.anthropic.com/en/docs/claude-code)
- [Model Context Protocol (MCP)](https://docs.anthropic.com/en/docs/mcp)
- [OpenAI Codex](https://openai.com/codex)
- [textlint](https://textlint.github.io/)
- [CCManager](https://github.com/kbwo/ccmanager)
- [Context7](https://context7.com/)

## ライセンス

このプロジェクトは MIT ライセンスの下でリリースされています。
