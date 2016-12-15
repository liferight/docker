FROM sshd:dockerfile

RUN mkdir -p /var/www/html

RUN mkdir -p /var/log/httpd

RUN sed -i 's/#ServerName www.example.com:80/ServerName localhost:80/g' /etc/httpd/conf/httpd.conf

ADD index.html /var/www/html/index.html
RUN chmod 777 /var/www/html/index.html

ADD run.sh /run.sh
RUN chmod 755 /run.sh

EXPOSE 80

CMD ["/run.sh"]
