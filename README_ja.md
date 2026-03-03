# Claude Code 設定ベストプラクティス

[English](./README.md) | 日本語

Claude Code の設定とカスタマイズに関するベストプラクティスを集めたリポジトリです。より良いものにするため、継続的に更新・改善していきます。

このリポジトリの設定ファイルは `~/.claude/` ディレクトリ配下に配置することを想定しています。設定ファイルを適切な場所に配置することで、Claude Code の動作をカスタマイズし、効率的な開発環境を構築できます。

## アプローチ

モデルの性能が上がった今、複雑な設定は不要です。むしろ設定を盛りすぎると逆効果になる可能性があります。このリポジトリでは、数少ない効きどころだけに絞っています。

- Claude Codeにはスラッシュコマンドが充実しています。まずはこれらを使いこなしましょう。カスタム設定を足すのはそのあとでいいです。
    - /resume・/rewind・/fork・/copy: 会話の再開・リストア・分岐・コピーなど
    - /review: PRのレビュー
    - /sinplify: 変更されたコードをレビュー・修正
    - /copy: セッションの内容をクリップボードに入れる
    - /add-dir: 追加したディレクトリを検索対象に加える
    - /batch: 大規模な改修をgit worktreeを作成して複数のPRを作成し対応する
    - /plan: 計画モードで実行
- Agent Teamsを使えば、複数のエージェントにタスクを分担させて並列に作業できます。設計・レビュー・実装・テストなど役割を分けることで、大規模なタスクも効率的に進められます。
- 公式プラグインを有効にすると良いでしょう。LSPプラグインの`typescript-lsp`, `pyright-lsp`, `rust-analyzer-lsp`を入れれば、トークンを追加消費せずにコードナビゲーションが正確になります。
- 場合のよってはMCPよりCLIツールを選ぶと良いでしょう。MCPサーバーは呼び出すたびにコンテキストを消費します。CLIツールなら、同じことをはるかに少ないトークンで実行できます。例えば、Playwright MCPをPlaywright CLIに置き換える、などです。

## プロジェクト構造

```
claude-code-settings/
├── CLAUDE.md          # ~/.claude/ に配置するグローバルユーザーガイドライン
├── LICENSE            # MIT ライセンスファイル
├── README.md          # 英語版 README
├── README_ja.md       # 日本語版 README（このファイル）
├── settings.json      # Claude Code 設定ファイル
├── skills/            # スキル定義
│   ├── kill-dev-process/
│   │   └── SKILL.md   # 開発プロセスクリーンアップスキル
│   └── playwright-cli/
│       ├── SKILL.md   # Playwright CLI によるブラウザ自動化（トークン効率重視）
│       └── references/ # 詳細リファレンスドキュメント
└── symlinks/          # 外部ツール設定ファイル（シンボリックリンク）
    └── claude.json    # Claude Code MCP サーバー設定テンプレート
```

## symlinks フォルダについて

`symlinks/` フォルダには、Claude Code に関連する各種外部ツールの設定ファイルが含まれています。Claude Code は頻繁に更新され、設定変更も多いため、すべての設定ファイルを1つのフォルダに集約することで編集が容易になります。関連ファイルが通常 `~/.claude/` ディレクトリ外に配置される場合でも、シンボリックリンクとしてここに配置することで一元管理できます。

実際の環境では、これらのファイルは指定された場所にシンボリックリンクとして配置されます。

```bash
# Claude Code 設定をリンク
ln -s /path/to/settings.json ~/.claude/settings.json
```

これにより、設定変更をリポジトリで管理し、複数の環境間で共有できます。

## 主な機能

### 1. スキル

このリポジトリは、Claude Code の機能を強化するスキルを提供します：

**スキル** - 一般的なタスク向けのユーザー呼び出し可能なコマンド：
- 開発プロセスのクリーンアップ
- Playwright CLI によるトークン効率的なブラウザ自動化

### 2. インタラクティブな開発ワークフロー

CLAUDE.md で定義されたルールにより、Claude Code との対話的な開発を促進します：
- リサーチ → 計画 → 承認 → 実装の順で進め、承認前にコードを書かない
- リサーチ結果や計画は `.tmp` にmarkdownとして書き出し、ユーザーがレビュー・注釈できるようにする
- **AskUserQuestion** を使用してユーザーの意思決定を支援
- **タスク管理システム** をタスク発生時に常に起動し、詳細を整理

### 3. 効率的な開発ルール

- **Context7 MCP の活用**: 常に最新のライブラリ情報を参照
- **トークン効率的なブラウザ自動化**: MCP の代わりに Playwright CLI を使用し、トークン消費を約4分の1に削減
- **LSP によるコード調査**: 正確なコードナビゲーションと分析を実現

### 4. チームワークフロー

エージェントチームは以下の構成に従います：
- **Lead + Reviewer**: 設計とレビューを担当する Claude Code エージェント
- **Implementer + Tester**: 実装とテストを担当する Claude Code エージェント

この関心の分離により、独立したレビューと実装の役割を通じて品質を確保します。

## ファイル詳細

### CLAUDE.md

グローバルユーザーガイドラインを定義します。以下の内容が含まれます：

