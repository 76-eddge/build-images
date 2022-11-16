FROM alpine AS deploy

# Install Powershell and its dependencies
RUN apk -U add --no-cache ca-certificates less ncurses-terminfo-base krb5-libs libgcc libintl libssl1.1 libstdc++ tzdata userspace-rcu zlib icu-libs curl lttng-ust && curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.2.7/powershell-7.2.7-linux-alpine-x64.tar.gz -o /tmp/powershell.tar.gz && mkdir -p /opt/microsoft/powershell/7 && tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 && chmod +x /opt/microsoft/powershell/7/pwsh && ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh # buildkit

# Use Powershell for all future RUN commands
SHELL ["/usr/bin/pwsh", "-Command"]

# Other dependencies
RUN apk add --no-cache linux-headers musl-dev binutils file gcc g++ make libc-dev perl make git cmake patch sed util-linux-dev openssl llvm-dev clang clang-analyzer doxygen gmp-dev libcrypto3 chromium ttf-freefont nodejs py3-setuptools py3-lxml py3-jinja2 python3 && ln -sf python3 /usr/bin/python

# Get npm
RUN apk -UX https://dl-cdn.alpinelinux.org/alpine/latest-stable/community add --no-cache npm gradle openjdk17-jdk 

# Get ninja
RUN Invoke-WebRequest 'https://github.com/ninja-build/ninja/archive/refs/tags/v1.11.0.zip' -OutFile '/tmp/ninja.zip'; Expand-Archive '/tmp/ninja.zip' '/opt'; Remove-Item '/tmp/ninja.zip'; cd '/opt/ninja-*'; ./configure.py --bootstrap; New-Item -ItemType "file" -Path "$profile" -Force; Add-Content "$profile" '$env:PATH = "${env:PATH}:/opt/ninja-1.11.0"'

# erlang
RUN apk add --no-cache erlang

# Grab our cross compilers
RUN Invoke-WebRequest 'https://github.com/76-eddge/musl-cross/releases/download/v0.9.11/x86_64-linux-musl.tar.xz' -OutFile '/tmp/x86_64-linux-musl.tar.xz'; New-Item -Path "/opt/x86_64-linux-musl" -ItemType "Directory" -Force; tar -xf "/tmp/x86_64-linux-musl.tar.xz" -C "/opt/x86_64-linux-musl"; # Remove-Item '/tmp/x86_64-linux-musl.tar.xz';\
Invoke-WebRequest 'https://github.com/76-eddge/musl-cross/releases/download/v0.9.11/aarch64-linux-musl.tar.xz' -OutFile '/tmp/aarch64-linux-musl.tar.xz'; New-Item -Path "/opt/aarch64-linux-musl" -ItemType "Directory" -Force; tar -xf "/tmp/aarch64-linux-musl.tar.xz" -C "/opt/aarch64-linux-musl"; Remove-Item '/tmp/aarch64-linux-musl.tar.xz';\
Invoke-WebRequest 'https://github.com/76-eddge/musl-cross/releases/download/v0.9.11/arm-linux-musleabihf.tar.xz' -OutFile '/tmp/arm-linux-musleabihf.tar.xz'; New-Item -Path "/opt/arm-linux-musleabihf" -ItemType "Directory" -Force; tar -xf "/tmp/arm-linux-musleabihf.tar.xz" -C "/opt/arm-linux-musleabihf"; Remove-Item '/tmp/arm-linux-musleabihf.tar.xz';\
Invoke-WebRequest 'https://github.com/76-eddge/musl-cross/releases/download/v0.9.11/i686-linux-musl.tar.xz' -OutFile '/tmp/i686-linux-musl.tar.xz'; New-Item -Path "/opt/i686-linux-musl" -ItemType "Directory" -Force; tar -xf "/tmp/i686-linux-musl.tar.xz" -C "/opt/i686-linux-musl"; Remove-Item '/tmp/i686-linux-musl.tar.xz';\
Invoke-WebRequest 'https://github.com/76-eddge/musl-cross/releases/download/v0.9.11/powerpc64le-linux-musl.tar.xz' -OutFile '/tmp/powerpc64le-linux-musl.tar.xz';  New-Item -Path "/opt/powerpc64le-linux-musl" -ItemType "Directory" -Force; tar -xf "/tmp/powerpc64le-linux-musl.tar.xz" -C "/opt/powerpc64le-linux-musl"; Remove-Item '/tmp/powerpc64le-linux-musl.tar.xz'

# Get our Node dependencies
COPY "package.json" /home/

RUN cd /home/ && npm install && npm audit

# Grab local files
COPY build.gradle /tmp/gradle/build.gradle

# Perform tasks as basic user
RUN adduser jenkins; chown -R jenkins /tmp/gradle

USER jenkins

RUN New-Item -ItemType "file" -Path "$profile" -Force; Add-Content "$profile" '$env:PATH = "${env:PATH}:/opt/gradle-7.5.1/bin/:/opt/jdk-17.0.2+8/bin:/opt/ninja-1.11.0"';  Add-Content "$profile" '$env:PUPPETEER_EXECUTABLE_PATH = "/usr/bin/chromium-browser"'

# Get our Gradle dependencies
# TODO: figure out how to set expiration on gradle dependencies?
RUN cd /tmp/gradle; gradle --no-daemon resolveDependencies
