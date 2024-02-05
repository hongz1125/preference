# server{
#     listen 80;
#       server_name  www.toboedu.com toboedu.com *.toboedu.com;
#       rewrite ^(.*) https://$server_name$1 permanent;
# }

server {
    listen 443 ssl http2;
    server_name www.toboedu.com toboedu.com *.toboedu.com;
    ssl_certificate   cert/toboedu.com.pem;
    ssl_certificate_key  cert/toboedu.com.key;
    ssl_session_timeout 5m;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;

        #全站静态资源存放目录
        location /static/ {
                alias   /www/static.toboedu.com/;
                index index.html;
        }

        #二级域名不能为空
        if ($http_host ~ "^toboedu.com$") {
                rewrite ^(.*) https://www.toboedu.com$1 permanent;
        }

        #设置变量
        if ($http_host ~* "^(.*?)\.toboedu\.com$"){
                set $domain $1;
        }

    location /mini_program/ {
        proxy_pass http://localhost:8001/;
    }

    location /api/ {
        # nginx 跨域
        add_header 'Access-Control-Allow-Origin' $http_origin;
        add_header 'Access-Control-Allow-Credentials' 'true';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
        add_header 'Access-Control-Allow-Headers' 'DNT,web-token,app-token,Authorization,Accept,Origin,Keep-Alive,User-Agent,X-Mx-ReqToken,X-Data-Type,X-Auth-Token,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';
        add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range';
        if ($request_method = 'OPTIONS') {
                add_header 'Access-Control-Max-Age' 1728000;
                add_header 'Content-Type' 'text/plain; charset=utf-8';
                add_header 'Content-Length' 0;
                return 204;
        }

        #转发设置用户远端ip
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        proxy_pass http://localhost:8808;

    }

    location /admin/ {
        proxy_pass http://localhost:8809/;
    }
    location /jenkins {

        rewrite /.* http://121.43.119.160:9999;
        }


    location /code/ {

                proxy_pass http://localhost:8443/;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";
                proxy_set_header X-real-ip $remote_addr;
                proxy_set_header X-Forwarded-For $remote_addr;
    }

    location / {
        proxy_set_header Host $host;

        # try_files $uri $uri/ /index.html;
        if ($domain ~* "www") {
                proxy_pass http://localhost:6002;
        }
    }

}
