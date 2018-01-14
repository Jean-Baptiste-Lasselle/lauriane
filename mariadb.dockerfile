FROM mariadb:10.1
ADD ./my.cnf .
RUN cp -f ./my.cnf /etc/mysql/my.cnf
EXPOSE 3306
CMD ["mysqld"]