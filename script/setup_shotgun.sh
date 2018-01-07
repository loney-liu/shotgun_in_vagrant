#!/usr/bin/env bash
. /home/vagrant/script/shotgun_global

SGHOME="/opt/shotgun/se"
SG_SRC="/vagrant/images"
TMP="/usr/tmp"

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
  SGHome="/opt/shotgun/se/production"
  SECHome="/opt/shotgun/sec"
  DCUP="docker-compose up -d"
  DCSTAT="Up      0.0.0.0:80->80/tcp"
  DCPS="sudo docker-compose ps"
  SECSTAT="Up      0.0.0.0:8080->8080/tcp"


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
    echo "SEC isn't running. start SEC"
    echo "cd ${SECHome} && ${DCUP}"
    #cd $SECHome && $DCUP
    systemctl start secstart
    echo "Access Shotgun http://127.0.0.1:9999"
  fi
}

## add shotgun sec
function _add_sec_startup_cript {
  SECRUN="/etc/systemd/system/secstart.service"
  SRC="/home/vagrant/script/secstart.service"
  echo "Checking if SEC startup exist"
  if [[ ! -f $SECRUN ]]; then
    sudo cp $SRC $SECRUN 
    systemctl enable secstart
    #systemctl start secstart
  fi
}


function _changepwd {
  CMD="sudo docker-compose run --rm app rake admin:reset_shotgun_admin_password[Admin.12345]"
  echo "cd ${SGHome} && ${CMD}"
  cd $SGHome && $CMD
}

if [[ ! -d $SGHOME ]]; then
  _cp_shotgun_image 
  sudo sh /vagrant/script/setup_validation_docker.sh --install
fi

_add_sec_startup_cript
sudo sh /vagrant/script/config-docker.sh

if [[ -f $TMP"/shotgun-docker-se-"$APPVER".tar.gz" ]]; then
  echo "Delete tar files in temp folder."
  sudo rm -rf $TMP/shotgun*
fi

_dcup

if [[ $RESETADMINPW == 1 ]]; then
  sleep 30s
  _changepwd
fi