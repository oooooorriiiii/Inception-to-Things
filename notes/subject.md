# Subject note

K3sとK3s、Vagrantの使い方を学ぶ課題。Ingressを使用したいので、kindではなくK3sを使用する。

## Part 1

### 要件

- 以下の要件を満たすvagrantfileを作成する
- Server
  - IP: `192.168.56.110`
  - K3sをcontroller modeでインストールする
- ServerWorker
  - IP: `192.168.56.111`
  - K3sをagent modeでインストールする
- パスワードなしでSSH接続できるようにする

### Vagrantfile

1. `vagrant init`でVagrantfileを作成する
2. 上記を要件を満たすようにVagrantfileを編集する
  - VMのイメージはLinux distribution の latest stable version であれば何でもよい
  - 2024/9時点では、Ubuntu 24.04 LTSが最新のLTSバージョンだが、Vagrant Cloudにイメージがないため、22.04 LTS（[`ubuntu/jammy64`](https://app.vagrantup.com/ubuntu/boxes/jammy64)）を使用することにした
3. `vagrant up`でVMを起動する
4. `vagrant ssh`でVMに接続する ← デフォルトでパスワードなしでSSH接続できる

#### Tips

- ネットワークインターフェースについて
  - subjectの記載では、`eth1`を使用するように指定されているが？
    - Linuxにおいてネットワークインターフェースの命名規則が変わったらしい
      - `eth0` -> `enp0s3` に相当
      - `eth1` -> `enp0s8` に相当
      - [CentOS 7のネットワーク名「enp1s0」という文字列の謎に迫る](https://qiita.com/fetaro/items/b61282130fa638de4528)
    - そのため、`enp0s8`でipアドレスが`192.168.56.110`, `192.168.56.111`になっていれば問題ない

### K3sのインストール

#### Server

- Vagrantfile内で実行するためのスクリプトを作成する
  - [Quick-Start Guide - K3S](https://docs.k3s.io/quick-start)
  - 基本的にはドキュメントに沿ってスクリプトを作成する
  - node ipを付与するために`--node-ip`だけ追加している
- Control Planeのトークンを取得する
  - このあとWorker node（k3sではagent）を追加していくときに、Master node（k3sではServer）のトークンが必要なため、トークンを取得しておく
  - `sudo cat /var/lib/rancher/k3s/server/token > /vagrant/token.env`
    - ちなみに、Vagrantはマウントの設定を明記しなくてもデフォルトでゲストVMの`/vagrant`ディレクトリをホストマシンのカレントディレクトリにマウントしてくれる。

#### ServerWorker

- Vagrantfile内で実行するためのスクリプトを作成する
  - agentとしてnodeを建てるため、`agent`オプション、Server nodeのIPアドレスとポート（`--server https://192.168.56.110:6443`）、保存しておいたServer nodeのトークン（`-t $(cat /vagrant/token.env)`）を指定する
  - node ipを付与するために`--node-ip`も追加する

#### Tips

- このあたりは、KubeadmでもMinikubeでもkindでもだいたい同じような操作となるため、一度経験しておくとその知識を使い回せてよい

### 確認

- Nodeが２つ立ち上がっていることを確認する
  - `kubectl get nodes`でnodeが２つ表示されていればよい
- HostのIPアドレスの確認
  - `ifconfig`で`enp0s8`のIPアドレスがそれぞれ`192.168.56.110`, `192.168.56.110`となっていればよい

## Part2

- Virtual machine1つとserver modeでインストールされたK3sが必要
- K3sインスタンスで実行できるウェブアプリケーションを適当に３つ選ぶ
- Host
    - 192.168.56.110
    - name: ymoriS
- ホストが指定されたら、そのホストにアクセスできるようにする
- デフォルトはapp3
- 実行コマンド curl -H "Host:app2.com" 192.168.42.110

## Part3

VagrantではなくDocker(k3d)を使用する
使用するPackageなどをインストールするためのスクリプトを作成しておくとよい。
- 以下の２つのnamespaceを作成する
  - `argocd`
  - `dev`
    - アプリケーションを格納しておくもの
    - Argo CDによって自動的にデプロイされる
    - 自分のGitHubリポジトリを使用する
      - Configuration fileを自分のリポジトリにpushしておく
      - メンバーのlogin名をリポジトリの名前に入れ込んでおいてください
    - taggingによって２つのバージョンを管理できるようにしておく

### Argo CD

- [Getting Started - Argo CD](https://argo-cd.readthedocs.io/en/stable/getting_started/)
  - 2. Download Argo CD CLI
    - 以下のページから適した方法でインストールする
      - [Installation - Argo CD](https://argo-cd.readthedocs.io/en/stable/cli_installation/)
  - 3. Access The Argo CD API Server
    - Port forwardingがいちばん簡単
    - 以下のコマンドを実行して、Argo CDのUIにアクセスする
      ```bash
      kubectl port-forward svc/argocd-server -n argocd 8080:443
      ```
    - ブラウザで`http://localhost:8080`にアクセスする（デフォルトで127.0.0.1:8080）
    - ログイン情報は以下の通り
      - username: admin
      - password: `argocd admin initial-password -n argocd`で取得する

## Tips

- dockerのバージョンは最新にしておく。
  - CNCFのプロジェクトではバージョンの不一致で諸々の問題が発生することがあるため、バージョンを揃えておくとよい。
    - 今回の課題で引いたバグの例
      - https://github.com/argoproj/argo-cd/issues/11647
      - https://github.com/argoproj/argo-cd/issues/9809


