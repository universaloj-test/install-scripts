debconf-set-selections <<< "mysql-server mysql-server/root_password password $_database_password_" && debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $_database_password_"
apt-get -qq update -y
apt-get -qq install -y apache2 php5 mysql-server libapache2-mod-auth-mysql php5-mysql subversion vim unzip cmake libapache2-mod-xsendfile zip fp-compiler php-pear php5-dev libv8-dev re2c libyaml-dev python python3 python-requests ntp
# /etc/apache2/sites-available/000-uoj.conf
a2dissite 000-default.conf && a2ensite 000-uoj.conf
cd /var/www
cp html uoj -r
cd /var
mkdir svn 
svnserve -d -r svn
svnadmin create svn/uoj
cd svn/uoj
mkdir cur
cd cur
svn checkout svn://127.0.0.1/uoj --username root --password root
cd ..
# vim conf/passwd
cd hooks/
# vim post-commit
chmod +x post-commit
# vim post-commit
# vim /etc/mysql/my.cnf
service mysql start
service mysql reload
# vim /etc/apache2/apache2.conf
service apache2 restart
cd /var/lib/php5
mkdir --mode=733 uoj
chmod +t uoj
adduser local_main_judger
usermod -a -G www-data local_main_judger
svnadmin create /var/svn/judge_client
cd /var/svn/judge_client/conf
# vim svnserve.conf
cd ..
mkdir cur
cd cur
svnserve -d -r /var/svn
svn checkout svn://127.0.0.1/judge_client --username root --password root
chown local_main_judger judge_client/ -R
cd judge_client
svnserve -d -r /var/svn
cd /var/svn/judge_client/hooks
# vim post-commit
chmod +x post-commit
cd /var/svn
mkdir problem
chown www-data problem -R
cd /var
mkdir uoj_data
chown www-data uoj_data -R
chgrp www-data uoj_data -R
ln -s /var/uoj_data data
/etc/init.d/apache2 reload
/etc/init.d/apache2 restart
cd /etc/apache2/sites-available
# vim 000-uoj.conf
pecl install v8js-0.1.3
a2enmod headers
pecl install yaml
vim /etc/php5/apache2/php.ini
service apache2 reload
a2enmod rewrite
cd /etc/apache2/
cd mods-enabled/
# vim /.dockerenv
cd /root
dpkg-reconfigure tzdata
############# vim /etc/localtime
# vim /etc/ntp.conf
service ntp start
