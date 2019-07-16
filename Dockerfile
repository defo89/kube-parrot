FROM alpine
MAINTAINER Michael Schmidt <michael.schmidt02@@sap.com>

RUN apk --no-cache add curl jq

ADD bin/linux/parrot parrot 

ADD ./entrypoint.sh .

RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
