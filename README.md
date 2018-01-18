# daf-docker-version
        Install steps on MAC OSX:
        1. git clone https://github.com/Movark09210512/daf-docker-version.git
        2. Change folder to daf-docker-version and put daf source code to daf-docker-version folder
        3. Into manifest folder and modify relational information: manifest/config/gamma_config.ini and manifest/config/production_config.ini or php/nginx's config
        4. docker build -t daf-docker-images .
        5. Edit docker-compose.yml: change "$(pwd)" to your code path
        6. docker-compose -f docker-compose.yml up -d
        7. Into the web container and test => web container connect to redis container or memcached container
           docker exec -it dafweb bash
           redis-cli -h redis
           telnet memcached 11211
