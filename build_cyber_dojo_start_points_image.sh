#!/bin/bash
set -exv

readonly MY_NAME=`basename "$0"`
readonly IMAGE_NAME="${1}"
readonly REPO_NAMES="${@:2}"

# - - - - - - - - - - - - - - - - -

error() { echo "ERROR: ${2}"; exit ${1}; }

show_use()
{
  echo "use: ${MY_NAME} <image-name> <git-repo-urls>"
  echo ""
  echo "Create a cyber-dojo start-point image."
  echo "Its base image will be cyberdojo/start-points-base"
  echo "and it will contain clones of all the specified git repos."
  echo "Examples"
  echo "\$ ${MY_NAME} acme/one-start-point file:///.../asm-assert"
  echo "\$ ${MY_NAME} acme/start-points https://github.com/cyber-dojo/start-points.git"
  #TODO: explain you must end up with one of each of the 3 kinds
  #TODO: or, provide defaults for each of the 3?
}

# - - - - - - - - - - - - - - - - -

if [ "${IMAGE_NAME}" = '--help' ];  then
  show_use; exit 0
fi
if ! hash git 2> /dev/null; then
  error 1 'git needs to be installed'
fi
if ! hash docker 2> /dev/null; then
  error 2 'docker needs to be installed'
fi
if [ "${IMAGE_NAME}" = '' ]; then
  show_use; error 3 'missing <image_name>'
fi
if [ "${REPO_NAMES}" = '' ]; then
  show_use; error 4 'missing <git-repo-urls>'
fi

# git clone all repos into docker context
readonly CONTEXT_DIR=$(mktemp -d /tmp/cyber-dojo-start-points.XXXXXXXXX)
echo "CONTEXT_DIR=:${CONTEXT_DIR}:"
ls -al ${CONTEXT_DIR}

echo "xxxx" >> ${CONTEXT_DIR}/try-me.txt

cleanup() { rm -rf ${CONTEXT_DIR} > /dev/null; }
trap cleanup EXIT
declare index=0
for repo_name in $REPO_NAMES; do
    cd ${CONTEXT_DIR}
    pwd
    git clone --verbose --depth 1 ${repo_name} ${index}
    cd ${index}
    pwd
    declare sha=$(git rev-parse HEAD)
    echo "sha=:${sha}:"
    echo "repo_name=:${repo_name}:"
    echo "${index} ${sha} ${repo_name}" >> ${CONTEXT_DIR}/shas.txt
    #((index++)) This is failing!?
    index=$((index + 1))
done

# create a Dockerfile in the docker context
readonly DOCKERFILE=${CONTEXT_DIR}/Dockerfile
echo 'FROM  cyberdojo/start-points-base'      >> ${DOCKERFILE}
echo 'ARG HOME=/app/repos'                    >> ${DOCKERFILE}
echo 'COPY . ${HOME}'                         >> ${DOCKERFILE}
echo 'RUN ruby /app/src/check_all.rb ${HOME}' >> ${DOCKERFILE}

# remove unwanted files from docker image
readonly DOCKER_IGNORE=${CONTEXT_DIR}/.dockerignore
echo "Dockerfile"    >> ${DOCKER_IGNORE}
echo ".dockerignore" >> ${DOCKER_IGNORE}

# build the image
docker build --tag ${IMAGE_NAME} ${CONTEXT_DIR}
