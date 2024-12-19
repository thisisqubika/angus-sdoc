FROM ruby:3.3.0

WORKDIR /home/angus-sdoc

COPY . ./

RUN bundle install

CMD ["/bin/bash"]
