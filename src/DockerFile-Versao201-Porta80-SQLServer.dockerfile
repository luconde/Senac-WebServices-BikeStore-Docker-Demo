# Informacoes
# Usa a imagem php:8.1.0
# Trabalha na pasta /app 
# Usa o SQL Server como driver

# Qual imagem a ser utilizada como referência: No caso é imagem php:8.1.0 disponível no Hub do Docker
FROM php:8.1.0

# Atualiza o sistema operacional com as ultimos updates
RUN apt-get update -y && apt-get install -y openssl zip unzip git gnupg2

# Baixa o composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instala o driver de acesso ao SQL Server
ENV ACCEPT_EULA=Y
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - 
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list 
RUN apt-get update 
RUN ACCEPT_EULA=Y apt-get -y --no-install-recommends install msodbcsql17 unixodbc-dev 
RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv
RUN docker-php-ext-enable sqlsrv pdo_sqlsrv

# Estabelece o diretorio de trabalho
WORKDIR /app

# Copia os arquivos para o diretorio de trabalho
COPY . /app

# Instala os componentes composer
RUN composer install

# Inicia o Laravel escutando na porta 8080
CMD php artisan serve --host=0.0.0.0 --port=80

# Expõe publicamente a porta 8080
EXPOSE 80