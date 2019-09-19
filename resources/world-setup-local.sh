# commands run locally so that the server can have the world files in the right place
# relies on another template file, existing-world-setup

kubectl cp ${existing-world} ${podname}:/tmp/db

kubectl cp ./resources/world-setup-provisioned.sh ${podname}:/ 
kubectl exec ${podname} chmod 777 /world-setup-provisioned.sh 
kubectl exec ${podname} /world-setup-provisioned.sh 
rm ./resources/world-setup-provisioned.sh 

kubectl delete pod ${podname} 
kubectl apply -f ./resources/mc-pod-provisioned.yaml 
rm -- "$0"