pipeline{
  agent any
//node {
  //git 'https://github.com/andriyskyy/babystep2git.git'
  if(action == 'Deploy') {
    
    stage('credentials'){
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: '88dba664-6a22-408a-ace8-526e88c3e522', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
    // some block
}
    //}
    
    stage('init') {
        sh """
            terraform init
        """
    }
    stage('plan') {
      sh label: 'terraform plan', script: "terraform plan -out=tfplan -input=false"
      script {
          timeout(time: 10, unit: 'MINUTES') {
              input(id: "Deploy Gate", message: "Deploy environment?", ok: 'Deploy')
          }
      }
    }
    stage('apply') {
        sh label: 'terraform apply', script: "terraform apply -lock=false -input=false tfplan"
    }
  }

  if(action == 'Destroy') {
    stage('plan_destroy') {
      sh label: 'terraform plan destroy', script: "terraform plan -destroy -out=tfdestroyplan -input=false"
    }
    stage('credentials'){
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: '88dba664-6a22-408a-ace8-526e88c3e522', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
    // some block
}
    }
    
    stage('destroy') {
      script {
          timeout(time: 10, unit: 'MINUTES') {
              input(id: "Destroy Gate", message: "Destroy environment?", ok: 'Destroy')
          }
      }
      sh label: 'Destroy environment', script: "terraform apply -lock=false -input=false tfdestroyplan"
    }
  }
}
}
