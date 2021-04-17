FROM ubuntu:18.04

# Fix locale issues
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

RUN apt-get update

# Install build tools (make, gcc, etc.) and bash
RUN apt-get install -y build-essential unzip git wget curl

# Install Java8
RUN apt-get install -y openjdk-11-jdk-headless

# Install Ruby
RUN apt-get install -y ruby ruby-dev

RUN gem install bundler -v '~> 1.0' -N
RUN gem install bundler -v '~> 2.0' -N

ENV ANDROID_HOME /opt/android-sdk-linux
ENV SDK_TOOLS_VERSION 6858069
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Install Android SDK tools
RUN mkdir -p /opt/android-sdk-linux && cd /opt \
    && wget -q https://dl.google.com/android/repository/commandlinetools-linux-${SDK_TOOLS_VERSION}_latest.zip -O commandlinetools-linux.zip \
    && unzip -q commandlinetools-linux.zip -d ${ANDROID_HOME} \
    && rm -f commandlinetools-linux.zip \
    && mv ${ANDROID_HOME}/cmdline-tools ${ANDROID_HOME}/latest \
    && mkdir ${ANDROID_HOME}/cmdline-tools \
    && mv ${ANDROID_HOME}/latest ${ANDROID_HOME}/cmdline-tools \
    && mkdir -p /root/.android \
    && touch /root/.android/repositories.cfg

# Accept Android SDK licences
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses

# Update packages
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --update

# Install selected packages
ADD packages.txt /$ANDROID_HOME

RUN while read -r package; do PACKAGES="${PACKAGES}${package} "; done < /$ANDROID_HOME/packages.txt && \
    yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager ${PACKAGES}

CMD [ "/bin/bash", "-l" ]
