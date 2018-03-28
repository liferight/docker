# 版本信息
FROM centos
MAINTAINER locutus "xxxx@qq.com"

# OS环境配置
RUN yum install -y wget

# 安装JDK
RUN mkdir /opt/software/jdk
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  -P /var/tmp/jdk http://download.oracle.com/otn-pub/java/jdk/8u131-b14/jdk-8u131-linux-x64.tar.gz
RUN tar xzf /opt/software/jdk/jdk-8u111-linux-x64.tar.gz -C /opt/jdk && rm -rf /opt/software/jdk/jdk-8u111-linux-x64.tar.gz

# 安装tomcat
RUN mkdir /opt/software/tomcat
RUN wget -P  /opt/software/tomcat http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.8/bin/apache-tomcat-8.5.8.tar.gz
RUN tar xzf /opt/software/tomcat/apache-tomcat-8.5.8.tar.gz -C /opt/tomcat && rm -rf /opt/software/tomcat/apache-tomcat-8.5.8.tar.gz

#设置环境变量
ENV JAVA_HOME /opt/jdk/jdk1.8.0_111
ENV CATALINA_HOME /opt/tomcat/apache-tomcat-8.5.8
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin

#打包项目并拷贝到tomcat webapps目录
RUN mkdir /opt/webapp
ADD ./  /opt/webapp
RUN cd  /opt/webapp  && cp /opt/webapp/war/test.war /opt/tomcat/apache-tomcat-8.5.8/webapps/

#开启内部服务端口
EXPOSE 8080

#启动tomcat服务器
CMD ["./opt/tomcat/apache-tomcat-8.5.8/bin/catalina.sh","run"] && tail -f /opt/tomcat/apache-tomcat-8.5.8/logs/catalina.out 
