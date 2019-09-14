#!/bin/bash
# base code from https://sookocheff.com/post/bash/parsing-bash-script-arguments-with-shopts/

gamemode="0"  # Default gamemode
worldname="k8s"  # Default worldname
release="1.14.4"
modpath=""
worldtype=DEFAULT
modpack=""
servertype=VANILLA
zone="us-west1-a"

# Parse options to the `mc-server` command
while getopts ":hbg:w:v:m:f:r" opt; do
  case ${opt} in
   h )
     echo "
Usage:

-r Sets up a Bedrock server, ignoring these options: -vmbf
-g Gamemode of the server(0 or 1 on Java; survival or creative on Bedrock)
-w Worldname of the server
-v Version of Minecraft to use
-m Activates Forge; path to the mod file(.jar) required
-b Creates a Biomes 'O' Plenty world if -m is also called and the modpath points to the Biomes 'O' Plenty mod file
-f Activates FTB; URL or path of modpack required

Note: Make sure the modpacks and mods match the version of Minecraft under the -v flag
Other Note: Using both -m and -f will only activate -m
" 1>&2
     exit 1
     ;;
   r )
     bedrock=true
     ;;
   g )
     gamemode=$OPTARG 
     ;;
   w )
     worldname=$OPTARG 
     ;;
   v )
     release=$OPTARG
     ;;
   m )
     modded=true
     servertype=FORGE
     modpath=$OPTARG
     ;;
   b )
     worldtype=BIOMESOP
     ;;
   f )
     ftb=true
     servertype=FTB
     modpack=$OPTARG
     ;;
   \? )
     echo "
Invalid Option: -$OPTARG

Usage:

-r Sets up a Bedrock server, ignoring these options: -vmbf
-g Gamemode of the server(0 or 1 on Java; survival or creative on Bedrock)
-w Worldname of the server
-v Version of Minecraft to use
-m Activates Forge; path to the mod file(.jar) required
-b Creates a Biomes 'O' Plenty world if -m is also called and the modpath points to the Biomes 'O' Plenty mod file
-f Activates FTB; URL or path of modpack required

Note: Make sure the modpacks and mods match the version of Minecraft under the -v flag
Other Note: Using both -m and -f will only activate -m
" 1>&2
     exit 1
     ;;
   : )
     echo "Invalid option: $OPTARG requires an argument" 1>&2
     exit 1
     ;;
  esac
done
shift $((OPTIND -1))


echo -e "spawn-protection=16
max-tick-time=60000
query.port=25565
generator-settings=
force-gamemode=false
allow-nether=true
gamemode="${gamemode}"
enable-query=false
player-idle-timeout=0
difficulty=1
spawn-monsters=true
op-permission-level=4
pvp=true
snooper-enabled=true
level-type="${worldtype}"
hardcore=false
enable-command-block=true
network-compression-threshold=256
max-players=20
resource-pack-sha1=
max-world-size=29999984
rcon.port=25575
server-port=25565
texture-pack=
server-ip=
spawn-npcs=true
allow-flight=false
level-name="${worldname}"
view-distance=10
displayname=Fill this in if you have set the server to public\!
resource-pack=
discoverability=unlisted
spawn-animals=true
white-list=false
rcon.password=minecraft
generate-structures=true
online-mode=true
max-build-height=256
level-seed=
use-native-transport=true
prevent-proxy-connections=false
motd=A Minecraft Server powered by K8S
enable-rcon=true" > ./server.properties.provisioned

echo 'kind: Pod
apiVersion: v1
metadata:
  name: mc-server-pod-java
  labels: 
    app: java
spec:
  volumes:
    - name: mc-world-storage
      persistentVolumeClaim:
        claimName: mc-claim-java
  containers:
    - name: mc-server-container-java
      image: itzg/minecraft-server
      ports:
        - containerPort: 25565
          name: "mc-server"
      volumeMounts:
        - mountPath: "/data"
          name: mc-world-storage
      env:
      - name: EULA
        value: "true"
      - name: VERSION
        value: '"${release}"'
      - name: TYPE
        value: '"${servertype}"'

---

apiVersion: v1
kind: Service
metadata:
  name: mc-exposer-java
  labels:
    app: java
spec:
  type: LoadBalancer
  ports:
    - protocol: TCP
      port: 25565
      targetPort: 25565
  selector: 
    app: java

---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mc-claim-java
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 5G' > ./mc-pod-provisioned.yaml



if [ $bedrock ]
then 
    release="1.12.0.28"
  echo "This command will create a Bedrock version '"${release}"' world titled '"${worldname}"'.
