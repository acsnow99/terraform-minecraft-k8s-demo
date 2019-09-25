cat resources/mc-pod-jenkins.yaml | sed "s/{{RELEASE}}/$RELEASE/g" \
| sed "s/{{SERVERTYPE}}/$SERVERTYPE/g" \
| sed "s/{{MODPACK}}/$MODPACK/g" \
| sed "s,{{DOCKER_REPO}},$DOCKER_REPO,g" \
> resources/deployment.yaml
cat resources/pvc-jenkins.yaml > resources/pvc-deployment.yaml
cat resources/server.properties.jenkins | sed "s/{{WORLDNAME}}/$WORLDNAME/g" \
| sed "s/{{GAMEMODE}}/$GAMEMODE/g" \
> resources/server.properties.provisioned