# drone

<https://github.com/harness/drone>

```bash
git remote add upstream git@github.com:harness/drone.git

git fetch upstream

git merge v2.12.1
```

## debug

```bash
docker run -it --rm \
-v $PWD/:/go/src/github.com/drone/drone \
-w /go/src/github.com/drone/drone \
-e GO111MODULE=auto \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.19-alpine \
bash -c '
git apply .beagle/0001-config.patch && \
git apply .beagle/0002-machine.patch && \
git apply .beagle/0003-yaml.patch && \
git apply .beagle/0004-user-alias.patch
'

docker run -it --rm \
--entrypoint bash \
-v $PWD/:/go/src/github.com/drone/drone \
-w /go/src/github.com/drone/drone \
-e GO111MODULE=off \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.19-alpine \
.beagle/build.sh
```

## cache

```bash
# golang cache
docker run -it --rm \
-v $PWD/:/go/src/github.com/drone/drone \
-w /go/src/github.com/drone/drone \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.19-alpine \
sh -c "
go mod tidy && \
go mod vendor
"
```

```bash
# 构建缓存-->推送缓存至服务器
docker run -it --rm \
  -e PLUGIN_REBUILD=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="drone" \
  -e PLUGIN_MOUNT=".git,./vendor,./go.sum" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0

# 读取缓存-->将缓存从服务器拉取到本地
docker run -it --rm \
  -e PLUGIN_RESTORE=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="drone" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0
```
