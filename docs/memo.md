## Memo
### clusterを作る
+ cluster作る
  + [同じプロジェクトならGCRにアクセスするためにscope追加とかする必要はない](https://cloud.google.com/container-registry/docs/using-with-google-cloud-platform?hl=ja)
```
gcloud container clusters create my-cluster
```
```
gcloud container clusters list
```

+ 永続化volume作成
```
gcloud compute disks create --size=500GB drone-volume
```

+ 静的IPアドレスの割当
```
gcloud compute addresses create drone-static-ip --global
```


### kubernetesでの実行

+ Kubernetesの名前空間を作る
```
kubectl create ns drone
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
kubectl --namespace drone exec -it mysql-84db84fb8d-wt5hk mysql -u root -ppassword -e 'create database if not exists drone;'

```