- **トップレベルルール**: MCP 使用、テスト要件、チームワークフローを含む基本的な運用ルール
- ライブラリ情報には常に Context7 MCP を使用
- コード調査には LSP を使用して正確なナビゲーションと分析を実現
- フロントエンド機能は Playwright CLI（`playwright-cli` via Bash）で検証
- コンソールログ・ネットワーク確認には `playwright-cli console` / `playwright-cli network` を使用
- 承認前にコードを書かない。リサーチ → 計画 → 承認 → 実装の順で進める
- リサーチ結果や計画は `.tmp` にmarkdownとして書き出す。口頭報告のみで済ませない
- 計画への注釈にはすべて対応し、明示的に指示があるまで実装しない
- 意思決定には AskUserQuestion を使用
- 批判的に応答し忖度しないが、強引な批判はしない
- タスク発生時は常にタスク管理システムを起動
- チーム編成: Lead + Reviewer（Claude Code エージェント）と Implementer + Tester（Claude Code エージェント）

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
> **注意:** `rm` は allow と deny の両方に存在します。deny が優先されるため、`rm` コマンドには明示的な承認が必要です。

#### フック設定（`hooks`）

**PostToolUse**（ツール使用後の自動処理）
- JS/TS/JSON/TSX ファイル編集時に Prettier で自動フォーマット

**Notification**（通知設定 - macOS）
- macOS 通知システムを使用してカスタムメッセージとタイトルで通知を表示

**Stop**（作業完了時の処理）
- 「作業が完了しました」通知を表示

#### MCP サーバー有効化（`enabledMcpjsonServers`）

プロジェクトレベルの `.mcp.json` で定義された MCP サーバーのうち、有効化するものを制御します。

- **context7** - ライブラリの最新ドキュメントとコード例

#### その他の設定
- `cleanupPeriodDays`: 20 - 古いデータのクリーンアップ期間
- `enableAllProjectMcpServers`: true - すべてのプロジェクト固有 MCP サーバーを有効化
- `language`: "Japanese" - インターフェース言語
- `alwaysThinkingEnabled`: true - 常に思考プロセスを表示
- `enabledPlugins`: コードインテリジェンス強化のための LSP プラグイン（rust-analyzer、typescript、pyright）

### 公式プラグイン

Claude Code は、コードインテリジェンスを強化するための公式 LSP（Language Server Protocol）プラグインを提供しています。これらは `settings.json` の `enabledPlugins` で設定されます。

| プラグイン          | 説明                                            |
| ------------------- | ----------------------------------------------- |
| `rust-analyzer-lsp` | Rust 言語サーバー（コードナビゲーション・分析） |
| `typescript-lsp`    | TypeScript/JavaScript 言語サーバー              |
| `pyright-lsp`       | Python 言語サーバー（型チェック・分析）         |

### スキル（skills/）

スキルは `/skill-name` 構文で直接呼び出せるユーザー呼び出し可能なコマンドです。

| スキル              | 説明                                                                         |
| ------------------- | ---------------------------------------------------------------------------- |
| `/kill-dev-process` | 開発中に残った不要なサーバー、ブラウザ、ポート占有プロセスを停止             |
| `/playwright-cli`   | Playwright CLI によるトークン効率的なブラウザ自動化（Playwright MCP の後継） |

## クイックインストール（curl）

リポジトリをクローンせずに、curl を使用して設定ファイルをすばやくダウンロードしてセットアップできます。

> **警告: 既存のファイルが上書きされます！**
>
> すでに `~/.claude/CLAUDE.md`、`~/.claude/settings.json`、または `~/.claude/skills/` 内のファイルをカスタマイズしている場合、**それらは上書きされ、カスタム設定は失われます**。
>
> **これらのコマンドを実行する前に：**
> 1. 既存の `~/.claude/` ディレクトリをバックアップしてください: `cp -r ~/.claude ~/.claude.backup`
> 2. または、必要なファイルのみを選択的にダウンロードしてください

### すべてのファイルをダウンロード

```bash
# 必要なディレクトリを作成
mkdir -p ~/.claude/skills/{kill-dev-process,playwright-cli}

# メイン設定ファイルをダウンロード
curl -o ~/.claude/CLAUDE.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/CLAUDE.md
curl -o ~/.claude/settings.json \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/settings.json

# スキルをダウンロード
curl -o ~/.claude/skills/kill-dev-process/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/kill-dev-process/SKILL.md
curl -o ~/.claude/skills/playwright-cli/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/playwright-cli/SKILL.md
```

### 個別ファイルのダウンロード

特定のファイルのみが必要な場合は、個別にダウンロードできます：

```bash
# 例: CLAUDE.md のみをダウンロード
mkdir -p ~/.claude
curl -o ~/.claude/CLAUDE.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/CLAUDE.md

# 例: 特定のスキルのみをダウンロード
mkdir -p ~/.claude/skills/kill-dev-process
curl -o ~/.claude/skills/kill-dev-process/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/kill-dev-process/SKILL.md
```

## 参考リンク

- [Claude Code 概要](https://docs.anthropic.com/en/docs/claude-code)
- [Model Context Protocol (MCP)](https://docs.anthropic.com/en/docs/mcp)
- [Context7](https://context7.com/)
- [Playwright CLI](https://www.npmjs.com/package/@playwright/cli)

## ライセンス

このプロジェクトは MIT ライセンスの下でリリースされています。
