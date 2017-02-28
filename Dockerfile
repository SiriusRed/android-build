FROM openjdk:8-jdk

ENV ANDROID_COMPILE_SDK 24
ENV ANDROID_BUILD_TOOLS 24.0.1
ENV ANDROID_SDK_TOOLS 24.4.1 
ENV ANDROID_HOME=/android-sdk-linux
ENV PATH=$PATH:/android-sdk-linux/platform-tools/

COPY ./gradlew gradlew

RUN apt-get --quiet update --yes &&\
    apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 jq
RUN wget  --quiet --output-document=android-sdk.tgz https://dl.google.com/android/android-sdk_r${ANDROID_SDK_TOOLS}-linux.tgz &&\
    tar --extract --gzip --file=android-sdk.tgz
RUN echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter android-${ANDROID_COMPILE_SDK} &&\ 
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter platform-tools &&\
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter build-tools-${ANDROID_BUILD_TOOLS} &&\
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-android-m2repository &&\
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-google-google_play_services &&\
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-google-m2repository &&\
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter addon-google_apis_x86-google-${ANDROID_COMPILE_SDK} &&\
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter sys-img-armeabi-v7a-android-${ANDROID_COMPILE_SDK} &&\
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-android-support &&\
    echo "export ANDROID_HOME=/android-sdk-linux"  >> ~/.profile &&\
    echo "export PATH=$PATH:/android-sdk-linux/platform-tools/" >> ~/.profile &&\
    chmod +x gradlew


