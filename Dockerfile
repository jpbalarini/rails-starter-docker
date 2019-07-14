# See https://intercityup.com/blog/how-i-build-a-docker-image-for-my-rails-app.html
# See https://intercityup.com/blog/deploy-rails-app-including-database-configuration-env-vars-assets-using-docker.html
FROM phusion/passenger-full
# Set correct environment variables.
ENV HOME /root
ENV RAILS_ENV production
RUN apt update
RUN apt install -y sudo
RUN apt-get install -y tzdata
RUN sudo apt-get install -y build-essential libcurl4-openssl-dev
RUN apt install -y redis-server
# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
# Start Nginx / Passenger
ARG RAILS_VER
ARG GIT_URL
COPY docker/set_ruby_env.sh /root/
RUN bash /root/set_ruby_env.sh
# Enable nginx
RUN rm -f /etc/service/nginx/down
# Enable the Redis service.
RUN rm -f /etc/service/redis/down
# Remove the default site
RUN rm /etc/nginx/sites-enabled/default

# Add the nginx conf file for the site
ADD docker/nginx.conf /etc/nginx/sites-enabled/webapp.conf

# Add the rails-env configuration file so Nginx preserves the environment variables listed
ADD docker/rails-env.conf /etc/nginx/main.d/rails-env.conf

# Prepare folders
RUN mkdir /home/app/webapp

# Add startup script to run during container startup
RUN mkdir -p /etc/my_init.d
ADD docker/startup.sh /etc/my_init.d/startup.sh
RUN chmod +x /etc/my_init.d/*.sh
RUN apt-get install git
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# COPY script.sh /home/app/
# RUN bash /home/app/script.sh

WORKDIR /home/app/webapp/
COPY . /home/app/webapp
COPY docker/database.yml /home/app/webapp/config
RUN chown -R app:app /home/app/webapp
RUN sudo -u app gem install bundler
RUN sudo -u app bundle install --without development test
RUN sudo -u app RAILS_ENV=production bundle exec rake assets:precompile
