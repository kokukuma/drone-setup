# drone.ioのsetup
## drone command
```
brew tap drone/drone
brew install drone
```

## 準備
### gihtubのtoken取得
+ [Register a new OAuth application](https://github.com/settings/applications/new)

### 環境変数
+ 確認

## local上での実行
### ngrok起動
+ [ngrok](https://dashboard.ngrok.com/get-started)
```
ngrok http 8080
```

### droneを起動
+ 起動
  + http://readme.drone.io/0.8/install/server-configuration/
```
cd local

DRONE_HOST="http://******.ngrok.io" \
DRONE_GITHUB_CLIENT="*****" \
DRONE_GITHUB_SECRET="*****" \
DRONE_SECRET=random-string \
DRONE_GITHUB_URL="https://github.com" \
docker-compose up
```

+ portforward
```
docker-machine ssh default -N -f -g -L 8080:localhost:8080
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

## GKEで実行する
### terraform
+ [terraform](https://www.terraform.io/docs/providers/google/r/container_cluster.html) を実行

+ 実行
```
terraform plan terraform
terraform apply terraform
```


### 実行確認
+ ローカルと同様

## その他
### podが起動しないときは
+ イベントを見る
```
kubectl get pod
kubectl logs po/name..
kubectl describe po/name..
```

### kubernetesのuiをみる
+ token確認
```
kubectl config view
```
+ proxy起動
```
kubectl proxy -p 8002
```
+ http://localhost:8002/ui
  + toeknを入力してログイン


### 資料
+ https://github.com/vallard/drone-kubernetes/blob/master/drone-server.yaml
+ https://github.com/appleboy/drone-on-kubernetes/blob/master/gke/drone-server-deployment.yaml


## 設定すべき環境変数
```
export DRONE_HOST=""
export DRONE_GITHUB_CLIENT=""
export DRONE_GITHUB_SECRET=""
export DRONE_SECRET="random-string"
export DRONE_ORGS=""
export MYSQL_PASSWORD="password"
export DRONE_DATABASE_DATASOURCE="root:password@tcp(mysql-service:3306)/drone?parseTime=true"
export DRONE_GITHUB_URL=""

export DRONE_GITHUB_CLIENT_BASE64=$(echo -n ${DRONE_GITHUB_CLIENT} | base64 )
export DRONE_GITHUB_SECRET_BASE64=$(echo -n ${DRONE_GITHUB_SECRET} | base64 )
export DRONE_SECRET_BASE64=$(echo -n ${DRONE_SECRET} | base64 )
export MYSQL_PASSWORD_BASE64=$(echo -n ${MYSQL_PASSWORD} | base64 )
export DRONE_DATABASE_DATASOURCE_BASE64=$(echo -n ${DRONE_DATABASE_DATASOURCE} | base64 )

export TF_VAR_project=""
export TF_VAR_region=""
export TF_VAR_zone=""
```

## 課題
+ 立ち上げたあとの出力を整理したい
  + つぎなにすればいいか

+ droneの接続先がIPのまま
  + これだと, 立ち上げる度にIP変わる
    + github OAuthのURL設定するものめんどくさいし.
    + staticにしたものをずっと保持し続けるでもありかな...
      + terraformで管理外になるけど.
      + GCSもそうだしいいかな...

+ 認証とかパスワードとかその辺
  + mysqlのuser名 / password
  + 設定すべき環境変数がけっこうぐちゃってる

+ 割り当てるスペックが雑
  + nodeのspecを利用するpodからちゃんと考える

+ teraffomr destroyしてもkubernetesのingの設定消せてない
  + kubectl delete ingしてるけど, なんか残るな...
    + ネットワークサービス-負荷分散-ロードバランサ/バックエンド
    + ComputeEngine-インスタンスグループ
  + 自分でロードバランサとかバックエンドサービスとか作って、
    + それをIngressの設定で明示的に使うとかした（static ip割り当てるときみたいに）ら、うまくいかないかな。。


+ kubernetes.tf、他の環境で動かすためには前提がある
  + 少なくともgcloud / kubectlが動かないと.
  + あとdirenvに書いてあるたくさんの環境変数

+ kubernetesのprovider, deployementに対応したらそっちで書き直す.
  + destroyしたときの挙動とか


