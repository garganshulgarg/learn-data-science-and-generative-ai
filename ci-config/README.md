```
docker build --progress=plain  -t learn-data-science:1.0 -f ci-config/Dockerfile .
```

```
docker run -p 8888:8888 learn-data-science:1.0
```