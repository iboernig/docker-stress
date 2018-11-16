# docker-stress
A simple tool to stress test a container platform and guage metrics data.
## Local usage with podman (or docker if you wish) 
Clone this repository:

    [iboernig@t470 Projects]$ git clone https://github.com/iboernig/docker-stress.git
    [iboernig@t470 Projects]$ cd docker-stress/

Build locally using podman (you can use "docker" with the same arguments, if you do not have podman)

    [iboernig@t470 Projects]$ podman build -t stress .
    STEP 1: FROM fedora:latest
    STEP 2: RUN yum -y install stress procps-ng 
    --> Using cache 8f2c95619aeb7799ae9806fd94d83605f894a458d344659910240092ed7efc4d
    STEP 3: FROM 8f2c95619aeb7799ae9806fd94d83605f894a458d344659910240092ed7efc4d
    ^[[OSTEP 4: ENV CPU_LOAD=1 MEM_LOAD=1 MEM_SIZE=256M
    --> Using cache 401365dae085f9a53d39e2eb6a2a14e6b21129d0e19d9f75a16503fc780b2bd5
    STEP 5: FROM 401365dae085f9a53d39e2eb6a2a14e6b21129d0e19d9f75a16503fc780b2bd5
    STEP 6: CMD stress --cpu $CPU_LOAD --vm $MEM_LOAD --vm-bytes $MEM_SIZE
    --> Using cache 8f71320d0ecad024efcbf98be0504eaf3354c08e6469e76a028c6f3b55e0bc95
    STEP 7: COMMIT 

And then run it:

    [iboernig@t470 docker-stress]$ podman run -it -rm stress 
    stress: info: [1] dispatching hogs: 1 cpu, 0 io, 1 vm, 0 hdd

You can change the parameters by setting the enviroment variables:
        
    [iboernig@t470 docker-stress]$ podman run -it -rm -e CPU_LOAD=2 -e MEM_LOAD=1 -e MEM_SIZE=512M stress
    stress: info: [1] dispatching hogs: 2 cpu, 0 io, 1 vm, 0 hdd
    
Note that each number of CPU_LOAD *and* each number of MEM_LOAD allocates one thread. The memory in the variable MEM_SIZE is the size *one* MEM_LOAD thread consumes. So if you use more than one, you will consume a multiple of MEM_SIZE memory.
For more infomation see `man stress`.

## Usage in Openshift
In OpenShift you only have to define a new app based on this repository:

    oc new-app https://github.com/iboernig/docker-stress.git

OpenShift then pulls teh repository, starts a docker build and deploys the image in one go.

If you need to tune the parameters you can do so by adding the environment variable to the deplyoment config. Either in the webconsole or by changing the deploymentconfig manually:

    oc set env dc/docker-stress CPU_LOAD=2 MEM_LOAD=1 MEM_SIZE=512M
