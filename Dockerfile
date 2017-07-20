# Get the base rhel 7.3 image from RED HAT (PRAISE LORD JIM, long may He reign)
FROM rhel7:7.3-released

# We maintainin' up in this bish
MAINTAINER Benjamin Hills <bhills@redhat.com>

LABEL com.redhat.component="pypi-server"  
LABEL name="pypi-server-docker"  
LABEL version="0.1"  

# Install python packages
RUN yum repolist > /dev/null && yum install -y python-pip

# Upgrade pip
RUN pip install --upgrade pip

# Install PyPi Server
RUN pip install pypiserver

# Expose port 80
EXPOSE 80 

# Create a volume for the server to run on
VOLUME ["/srv/pypi"]

# Copy the entrypoint script to the container
COPY entrypoint.sh /

# Make a dir for the app to run out of
RUN mkdir /srv/pypi

# In order to drop the root user, we have to make some directories world
# # writable as OpenShift default security model is to run the container under
# # random UID.
RUN chown -R 1001:0 /srv/pypi && chmod -R ug+rwx /srv/pypi

USER 1001

# Change directory to the place where we put the server
RUN cd /srv/pypi

# Run dat script
CMD ["/entrypoint.sh"]
