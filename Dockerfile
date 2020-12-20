FROM ruby:2.7.1

# 必要なライブラリインストール
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# yarnパッケージ管理ツールをインストール
RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y yarn

# Node.jsをインストール
# RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
#  apt-get install nodejs
RUN curl -SL https://deb.nodesource.com/setup_12.x | bash
RUN apt-get install -y nodejs




RUN mkdir /dokotory
WORKDIR /dokotory
COPY Gemfile /dokotory/Gemfile
COPY Gemfile.lock /dokotory/Gemfile.lock
RUN bundle install
COPY . /dokotory

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
