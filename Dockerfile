FROM alpine:latest

# Cài wget, unzip
RUN apk add --no-cache wget unzip

# Download và cài Xray
RUN wget -q https://github.com/XTLS/Xray-core/releases/download/v1.8.24/Xray-linux-64.zip \
    && unzip -o Xray-linux-64.zip \
    && chmod +x xray \
    && mv xray /usr/local/bin/xray \
    && rm -f Xray-linux-64.zip

# Tạo config vmess + ws
# UUID: d342d11e-d424-4583-b36e-524ab1f0afa4
# Port: 8080, path: /
RUN echo '{ \
  "log": {"loglevel": "warning"}, \
  "inbounds": [{ \
    "port": 8080, \
    "protocol": "vmess", \
    "settings": { \
      "clients": [{"id": "d342d11e-d424-4583-b36e-524ab1f0afa4"}] \
    }, \
    "streamSettings": { \
      "network": "ws", \
      "security": "none", \
      "wsSettings": {"path": "/"} \
    } \
  }], \
  "outbounds": [{"protocol": "freedom"}] \
}' > /etc/xray-config.json

EXPOSE 8080

CMD ["xray", "run", "-config", "/etc/xray-config.json"]
