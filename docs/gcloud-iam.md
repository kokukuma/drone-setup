## サービスアカウントの作成
### 付けるべき権限
+ [権限一覧](https://cloud.google.com/iam/docs/understanding-roles?hl=ja)
+ GCE
  + Podに割り当てるdiskを作る
  + 静的IPの設定
  + その他, GKEから勝手に使われる
+ GKE
  + roles/container.admin
    + Kubernetesクラスタを作る/削除する
+ GCR: コンテナレジストリ
  + roles/cloudbuild.builds.editor
    + Podで使うimageを登録する
+ ※
  + 一つ一つ付けるのはめんどくさすぎるので, 一旦, roles/owner.

### terraform用のサービスアカウントを作る
+ IAMのサービスアカウントを作成する
```
gcloud iam service-accounts create terraform-account \
    --display-name terraform-account
```

+ 作ったサービスアカウントのemailを確認
```
export SA_EMAIL=$(gcloud iam service-accounts list --filter="displayName:terraform-account" --format='value(email)')
export PROJECT=$(gcloud info --format='value(config.project)')
```

+ 作ったサービスアカウントに権限を付与
```
gcloud projects add-iam-policy-binding $PROJECT \
    --role roles/owner \
    --member serviceAccount:$SA_EMAIL
```

+ サービスアカウントのKeyをダウンロード
```
gcloud iam service-accounts keys create drone-sa.json --iam-account $SA_EMAIL
```

### Drone用のサービスアカウントを作る
+ IAMのサービスアカウントを作成する
```
gcloud iam service-accounts create  drone-account \
    --display-name drone-account
```

+ 作ったサービスアカウントのemailを環境変数に入れておく
```
export SA_EMAIL=$(gcloud iam service-accounts list --filter="displayName:drone-account" --format='value(email)')
export PROJECT=$(gcloud info --format='value(config.project)')
```

+ 作ったサービスアカウントに権限を付与
```
gcloud projects add-iam-policy-binding $PROJECT \
    --role roles/cloudsql.editor \
    --role roles/cloudsql.client \
    --role roles/storage.admin \
    --member serviceAccount:$SA_EMAIL
```

+ サービス アカウント キーをダウンロード
  + 最終的には, Kubernetes Engineにアップロードする
```
gcloud iam service-accounts keys create drone-sa.json --iam-account $SA_EMAIL
```
