#!/bin/bash -e

PUSH=

for ARG; do
  shift

  case $ARG in
      (--push) PUSH=true ;;
         (--*) echo Ignoring unrecognized option: $ARG 1>&2 ;;
           (*) set -- "$@" "$ARG" ;;
  esac
done

if [ $# -gt 0 ]; then
  echo Expected arguments: [--push] 1>&2
  exit 1
fi

# docker buildx build . --file Dockerfile --tag horseshoe/horseshoe --tag horseshoe/horseshoe:${GITHUB_REF/refs\/tags\//} --platform linux/amd64,linux/arm/v7,linux/arm64 --build-arg DEPLOY=local-jar --build-arg JAR_FILE=build/libs/horseshoe-*.jar --target deploy --push
# docker build cxx --tag 76eddge/cxx --target deploy
docker build cxx-CentOS6 --tag 76eddge/cxx:CentOS6 --target deploy
if [ ! -z "$PUSH" ]; then docker push -a 76eddge/cxx; fi
