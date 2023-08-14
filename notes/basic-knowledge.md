# 基礎知識
## K3s
- https://k3s.io/
- Lightweight Kubernetes
### Architecture
- Server nodeは`k3s server`コマンドを実行するホストとして定義される
- コントロールプレーンとデータストアコンポーネントを管理する
- Agent nodeは`k3s agent`コマンドを実行するホストとして定義される
- コントロールプレーンとデータストアコンポーネントを持たない
- ServerとAgentのどちらもkuberlet, container runtime, CNIを実行できる
- ![How it Works](images/how-it-works-k3s-revised.svg "How it Works")
## K3b
- Dockerコンテナ内でK3sを起動するためのツール
- マルチノード構成のKubernetes環境を構築することができる
- Serverコンテナ
    - KubernetesのMasterに相当する
- Agentコンテナ
    - KubernetesのWorkerに相当する
- 