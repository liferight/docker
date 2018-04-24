# 版本信息
FROM centos:6.9

# 上传JDK和tomcat
ADD ./jdk-8u131-linux-x64.rpm /root
RUN /bin/rpm -ivh /root/jdk-8u131-linux-x64.rpm && rm -rf /root/jdk-8u131-linux-x64.rpm
# 安装tomcat
ADD ./tomcat.tar.gz /usr/local
#RUN /bin/tar xzvf /opt/tomcat/apache-tomcat-8.5.15.tar.gz -C /usr/local/tomcat && rm -rf /opt/tomcat/apache-tomcat-8.5.15.tar.gz

#设置环境变量
#ENV JAVA_HOME /opt/jdk/jdk1.8.0_111
#ENV CATALINA_HOME /opt/tomcat/apache-tomcat-8.5.8
#ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin

ADD run.sh /run.sh
RUN chmod 755 /run.sh
#开启内部服务端口
EXPOSE 8080

#启动tomcat服务器
ENTRYPOINT /usr/local/tomcat/bin/startup.sh && tail -f /usr/local/tomcat/logs/catalina.out
