cat Jenkins-bedrock/resources/mc-pod-jenkins.yaml | sed "s/{{RELEASE}}/$RELEASE/g" \
| sed "s/{{SERVERTYPE}}/$SERVERTYPE/g" \
| sed "s/{{MODPACK}}/$MODPACK/g" \
| sed "s,{{DOCKER_REPO}},$DOCKER_REPO,g" \
| sed "s/{{WORLDNAME}}/$WORLDNAME/g" \
| sed "s/{{GAMEMODE}}/$GAMEMODE/g" \
> Jenkins-bedrock/resources/deployment.yaml
cat Jenkins-bedrock/resources/pvc-jenkins.yaml > Jenkins-bedrock/resources/pvc-deployment.yaml