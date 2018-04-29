FROM openjdk:8

MAINTAINER Jean-Baptiste Lasselle <jean.baptiste.lasselle.it@gmail.com>

USER root

# Create the 'siebenzunft' user and group used to launch processes
# The uid and gid will be set to 901 to avoid conflicts with offical users on the docker host.
RUN groupadd -r siebenzunft -g 901 && \
    useradd -u 901 -r -g siebenzunft -m -d /home/siebenzunft -s /sbin/nologin -c "siebenzunft user" siebenzunft && \
    chmod 755 /opt     

# Set the working directory
WORKDIR /opt

# set environments 
ENV WILDFLY_VERSION 10.1.0.Final
ENV WILDFLY_HOME=/opt/wildfly
ENV WILDFLY_DEPLOYMENT=$WILDFLY_HOME/standalone/deployments
ENV WILDFLY_CONFIG=$WILDFLY_HOME/standalone/configuration
ENV DEBUG=false
	
# Add the Wildfly start script 
ADD fichierdehors repertoirdedans
RUN macommande

# une copie
COPY repertoiredehors repertoirededans

# un volume
VOLUME cccc

# Set home directory
WORKDIR cccc

# Expose the ports we're interested in
EXPOSE 8080 9990

CMD [ "sh", "-c", "sbt", "~compile", "~run" ]