Requirments:

 Install Docker & Docker-compose

 In the project directory, Run:
 
   docker-compose build
  
   docker-compose up

 Access docker's application container using it's id by Run:
 
    docker ps
    
After getting it's id to access it, Run : 

    sudo docker exec -it YOUR_CONTAINER_ID /bin/sh

    Note: replace YOUR_CONTAINER_ID with your container application id


For APIs Doc using Rswag Swagger, once you set up the project, Follow this link:
http://localhost:3000/api-docs/index.html
