# microservice_demo
Repo này là demo cho microservice với docker swarm và traefik

# Install

Yêu cầu cài đặt docker trên ubuntu <br>
Tạo ít nhất 3 máy ảo để chạy docker swarm, 1 máy sẽ là manager và 2 máy là work 

Tạo manager ở chế độ swarn theo lệnh sau:
```
docker swarm init --advertise-addr <MANAGER-IP>
```
Ta sẽ được kết quả như sau:
```
Swarm initialized: current node (i5oqjrejsz4m2i8nuwgzgecfn) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
    192.168.88.132:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

Tiếp tục trên 2 máy worker chạy lệnh từ kết quả bên trên để tham gia vào cluster:
```
docker swarm join \
    --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
    192.168.88.132:2377
```

Có thể chạy lệnh sau để lấy ra token nếu bị mất
```
sudo docker swarm join-token worker
```

Chạy lệnh để kiểm tra cụm cluster docker:
```
sudo docker node ls
```
Đây là ví dụ kết quả trả về:

![alt text](https://github.com/nguyentrunghieu15/microservice_demo/blob/main/1.PNG)

Tiếp tục ta tạo 1 registry để cho 3 máy lấy images
Trên máy manager chạy lênh sau để tạo 1 registry:
```
sudo docker run -name registry -p 5000:5000 registry:2
```

Hiện tại ta đã có 1 private registry để push image

# Running
Repo hiện tại đã có sẵn 1 chương trình helloworld bằng python, chúng ta sẽ build image và push nó lên registry, thực hiện lần lượt các lệnh sau

```
sudo docker build . -t app
sudo docker image tag app localhost:5000/app
sudo docker push localhost:5000/app
```

Hiện tại thì app đã có sẵn trên registry

Sau đây chúng ta sẽ deploy treafik và app lên docker swarm:
```
sudo docker stack deploy --compose-file docker-compose.yml stackdemo
```
Kiểm tra các service:
![alt text](https://github.com/nguyentrunghieu15/microservice_demo/blob/main/2.PNG)

Scale app lên nhiều instance bằng lệnh sau:
```
sudo docker service scale stackdemo_app=4
```
Kiểm tra lại:
![alt text](https://github.com/nguyentrunghieu15/microservice_demo/blob/main/3.PNG)

Chúng ta có thể kiểm tra bằng cách mở trình duyệt lên với mỗi lần mở sẽ thấy app id khác nhau, chứng tỏ app đã được load balancing
![alt text](https://github.com/nguyentrunghieu15/microservice_demo/blob/main/4.PNG)
![alt text](https://github.com/nguyentrunghieu15/microservice_demo/blob/main/5.PNG)


