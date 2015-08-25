# sheduler-server
Server-client aplication with web interface for schedule tasks. <br>
Client app https://github.com/Mordorreal/sheduler-client<br>

1.0 Install Docker and docker-compose<br>
  1.1 http://docs.docker.com/installation/<br>
     1.1.1 for linux run <br>
        sudo apt-get install curl<br>
        curl -sSL https://get.docker.com/ | sh<br>
  1.2 http://docs.docker.com/compose/install/<br>
      1.2.1 for linux run<br>
        curl -L https://github.com/docker/compose/releases/download/VERSION_NUM/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose<br>
        chmod +x /usr/local/bin/docker-compose<br>
 2.0 Move to sheduler-server folder in console<br>
  2.1 run in console<br>
    docker-compose build<br>
  2.2 after compete run one time all images using command<br>
    docker-compose up<br>
    ctrl+c to stop<br>
  2.3 type following commands to initialize data base and make migration<br>
    docker-compose run server rake db:create<br>
    docker-compose run server rake db:migrate<br>
  3.0 Start server by command<br>
    docker-compose up<br>
    3.1 or run as daemon<br>
      docker-compose start<br>
    3.1 stop by<br>
      ctrl+c or docker-compose stop<br>
  4.0 Move to sheduler-client folder in console<br>
    4.1 you need to install ruby and gem bundler
    4.1 run bundler install
    4.2 run in console to start as daemon<br>
      ruby app/client.rb -i 0.0.0.0 -p 8080<br>
      4.2.1 -i is ip address to server<br>
          -p port(default is 8080)<br>
  5.0 To access web site use http://localhost <br>
    5.1 password 'admin'<br>
