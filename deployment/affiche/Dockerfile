FROM nginx:latest

WORKDIR /usr/share/nginx/html

#Retire les fichiers par défaut nginx
RUN rm -rf ./*

COPY ./page_web/ .