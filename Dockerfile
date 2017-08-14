FROM usgsastro/centos7:latest
MAINTAINER rbogle@usgs.gov

RUN wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo \
    && rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key

RUN yum install -y java-1.8.0-openjdk jenkins && yum clean all

# edited sysinit script to remove --daemon flag in cmd
COPY etc/jenkins /etc/init.d/jenkins

# Add Tini to do PID 1 management
ENV TINI_VERSION v0.15.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

# web interface
EXPOSE 8080

# slave api ports
EXPOSE 50000

ENTRYPOINT ["/bin/tini", "--" ]

CMD ["/etc/init.d/jenkins", "start"]
