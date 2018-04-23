## トラブルシューティング
### podが起動しないときは
+ イベントを見る
```
kubectl get pod
kubectl logs po/name..
kubectl describe po/name..
kubectl exec -it pod_name -c container_name -- cat file
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

### googleアカウントを変更した場合
+ backend gcpでterraform initした場合使われるgoogleアカウントはデフォルトのもの
  + 以下で変更する.
```
gcloud beta auth application-default login
```
```
gcloud compute project-info add-metadata \
    --metadata google-compute-default-region=europe-west1,google-compute-default-zone=europe-west1-b
```

### GKE上で, GCRからimage pull出来なかった
+ 多分scopeが足りない?
  + [](https://cloud.google.com/sdk/gcloud/reference/alpha/compute/instances/set-scopes)
+ 何も指定しなかった場合はいかが設定される
    ```
    ユーザー情報                無効
    Compute Engine              読み取り / 書き込み
    ストレージ                  読み取りのみ
    タスクキュー                無効
    BigQuery                    無効
    Cloud SQL                   無効
    Cloud Datastore             無効
    Stackdriver Logging API     書き込みのみ
    Stackdriver Monitoring API  フル
    Cloud Platform              無効
    Bigtable データ             無効
    Bigtable 管理               無効
    Cloud Pub/Sub               無効
    サービス コントロール       有効
    サービス管理                読み取りのみ
    Stackdriver Trace           書き込みのみ
    Cloud Source Repositories   無効
    Cloud デバッガ              無効
    ```
+ Droneのregistoryに追加
