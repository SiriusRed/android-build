# DESCRIPTION:    Oracle Java jdk-8u131, Android Compile SDK 25, Android Build Tools 25.0.2, Android SDK Tools 25.2.3
# SOURCE:         https://github.com/SiriusRed/android-build

FROM ubuntu:latest

ENV JDK_ARCHIVE_NAME=jdk-8u131-linux-x64.tar.gz
ENV JDK_ARCHIVE_URL=http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz 
ENV ANDROID_COMPILE_SDK=25
ENV ANDROID_BUILD_TOOLS=25.0.2
ENV ANDROID_SDK_TOOLS=25.2.3
ENV ANDROID_HOME=/android-sdk-linux
ENV JAVA_HOME=/srv/java/jdk
ENV PATH=$PATH:/srv/java/jdk/bin:/srv/java:/android-sdk-linux/platform-tools/
    
COPY ./gradlew gradlew

RUN apt-get --quiet update --yes &&\
    apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 curl jq git zipalign
    
RUN cd /tmp && \
    curl -L -O -H "Cookie: oraclelicense=accept-securebackup-cookie" -k "$JDK_ARCHIVE_URL" &&\
    mkdir /srv/java &&\
    tar xf $JDK_ARCHIVE_NAME -C /srv/java &&\
    rm -f $JDK_ARCHIVE_NAME &&\
    ln -s /srv/java/jdk* /srv/java/jdk &&\
    ln -s /srv/java/jdk /srv/java/jvm &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget  --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/tools_r${ANDROID_SDK_TOOLS}-linux.zip &&\
    unzip android-sdk.zip -d android-sdk-linux/ &&\
    echo y | $ANDROID_HOME/tools/android --silent update sdk --no-ui --all --filter android-${ANDROID_COMPILE_SDK} &&\ 
    echo y | $ANDROID_HOME/tools/android --silent update sdk --no-ui --all --filter platform-tools &&\
    echo y | $ANDROID_HOME/tools/android --silent update sdk --no-ui --all --filter build-tools-${ANDROID_BUILD_TOOLS} &&\
    echo y | $ANDROID_HOME/tools/android --silent update sdk --no-ui --all --filter extra-android-m2repository &&\
    echo y | $ANDROID_HOME/tools/android --silent update sdk --no-ui --all --filter extra-google-google_play_services &&\
    echo y | $ANDROID_HOME/tools/android --silent update sdk --no-ui --all --filter extra-google-m2repository &&\
    echo y | $ANDROID_HOME/tools/android --silent update sdk --no-ui --all --filter addon-google_apis_x86-google-${ANDROID_COMPILE_SDK} &&\
    echo y | $ANDROID_HOME/tools/android --silent update sdk --no-ui --all --filter sys-img-armeabi-v7a-android-${ANDROID_COMPILE_SDK} &&\
    echo y | $ANDROID_HOME/tools/android --silent update sdk --no-ui --all --filter extra-android-support &&\
    echo y | $ANDROID_HOME/tools/bin/sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2" &&\
    chmod +x gradlew

