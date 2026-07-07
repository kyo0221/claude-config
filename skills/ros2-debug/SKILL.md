---
name: ros2-debug
description: Use when debugging ROS 2 systems - nodes not communicating, topics missing or silent, TF errors, QoS mismatches, colcon build failures, rosbag replay issues, nav2/localization misbehavior. Provides a systematic diagnosis checklist instead of guessing.
---

# ROS 2 デバッグ手順（Humble）

「動かない」の報告から原因を推測でいじり始めない。以下の順で切り分けてから修正に入る。

## 0. 環境の確認（最初に必ず）

```bash
echo $ROS_DISTRO                # 期待: humble
echo $ROS_DOMAIN_ID             # 通信しないときは端末間の不一致を疑う
which python3 && python3 -c "import rclpy" 2>&1   # venv/conda 混入の検出
```

- ワークスペースの source 順序: `/opt/ros/humble/setup.bash` → `install/setup.bash`。underlay/overlay の取り違えは「古いコードが動く」症状になる。
- `--symlink-install` でビルドしていない場合、Python ノードの編集は再ビルドまで反映されない。

## 1. ノード・トピックの生存確認

```bash
ros2 node list
ros2 node info /node_name              # 実際の購読/配信を確認
ros2 topic list
ros2 topic hz /topic                    # 出てるか・レートは期待通りか
ros2 topic echo /topic --once           # 中身は妥当か
```

- 「トピックはあるが echo に何も出ない」→ 次の QoS 節へ。
- ノードが list に出ない → 起動ログを確認（クラッシュ、パラメータ未定義、remap ミス）。

## 2. QoS 不一致（ROS 2 で最頻出）

```bash
ros2 topic info /topic --verbose        # publisher/subscriber 両方の QoS を見る
```

- 典型: センサ側 `BEST_EFFORT` × 購読側 `RELIABLE` → 一切届かない（エラーも出ない）。
- `TRANSIENT_LOCAL`（latched 相当）の不一致は map や /tf_static で起きやすい。
- rosbag 再生時は QoS override を使う: `ros2 bag play <bag> --qos-profile-overrides-path <yaml>`（formula_ws には `rosbag_qos_profile.yaml` がある）。

## 3. TF の切り分け

```bash
ros2 run tf2_tools view_frames          # frames.pdf でツリーの分断を確認
ros2 run tf2_ros tf2_echo map base_link # 特定の変換が引けるか・時刻は妥当か
ros2 topic echo /tf_static --once
```

- 「Lookup would require extrapolation into the past/future」→ 時刻同期（sim time / センサドライバの stamp / `use_sim_time` の不統一）を疑う。
- `use_sim_time` は**全ノードで**一致させる。rosbag / シミュレータ再生時の定番事故。

## 4. パラメータ・ライフサイクル

```bash
ros2 param dump /node_name
ros2 lifecycle get /node_name           # nav2 系は unconfigured のまま止まっていないか
```

## 5. ビルド問題（colcon）

```bash
cd <ws> && colcon build --symlink-install --packages-select <pkg> --event-handlers console_direct+
colcon list --packages-up-to <pkg>      # 依存の把握
rm -rf build/<pkg> install/<pkg>        # キャッシュ疑いのときだけ、パッケージ単位で
```

- ヘッダが見つからない: `package.xml` と `CMakeLists.txt` の依存宣言の両方を確認。
- ビルド全消し（`rm -rf build install log` 全体）は最終手段。まずパッケージ単位で。

## 6. ログ

```bash
ros2 run <pkg> <node> --ros-args --log-level debug
ls -t ~/.ros/log | head                 # launch 経由のクラッシュログ
```

## 報告の形式

原因を特定したら「症状 → 切り分けで確認した事実 → 原因 → 修正方針」の順で報告する。修正がコード変更を伴う場合は、可能なら再現テスト（失敗するテスト）を先に用意してから直す。
