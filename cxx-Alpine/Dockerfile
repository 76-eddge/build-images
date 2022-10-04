FROM alpine AS build

RUN apk add g++ util-linux-dev llvm-dev clang

# Cleanup
RUN strip /lib*/*.so* /usr/lib*/*.so* /usr/lib/gcc*/*/*/*/*.so* || echo Ignoring invalid files 1>&2

# Prepare deploy directory
RUN mkdir -p /deploy/lib /deploy/usr/lib && \
	find /lib /usr/lib '(' -name 'ld-*' -o -name 'libanl*' -o -name 'libBrokenLocale*' -o -name 'libc[.-]*' -o -name 'libcidn*' -o -name 'libcrypt[.-]*' -o -name 'libdl*' -o -name 'libfreebl*' -o -name 'libgcc_s*' -o -name 'libm[.-]*' -o -name 'libmvec*' -o -name 'libnsl*' -o -name 'libnss*' -o -name 'libpthread*' -o -name 'libresolv*' -o -name 'librt[.-]*' -o -name 'libstdc++*' -o -name 'libthread_db*' -o -name 'libutil*' -o -name 'libuuid*' -o -name 'libz*' -o -name '*.o' -o -name '*.a' -o \
		-name 'libbfd*' -o -name 'libctf*' -o -name 'libcloog*' -o -name 'libgmp*' -o -name 'libgomp*' -o -name 'libisl*' -o -name 'libmemusage*' -o -name 'libmpc*' -o -name 'libmpfr*' -o -name 'libopcodes*' -o -name 'libpcprofile*' ')' -exec cp -al {} /deploy{} \; && \
	cp -al /usr/lib/gcc /deploy/usr/lib/

RUN mkdir -p /deploy/usr/bin && \
	find /usr/bin '(' -name '*-addr2line' -o -name '*-ar' -o -name '*-as' -o -name '*-c++filt' -o -name '*-cpp*' -o -name '*-elfedit' -o -name '*-g++*' -o -name '*-gcc*' -o -name '*-gcov*' -o -name '*-gprof' -o -name '*-ld' -o -name '*-ld.*' -o -name '*-nm' -o -name '*-objcopy' -o -name '*-objdump' -o -name '*-ranlib' -o -name '*-readelf' -o -name '*-size' -o -name '*-strings' -o -name '*-strip' -o \
		-name 'addr2line' -o -name 'ar' -o -name 'as' -o -name 'c++filt' -o -name 'cpp*' -o -name 'elfedit' -o -name 'g++*' -o -name 'gcc*' -o -name 'gcov*' -o -name 'gold' -o -name 'gprof' -o -name 'ld' -o -name 'ld.*' -o -name 'nm' -o -name 'objcopy' -o -name 'objdump' -o -name 'ranlib' -o -name 'readelf' -o -name 'size' -o -name 'strings' -o -name 'strip' ')' -exec cp -al {} /deploy{} \;

RUN cp -al /usr/include /usr/libexec /deploy/usr/

# Deploy
FROM scratch AS deploy

COPY --from=build /deploy/ /

# Test
RUN [ "/usr/bin/g++", "--version" ]

ENTRYPOINT [ "/lib/ld-musl-x86_64.so.1" ]
CMD [ "/usr/bin/g++", "--version" ]
