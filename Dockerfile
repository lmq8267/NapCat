# 使用 Ubuntu 22.04
FROM ubuntu:22.04

# 避免交互
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# 安装依赖 + 设置时区 + 减少镜像体积
RUN apt-get update && \
    apt-get install -y tzdata sudo curl jq ca-certificates && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

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
