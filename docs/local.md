## drone自体をlocal上で実行する場合
### ngrok起動
+ droneから
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
