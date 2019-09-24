node('docker') {

    stage 'Checkout'
        checkout scm

    stage 'Clear Environment'
        sh "terraform init"
        sh "yes yes | terraform destroy -var-file=states/default-jenkins.tfvars -target=module.provisioner"

    stage 'Integration Test'
        sh "yes yes | terraform apply -var-file=states/default-jenkins.tfvars"
}
