FROM alpine:latest

RUN apk update && apk add postgresql-client wget gnupg

RUN wget https://github.com/Backblaze/B2_Command_Line_Tool/releases/latest/download/b2-linux 

RUN chmod +x b2-linux 

CMD ["/bin/sh"]

