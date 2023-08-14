# Subject note

K3sとK3s、Vagrantの使い方を学ぶ課題。Ingressを使用したいので、kindではなくK3sを使用する。
## Part 1
- 1CPU, 512MB or 1024MBで構築することを強くおすすめする
    - なぜ？
### 要件
- 以下の要件を満たすvagrantfileを作成する
- Server
    - eth1
        - 192.168.56.110
    - K3sをcontroller modeでインストールする
- ServerWorkers
    - eth1
        - 192.168.56.111
    - K3sをagent modeでインストールする
- パスワードなしでSSH接続できるようにする

## Part2
- Virtual machine1つとserver modeでインストールされたK3sが必要
- K3sインスタンスで実行できるウェブアプリケーションを適当に３つ選ぶ
- Host
    - 192.168.56.110
    - name: ymoriS
- ホストが指定されたら、そのホストにアクセスできるようにする
- デフォルトはapp3
- 実行コマンド curl -H "Host:app2.com" 192.168.42.110

### Part3
VagrantではなくDockerを使用する
使用するPackageなどをインストールするためのスクリプトを作成しておくとよい。
- 以下の２つのnamespaceを作成する
    - Argo CDs
    - dev
        - アプリケーションを格納しておくもの
        - Argo CDによって自動的にデプロイされる
        - 自分のGitHubリポジトリを使用する
            - Configuration fileを自分のリポジトリにpushしておく
            - メンバーのlogin名をリポジトリの名前に入れ込んでおいてください
    - taggingによって２つのバージョンを管理できるようにしておく
    - 
    - 


