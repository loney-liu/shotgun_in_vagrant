#!/usr/bin/env bash
. /home/vagrant/script/shotgun_global

SGHOME="/opt/shotgun/se"
SG_SRC="/vagrant/images"
TMP="/usr/tmp"

SGHome="/opt/shotgun/se/production"
SECHome="/opt/shotgun/sec"
DCUP="docker-compose up -d"
DCPS="sudo docker-compose ps"
DCSTOP="sudo docker-compose stop"
DCSTAT="Up      0.0.0.0:80->80/tcp"
SECSTAT="Up      0.0.0.0:8080->8080/tcp"

function _cp_shotgun_image {
  echo "sudo cp ${SG_SRC}/shotgun-docker-se-${APPVER}.tar.gz ${TMP}"
  sudo cp $SG_SRC"/shotgun-docker-se-"$APPVER".tar.gz" $TMP
  echo "sudo cp ${SG_SRC}/shotgun-docker-se-transcoder-server-${TSVER}.tar.gz ${TMP}"
  sudo cp $SG_SRC"/shotgun-docker-se-transcoder-server-"$TSVER".tar.gz" $TMP
  echo "sudo cp ${SG_SRC}/shotgun-docker-se-transcoder-worker-${TWVER}.tar.gz ${TMP}"
  sudo cp $SG_SRC"/shotgun-docker-se-transcoder-worker-"$TWVER".tar.gz" $TMP
  echo "sudo cp ${SG_SRC}/shotgun-docker-sec-${SECVER}.tar.gz ${TMP}"
  sudo cp $SG_SRC"/shotgun-docker-sec-"$SECVER".tar.gz" $TMP
}

function _dcup {
  echo "Checking if shotgun running..."
  echo "cd ${SGHome} && ${DCPS} | grep \"${DCSTAT}\" &> /dev/null"
  if cd $SGHome && $DCPS | grep "${DCSTAT}" &> /dev/null
  then
    echo "shotgun is running"
    echo "Access Shotgun http://127.0.0.1:8888"
  else
    echo "shotgun isn't running. start shotgun"
    echo "cd ${SGHome} && ${DCUP}"
    cd $SGHome && $DCUP
    echo "Access Shotgun http://127.0.0.1:8888"
  fi


  echo "Checking if SEC running..."
  echo "cd ${SECHome} && ${DCPS} | grep \"${SECSTAT}\" &> /dev/null"
  if cd $SECHome && $DCPS | grep "${SECSTAT}" &> /dev/null
  then
    echo "SEC is running"
    echo "Access Shotgun http://127.0.0.1:9999"
  else
    _sec_start
    systemctl start secstart
    echo "Access Shotgun http://127.0.0.1:9999"
  fi
}

function _restartsec {
  echo "Checking if SEC running..."
  echo "cd ${SECHome} && ${DCPS} | grep \"${SECSTAT}\" &> /dev/null"
  if cd $SECHome && $DCPS | grep "${SECSTAT}" &> /dev/null
  then
    echo "SEC is running"
    echo "Restart SEC"
    cd $SECHome && $DCSTOP
    systemctl start secstart
  else
    echo "SEC isn't running. start SEC"
    echo "cd ${SECHome} && ${DCUP}"
    #cd $SECHome && $DCUP
    systemctl start secstart
    echo "Access Shotgun http://127.0.0.1:9999"
  fi
}

## add shotgun sec
function _sec_start {
  SECRUN="/etc/systemd/system/secstart.service"
  SRC="/home/vagrant/script/secstart.service"
  echo "Checking if SEC startup exist"
  if [[ ! -f $SECRUN ]]; then
    echo "sudo cp ${SRC} ${SECRUN}"
    sudo cp $SRC $SECRUN 
    systemctl enable secstart
  fi
}

##Add sec clustre
function _add_sec_clustre {
  SRC="/home/vagrant/script/Shotgun_In_Vagrant.json"
  CLUSTERFLD="/opt/shotgun/sec/sec/clusters"
  CLUSTERCFG="/opt/shotgun/sec/sec/clusters/Shotgun_In_Vagrant.json"

  if [[ ! -d $CLUSTERFLD ]]; then
    echo "sudo mkdir -p ${CLUSTERFLD}"
    sudo mkdir -p $CLUSTERFLD
  fi

  if [[ ! -f $CLUSTERCFG ]]; then
    echo "cp ${SRC} ${CLUSTERCFG}"
    sudo cp $SRC $CLUSTERCFG
    _restartsec
  fi
}

function _changepwd {
  CMD="sudo docker-compose run --rm app rake admin:reset_shotgun_admin_password[${SHOTGUN_ADMIN_PW}]"
  echo "cd ${SGHome} && ${CMD}"
  cd $SGHome && $CMD
}

if [[ ! -d $SGHOME ]]; then
  _cp_shotgun_image 
  sudo sh /vagrant/script/setup_validation_docker.sh --install
fi

sudo sh /vagrant/script/config-docker.sh

if [[ -f $TMP"/shotgun-docker-se-"$APPVER".tar.gz" ]]; then
  echo "Delete tar files in temp folder."
  sudo rm -rf $TMP/shotgun*
fi

_dcup
_add_sec_clustre

if [[ $RESETADMINPW == 1 ]]; then
  sleep 30s
  _changepwd
fi