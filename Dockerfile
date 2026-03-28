# 使用 Ubuntu 22.04
FROM ubuntu:22.04

# 避免交互
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# 安装必要的软件包 + 设置时区 + 清理缓存
RUN apt-get update && apt-get install -y \
    libnss3 \
    libnotify4 \
    libsecret-1-0 \
    libgbm1 \
    xvfb \
    libasound2 \
    fonts-wqy-zenhei \
    gnutls-bin \
    libglib2.0-dev \
    libdbus-1-3 \
    libgtk-3-0 \
    libxss1 \
    libxtst6 \
    libatspi2.0-0 \
    libx11-xcb1 \
    ffmpeg \
    unzip \
    dbus-user-session \
    curl \
    jq \
    gosu \
    sudo \
    tzdata && \
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 设置工作目录
WORKDIR /app

# 创建必要目录（避免挂载时报错）
RUN mkdir -p \
    /app/.config/QQ \
    /app/napcat/config \
    /app/napcat/plugins

# 下载并执行安装脚本
RUN curl -o napcat.sh https://raw.githubusercontent.com/NapNeko/napcat-linux-installer/refs/heads/main/install.sh && \
    bash napcat.sh

# 声明挂载目录
VOLUME ["/app/.config/QQ", "/app/napcat/config", "/app/napcat/plugins"]
# QQ 持久化数据路径：/app/.config/QQ
# NapCat 配置文件路径: /app/napcat/config
# NapCat 插件目录路径: /app/napcat/plugins

# 暴露端口
EXPOSE 3000 3001 6099

# 启动命令
CMD ["bash", "./launcher.sh"]
