from tomcat:8.0.20-jre8 
RUN mkdir /usr/local/tomcat/webapps/myapp
COPY project/target/project-4.0-DAP.war /usr/local/tomcat/webapps/project-4.0-DAP.war