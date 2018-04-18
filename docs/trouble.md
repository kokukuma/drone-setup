## トラブルシューティング
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

### googleアカウントを変更した場合
+ backend gcpでterraform initした場合使われるgoogleアカウントはデフォルトのもの
  + 以下で変更する.
```
gcloud beta auth application-default login
```
