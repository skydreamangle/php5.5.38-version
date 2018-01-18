# daf-docker-version
        Install steps on MAC OSX:
        1. git clone 
        2. Change folder and put source code 
        3. Into manifest folder and modify relational information: manifest/config/gamma_config.ini and manifest/config/production_config.ini or php/nginx's config
        4. docker build -t docker-images .
        5. Edit docker-compose.yml: change "$(pwd)" to your code path
        6. docker-compose -f docker-compose.yml up -d
        7. Into the web container and test => web container connect to redis container or memcached container
           docker exec -it dafweb bash
           redis-cli -h redis
           telnet memcached 11211
