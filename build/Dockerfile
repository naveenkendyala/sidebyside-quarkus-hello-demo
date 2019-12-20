FROM registry.access.redhat.com/ubi7-dev-preview/ubi-minimal
WORKDIR /work/
COPY target/sidebyside-quarkus-hello-demo-1.0-SNAPSHOT-runner /work/sidebyside-quarkus-hello-demo-1.0-SNAPSHOT-runner
RUN chmod 775 /work
EXPOSE 8080
ENTRYPOINT [ "./sidebyside-quarkus-hello-demo-1.0-SNAPSHOT-runner", "-Xmx7m", "-Xmn7m", "-Xms7m" ]
