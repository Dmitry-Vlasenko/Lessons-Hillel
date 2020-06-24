#!/bin/bash
yusm -y update && echo>>/var/log/testlog good update || echo>>/var/log/testlog bad update
cat <<'EOF' >  /etc/yum.repos.d/nginx.repo
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF
yum-config-manager --enable nginx-mainline
yum -y install nginx && echo>>/var/log/testlog good install nginx || echo>>/var/log/testlog bad install nginx
cat <<'EOF' > /etc/nginx/conf.d/default.conf
server {
    listen       80;
    server_name  localhost;

    location / {
        root   /var/www2/;
        index  index.php index.html index.htm;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
       location ~ \.php$ {
        root /var/www2;
        try_files $uri =404;
        fastcgi_pass unix:/run/php-fpm/www.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF
yum -y install epel-release && echo>>/var/log/testlog good install epel-release || echo>>/var/log/testlog bad install epel-release
yum -y repolist 
yum -y install php php-fpm && echo>>/var/log/testlog good install php php-fpm || echo>>/var/log/testlog bad install php php-fpm
cat <<'EOF' >/etc/php-fpm.d/www.conf
[www]
user = nginx
group = nginx
listen = /run/php-fpm/www.sock
listen.owner = nginx
listen.group = nginx
listen.mode = 0660
listen.allowed_clients = 127.0.0.1
pm = dynamic
pm.max_children = 50
pm.start_servers = 5
pm.min_spare_servers = 5
pm.max_spare_servers = 35
slowlog = /var/log/php-fpm/www-slow.log
php_admin_value[error_log] = /var/log/php-fpm/www-error.log
php_admin_flag[log_errors] = on
php_value[session.save_handler] = files
php_value[session.save_path]    = /var/lib/php/session
php_value[soap.wsdl_cache_dir]  = /var/lib/php/wsdlcache
EOF
mkdir /var/www2/ && echo>>/var/log/testlog good create directory|| echo>>/var/log/testlog bad create directory
cat <<'EOF' > /var/www2/index.php
<?php
phpinfo();
?>
EOF
chown -R nginx:nginx /var/www2/ && echo>>/var/log/testlog good create permission directory|| echo>>/var/log/testlog bad create permission directory
setenforce 0 && echo>>/var/log/testlog good off selinux|| echo>>/var/log/testlog bad off selinux
systemctl start php-fpm && echo>>/var/log/testlog good start php-fpm|| echo>>/var/log/testlog bad startt php-fpm
systemctl start nginx && echo>>/var/log/testlog good start nginx|| echo>>/var/log/testlog bad startt nginx