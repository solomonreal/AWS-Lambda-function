#c;ear all contents ons creen
clear

#Set up Kubernetes enviroment connecting to production cluster
printf "\nCONNECTING TO PRODUCTION KUBE CLUSTER\n"
export KUBECONFIG=/home/ansible/kubectlconfigs/chzrhk8sprd/admin.config

#checking if export worked
echo $KUBECONFIG

#Verify this is the right admin.config
printf "\nIs the above path the Production cluster?\n"

#Remove any old repo otherwise Git clone does not work
rm -r -f /home/ansible/repo/eportal

#Notification
printf "\nDeployment beginning\n"

#Username prompt
printf "\nWhat is your git username?\n"
read GIT_USER

printf "\nePortal git clone in progress\n"
git clone http://$GIT_USER@git.fpprod.corp/itps/eportal.git /home/ansible/repo/eportal

printf "\nWhat version of ePortal charts are you deploying? Format should be X.X.XX e.g 0.1.45\n"
read CHART_VERSION

#move to ePortal PRD repo and download charts
cd /home/ansible/repo/eportal/eportal-ltq-prd
wget http://artifactory.fpprod.corp/artifactory/virtual-eportal-charts/eportal-app-layer/eportal-app-layer-$CHART_VERSION.tgz

#untar chart and remove tar
tar vxf eportal-app-layer-$CHART_VERSION.tgz
rm -r -f eportal-app-layer-$CHART_VERSION.tgz

#move chart folder contents and delete eportal app layer folder
#BELOW two commands not NEEDED 
#mv eportal-app-layer/* /home/ansible/repo/eportal/eportal-ltq-prd 
#rm -r /home/ansible/repo/eportal/eportal-ltq-prd/eportal-app-layer/

rm -r -f /home/ansible/deploymentscripts/eportal

#helm upgrade and watch commands
helm upgrade --wait --timeout 600 epltqprd -f values.yaml ./eportal-app-layer
watch kubectl get deploy,rc,rs,pods,services -o wide -n eportal-ltq-prd
