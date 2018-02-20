FROM usgsastro/centos7:latest
MAINTAINER rbogle@usgs.gov
ENV JenkinsVer 2.84

RUN wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo \
    && rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key

# we add the jenkins user/group to keep consistent uid/gid with persistent storage
RUN groupadd -g 996 jenkins && useradd -d /var/lib/jenkins -M -g 996 -u 998 jenkins

RUN yum install -y java-1.8.0-openjdk jenkins-${JenkinsVer} sssd-client && yum clean all

# edited sysinit script to remove --daemon flag in cmd
COPY etc/jenkins /etc/init.d/jenkins

# we are mapping sssd from host for logins on jenkins
# you must mount /var/lib/sss/pipes into the container
# and use the unix auth with jenkins service in jenkins
COPY etc/pam /etc/pam.d/jenkins

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
