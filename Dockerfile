FROM ruby:3.4

WORKDIR /home/angus-sdoc

COPY . ./

RUN bundle install

CMD ["/bin/bash"]
