FROM fedora:latest

RUN yum -y install stress procps-ng 

ENV CPU_LOAD=1 MEM_LOAD=1 MEM_SIZE=256M
CMD stress --cpu $CPU_LOAD --vm $MEM_LOAD --vm-bytes $MEM_SIZE
