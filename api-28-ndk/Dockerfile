FROM alpine:3.8

# Install glibc compatibility layer (required by cmake and ninja)
RUN apk add gcompat

# Install build tools (make, gcc, etc.) and bash
RUN apk add --update --no-cache build-base bash unzip git

# Install Java8
RUN apk add --update --no-cache openjdk8

# Install Ruby
RUN apk add --update --no-cache ruby ruby-dev

RUN gem install bundler -N

ENV ANDROID_HOME /opt/android-sdk-linux
ENV SDK_TOOLS_VERSION 3859397
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Install Android SDK tools
RUN mkdir -p /opt/android-sdk-linux && cd /opt \
    && wget -q http://dl.google.com/android/repository/sdk-tools-linux-${SDK_TOOLS_VERSION}.zip -O android-sdk-tools.zip \
    && unzip -q android-sdk-tools.zip -d ${ANDROID_HOME} \
    && rm -f android-sdk-tools.zip \
    && mkdir -p /root/.android \
    && touch /root/.android/repositories.cfg

# Accept Android SDK licences
RUN yes | sdkmanager --licenses

# Update packages
RUN sdkmanager --update

# Install selected packages
ADD packages.txt /$ANDROID_HOME

RUN while read -r package; do PACKAGES="${PACKAGES}${package} "; done < /$ANDROID_HOME/packages.txt && \
    ${ANDROID_HOME}/tools/bin/sdkmanager ${PACKAGES}

CMD [ "/bin/bash", "-l" ]
