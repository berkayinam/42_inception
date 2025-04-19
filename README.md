# 42_inception

42 okulunun sistem yönetimi projesi olan Inception, Docker ve Docker Compose kullanarak çoklu container yapısında bir web altyapısı oluşturmayı amaçlamaktadır.

## 🐳 Proje Hakkında

Inception projesi, Docker containerları kullanarak NGINX, WordPress ve MariaDB servislerini içeren bir web altyapısı kurmayı hedeflemektedir. Proje, sistem yönetimi, container teknolojileri ve servis orchestration konularında pratik deneyim kazandırmayı amaçlamaktadır.

## 💻 Teknolojiler

### Container Teknolojileri
- Docker
- Docker Compose
- Docker Network
- Docker Volume

### Servisler
- NGINX (Web Sunucusu)
- WordPress (CMS)
- MariaDB (Veritabanı)
- PHP-FPM
- FTP Server

## 🛠️ Kurulum

### Gereksinimler
- Docker Engine
- Docker Compose
- Make
- Git

### Kurulum Adımları

1. Projeyi klonlayın:
```bash
git clone https://github.com/[kullanıcı-adı]/42_inception.git
cd 42_inception
```

2. Ortam değişkenlerini ayarlayın:
```bash
cp .env.example .env
# .env dosyasını düzenleyin
```

3. Servisleri başlatın:
```bash
make
# veya
docker-compose up --build -d
```

## 📝 Proje Yapısı

```
42_inception/
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   └── requirements/
│       ├── nginx/
│       │   ├── Dockerfile
│       │   └── conf/
│       ├── wordpress/
│       │   ├── Dockerfile
│       │   └── conf/
│       └── mariadb/
│           ├── Dockerfile
│           └── conf/
├── Makefile
└── README.md
```

## 🎯 42 Proje Gereksinimleri

### Zorunlu Kısım
- [x] Docker Compose kullanımı
- [x] Özel Docker imajları
- [x] NGINX (TLSv1.2 veya TLSv1.3)
- [x] WordPress + php-fpm
- [x] MariaDB
- [x] Volume yönetimi
- [x] Docker network

### Bonus Özellikler
- [x] Redis önbelleği
- [x] FTP sunucusu
- [x] Statik website
- [x] Adminer
- [x] Servis seçimi

## 🔧 Servis Konfigürasyonları

### NGINX
```nginx
# /etc/nginx/conf.d/default.conf
server {
    listen 443 ssl;
    server_name [domain];

    ssl_certificate /etc/nginx/ssl/[domain].crt;
    ssl_certificate_key /etc/nginx/ssl/[domain].key;
    ssl_protocols TLSv1.2 TLSv1.3;

    root /var/www/html;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        fastcgi_pass wordpress:9000;
        fastcgi_index index.php;
        include fastcgi_params;
    }
}
```

### WordPress
```Dockerfile
FROM debian:buster

RUN apt-get update && apt-get install -y \
    php7.3-fpm \
    php7.3-mysql \
    wget

COPY conf/www.conf /etc/php/7.3/fpm/pool.d/
COPY tools/wp-config.php /var/www/html/

CMD ["php-fpm7.3", "-F"]
```

### MariaDB
```Dockerfile
FROM debian:buster

RUN apt-get update && apt-get install -y \
    mariadb-server

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY tools/init.sql /docker-entrypoint-initdb.d/

CMD ["mysqld"]
```

## 🚀 Makefile Komutları

```makefile
all: up

up:
    docker-compose -f srcs/docker-compose.yml up --build -d

down:
    docker-compose -f srcs/docker-compose.yml down

clean: down
    docker system prune -a
    docker volume rm $$(docker volume ls -q)

re: clean all
```

## 📊 Volume Yönetimi

### WordPress Volume
```yaml
volumes:
  wordpress_data:
    driver: local
    driver_opts:
      type: none
      device: /home/[user]/data/wordpress
      o: bind
```

### MariaDB Volume
```yaml
volumes:
  mariadb_data:
    driver: local
    driver_opts:
      type: none
      device: /home/[user]/data/mariadb
      o: bind
```

## 🔒 SSL Sertifika Oluşturma

```bash
# Self-signed sertifika oluşturma
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/[domain].key \
    -out /etc/nginx/ssl/[domain].crt
```

## 🐛 Hata Ayıklama

### Container Logları
```bash
# Tüm container loglarını görüntüle
docker-compose logs

# Belirli bir servisin loglarını görüntüle
docker-compose logs [servis-adı]
```

### Container Shell'e Erişim
```bash
# Container'a bağlan
docker-compose exec [servis-adı] bash
```

## 📈 Performans İyileştirmeleri

1. NGINX Optimizasyonu
   - Worker process ayarları
   - Buffer boyutları
   - Gzip sıkıştırma
   - FastCGI önbelleği

2. WordPress Optimizasyonu
   - PHP-FPM ayarları
   - Opcode önbelleği
   - Redis entegrasyonu

3. MariaDB Optimizasyonu
   - Buffer pool boyutu
   - Query önbelleği
   - InnoDB ayarları

## 🔍 Test ve Doğrulama

1. Servis Durumu Kontrolü
```bash
docker-compose ps
```

2. SSL Kontrolü
```bash
openssl s_client -connect [domain]:443 -tls1_2
```

3. WordPress Kontrolü
```bash
curl -k https://[domain]
```

## 📝 Lisans

Bu proje [MIT](LICENSE) lisansı altında lisanslanmıştır.

## 📚 Kaynaklar

- [Docker Dokümantasyonu](https://docs.docker.com/)
- [NGINX Dokümantasyonu](https://nginx.org/en/docs/)
- [WordPress Dokümantasyonu](https://wordpress.org/documentation/)
- [MariaDB Dokümantasyonu](https://mariadb.com/kb/en/documentation/)

---

⭐️ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın!
