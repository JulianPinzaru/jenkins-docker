FROM jenkins/jenkins:lts
USER root
ENV TZ=America/Los_Angeles

RUN mkdir -p /tmp/download && \
 curl -L https://download.docker.com/linux/static/stable/x86_64/docker-18.03.1-ce.tgz | tar -xz -C /tmp/download && \
 rm -rf /tmp/download/docker/dockerd && \
 mv /tmp/download/docker/docker* /usr/local/bin/ && \
 rm -rf /tmp/download

RUN groupadd -g 999 docker && usermod -aG staff,docker,daemon jenkins

RUN mkdir /home/jenkins && \
    chown -R jenkins:jenkins /home/jenkins && \
    chmod 700 /home/jenkins

#RUN cd /home/jenkins && mkdir docker && chown -R root:docker /home/jenkins/docker.sock
#RUN chmod g+s /home/jenkins/docker

#RUN chmod g+s /var/local
#RUN chown root:daemon /var/local

RUN echo "alias ll='ls -alF --color=auto'" >> ~/.bashrc

# Set the working directory to the newly created directory
WORKDIR /home/jenkins

#USER jenkins

ENTRYPOINT ["/usr/bin/tini", "--"]

# Run your program under Tini
CMD ["/bin/bash", "-c", "chmod 660 /home/jenkins/docker.sock; chown root:docker /home/jenkins/docker.sock; su jenkins && /usr/local/bin/jenkins.sh"]



