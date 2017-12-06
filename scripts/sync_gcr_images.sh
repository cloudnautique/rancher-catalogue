#!/bin/bash

workdir=`pwd`
log_file=${workdir}/sync_images_$(date +"%Y-%m-%d").log
images_list="kubernetes-dashboard,k8s-dns-sidecar,k8s-dns-kube-dns,k8s-dns-dnsmasq-nanny,heapster-grafana,heapster-influxdb,heapster,pause,tiller"
images_arch=amd64
images_namespace=rancher

#Input params: messages
#Output params: None
#Function: Present the processing log and write to log file.
logger()
{   
    log=$1
    cur_time='['$(date +"%Y-%m-%d %H:%M:%S")']'
    echo ${cur_time} ${log} | tee -a ${log_file}
}

#Input params: None
#Output params: None
#Function: Install jq tools regarding to different linux releases.
jq_install ()
{
    logger "Start to install jq"

    if [ -r '/etc/debian_version' ]; then
        apt install -y jq
    elif [ -r '/etc/fedora-release' ]; then
        yum install -y jq
    elif [ -r '/etc/redhat-release' ]; then
        yum install -y jq
    elif [ -r '/etc/centos-release' ]; then
        yum install -y jq
    elif [ -r '/etc/lsb-release' ]; then
        apt-get install -y jq
    else 
        logger "Could not get any linux release information."
        exit -1
    fi

    if [ $? -eq 0 ]; then
        logger "Installed the jq successfully."
        return 0
    else
        logger "Installed the jq failed, please kindly check the errors in log."
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
    gcr_namespace=$1
    img_tag=$2  
    rancher_namespace=$3

    docker pull gcr.io/${gcr_namespace}/${img_tag}
    docker tag gcr.io/${gcr_namespace}/${img_tag} ${rancher_namespace}/${img_tag}
    docker push ${rancher_namespace}/${img_tag}

    if [ $? -ne 0 ]; then
        logger "synchronized the ${rancher_namespace}/${img_tag} failed."
        exit -1
    else
        logger "synchronized the ${rancher_namespace}/${img_tag} successfully."
        return 0
    fi
}

#Input params: images list, arch type, namespace
#Output params: None
#Function: Loop to list/compare images and invoke docker_push to update images.
sync_images_with_arch ()
{
    img_list=$1
    img_arch=$2
    img_namespace=$3

    for imgs in $(echo ${img_list} | tr "," "\n");
    do  
        if [ "x${imgs}" == "xtiller" ]; then
            kube_tags=$(curl -k -s -X GET https://gcr.io/v2/kubernetes-helm/${imgs}/tags/list | jq -r '.tags[]'|sort -r)
            rancher_result=$(curl -k -s -X GET https://registry.hub.docker.com/v2/repositories/${img_namespace}/${imgs}/tags/ | jq '.["detail"]' | sed 's/\"//g' | awk '{print $2}')

            if [ "x${rancher_result}" == "xnot" ]; then
                for tags in ${kube_tags}
                do
                    docker_push "kubernetes-helm" ${imgs}:${tags} ${img_namespace}
                done
            else
                rancher_tags=$(curl -k -s -X GET https://registry.hub.docker.com/v2/repositories/${img_namespace}/${imgs}/tags/?page_size=1000 | jq '."results"[]["name"]' |sort -r |sed 's/\"//g' )
                for tags in ${kube_tags}
                do
                    if echo "${rancher_tags[@]}" | grep -w "${tags}" &>/dev/null; then
                        logger "The image ${imgs}:${tags} has been synchronized and skipped."
                    else
                        docker_push "kubernetes-helm" ${imgs}:${tags} ${img_namespace}
                    fi  
                done
            fi
        else
            kube_tags=$(curl -k -s -X GET https://gcr.io/v2/google_containers/${imgs}-${img_arch}/tags/list | jq -r '.tags[]'|sort -r)
            rancher_result=$(curl -k -s -X GET https://registry.hub.docker.com/v2/repositories/${img_namespace}/${imgs}-${img_arch}/tags/ | jq '.["detail"]' | sed 's/\"//g' | awk '{print $2}')

            if [ "x${rancher_result}" == "xnot" ]; then  
                for tags in ${kube_tags}
                do  
                    docker_push "google_containers" ${imgs}-${img_arch}:${tags} ${img_namespace}
                done
            else
                rancher_tags=$(curl -k -s -X GET https://registry.hub.docker.com/v2/repositories/${img_namespace}/${imgs}-${img_arch}/tags/?page_size=1000 | jq '."results"[]["name"]' |sort -r |sed 's/\"//g' )
                for tags in ${kube_tags}
                do  
                    if  echo "${rancher_tags[@]}" | grep -w "${tags}" &>/dev/null; then
                        logger "The image ${imgs}-${img_arch}:${tags} has been synchronized and skipped."
                    else
                        docker_push "google_containers" ${imgs}-${img_arch}:${tags} ${img_namespace}
                    fi
                done
            fi
        fi
    done

    logger 'Completed to synchronize.'

    return 0
}

#main process
jq_install
docker_login_check
sync_images_with_arch ${images_list} ${images_arch} ${images_namespace}
