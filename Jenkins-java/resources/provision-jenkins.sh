cat Jenkins-java/resources/mc-pod-jenkins.yaml | sed "s/{{RELEASE}}/$RELEASE/g" \
| sed "s/{{SERVERTYPE}}/$SERVERTYPE/g" \
| sed "s/{{MODPACK}}/$MODPACK/g" \
| sed "s,{{DOCKER_REPO}},$DOCKER_REPO,g" \
> Jenkins-java/resources/deployment.yaml
cat Jenkins-java/resources/pvc-jenkins.yaml > Jenkins-java/resources/pvc-deployment.yaml
cat Jenkins-java/resources/server.properties.jenkins | sed "s/{{WORLDNAME}}/$WORLDNAME/g" \
| sed "s/{{GAMEMODE}}/$GAMEMODE/g" \
> Jenkins-java/resources/server.properties.provisioned