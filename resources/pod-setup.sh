gcloud container clusters get-credentials ${cluster-name} --zone ${region}-a --project ${project} 
gcloud compute disks create ${disk-name} --zone us-west1-a || true 
kubectl apply -f resources/mc-pod-provisioned.yaml

sleep 60 
kubectl cp ./resources/server.properties.provisioned ${podname}:/data/server.properties 
kubectl exec ${podname} chmod 777 /data/server.properties 
kubectl exec ${podname} cp /data/server.properties /data/FeedTheBeast/server.properties || true
rm ./resources/server.properties.provisioned

rm -- "$0"