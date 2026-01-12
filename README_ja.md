# Claude Code 設定ベストプラクティス

[English](./README.md) | 日本語

Claude Code の設定とカスタマイズに関するベストプラクティスを集めたリポジトリです。より良いものにするため、継続的に更新・改善していきます。

このリポジトリの設定ファイルは `~/.claude/` ディレクトリ配下に配置することを想定しています。設定ファイルを適切な場所に配置することで、Claude Code の動作をカスタマイズし、効率的な開発環境を構築できます。

## プロジェクト構造

```
claude-code-settings/
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
│   ├── agent-browser/
│   │   └── SKILL.md   # ブラウザ自動化スキル
│   ├── agent-memory/
│   │   └── SKILL.md   # 永続メモリ管理スキル
│   ├── code-review/
│   │   └── SKILL.md   # PR コードレビュースキル
│   ├── design-principles/
│   │   └── SKILL.md   # デザインシステム適用スキル
│   ├── quality-check/
│   │   └── SKILL.md   # コード品質検証スキル
│   ├── self-review/
│   │   └── SKILL.md   # セルフレビュードキュメント生成スキル
│   └── textlint/
│       └── SKILL.md   # Markdown リンティングスキル
└── symlinks/          # 外部ツール設定ファイル（シンボリックリンク）
    ├── claude.json
    └── config/
        ├── ccmanager/
        │   └── config.json
        └── serena/
            └── serena_config.yml  # Serena MCP 設定（シンボリックリンク）
```

## symlinks フォルダについて

`symlinks/` フォルダには、Claude Code に関連する各種外部ツールの設定ファイルが含まれています。Claude Code は頻繁に更新され、設定変更も多いため、すべての設定ファイルを1つのフォルダに集約することで編集が容易になります。関連ファイルが通常 `~/.claude/` ディレクトリ外に配置される場合でも、シンボリックリンクとしてここに配置することで一元管理できます。

実際の環境では、これらのファイルは指定された場所にシンボリックリンクとして配置されます。

```bash
# Claude Code 設定をリンク
ln -s /path/to/settings.json ~/.claude/settings.json

# ccmanager 設定をリンク
ln -s /path/to/.config/ccmanager/config.json ~/.claude/symlinks/config/ccmanager/config.json
```

これにより、設定変更をリポジトリで管理し、複数の環境間で共有できます。

## 主な機能

### 1. カスタムエージェントとスキル

このリポジトリは、Claude Code の機能を強化する専門エージェントとスキルを提供します：

**エージェント** - 特定ドメイン向けの専門エージェント：
- バックエンド/API の設計と実装の専門知識
- フロントエンド開発とデザインレビュー

**スキル** - 一般的なタスク向けのユーザー呼び出し可能なコマンド：
- 実装ガイドラインに基づくコードレビュー
- デザインシステムの適用
- 品質チェックとリンティング

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

## ファイル詳細

### CLAUDE.md

プロジェクト固有のガイドラインを定義します。以下の内容が含まれます：

- **トップレベルルール**: 言語設定、MCP 使用、テスト要件を含む基本的な運用ルール
- 応答は日本語で行う
- ライブラリ情報には常に Context7 MCP を使用
- コード調査には常に Serena MCP を使用
- フロントエンド機能は Playwright MCP または Chrome DevTools MCP で検証
- 意思決定には AskUserQuestion を使用

### settings.json

Claude Code の動作を制御する設定ファイル：

#### 環境変数設定（`env`）
```json
{
  "DISABLE_TELEMETRY": "1",                      // テレメトリを無効化
  "DISABLE_ERROR_REPORTING": "1",                // エラーレポートを無効化
  "DISABLE_BUG_COMMAND": "1",                    // バグコマンドを無効化
  "API_TIMEOUT_MS": "600000",                    // API タイムアウト（10分）
  "DISABLE_AUTOUPDATER": "0",                    // 自動更新設定
  "CLAUDE_CODE_ENABLE_TELEMETRY": "0",           // Claude Code テレメトリ
  "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1" // 非必須トラフィックを無効化
}
```

#### パーミッション設定（`permissions`）

**allow（許可リスト）**:
- ファイル読み取り: `Read(**)`
- 特定ディレクトリへの書き込み: `Write(src/**)`, `Write(docs/**)`, `Write(.tmp/**)`
- パッケージ管理: `pnpm install`, `pnpm run test`, `pnpm run build`
- 基本的なシェルコマンド: `ls`, `cat`, `head`, `tail`, `pwd`, `find`, `tree`, `mkdir`, `mv`
- Docker 操作: `docker compose up -d --build`
- macOS 通知: `osascript -e`

**deny（拒否リスト）**:
- 危険なコマンド: `sudo`, `rm -rf`
- Git 操作: `git push`, `git commit`, `git reset`, `git rebase`
- セキュリティ関連: `.env.*` ファイルの読み取り、`id_rsa`、`id_ed25519`、トークン、キー
- 機密ファイルへの書き込み: `.env*`, `**/secrets/**`
- ネットワーク操作: `curl`, `wget`, `nc`
- パッケージ削除: `npm uninstall`, `npm remove`
- 直接的なデータベース操作: `psql`, `mysql`, `mongod`
- 特定の Serena MCP ツール: `create_text_file`, `delete_lines`, `execute_shell_command`, `replace_lines`, `replace_regex`

#### フック設定（`hooks`）

**PostToolUse**（ツール使用後の自動処理）
- JS/TS/JSON/TSX ファイル編集時に Prettier で自動フォーマット

**Notification**（通知設定 - macOS）
- macOS 通知システムを使用してカスタムメッセージとタイトルで通知を表示

**Stop**（作業完了時の処理）
- 「作業が完了しました」通知を表示

