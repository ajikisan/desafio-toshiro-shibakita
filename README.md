<p>Desafio Docker Utilização Prática no Cenário de Microsserviços
<p>Aluna: Mirian Ajiki Molicawa </p>
<p>Digital Innovation One </p>
<p>Instrutor: Denilson Bonatti</p>
<p>Data: 02/03/2023 </p>

### Tecnologias 
<p> [Amazon](https://aws.amazon.com/pt/)
<p> [Lodario](https://loader.io/)
<p> [Dockerhub](https://hub.docker.com/_/mysql/)
<p> Linux Ubuntu

### Descrição do Desafio
<p> Replicar projeto prático TOSHIRO SHIBAKITA, criando em um repositório uma estrutura de Microsserviços com os conhecimentos básicos em Linux, Docker e AWS.  

#### Procedimentos Realizados
'''

Teste utilizando o site https://loader.io/ para estressar o container
root@aws-1:/var/lib/docker/volumes/app/_data# nano loaderio-a8d6f00941a20ab890591c32cbc5d65b.txt
root@aws-1:/var/lib/docker/volumes/app/_data#  docker ps
root@aws-1:/var/lib/docker/volumes/app/_data#  docker rm --force web-server
root@aws-1:/var/lib/docker/volumes/app/_data#  docker ps

Iniciando um Cluster Swarm
root@aws-1:/var/lib/docker/volumes/app/_data#  docker swarm init

Gerado o ip local para porta 3223
docker swarm join --token SWMTKN-1-4mntqyqj5dc24isefobeodn3kom0uo745qikpbyxtlayf0k-6jecmr07ta2sg0ztmtcxtc39 
223.225.139.33:3223

root@aws-1:/var/lib/docker/volumes/app/_data# ip a

root@aws-1:/var/lib/docker/volumes/app/_data# docker node ls
ID			   HOSTNAME 	STATUS 	AVAILABILITY 	MANAGER STATUS 	ENGINE VERSION
unzc3cbla6tx2928g3tpjlz2 * aws-1 	Ready	Active		Leader	 	23.03.01
qesgg3cdl9tx1532g4tpjezp   aws-2 	Ready	Active		 		23.03.01
otjee3cflrr2t228g1t3jcze   aws-3 	Ready	Active	         		23.03.01


Criando um serviço no cluster
root@aws-1:/var/lib/docker/volumes/app/_data# docker service create --name web-server --replicas 3-dt -p 80:80
--mount type=volume,src=app,dst=/app/ webdevops/php-apache:alpine-php7
xxa5f5l2gt2y3afdauxkla0mn1

Criação de serviço de containers dentro das máquinas virtuais
root@aws-1:/var/lib/docker/volumes/app/_data# docker service ps web-server
ID ERROR  NAME PORTS  	IMAGE NODE DESIRED STATE CURRENT STATE
jkfajfl4656d web-server.1 webdevops/php-apache:alpine-php7 aws-1  Running Running 30 seconds ago
adaddjlrq782 web-server.2 webdevops/php-apache:alpine-php7 aws-1  Running Running 33 seconds ago
twrrwf23623h web-server.3 webdevops/php-apache:alpine-php7 aws-1  Running Running 50 seconds ago

root@aws-1:/var/lib/docker/volumes/app/_data# ls
index.php loaderio-a8d6f00941a20ab890591c32cbc5d65b.txt

Replicando um volume dentro do cluster através do servidor nfs, onde está o microserviço
root@aws-1:/var/lib/docker/volumes/app/_data# apt-get install nfs-server -y

Criação de arquivo de configuração para replicar uma pasta para o root 2 e 3 
root@aws-1:/var/lib/docker/volumes/app/_data# nano /etc/exports

GNU nano 
/etc/exports: the access control list for filesytems wich may be exported
to NFS clients. See exports(5).
Example for NFSv2 and NFSv3:
/srv/homes hostname1(rw,sync,no_subtree_check) hostname2(ro,sync, no_subtree_check)
Example for NFSv4
/srv/nfs4 gss/krb5i(rw,sync,fsid=0,crossmnt,no_subtree_check)
/srv/nfs4/homes gss/krb5i(rw,sync,no_subtree_check)

echo "permissão de acesso a todas as máquinas..."
/var/lib/docker/volumes/app/_data *(rw,sync,no_subtree_check)
echo "Fim do comando..."

Executar o comando, se der erro algo foi escrito errado no nano
root@aws-1:/var/lib/docker/volumes/app/_data# exportsfs -ar

Demonstra o que foi compartilhado no computador
root@aws-1:/var/lib/docker/volumes/app/_data# showmount -e
Export list for aws-1:
/var/lib/docker/volumes/app/_data *
root@aws-1:/var/lib/docker/volumes/app/_data#

Criação do Proxy
root@aws-1:/var/lib/docker/volumes/app/_data# cd/
root@aws-1:/#
root@aws-1:/# mkdir /proxy
root@aws-1:/# cd /proxy/
Criação do arquivo de configuração 
root@aws-1:/proxy# nano nginx.conf

GNU nano
http {
   
    upstream all {
        server 223.25.0.133:80;
        server 223.25.0.172:80;
        server 223.25.0.244:80;
    }

    server {
         listen 4500;
         location / {
              proxy_pass http://all/;
         }
    }

}

events { }

root@aws-1:/proxy# ls
nginx.conf

Indicar a imagem e o arquivo para copiar para o container

root@aws-1:/proxy# nano dockerfile

GNU nano
echo "indicação do arquivo de configuração a ser copiado..."
FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf

root@aws-1:/proxy# docker build - t proxy-app .

root@aws-1:/proxy# docker image ls
REPOSITORY TAG IMAGE ID CREATED SIZE
proxy-app latest 8a54654a32deg 12 seconds ago 142MB
mysql 5.5 5564545d5d6 1 hour ago 448 MB
nginx latest fjlafja22lç 53 seconds ago 142 MB
webdevops/php-apache alpine-php7 465f4a54fa3f 2 hour ago

Será executado apenas no primeiro servidor
root@aws-1:/proxy# docker container run --name my-proxy-app -dti - p 4500:4500 proxy-app
66d5e45622200gkajlajalhklpjvlhlnf566d26wwwd1sc55rww54d4fsg92d4dc
root@aws-1:/proxy# docker container ls

Teste utilizando o site https://loader.io/ para realização estressando o cluster

Segunda máquina virtual que será o cluster
root@fedora docker]# shh -i ./DOCKER.pem ubuntu@92.113.140.59
root@aws-2:/home/ubuntu# docker swarm join --token SWMTKN-1-4mntqyqj5dc24isefobeodn3kom0uo745qikpbyxtlayf0k-6jecmr07ta2sg0ztmtcxtc39 
223.225.139.33:3223
this node joined a swarm as a worker.
root@aws-2:/home/ubuntu# cd /var/lib/docker/volumes/app/_data
root@aws-2:/var/lib/docker/volumes/app/_data# ls

Instalação cliente nfs
root@aws-2:/var/lib/docker/volumes/app/_data# apt-get install nfs-common

Montagem da pasta com a versão 3 no mesmo lugar
root@aws-2:/var/lib/docker/volumes/app/_data# mount -o v3 223.25.0.133:var/lib/docker/volumes/app/_data var/lib/docker/volumes/app/_data
root@aws-2:/var/lib/docker/volumes/app/_data# 
root@aws-2:/var/lib/docker/volumes/app/_data# ls
index.php loaderio-a8d6f00941a20ab890591c32cbc5d65b.txt
root@aws-2:/var/lib/docker/volumes/app/_data#

Terceira máquina virtual que será o cluster
[root@fedora docker]# shh -i ./DOCKER.pem ubuntu@92.113.140.59
root@aws-3:/home/ubuntu# ssh -i ./DOCKER.pem ubuntu@92.113.140.59
root@aws-3:/home/ubuntu# docker swarm join --token SWMTKN-1-4mntqyqj5dc24isefobeodn3kom0uo745qikpbyxtlayf0k-6jecmr07ta2sg0ztmtcxtc39 
223.225.139.33:3223
this node joined a swarm as a worker
root@aws-3:/home/ubuntu#
root@aws-3:/home/ubuntu# cd /var/lib/docker/volumes/app/_data
root@aws-3:/var/lib/docker/volumes/app/_data# ls

Instalação cliente nfs
root@aws-3:/var/lib/docker/volumes/app/_data# apt-get install nfs-common

Montagem da pasta com a versão 3 no mesmo lugar
root@aws-3:/var/lib/docker/volumes/app/_data# mount -o v3 223.25.0.133:var/lib/docker/volumes/app/_data var/lib/docker/volumes/app/_data
root@aws-3:/var/lib/docker/volumes/app/_data# ls
root@aws-3:/var/lib/docker/volumes/app/_data# cd ..
root@aws-3:/var/lib/docker/volumes/app# ls
data
root@aws-3:/var/lib/docker/volumes/app# cd _data/
root@aws-3:/var/lib/docker/volumes/app/_data# ls
index.php loaderio-a8d6f00941a20ab890591c32cbc5d65b.txt
root@aws-3:/var/lib/docker/volumes/app/_data#

'''

### Fonte
[Fonte](https://github.com/denilsonbonatti/toshiro-shibakita)