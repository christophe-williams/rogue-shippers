# base image
FROM python:3.8-slim-buster

# ubuntu installing - python, pip, graphviz
RUN apt-get update &&\
    apt-get install python3.7 -y &&\
    apt-get install python3-pip -y &&\
    apt-get install graphviz -y

# exposing default port for streamlit
EXPOSE $PORT

# making directory of app
WORKDIR /streamlit-docker

# install pip then packages
RUN pip3 install --quiet streamlit pivottablejs joblib

# copying all files over
COPY src ./src
COPY data ./data

# cmd to launch app when container is run
CMD ["streamlit", "run", "src/pivot.py"]

# streamlit-specific commands for config
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
RUN mkdir -p /root/.streamlit
RUN bash -c 'echo -e "\
[general]\n\
email = \"\"\n\
" > /root/.streamlit/credentials.toml'

RUN bash -c 'echo -e "\
[server]\n\
enableCORS = false\n\
" > /root/.streamlit/config.toml'
