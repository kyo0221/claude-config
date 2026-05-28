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

```text
1. Ask, don't assume. If something is unclear, ask before writing a single line.
2. Simplest solution first. Always implement the simplest thing that could work.
3. Don't touch unrelated code. If a file is not directly part of the current task, do not modify it.
4. Flag uncertainty explicitly. If you're not confident about an approach, say so before proceeding.
```

### 日本語訳

1. **推測せずに聞く** — 不明点があれば、コードを1行も書く前に質問する。
2. **まずは最小の解決策で** — 動くなかで一番シンプルなものを実装する。
3. **関係ないコードに触らない** — 今のタスクに直接関係しないファイルは変更しない。
4. **不確実なら明示する** — アプローチに自信がないときは、進める前にそう伝える。

## インストール (`install.sh`)

このリポジトリの `CLAUDE.MD` と `skills/` を Global スコープ (`~/.claude/`) に一括で配置するシェルスクリプトです。

```bash
./install.sh
```

### 動作

- リポジトリ直下の `CLAUDE.MD` を `~/.claude/CLAUDE.MD` にコピー
- リポジトリ直下の `skills/` を `~/.claude/skills/` にコピー
- 配置先に同名のファイル / ディレクトリが既に存在する場合は、`*.bak.YYYYMMDD-HHMMSS` の形式でバックアップしてから上書き
- スクリプトはどのディレクトリから実行しても、自身の置かれた場所を基準に動作

### 反映

コピー方式のため、リポジトリ側を更新したあとは `./install.sh` を再実行することで Global スコープに反映されます。
