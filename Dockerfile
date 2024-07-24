FROM registry.access.redhat.com/ubi9/nodejs-20@sha256:2dc43901e53420104d4742a201fc1f30b5c560362c542e821c07f77a805aec9a as Build
#
COPY . .
USER root
EXPOSE 3000
RUN echo "export PATH=${PATH}:$HOME/node_modules/.bin" >> ~/.bashrc && \
    npm install --ignore-scripts && \
    npm run build && \
    chmod -R 777 /opt/app-root/src/.npm && \
    echo "NEXT_PUBLIC_REKOR_DEFAULT_DOMAIN = ${NEXT_PUBLIC_REKOR_DEFAULT_DOMAIN}" && \
    npm cache clean --force
USER 1001
CMD ["node_modules/.bin/next", "start"]

LABEL \
      com.redhat.component="trusted-artifact-signer-rekor-ui" \
      name="trusted-artifact-signer-rekor-ui" \
      version="0.0.1" \
      summary="User Interface for checking Rekor Entries" \
      description="Provides a user interface for checking Rekor Entries through a Node App" \
      io.k8s.description="Provides a user interface for checking Rekor Entries through a Node App" \
      io.k8s.display-name="Provides a user interface for checking Rekor Entries through a Node App" \
      io.openshift.tags="rekor-ui, rekor, cli, rhtas, trusted, artifact, signer, sigstore" \
      maintainer="trusted-artifact-signer@redhat.com"
