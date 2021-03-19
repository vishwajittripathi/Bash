#!/bin/bash
ngrok_url() {
#cmd=$(ps -aef | grep [n]ginx | head -n 1 | tail -1 |  awk '{print $11}')
ngrokStat=$(pgrep -x ngrok)
#if [[ "$cmd" == "/usr/sbin/nginx" ]] && 
if [[ -z "$ngrokStat" ]]
then
echo "$SERVICE stopped, Going to restart"
cd ~/script/utility
./ngrok http 80 --log=stdout > ../logs/ngrok.log &
sleep 10;
cd ../logs/
sleep 10;
newUrl=$(find . -name "ngrok.log" -exec grep "url=https:" {} \; |  awk '{print $8}')
echo "$SERVICE running now .."
echo "$newUrl"  | mail -s "Ngrok Webpida URL" w@outlook.com  #<< EOF
#echo "$newUrl"
#EOF
else 
cd ~/script/logs/
sleep 10;
url=$(find . -name "ngrok.log" -exec grep "url=https:" {} \; |  awk '{print $8}')
echo "$url" | mail -s "Ngrok Webpida URL"  w@outlook.com  #<< EOF
#echo "$url"
#EOF
fi
}
cd ~
cpuTemp=$(cpu=$(</sys/class/thermal/thermal_zone0/temp) && echo "$((cpu/1000))'C")
gpuTemp=$(gpu=($(/opt/vc/bin/vcgencmd measure_temp)) && echo "$gpu" | awk -F'=' '{print $2}')
FreeMemory=$(free -mt | grep Total | awk '{print $4}')
FreeSpace=$(df -h | head -n 2 | tail -n -1 | awk '{print $4}')
Service_List=$(systemctl list-units --type=service | head -n 53 | awk 'OFS="	"{print $1,$2,$3}')
upTime=$(uptime -s)
lastShutdown=$(last -x|grep shutdown | head -1 | awk 'OFS="-" {print $7,$6,$8}')
StatusFail2Ban=$(systemctl status fail2ban | head -n 3 | tail -n 1 | awk '{print $2}')
cmd=$(systemctl status nginx | grep "active" | awk '{print $2}')
pid=$(systemctl status nginx | grep "Main PID" | awk '{print $3}')
if [ "$cmd" == "active" ]
then
ngrok_url
else 
echo "Need to Restart Nginx"
sudo /etc/init.d/nginx start
cmd=$(systemctl status nginx | grep "active" | awk '{print $2}')
pid=$(systemctl status nginx | grep "Main PID" | awk '{print $3}')
ngrok_url
fi
mail -s "System Status" w@outlook.com << EOF

Hi Vishwajit,

Please find status  of your Device 

Nginx	: "$cmd | $pid"

CPU temp:"$cpuTemp"

GPU temp:"$gpuTemp"

RAM	:"$FreeMemory"

Space	:"$FreeSpace"

l_Shdn 	:"$lastShutdown"

StatusFail2Ban = "$StatusFail2Ban"

EOF
