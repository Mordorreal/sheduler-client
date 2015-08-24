# sheduler-client
Server-client aplication with web interface for schedule tasks.

1. Install Docker and docker-compose
  1.1 http://docs.docker.com/installation/
     1.1.1 for linux run 
        sudo apt-get install curl
        curl -sSL https://get.docker.com/ | sh
  1.2 http://docs.docker.com/compose/install/
      1.2.1 for linux run
        curl -L https://github.com/docker/compose/releases/download/VERSION_NUM/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
 2. Move to sheduler-server folder in console
  2.1 run in console
    docker-compose build
  2.2 after compete run one time all images using command
    docker-compose up
    ctrl+c to stop
  2.3 type following commands to initialize data base and make migration
    docker-compose run server rake db:create
    docker-compose run server rake db:migrate
  3. Start server by command
    docker-compose up
    3.1 or run as daemon
      docker-compose start
    3.1 stop by
      ctrl+c or docker-compose stop
  4. Move to sheduler-client folder in console
    4.1 run in console to start as daemon
      ruby app/client.rb -i 0.0.0.0 -p 8080
      4.2 -i is ip address to server
          -p port(default is 8080)
  5. To access web site use http://localhost 
    5.1 password 'admin'

Feedback
  Task take more that expected 10 hours. 
  Wink don't have client for 64 bit linux os.
  Please, contact me by email denis@savchuk.space in case of any problem with runing application or any questions
  Make also odt format. Don't use Microsoft office.