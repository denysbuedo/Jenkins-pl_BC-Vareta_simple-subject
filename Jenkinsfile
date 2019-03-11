/*
@Autor: Denys Buedo Hidalgo
@Proyecto: BC-Vareta Method (https://github.com/denysbuedo/Jenkins_BC-Vareta.git)
@Joint China-Cuba Laboratory
@Universidad de las Ciencias Informaticas
*/

node{

  	//--- Getting the upstream build number
    echo "Reading the build parent number"
    def manualTrigger = true
  	def upstreamBuilds = ""
  	currentBuild.upstreamBuilds?.each {b ->
    	upstreamBuilds = "${b.getDisplayName()}"
    	manualTrigger = false
  	}
  	def xml_name = "$upstreamBuilds" + ".xml"
  	
  	//--- Reading current job config ---
	echo "Reading the job config"
  	def job_config = readFile "$JENKINS_HOME/jobs/BC-Vareta/builds/QueueJobs/$xml_name"
	def parser = new XmlParser().parseText(job_config)
	def job_name = "${parser.attribute("job")}"
	def build_ID ="${parser.attribute("build")}"
	def owner_name ="${parser.attribute("name")}"
	def notif_email ="${parser.attribute("email")}"
	def eeg = "${parser.attribute("EEG")}"
	def leadfield ="${parser.attribute("LeadField")}"
    def surface ="${parser.attribute("Surface")}"
	def scalp="${parser.attribute("Scalp")}"
	
	//Setting Build description
	def currentBuildName = "BUILD#$build_ID-$owner_name"
	currentBuild.displayName = "$currentBuildName"
	
	stage('DATA ACQUISITION'){
  		
  		 //--- Downloading BC-Vareta code from GitHub reporitory ---
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'github_dbuedo-id', url: 'https://github.com/denysbuedo/BC_VaretaModel.git']]])
  		
  		//--- Creating current matlab workspace
  		sh "mkdir $JENKINS_HOME/jobs/$JOB_NAME/builds/$BUILD_ID/$currentBuildName"
  		sh "mkdir $JENKINS_HOME/jobs/$JOB_NAME/builds/$BUILD_ID/$currentBuildName/result"
		
		//--- Moving data files to matlab workspace
		sh "cp -a $JENKINS_HOME/jobs/$JOB_NAME/workspace/. $JENKINS_HOME/jobs/$JOB_NAME/builds/$BUILD_ID/$currentBuildName"
		sh "mv $JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/xml_data_descriptor.xml $JENKINS_HOME/jobs/$JOB_NAME/builds/$BUILD_ID/$currentBuildName/data"
		sh "mv $JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/$eeg $JENKINS_HOME/jobs/$JOB_NAME/builds/$BUILD_ID/$currentBuildName/data"
		sh "mv $JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/$leadfield $JENKINS_HOME/jobs/$JOB_NAME/builds/$BUILD_ID/$currentBuildName/data"
		sh "mv $JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/$surface $JENKINS_HOME/jobs/$JOB_NAME/builds/$BUILD_ID/$currentBuildName/data"
		sh "mv $JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/$scalp $JENKINS_HOME/jobs/$JOB_NAME/builds/$BUILD_ID/$currentBuildName/data"
		
  		//--- Starting ssh agent on Matlab server ---
		sshagent(['fsf_id_rsa']) {      

			//--- Copying de data file to External_data folder in Matlab Server --- 
			sh 'ssh -o StrictHostKeyChecking=no root@192.168.17.129'
			sh "scp -r $JENKINS_HOME/jobs/$JOB_NAME/builds/$BUILD_ID/$currentBuildName root@192.168.17.129:/root/matlab/"
        } 
        
	}
  
	stage('DATA PROCESSING (BC-Vareta)'){
  		
  		//--- Starting ssh agent on Matlab Server ---
		sshagent(['fsf_id_rsa']) { 
		
			/*--- Goal: Execute the matlab command, package and copy the results in the FTP server and clean the workspace.  
			@file: jenkins.sh
        	@Parameter{
    			$1-action [run, delivery]
        		$2-Name of the person who run the task ($owner_name)
        		$3-EEG file ($eeg)
        		$4-LeadField ($leadfield)
        		$5-Surface ($surface)
        		$6-Scalp ($scalp) 
			} ---*/           
       		echo "--- Run Matlab command ---"
        	sh 'ssh -o StrictHostKeyChecking=no root@192.168.17.129'
			sh "ssh root@192.168.17.129 chmod +x /root/matlab/$currentBuildName/jenkins.sh"
        	sh "ssh root@192.168.17.129 /root/matlab/$currentBuildName/jenkins.sh run $owner_name $eeg $leadfield $surface $scalp $currentBuildName"	
		}
	}
  
	stage('DATA DELIVERY'){
		
		//--- Starting ssh agent on Matlab Server ---
		sshagent(['fsf_id_rsa']) { 
		
			/*--- Goal: Execute the matlab command, package and copy the results in the FTP server and clean the workspace.  
			@file: jenkins.sh
        	@Parameter{
    			$1-action [run, delivery]
        		$2-Name of the person who run the task ($owner_name)
        		$3-EEG file ($eeg)
        		$4-LeadField ($leadfield)
        		$5-Surface ($surface)
        		$6-Scalp ($scalp) 
			} ---*/           
       		echo "--- Tar and copy files result to FTP Server ---"
        	sh 'ssh -o StrictHostKeyChecking=no root@192.168.17.129'
        	sh "ssh root@192.168.17.129 /root/matlab/$currentBuildName/jenkins.sh delivery $owner_name $eeg $leadfield $surface $scalp $currentBuildName"	
		}
	}
  
	stage('NOTIFICATION AND REPORT'){
    	
    	//--- Inserting data in influxdb database ---/
		step([$class: 'InfluxDbPublisher', customData: null, customDataMap: null, customPrefix: null, target: 'influxdb'])
	}

}
