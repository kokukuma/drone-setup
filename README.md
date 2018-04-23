# Drone.ioのsetup
## 構造
+ GKE上でdroneを動かす
+ 操作したい範囲で便宜上レイヤを想定している
  + persistence : disk, static ipの設定
  + cluster     : GKE clusterの設定
  + kubernetes  : droneの設定

## 構築
+ [事前準備](docs/init.md) をやる
+ 環境の構築用のコマンドを実行する.
  ```
  terraform init terraform  # 最初だけ必要
  terraform plan terraform  # dry run
  terraform apply terraform # 適用
  ```
+ レイヤ毎に起動/破棄を制御したい場合は[terraformの使い方](docs/terraform.md)を読む
+ ちなみに, ingressにip割り当てられてから, 実際につなげるようになるまでに5分そこそこかかる. いったい何をやってるんだか.


## レポジトリの登録
### CIしたいレポジトリをactivateする
+ メニューのRepositoriesを選択.
+ 必要なレポジトリにチェックを入れる

### DroneのTOKENを取得する
+ droneコマンドを実行するために必要
+ メニューのTokenから取得して, 環境変数に設定しておく.
  ```
  export DRONE_SERVER=""
  export DRONE_TOKEN=""
  ```
+ コマンドが使えるようになっている
  ```
  drone info
  ```

### secret / registroyを登録
+ 各レポジトリで実行する内容によって, secretやregistoryの設定をする必要がある.
+ web ui上からも一応できる
+ secret
  + 例えば, gcpのcredentialsとか
    ```
    drone secret add \
      --repository karino-t/test-drone \
      --image plugins/gcr \
      --name google_credentials \
      --value $GOOGLE_CREDENTIALS # GOOGLE_CREDENTIALS=$(cat proj-gcp-sa.json | base64)
    ```
  + 例えば, slackのwebhookurlとか
    ```
    drone secret add \
      --repository karino-t/test-drone \
      --image plugins/slack \
      --name slack_webhook \
      --value $SLACK_WEBHOOK  # SLACK WEBHOOK URL
    ```
+ registory
  + GCR
    ```
    drone registry add \
        --repository karino-t/test-drone \
        --hostname gcr.io \
        --username _json_key \
        --password @drone-sa.json
    ```

## CIを実行
### コマンドで実行
+ drone commandから実行する
  ```
  drone exec --local
  ```

### CIとして実行
+ Drone.io上で, レポジトリをactivateする.
+ PRを作成してpushする

## その他
+ [drone自体をlocal上で実行する場合](docs/local.md)
+ [トラブルシューティング](docs/trouble.md)

## 資料
+ [droneのdeployment](https://github.com/vallard/drone-kubernetes/blob/master/drone-server.yaml)
+ [droneのdeployment2](https://github.com/appleboy/drone-on-kubernetes/blob/master/gke/drone-server-deployment.yaml)
+ [terraform](https://www.terraform.io/docs/providers/google/r/container_cluster.html)

## 課題
### cluster落とすとデータ消える状態
+ mysqlはkubernetesに乗せるものじゃないな. たぶん.

### 割り当てるスペックが雑
+ nodeのspecを利用するpodからちゃんと考える

### droneの接続先がIPのまま
+ これだと, 立ち上げる度にIP変わる
  + github OAuthのURL設定するものめんどくさいし.
  + staticにしたものをずっと保持し続けるでもありかな...
    + terraformで管理外になるけど.
    + GCSもそうだしいいかな...

### 認証とかパスワードとかその辺
+ mysqlのuser名 / password

### kubernetes.tfが微妙.
+ kubernetesのprovider, deployementに対応したらそっちで書き直す.
+ kubernetes.tf、他の環境で動かすためには前提がある
  + 少なくともgcloud / kubectlが動かないと.
  + あとdirenvに書いてあるたくさんの環境変数
