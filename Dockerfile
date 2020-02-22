FROM amazonlinux
RUN yum -y install git zip tar java which make gcc
RUN curl -O https://software-lab.de/picoLisp-19.12.tgz
RUN tar zxf picoLisp-19.12.tgz && cd picoLisp/src64 && make
RUN cd / && git clone --depth 1 https://github.com/aw/picolisp-json && git clone --depth 1 https://github.com/aw/picolisp-awscurl
RUN mkdir picoLisp/json picoLisp/awscurl
RUN cp picolisp-json/json.l picolisp-json/LICENSE picoLisp/json/
RUN cp picolisp-awscurl/libawscurl.l picolisp-awscurl/LICENSE picoLisp/awscurl/
ARG uid
RUN chown -R ${uid} /picoLisp

ENTRYPOINT ["mv", "/picoLisp", "/build/"]