Continue(y or n)?"
    read run
    if [ $run = y ]
    then
      echo "Then here we go!"



    #ACTUAL RUN SCRIPT FOR A BEDROCK SERVER

    echo -e "server-name=Alexs K8S Server\n\
gamemode="${gamemode}"\n\
difficulty=normal\n\
allow-cheats=false\n\
max-players=10\n\
online-mode=true\n\
white-list=false\n\
server-port=19132\n\
server-portv6=19133\n\
view-distance=32\n\
tick-distance=4\n\
player-idle-timeout=30\n\
max-threads=8\n\
level-name="${worldname}"\n\
level-seed=\n\
default-player-permission-level=operator\n\
texturepack-required=false" > ./server.properties.provisioned

    echo 'kind: Pod
apiVersion: v1
metadata:
  name: mc-server-pod-bedrock
  labels: 
    app: bedrock
spec:
  volumes:
    - name: mc-world-storage
      persistentVolumeClaim:
        claimName: mc-claim-bedrock
  containers:
    - name: mc-server-container
      image: itzg/minecraft-bedrock-server
      ports:
        - containerPort: 19132
          name: "mc-server"
      volumeMounts:
        - mountPath: "/data"
          name: mc-world-storage
      env:
      - name: EULA
        value: "true"
      - name: VERSION
        value: '"${release}"'

---

apiVersion: v1
kind: Service
metadata:
  name: mc-exposer-toast
  labels:
    app: minecraft
    world: toast
spec:
  type: LoadBalancer
  ports:
    - protocol: UDP
      port: 19132
      targetPort: 19132
  selector: 
    app: bedrock

---


apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mc-claim-bedrock
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 5G' > ./mc-pod-provisioned.yaml

    kubectl apply -f ./mc-pod-provisioned.yaml

    sleep 120

    kubectl cp ./server.properties.provisioned mc-server-pod-bedrock:/data/server.properties

    kubectl exec mc-server-pod-bedrock -- /bin/sh -c 'kill 1'



    else
      echo "Server creation cancelled"
    fi
else
  if [ $modded ]
  then
    echo "This command will create a Forge-modded version "${release}" world titled '"${worldname}"' with the mod at
"${modpath}" 
installed. Continue(y or n)?"
    read run
    if [ $run = y ]
    then
      echo "Then here we go!"


  # ACTUAL RUN SCRIPT FOR MODDED SERVER

      kubectl apply -f ./mc-pod-provisioned.yaml

      sleep 180

      kubectl cp $modpath mc-server-pod-java:/data/mods/
      kubectl cp ./server.properties.provisioned mc-server-pod-java:/data/server.properties
      kubectl exec mc-server-pod-java chmod 777 server.properties
      kubectl exec mc-server-pod-java rcon-cli stop

      echo "Creation complete, please wait for the server to configure.
Server IP Address: "
      kubectl get svc mc-exposer-java -o jsonpath="{.status.loadBalancer.ingress[*].ip}"
      echo ""



    else
      echo "Server creation cancelled"
    fi
  else 
    if [ $ftb ]
    then 
      echo "This command will create a FeedTheBeast version "${release}" world titled '"${worldname}"' with the modpack at
"${modpack}" 
installed. Continue(y or n)?"
      read run
      if [ $run = y ]
      then
        echo "Then here we go!"


  # ACTUAL RUN SCRIPT FOR FTB SERVER

        kubectl apply -f ./mc-pod-provisioned.yaml

        sleep 400

        kubectl cp server.properties.provisioned mc-server-pod-java:/data/FeedTheBeast/server.properties
        kubectl exec mc-server-pod-java chmod 777 /data/FeedTheBeast/server.properties
        kubectl exec mc-server-pod-java rcon-cli stop

        echo "Creation complete, please wait for the server to configure.
Server IP Address: "
        kubectl get svc mc-exposer-java -o jsonpath="{.status.loadBalancer.ingress[*].ip}"
        echo ""



      else
        echo "Server creation cancelled"
      fi
    else 
      echo "This command will create a vanilla version "${release}" world titled '"${worldname}".' Continue(y or n)?"
      read run
      if [ $run = y ]
      then
        echo "Then here we go!"


  # ACTUAL RUN SCRIPT FOR VANILLA SERVER
        
        kubectl apply -f ./mc-pod-provisioned.yaml


        sleep 150

        kubectl cp server.properties.provisioned mc-server-pod-java:/data/server.properties
        kubectl exec mc-server-pod-java chmod 777 server.properties
        kubectl exec mc-server-pod-java rcon-cli stop

        echo "Creation complete, please wait for the server to configure.
Server IP Address: "
        kubectl get svc mc-exposer-java -o jsonpath="{.status.loadBalancer.ingress[*].ip}"
        echo ""



      else
        echo "Server creation cancelled"
      fi
    fi
  fi
fi

rm mc-pod-provisioned.yaml
rm server.properties.provisioned