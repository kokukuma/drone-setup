# Drone.ioのsetup
## 準備
### install drone command
```
brew tap drone/drone
brew install drone
```

### install gcloud
+ [Cloud SDK のインストール](https://cloud.google.com/sdk/downloads?hl=ja)

### install terraform
+ [getting-started/install](https://www.terraform.io/intro/getting-started/install.html)

### gihtubのtoken取得
+ [Register a new OAuth application](https://github.com/settings/applications/new)
+ Client IDと Client Secretを作っておく.
+ Homepage URLとAuthorization callback URLは後から作成された物を追加する

### 環境変数
+ direnvに書いておく.
```
// configmapに設定されるもの
export DRONE_GITHUB_URL="https://github.com" // gitubのurl
export DRONE_HOST="" // terraformで構築するときは内部で設定される

// secret経由で渡されるもの
export DRONE_GITHUB_CLIENT=""       // 作ったやつ
export DRONE_GITHUB_SECRET=""       // 作ったやつ
export DRONE_SECRET=random-string   // 
export MYSQL_PASSWORD="password"    // 
export DRONE_DATABASE_DATASOURCE="root:password@tcp(mysql-service:3306)/drone?parseTime=true"

// secretに設定されるもの
export DRONE_GITHUB_CLIENT_BASE64=$(echo -n ${DRONE_GITHUB_CLIENT} | base64 )
export DRONE_GITHUB_SECRET_BASE64=$(echo -n ${DRONE_GITHUB_SECRET} | base64 )
export DRONE_SECRET_BASE64=$(echo -n ${DRONE_SECRET} | base64 )
export MYSQL_PASSWORD_BASE64=$(echo -n ${MYSQL_PASSWORD} | base64 )
export DRONE_DATABASE_DATASOURCE_BASE64=$(echo -n ${DRONE_DATABASE_DATASOURCE} | base64 )

// terraform実行時に読まれる物
export TF_VAR_project=''
export TF_VAR_region=''
export TF_VAR_zone=''
```

## Drone立ち上げ
### terraform

+ 実行
```
terraform plan terraform
terraform apply terraform
```

### 実行確認
+ コマンドから実行
  + .drone.yamlを設置したレポジトリを作る
  + drone commandから実行する
  ```
  drone exec --local
  ```

+ CIとして実行
  + Drone.io上で, レポジトリをアクティベイトする.
  + PRを作成してpushする

## その他
+ [drone自体をlocal上で実行する場合](docs/local.md)
+ [トラブルシューティング](docs/trouble.md)


## 資料
+ [droneのdeployment](https://github.com/vallard/drone-kubernetes/blob/master/drone-server.yaml)
+ [droneのdeployment2](https://github.com/appleboy/drone-on-kubernetes/blob/master/gke/drone-server-deployment.yaml)
+ [terraform](https://www.terraform.io/docs/providers/google/r/container_cluster.html) 

## 課題
+ 割り当てるスペックが雑
  + nodeのspecを利用するpodからちゃんと考える

+ droneの接続先がIPのまま
  + これだと, 立ち上げる度にIP変わる
    + github OAuthのURL設定するものめんどくさいし.
    + staticにしたものをずっと保持し続けるでもありかな...
      + terraformで管理外になるけど.
      + GCSもそうだしいいかな...

+ 認証とかパスワードとかその辺
  + mysqlのuser名 / password
  + 設定すべき環境変数がけっこうぐちゃってる

+ teraffomr destroyしてもkubernetesのingの設定消せてない
  + kubectl delete ingしてるけど, なんか残るな...
    + ネットワークサービス-負荷分散-ロードバランサ/バックエンド
    + ComputeEngine-インスタンスグループ
  + 暫定対応として, 
    + `kubectl --namespace drone delete ing drone` をして, 消えたのを見てからdestroy...

+ kubernetes.tf、他の環境で動かすためには前提がある
  + 少なくともgcloud / kubectlが動かないと.
  + あとdirenvに書いてあるたくさんの環境変数

+ kubernetesのprovider, deployementに対応したらそっちで書き直す.
  + destroyしたときの挙動とか
