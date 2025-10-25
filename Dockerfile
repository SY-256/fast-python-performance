FROM nvcr.io/nvidia/pytorch:22.03-py3
ENV NVIDIA_VISIBLE_DEVICES all
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64
EXPOSE 8888

# パッケージの更新
RUN apt update && apt upgrade -y && apt install -y graphviz curl

# NVMとNode.jsを完全に削除
RUN rm -rf /usr/local/nvm
RUN rm -rf /usr/local/nodejs
RUN apt remove -y nodejs npm || true
RUN apt purge -y nodejs npm || true
RUN apt autoremove -y
RUN rm -rf /usr/bin/node /usr/bin/npm /usr/local/bin/node /usr/local/bin/npm
RUN rm -rf /usr/local/lib/node_modules /usr/lib/node_modules
RUN rm -rf /opt/conda/bin/node /opt/conda/bin/npm

# 手動でNode.js 20をダウンロードしてインストール
RUN cd /tmp && \
    wget https://nodejs.org/dist/v20.10.0/node-v20.10.0-linux-x64.tar.xz && \
    tar -xf node-v20.10.0-linux-x64.tar.xz && \
    mv node-v20.10.0-linux-x64 /usr/local/nodejs && \
    rm node-v20.10.0-linux-x64.tar.xz

# シンボリックリンクを作成してPATHの問題を回避
RUN ln -sf /usr/local/nodejs/bin/node /usr/local/bin/node
RUN ln -sf /usr/local/nodejs/bin/npm /usr/local/bin/npm
RUN ln -sf /usr/local/nodejs/bin/npx /usr/local/bin/npx

# 環境変数を設定（nvmのPATHを無効化）
ENV PATH="/usr/local/bin:/usr/local/nodejs/bin:/opt/conda/lib/python3.8/site-packages/torch_tensorrt/bin:/opt/conda/bin:/usr/local/mpi/bin:/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/ucx/bin:/opt/tensorrt/bin"

# インストール確認
RUN which node && which npm && node --version && npm --version

# Claude Codeを手動でインストール（互換性問題の回避）
RUN npm install -g @anthropic-ai/claude-code@latest || \
    npm install -g @anthropic-ai/claude-code --force || \
    echo "Claude Code installation failed, will install manually"

COPY requirements.txt . 
RUN pip install -U pip
RUN pip install -r requirements.txt

COPY kaggle.json .
RUN mkdir /root/.kaggle \
    && cp kaggle.json -d /root/.kaggle/kaggle.json \
    && chmod 600 /root/.kaggle/kaggle.json


# Claude Code用の環境変数設定（必要に応じて）
# ENV ANTHROPIC_API_KEY=""

# 作業ディレクトリを設定
WORKDIR /workspaces/cmi-detect-behavior-with-sensor-data
