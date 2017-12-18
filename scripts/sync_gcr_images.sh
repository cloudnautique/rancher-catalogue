#!/bin/bash

workdir=`pwd`
log_file=${workdir}/sync_images_$(date +"%Y-%m-%d").log

#Input params: messages
#Output params: None
#Function: Present the processing log and write to log file.
logger()
{   
    log=$1
    cur_time='['$(date +"%Y-%m-%d %H:%M:%S")']'
    echo ${cur_time} ${log} | tee -a ${log_file}
}

#check shyaml install 
shyaml_install_check ()
{   
    logger "check shyaml install"
    shyaml -h
    if [ $? -eq 0 ]; then
        logger "shyaml has been installed."
        return 0
    else
        logger "Please install shyaml."
        exit -1
    fi
}

#check Docker install
docker_install_check ()
{   
    logger "check Docker install"
    docker -v
    if [ $? -eq 0 ]; then
        logger "Docker has been installed."
        return 0
    else
        logger "Please install Docker."
        exit -1
    fi
}

#Input params: None
#Output params: None
#Function: Install jq tools regarding to different linux releases.
jq_install_check ()
{
    logger "check jq install"
    jq --version
    if [ $? -eq 0 ]; then
        logger "JQ has been installed."
        return 0
    else
        logger "Please install JQ."
        exit -1
    fi
}

#Input params: None
#Output params: None
#Function: Loop to load and verify user's registry information.
docker_login_check ()
{   
    docker_info=$(docker info |grep Username |wc -l)
    if  [ ${docker_info} -eq 1 ]; then
        #echo  "Check that you have logged in to docker hub"
        logger "Check that you have logged in to docker hub"
        return 0
    else
        #echo "You didn't log in to docker hub. Please login"
        logger "You didn't log in to docker hub. Please login"
        exit
    fi
}

#Input params: kube namespace, image information, rancher namespace
#Output params: None
#Function: Pull and retag the image from google's offical registry, then push it to customized registry.
docker_push ()
{   
    s_repo=$1
    t_repo=$2
    s_namespace=$3
    t_namespace=$4
    img=$5
    tag=$6

    docker pull ${s_repo}/${s_namespace}/${img}:${tag}
    docker tag  ${s_repo}/${s_namespace}/${img}:${tag} ${t_repo}/${t_namespace}/${img}:${tag}
    docker push ${t_repo}/${t_namespace}/${img}:${tag}

    if [ $? -ne 0 ]; then
        logger "synchronized the ${t_repo}/${t_namespace}/${img}:${tag} failed."
        exit -1
    else
        logger "synchronized the ${t_repo}/${t_namespace}/${img}:${tag} successfully."
        return 0
    fi
}

sync_images ()
{   
    for img_tag in $(echo ${images_tag_list});
    do  
        source_namespace=$(echo ${img_tag} | awk -F"/" '{print $1}')
        imgs=$(echo ${img_tag} |awk -F"/" '{print $2}' | awk -F":" '{print $1}')
        tags=$(echo ${img_tag} |awk -F"/" '{print $2}' | awk -F":" '{print $2}')

        target_imgs_check=$(curl -k -s -X GET https://registry.hub.docker.com/v2/repositories/${target_namespace}/${imgs}/tags/ | jq '.["detail"]' | sed 's/\"//g' | awk '{print $2}')

        if [ x"${check_tag}" == x"True" ]; then
            if [ "x${target_imgs_check}" == "xnot" ]; then  
                 docker_push ${source_repo} ${target_repo} ${source_namespace} ${target_namespace} ${imgs} ${tags}
            else
                target_tags_check=$(curl -k -s -X GET https://registry.hub.docker.com/v2/repositories/${target_namespace}/${imgs}/tags/?page_size=1000 | jq '."results"[]["name"]' |sort -r |sed 's/\"//g')  
                if  echo "${target_tags_check[@]}" | grep -w "${tags}" &>/dev/null; then
                    logger "The image ${target_namespace}/${imgs}:${tags} has been synchronized and skipped."
                else
                    docker_push ${source_repo} ${target_repo} ${source_namespace} ${target_namespace} ${imgs} ${tags}
                fi
            fi
        else
            docker_push ${source_repo} ${target_repo} ${source_namespace} ${target_namespace} ${imgs} ${tags}
        fi
    done
    logger 'Completed to synchronize.'
    return 0
}

#main process
jq_install_check
shyaml_install_check
docker_install_check
docker_login_check

images_tag_list=$(cat image-sync.yaml | shyaml get-value images | awk '{print $2}')
check_tag=$(cat image-sync.yaml | shyaml get-value check_tag)
source_repo=$(cat image-sync.yaml | shyaml get-value source_repo)
target_repo=$(cat image-sync.yaml | shyaml get-value target_repo)
target_namespace=$(cat image-sync.yaml | shyaml get-value target_namespace)

sync_images