## terraform使い方
### 初回
```
terraform init terraform
```

### 全てのレイヤを操作する
最初の作成, 全てをなかったことにするときに使う

+ 作成
```
terraform apply terraform
```

+ 破棄
```
terraform destroy terraform
```

### cluster/kubernetesレイヤを操作する
一旦止めておきたいけど, データは消したくないときに使う.

+ 破棄
  + 戻すときは指定無しでいい.
```
terraform destroy \
  -target=module.kubernetes \
  -target=module.cluster terraform
```


### kubernetesレイヤだけを操作する
k8sを更新したので更新したい.

+ 破棄
  + 戻すときは指定無しでいい.
```
terraform destroy -target=module.kubernetes terraform
```
