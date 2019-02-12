FROM arm32v6/python:3-alpine
WORKDIR /usr/src/app

# Install useful dev tools
RUN apk --no-cache --update add jq vim
# Or, if git is needed
# RUN apk --no-cache --update add git jq vim

# Install the SpeedTest CLI
RUN pip install speedtest-cli

# Might need this approach on otherplatforms
#RUN git clone https://github.com/sivel/speedtest-cli.git
#RUN cd speedtest-cli; python setup.py install

# Install flask (for the REST API server)
RUN pip install Flask

# Copy over the source
COPY speedtest_server.py .

# Run the daemon
CMD python speedtest_server.py

