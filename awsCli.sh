#!/bin/bash
DarkGray='\033[1;31m'
NC='\033[1;0m'
LightBlue='\033[1;34m'
Orange='\033[0;33m'
echo -n  "Enter you Command here : ";
read;
echo  you want to  ${REPLY} aws instance
if [[ ${REPLY} == start ]] && [[ ${REPLY} != "" ]]
then
printf "${DarkGray} going to start AWS instance..... ${NC} \n"
aws ec2 start-instances --instance-ids i-04abd7c42a0872f64 --query 'StartingInstances[*].CurrentState' --output text | awk '{print $2}'
awsPubIp=$(aws ec2 describe-instances --instance-ids i-04abd7c42a0872f64 --query 'Reservations[*].Instances[*].PublicIpAddress' --output=text | sed 's/\./\-/g')
sleep 5
echo "$awsPubIp"
sleep 5
ssh -i "web.pem" ubuntu@ec2-$awsPubIp.ap-south-1.compute.amazonaws.com
elif [[ ${REPLY} == stop ]] && [[ ${REPLY} != "" ]]
then
printf "${LightBlue} going to stop aws instance...... ${NC} \n"
aws ec2 stop-instances --instance-ids i-04abd7c42a0872f64 --query 'StoppingInstances[*].CurrentState' --output text | awk '{print $2}'
else
printf  "${Orange} please enter proper command start or stop ${NC} \n"
fi
sleep 5
echo "Status of AWS Instance $(aws ec2 describe-instances --instance-ids i-04abd7c42a0872f64  --query 'Reservations[*].Instances[*].State' --output text | awk '{print $2}')"
#awsPubIp=$(aws ec2 describe-instances --instance-ids i-04abd7c42a0872f64 --query 'Reservations[*].Instances[*].PublicIpAddress' --output=text | sed 's/\./\-/g')
#sleep 5
#ssh -i "web.pem" ubuntu@ec2-$awsPubIp.ap-south-1.compute.amazonaws.com
