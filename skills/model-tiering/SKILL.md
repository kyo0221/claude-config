---
name: model-tiering
description: Use whenever dispatching subagents via the Agent tool (parallel agents, subagent-driven development, background tasks). Assigns the right model per task tier - judgment/planning/integration stays in the main session (fable), coding/debugging/review goes to sonnet, simple mechanical work (file organization, bulk search, log extraction) goes to haiku.
---

# サブエージェントのモデル使い分け（Model Tiering）

## 概要

Agent ツールでサブエージェントを起動するときは、タスクの性質に応じて `model` パラメータを**必ず明示**する。指定を省略すると親モデルを継承し、単純作業に高コストなモデルを使うことになる。

## モデル割り当て表

| Tier | model | 対象タスク |
|------|-------|-----------|
| 判断・統合 | 委譲しない（メインセッション = fable が担当） | タスク分解、計画立案、結果の統合、設計判断、最終レビュー、コンフリクト解消 |
| 実装 | `sonnet` | コーディング、デバッグ、テスト作成、モジュール単位のコードレビュー、リファクタリング、ドキュメント執筆 |
| 単純作業 | `haiku` | ファイル整理・移動・リネーム、大量 grep・全数調査、ログ抽出・集計、フォーマット変換、定型ボイラープレート生成 |

## Tier 判定ルール

迷ったら次の順で判定する:

1. **「何をすべきか自体を決める」タスクか？** → 委譲しない。メインセッション（fable）が自分で行う。
2. **「コードを書く・直す・レビューする」タスクか？** → `sonnet`
3. **「手順が明確で、間違えてもやり直しが容易な機械的作業」か？** → `haiku`
4. haiku か sonnet か迷う場合 → 判断・読解の比重が少しでもあれば `sonnet`

## 運用ルール

- **fable の仕事は委譲しない**: 判断・統合のためだけにサブエージェントを立てない。メインが fable なので `opus` への委譲も原則不要。
- **プロンプトは自己完結させる**: サブエージェントは会話コンテキストを持たない。対象パス、期待成果物、報告フォーマット、制約（変更禁止ファイル、触ってよいディレクトリ）をプロンプトにすべて書く。
- **独立タスクは並列起動**: 依存関係のないタスクは同一メッセージで複数 Agent を起動する。依存があるものは前段の結果を待ってから起動する。
- **エスカレーション**: haiku の作業中に判断が必要と判明したら sonnet で再実行する。sonnet が設計判断で詰まったら、その判断はメインセッションに戻す（サブエージェント同士で決めさせない）。
- **TDD 準拠**: sonnet にコーディングを委譲するときは、テスト先行（失敗するテストを先に書く → 失敗を確認 → 実装 → パス確認）の手順をプロンプトに含める。
- **報告フォーマットを指定する**: 「変更ファイル一覧 / 実行したテストと結果 / 未解決事項・懸念」を必ず報告させ、メインセッションが検証・統合する。

## 呼び出し例

```
Agent(
  subagent_type: "general-purpose",
  model: "sonnet",
  description: "obstacle_detector のバグ修正",
  prompt: "リポジトリ: ~/formula_ws/src/perception。obstacle_detector ノードで
    クラスタ数が 0 のとき publish がクラッシュする。まず失敗する gtest を
    test/ に追加して失敗を確認し、その後修正してテストをパスさせること。
    報告: 変更ファイル一覧、テスト実行コマンドと結果、未解決事項。"
)

Agent(
  subagent_type: "general-purpose",
  model: "haiku",
  description: "launch ファイルの一覧化",
  prompt: "~/formula_ws/src 以下の全 *.launch.py を再帰的に探し、
    パッケージ名・ファイルパス・起動ノード名を Markdown 表にして報告すること。
    ファイルの変更は禁止。"
)
```

関連スキル: [dispatching-parallel-agents]（並列化の判断基準）、[subagent-driven-development]（計画実行のワークフロー）。これらでサブエージェントを起動する際も本スキルのモデル割り当てを適用する。
