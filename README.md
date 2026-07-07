# claude-config

Claude Code 用の `CLAUDE.md` 設定リポジトリ。

## `CLAUDE.md` の配置場所

`CLAUDE.md` は配置場所によってスコープが変わります。

### Global (全プロジェクト共通)

```
~/.claude/CLAUDE.md
```

ホームディレクトリ配下に置くと、Claude Code を起動するすべてのプロジェクトでこのルールが読み込まれます。「自分のデフォルトの作法」を定義する場所です。

### Local (プロジェクト単位 / チーム共有)

```
<project-root>/CLAUDE.md
```

プロジェクトのルートに置くと、そのプロジェクトで Claude Code を起動したときだけ読み込まれます。チーム共有のルールやリポジトリ固有の約束事を書く場所です（git にコミット可）。

### Local (個人ローカル設定)

```
<project-root>/CLAUDE.local.md
```

同じくプロジェクト直下に置きますが、こちらは **自分専用** の上書き用ファイル。`.gitignore` に入れておけば、チームに共有せず自分だけのメモやルールを書けます（自分のデバッグ用ルール、個人的な好み等）。

> Global, Localには読み込み順序があり、Local（プロジェクト単位）, Global（全プロジェクト共通）, Local（個人ローカル設定）の順で優先順位が働くらしいです 

## このリポジトリの `CLAUDE.md` の内容

- **会話ガイドライン** — 常に日本語で会話する
- **開発方針（TDD）** — テスト駆動開発を原則とし、テスト作成 → 失敗確認 → 実装 → パス確認のループを回す
- **Subagent Model Tiering** — Agent tool でサブエージェントに委譲するとき、タスクの性質（計画・分解 / 実装 / 単純作業）に応じて `model` パラメータを明示的に使い分ける

詳細は [`CLAUDE.md`](CLAUDE.md) を参照。

## インストール (`install.sh`)

このリポジトリの `CLAUDE.md` と `skills/` を Global スコープ (`~/.claude/`) に一括で配置するシェルスクリプトです。

```bash
./install.sh
```

### 動作

- リポジトリ直下の `CLAUDE.md` を `~/.claude/CLAUDE.md` にコピー
- リポジトリ直下の `skills/` を `~/.claude/skills/` にコピー
- 配置先に同名のファイル / ディレクトリが既に存在する場合は、`*.bak.YYYYMMDD-HHMMSS` の形式でバックアップしてから上書き
- スクリプトはどのディレクトリから実行しても、自身の置かれた場所を基準に動作

### 反映

コピー方式のため、リポジトリ側を更新したあとは `./install.sh` を再実行することで Global スコープに反映されます。

### 注意（ファイル名の大文字小文字）

Claude Code は `~/.claude/CLAUDE.md`（小文字）と `~/.claude/skills/<name>/SKILL.md`（小文字）を読み込みます。大文字の `CLAUDE.MD` / `SKILL.MD` は認識されないため、このリポジトリでは常に小文字のファイル名で管理してください。