#### MCP サーバー設定（`enabledMcpjsonServers`）
- **context7** - ライブラリの最新ドキュメントとコード例
- **playwright** - ブラウザ自動化とテスト
- **serena** - セマンティックコード分析とインテリジェントなコードナビゲーション
- **chrome-devtools** - Chrome DevTools 連携

#### その他の設定
- `cleanupPeriodDays`: 20 - 古いデータのクリーンアップ期間
- `enableAllProjectMcpServers`: true - すべてのプロジェクト固有 MCP サーバーを有効化
- `language`: "Japanese" - インターフェース言語
- `alwaysThinkingEnabled`: true - 常に思考プロセスを表示
- `model`: "opusplan" - プランニング用のデフォルトモデル

### カスタムエージェント（agents/）

カスタムエージェントは、特定の開発タスク向けの専門機能を提供します。これらのエージェントは Claude Code 使用時に自動的に利用可能になり、Task ツールを通じて呼び出せます。

| エージェント                         | 説明                                                                             |
| ---------------------------------- | -------------------------------------------------------------------------------- |
| `backend-design-expert`            | 仕様優先設計と運用正確性のためのコード非依存バックエンド/API エキスパート              |
| `backend-implementation-engineer`  | クリーンアーキテクチャで Hono + TypeScript を使用したバックエンド HTTP API を実装     |
| `frontend-design-expert`           | SPA/SSR アプリ向けのコード非依存フロントエンドレビュアー、アーキテクチャとパフォーマンスを監査 |
| `frontend-implementation-engineer` | Svelte 5 + SvelteKit + TypeScript を使用した本番対応 Web アプリを実装               |

### 公式プラグイン

Claude Code は、Claude Code セッション内から直接インストールできる公式プラグインを提供しています。これらのプラグインは、手動での設定ファイル作成なしに事前構築された機能を提供します。

**インストール方法：**
```bash
# 公式プラグインマーケットプレイスを更新
/plugin marketplace update claude-plugins-official

# code-simplifier プラグインをインストール
/plugin install code-simplifier
```

| プラグイン          | 説明                                                                    |
| ------------------ | ----------------------------------------------------------------------- |
| `code-simplifier`  | AI 生成コードが不必要に複雑になることを防ぐエキスパート                      |

### スキル（skills/）

スキルは `/skill-name` 構文で直接呼び出せるユーザー呼び出し可能なコマンドです。

| スキル               | 説明                                                                    |
| -------------------- | ----------------------------------------------------------------------- |
| `/agent-browser`     | Web テスト、フォーム入力、スクリーンショット取得のためのブラウザ操作を自動化    |
| `/agent-memory`      | 会話をまたいで知識を保存する永続メモリ管理                                   |
| `/code-review`       | 確立されたガイドラインに従ってプルリクエストの徹底的なコードレビューを実行     |
| `/design-principles` | Linear、Notion、Stripe にインスパイアされた精密でミニマルなデザインシステムを適用 |
| `/quality-check`     | コード変更後に実行する品質チェック                                         |
| `/self-review`       | PR提出前にセルフレビュードキュメントを生成（日本語で出力）                    |
| `/textlint`          | 指定ファイルで textlint を実行し、自動および手動で修正                       |

## セットアップ

### 1. リポジトリをクローン

```bash
git clone https://github.com/nokonoko1203/claude-code-settings.git
cd claude-code-settings
```

### 2. Claude Code に設定を適用

リポジトリの内容を `~/.claude/` にコピーするか、シンボリックリンクを作成してリポジトリと同期を維持できます。

#### オプション A: ~/.claude/ に内容をコピー
```bash
# 設定ファイルを ~/.claude/ ディレクトリにコピー
cp .textlintrc.json ~/.claude/
cp CLAUDE.md ~/.claude/
cp settings.json ~/.claude/
cp -r agents ~/.claude/
cp -r skills ~/.claude/
cp -r symlinks ~/.claude/
```

#### オプション B: リポジトリを ~/.claude/ にリンク（推奨）
```bash
# リポジトリを同期するためのシンボリックリンクを作成
ln -s /path/to/claude-code-settings ~/.claude/claude-code-settings
# 個別ファイルをリンク
ln -s ~/.claude/claude-code-settings/CLAUDE.md ~/.claude/
ln -s ~/.claude/claude-code-settings/settings.json ~/.claude/
ln -s ~/.claude/claude-code-settings/agents ~/.claude/
ln -s ~/.claude/claude-code-settings/skills ~/.claude/
```

### 3. シンボリックリンクを使用した外部ツールの設定

一元管理のため、外部ツールの場所から `~/.claude/symlinks/` へのシンボリックリンクを作成します：

```bash
# symlinks ディレクトリ構造を作成
mkdir -p ~/.claude/symlinks/config/ccmanager/

# Claude Code グローバル設定を symlinks フォルダにリンク
ln -s ~/claude.json ~/.claude/symlinks/claude.json

# ccmanager 設定を symlinks フォルダにリンク
ln -s ~/.config/ccmanager/config.json ~/.claude/symlinks/config/ccmanager/config.json
```

このアプローチにより、すべての Claude Code 関連設定ファイルを `~/.claude/` ディレクトリに集約し、管理を容易にします。

## 参考リンク

- [Claude Code 概要](https://docs.anthropic.com/en/docs/claude-code)
- [Model Context Protocol (MCP)](https://docs.anthropic.com/en/docs/mcp)
- [textlint](https://textlint.github.io/)
- [CCManager](https://github.com/kbwo/ccmanager)
- [Context7](https://context7.com/)

## ライセンス

このプロジェクトは MIT ライセンスの下でリリースされています。
