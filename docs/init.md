## 事前準備
### install drone command
```
brew tap drone/drone
brew install drone
```

## ローカル
### install gcloud
+ [Cloud SDK のインストール](https://cloud.google.com/sdk/downloads?hl=ja)

### install terraform
+ [getting-started/install](https://www.terraform.io/intro/getting-started/install.html)

### 環境変数
+ direnvに書いておく.
```
// configmapに設定されるもの
export DRONE_GITHUB_URL="https://github.com" // gitubのurl

// secret経由で渡されるもの
export DRONE_GITHUB_CLIENT=""       // 作ったやつ
export DRONE_GITHUB_SECRET=""       // 作ったやつ
export DRONE_ADMIN=""               // ログインを許可したいユーザ
export DRONE_SECRET=random-string   //
export DRONE_DATABASE_DATASOURCE="proxyuser@tcp(127.0.0.1:3306)/drone?parseTime=true"

// secretに設定されるもの
export DRONE_GITHUB_CLIENT_BASE64=$(echo -n ${DRONE_GITHUB_CLIENT} | base64 )
export DRONE_GITHUB_SECRET_BASE64=$(echo -n ${DRONE_GITHUB_SECRET} | base64 )
export DRONE_SECRET_BASE64=$(echo -n ${DRONE_SECRET} | base64 )
export DRONE_DATABASE_DATASOURCE_BASE64=$(echo -n ${DRONE_DATABASE_DATASOURCE} | base64 )
export CLOUDSQL_CREDENTIALS_BASE64=$(cat drone-sa.json | base64)

// terraform実行時に読まれる物
export TF_VAR_project=''
export TF_VAR_region=''
export TF_VAR_zone=''
export TF_VAR_credentials_file=''

// terraform内で設定されるので, ローカルでしか意味がないもの
// export DRONE_HOST=""
// export DRONE_DB_CONN_NAME=""
```

## Github
### gihtubのtoken取得
+ [Register a new OAuth application](https://github.com/settings/applications/new)
+ Client IDと Client Secretを作っておく.
+ Homepage URLとAuthorization callback URLは後から作成された物を追加する

## GCP
### terraformを操作する用のサービスアカウントの作成
+ [サービスアカウントの作成 ](docs/gcloud-iam.md)
  + json keyを取得する
  + これもterraformにしておきたい..
+ role
  + roles/owner

### Drone用のサービスアカウントの作成
+ [サービスアカウントの作成 ](docs/gcloud-iam.md)
  + json keyを取得する
  + これもterraformにしておきたい..
+ role
  + roles/cloudsql.editor
  + roles/cloudsql.client
  + roles/cloudbuild.builds.editor

### terraformのbucket作成
+ GCSに作成しておく.
```
```

### terraformの
+ CloudSQLのinstanceを作成しておく.
```
gcloud sql instances create drone-db --region=asia-east1
```





