# skills

Claude Code 用の Skill 定義ディレクトリ。

Skill は「特定の状況で Claude に取らせたい振る舞い」をひとつのドキュメントにまとめたもの。会話のなかでトリガー条件にマッチすると Claude が自発的に読み込み、その手順に沿って作業を進めます。

## Skill の配置場所

`CLAUDE.md` と同様に、配置場所でスコープが変わります。

### Global (全プロジェクト共通)

```
~/.claude/skills/<skill-name>/SKILL.md
```

ホームディレクトリ配下に置くと、すべてのプロジェクトで利用可能になります。「自分のデフォルトの作業手順」を定義する場所です。

### Local (プロジェクト単位 / チーム共有)

```
<project-root>/.claude/skills/<skill-name>/SKILL.md
```

プロジェクト直下に置くと、そのプロジェクトでだけ読み込まれます。チームで共有したいワークフロー（リリース手順、レビュー方針など）を書く場所です。

## Skill ファイルの構造

各 Skill は専用ディレクトリの `SKILL.md` に書きます。先頭の frontmatter で **いつこの Skill を発動させるか** を宣言します。

```markdown
---
name: <skill-name>
description: <Claude がトリガー判定に使う一行サマリ。発動条件を具体的に書く>
---

# <Skill 名>

<手順や原則を Markdown で記述>
```

- `name` — Skill の識別子（kebab-case）。ディレクトリ名と揃える。
- `description` — Claude はこの説明文を見て「今このスキルを使うべきか」を判断するため、**発動条件（ユーザーの発言の特徴やタスクの種類）を具体的に書く** のが重要。
- 本文 — 実際の手順、チェックリスト、アンチパターンなど。補助資料は同じディレクトリに置いて相対リンクで参照可能。

## このリポジトリに含まれる Skill

- [tdd](tdd/SKILL.MD) — 赤 → 緑 → リファクタを **垂直スライス（1 テスト → 1 実装）** で回す TDD ループ。public interface 越しの振る舞いだけを検証する原則を徹底させる。
- [diagnose](diagnose/SKILL.MD) — 厄介なバグや性能リグレッションのための診断規律。再現 → 最小化 → 仮説 → 計測 → 修正 → 回帰テストの 6 フェーズで進める。
- [writing-plans](writing-plans/SKILL.MD) — 複数ステップのタスクに着手する前に、コードに触れず実装プランを書くためのガイド。触るファイル・テスト・コミット粒度まで具体化する。
- [executing-plans](executing-plans/SKILL.MD) — 書かれたプランを別セッションで実行するときの進め方。レビューチェックポイントを挟みながら順に消化する。
- [subagent-driven-development](subagent-driven-development/SKILL.MD) — プランを subagent に分担実行させる進め方。各タスク後に「仕様適合レビュー → コード品質レビュー」の二段レビューを挟む。
- [dispatching-parallel-agents](dispatching-parallel-agents/SKILL.MD) — 状態を共有せず順序依存もない 2 つ以上のタスクを、並列の subagent に分散させるための指針。
- [requesting-code-review](requesting-code-review/SKILL.MD) — マージ前や機能完成時に reviewer subagent を立ち上げてセルフレビューさせる。レビュアーには会話履歴ではなく必要な文脈だけを渡す。
- [receiving-code-review](receiving-code-review/SKILL.MD) — レビュー指摘を受け取る側の振る舞い。同意の演技や盲目的な反映ではなく、技術的に検証してから取り込む。
- [verification-before-completion](verification-before-completion/SKILL.MD) — 「完了した」「直った」と主張する前に検証コマンドを実走し、出力で裏付けを取らせる規律。エビデンス先行・主張は後。
- [writing-skills](writing-skills/SKILL.MD) — 新しい Skill を書く / 既存 Skill を編集する / デプロイ前に動作を確認するときの作法をまとめたメタスキル。
- [using-superpowers](using-superpowers/SKILL.MD) — 会話開始時に必ず読み込まれるメタスキル。他のスキルを発見・呼び出すためのフックとして働く。

## 新しい Skill を追加するときの目安

1. `skills/<skill-name>/SKILL.md` を作る（ディレクトリ名と `name` を揃える）
2. `description` に **トリガーになるユーザー発話の特徴** を具体的に書く（"〜と言ったとき" レベルの粒度）
3. 本文は手順だけでなく、**アンチパターン** と **判断基準（迷ったときどう決めるか）** を書く
4. 関連 Skill があれば相対リンクで相互参照する
