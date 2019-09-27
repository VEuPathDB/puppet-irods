# custom dockerfile that removes default webapps from diceunc image.
#
# If you want to use this image, you will need to build it, push it, and
# specify its location in heira

FROM diceunc/rest:4.1.10.0-RC1

# remove stuff we don't need
RUN rm -rf /usr/local/tomcat/webapps/ROOT
RUN rm -rf /usr/local/tomcat/webapps/docs
RUN rm -rf /usr/local/tomcat/webapps/examples
RUN rm -rf /usr/local/tomcat/webapps/host-manager
RUN rm -rf /usr/local/tomcat/webapps/manager

CMD ["/runit.sh"]
