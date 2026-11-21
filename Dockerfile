FROM alpine:latest

RUN apk add --no-cache wget unzip

RUN wget -q https://github.com/XTLS/Xray-core/releases/download/v1.8.24/Xray-linux-64.zip \
    && unzip -o Xray-linux-64.zip \
    && chmod +x xray \
    && mv xray /usr/local/bin/xray \
    && rm -f Xray-linux-64.zip

EXPOSE 8080

CMD sh -c 'echo "{\
  \"log\":{\"loglevel\":\"warning\"},\
  \"inbounds\":[{\
    \"port\":${PORT:-8080},\
    \"protocol\":\"vmess\",\
    \"settings\":{\"clients\":[{\"id\":\"d342d11e-d424-4583-b36e-524ab1f0afa4\"}]},\
    \"streamSettings\":{\"network\":\"ws\",\"security\":\"none\",\"wsSettings\":{\"path\":\"/\"}}\
  }],\
  \"outbounds\":[{\"protocol\":\"freedom\"}]\
}" > /etc/xray-config.json && xray run -config /etc/xray-config.json'
