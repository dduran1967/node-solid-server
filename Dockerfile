FROM node:8
EXPOSE 8443

# Use node user's home directory for better security.
WORKDIR /home/node/solid-server

# Install dependencies first for faster and smaller builds.
COPY package.json .
RUN npm install --production
COPY . .

# Create ssl certificates
# TODO: add logic for skipping this step when certs are handled elsewhere.
ARG DOMAIN="*.localhost"
ARG SUBJECT=/CN=${DOMAIN}
WORKDIR .ssl
RUN openssl req \
    -new \
    -x509 \
    -nodes \
    -newkey rsa:4096 \
    -subj ${SUBJECT} \
    -keyout ${DOMAIN}.key.pem \
    -out ${DOMAIN}.crt.pem
WORKDIR ..


CMD node bin/solid start --verbose
