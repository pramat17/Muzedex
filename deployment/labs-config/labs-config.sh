#!/bin/bash 

LABSCONFIG_PATH=`pwd`
export KUBECONFIG=$LABSCONFIG_PATH/labs-config.conf
export PATH=$PATH:$LABSCONFIG_PATH

