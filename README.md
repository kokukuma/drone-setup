# drone.ioのsetup
## drone command
```
brew tap drone/drone
brew install drone
```

## local上での実行
+ [ngrok](https://dashboard.ngrok.com/get-started)
```
ngrok http 8080
```

+ Register a new OAuth application
  + https://github.com/settings/applications/new

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

## 実行確認
+ コマンドから実行
  + .drone.yamlを設置したレポジトリを作る
  + drone commandから実行する
  ```
  drone exec --local
  ```

+ CIとして実行
  + Drone.io上で, レポジトリをアクティベイトする.
  + PRを作成してpushする


## kubernetes上での実行
+ cluster作る
  + [同じプロジェクトならGCRにアクセスするためにscope追加とかする必要はない](https://cloud.google.com/container-registry/docs/using-with-google-cloud-platform?hl=ja)
```
gcloud container clusters create my-cluster
```
```
gcloud container clusters list
```

+ Kubernetesの名前空間を作る
```
kubectl create ns drone
```

+ 永続化volume作成
```
gcloud compute disks create --size=500GB drone-volume
```

+ 静的IPアドレスの割当
```
gcloud compute addresses create drone-static-ip --global
```



+ pod作る
  + 環境変数の設定(direnv便利)
  ```
  export DRONE_HOST="http://******.ngrok.io"
  export DRONE_GITHUB_CLIENT="*****"
  export DRONE_GITHUB_SECRET="*****"
  export DRONE_SECRET=random-string
  export DRONE_GITHUB_URL="https://github.com"

  export DRONE_GITHUB_CLIENT_BASE64=$(echo ${DRONE_GITHUB_CLIENT} | base64 )
  export DRONE_GITHUB_SECRET_BASE64=$(echo ${DRONE_GITHUB_SECRET} | base64 )
  export DRONE_SECRET_BASE64=$(echo ${DRONE_SECRET} | base64 )
  ```

  + configmap, secretを作成する
  ```
  envsubst < k8s/config/configmap.yaml | kubectl apply -f -
  envsubst < k8s/config/secret.yaml | kubectl apply -f -
  ```

  + service/deploymentを作成する
  ```
  kubectl apply -f k8s/lb/
  kubectl apply -f k8s/volume/
  kubectl apply -f k8s/mysql/
  kubectl apply -f k8s/drone/
  ```

  + ちゃんと出来てるか確認する
  ```
  kubectrl get pod --namespace drone
  ```

### mysql起動後
+ drone databaseを作る
```
kubectl --namespace drone exec -it mysql-84db84fb8d-wt5hk /bin/bash
mysql -u root -ppassword
create database if not exists drone;
```

## トラブルシューティン部
### podが起動しないときは
+ イベントを見る
```
kubectrl get pod
kubectrl logs po/name..
kubectrl describe po/name..
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

### 課題
+ GKE上で動かした場合, gheからのcloneが出来てなさげ...
+ 


## 資料
+ https://github.com/vallard/drone-kubernetes/blob/master/drone-server.yaml
+ https://github.com/appleboy/drone-on-kubernetes/blob/master/gke/drone-server-deployment.yaml
