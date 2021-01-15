#!/bin/sh -l

attempt_counter=0

interval=3
max_attempts=$(($7/interval));

## Wait until server is ready to continue
until $(curl --output /dev/null --silent --head --fail $1); do
  if [ ${attempt_counter} -eq ${max_attempts} ];then
    echo "Max attempts reached"
    exit 1
  fi

  printf '.'
  attempt_counter=$(($attempt_counter+1))
  sleep $interval
done

## Login
$JBOSS_HOME/bin/kcadm.sh config credentials \
--server $1 \
--user $2 \
--password $3 \
--realm $4 \
--client $5

## Execute jboss-cli.sh
eval $JBOSS_HOME/bin/jboss-cli.sh $8

## Execute kcadm.sh
eval $JBOSS_HOME/bin/kcadm.sh $6
