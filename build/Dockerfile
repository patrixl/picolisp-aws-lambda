FROM amazonlinux
RUN yum -y install git zip tar java which make gcc
RUN curl -O https://software-lab.de/picoLisp-19.12.tgz
RUN tar zxf picoLisp-19.12.tgz
RUN cd picoLisp/src64 && make
COPY copy.sh /copy.sh

ENTRYPOINT ["bash", "/copy.sh"]
