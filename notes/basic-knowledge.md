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


## ネットワークインターフェースについて

- subjectの記載では、`eth1`を使用するように指定されているが？
  - Linuxにおいてネットワークインターフェースの命名規則が変わったらしい
    - `eth0` -> `enp0s3` に相当
    - `eth1` -> `enp0s8` に相当
    - [CentOS 7のネットワーク名「enp1s0」という文字列の謎に迫る](https://qiita.com/fetaro/items/b61282130fa638de4528)

## TLS証明書

- [KubernetesのTLS証明書](https://qiita.com/nsawa/items/4f11ac89707aad2c3d4a)