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
