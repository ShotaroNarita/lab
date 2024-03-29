FROM ubuntu:latest

ARG new_user

# ユーザを作成
RUN useradd -ms /bin/bash ${new_user}

# sshディレクトリを作成
RUN mkdir /home/${new_user}/.ssh

# 公開鍵をコピー
COPY terminal.pub /home/${new_user}/.ssh/authorized_keys

# sshサーバをインストール
RUN apt update && apt install -y openssh-server sudo && apt clean

# ひとまずパスワードを設定
RUN echo "${new_user}:password" | chpasswd

# sudoに追加
RUN gpasswd -a ${new_user} sudo

# ssh用のディレクトリを作成
RUN mkdir /var/run/sshd

# パスワードを使用したログインを許可しない
RUN sed -i -r 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config 

# 公開鍵認証を許可
RUN sed -i -r 's/#AuthorizedKeysFile/AuthorizedKeysFile/' /etc/ssh/sshd_config

# ポートを22から2222に変更
RUN sed -i -r 's/^#Port 22/Port 2222/' /etc/ssh/sshd_config 

RUN /usr/sbin/sshd

EXPOSE 2222

ENTRYPOINT [ "/usr/sbin/sshd", "-D" ]
