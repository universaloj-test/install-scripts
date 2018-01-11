
################## Preinstall Start ##################
echo "Preinstall Starts"
debconf-set-selections <<< "mysql-server mysql-server/root_password password root" && debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"
apt-get -qq update -y
apt-get -qq install -y apache2 php5 mysql-server libapache2-mod-auth-mysql php5-mysql subversion vim unzip cmake libapache2-mod-xsendfile zip fp-compiler php-pear php5-dev libv8-dev re2c libyaml-dev python python3 python-requests ntp
cp ~/install-scripts/pre-install/000-uoj.conf /etc/apache2/sites-available/000-uoj.conf
a2dissite 000-default.conf && a2ensite 000-uoj.conf
cp /var/www/html/ /var/www/uoj/ -r
cd /var/
mkdir svn && cd /var/svn/
svnserve -d -r /var/svn/
svnadmin create /var/svn/uoj/
cd /var/svn/uoj/conf/
cp ~/install-scripts/pre-install/uoj-svnserve.conf /var/svn/uoj/conf/svnserve.conf
cp ~/install-scripts/pre-install/passwd /var/svn/uoj/conf/passwd
cd /var/svn/uoj/
mkdir cur
cd /var/svn/uoj/cur/
svn checkout svn://127.0.0.1/uoj --username root --password root
cd ..
cd hooks/
cp ~/install-scripts/pre-install/uoj-post-commit post-commit
chmod +x post-commit
cp ~/install-scripts/pre-install/my.cnf /etc/mysql/my.cnf
cp ~/install-scripts/pre-install/apache2.conf /etc/apache2/apache2.conf
service mysql start
service mysql reload
service apache2 reload
cd /var/lib/php5
service apache2 start
mkdir --mode=733 uoj
chmod +t uoj
adduser local_main_judger
usermod -a -G www-data local_main_judger
svnadmin create /var/svn/judge_client
cp ~/install-scripts/pre-install/judge-svnserve.conf /var/svn/judge_client/conf/svnserve.conf
cd /var/svn/judge_client/
mkdir cur
cd cur
svnserve -d -r /var/svn
svn checkout svn://127.0.0.1/judge_client --username root --password root
chown local_main_judger judge_client/ -R
cd judge_client
svnserve -d -r /var/svn
cd /var/svn/judge_client/hooks
cp ~/install-scripts/pre-install/judge-post-commit post-commit
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
pecl install v8js-0.1.3
pecl install yaml
a2enmod headers
cp ~/install-scripts/pre-install/php.ini /etc/php5/apache2/php.ini
service apache2 reload
a2enmod rewrite
cp ~/install-scripts/pre-install/.dockerenv /.dockerenv
cd /root
dpkg-reconfigure tzdata
cp ~/install-scripts/pre-install/ntp.conf /etc/ntp.conf
service ntp start
echo "Preinstall Finished"
################## Preinstall Finished ##################
################## Download UOJ Source Code Start ##################
echo "Download UOJ Source Code Start"
cd ~
git clone https://github.com/universaloj-test/uoj-web.git --depth=1 && cd uoj-web && rm -rf .git && cd ..
git clone https://github.com/universaloj-test/uoj-judge.git --depth=1 && cd uoj-judge && rm -rf .git && cd ..
echo "Download UOJ Source Code Finished"
################## Download UOJ Source Code Finished ##################
################## Configure UOJ Start ##################
echo "Configure UOJ Start"
cp uoj-web /root/uoj_1 -R
cp uoj-judge /root/judge_client_1 -R
cd ~/install-scripts/install/ && php gen-uoj-config.php && chmod +x install && ./install && rm * -rf
cd ~ && wget https://raw.githubusercontent.com/universaloj-test/install-scripts/master/install/up && chmod +x /root/up
cd ~ && rm -rf install-scripts
echo "Configure UOJ Finished"
################## Configure UOJ Finished ##################

echo "Done!"


