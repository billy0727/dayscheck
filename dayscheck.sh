#! /bin/bash
# dailycheck.sh
# nodes operation check by sensor_engine.log
# Billy Hsia
# fuction: calulate yesterday n3, n4, LQI(avg,sd), n2(avg,sd)
# fix record
  # 2018/12/17 first version
  # 2018/12/20 all/each node report

# clean temp files
mkdir -p tmp
> ./tmp/lqi_avg_temp.tmp
> ./tmp/lqi_sd_temp.tmp
> ./tmp/dataloss_temp.tmp
> ./tmp/u3_temp.tmp
> ./tmp/u4_temp.tmp
> ./tmp/mac.tmp
> temp.txt
> node_temp.txt

#Output Title generate
echo "Date" >> temp.txt
echo "u3_Avg" >> temp.txt
echo "u3_SD" >> temp.txt
echo "u4_Avg" >> temp.txt
echo "u4_SD" >> temp.txt
echo "LQI_Avg" >> temp.txt
echo "LQI_SD" >> temp.txt
echo "n2_Avg" >> temp.txt
echo "n2_SD" >> temp.txt

echo "Node" >> node_temp.txt
echo "Date" >> node_temp.txt
echo "u3" >> node_temp.txt
echo "u4" >> node_temp.txt
echo "LQI_Avg" >> node_temp.txt
echo "LQI_SD" >> node_temp.txt
echo "n2" >> node_temp.txt

read -p "month? " month
read -p "firstday? " firstday
read -p "lastday? " lastday


for i in $(seq -s " " -f %02g $firstday $lastday);
do

    # clean temp files
    #> lqi_avg_temp.txt
    #> lqi_sd_temp.txt
    #> dataloss_temp.txt

    #create date for cat log
    echo "${month}-$i" >> temp.txt

    #u3
    #cat sensor_engine.log |grep -a Debug |grep -a "${month}-$i" |grep -a u3, |wc -l >> temp.txt
    #u4
    #cat sensor_engine.log |grep -a Debug |grep -a "${month}-$i" |grep -a u4, |wc -l >> temp.txt
    
    # AVG(nodes), SD(nodes)
    macstxt=$(cat /opt/mwg/macs.txt |grep -a Add |awk '{$1=null ;print}')
    for node in $macstxt

    do
      echo "${node}" >> ./tmp/mac.tmp
      echo "${node}" >> node_temp.txt
      echo "${month}-$i" >> node_temp.txt
      #u3
      u3=$(cat /var/log/sensor_engine.log |grep -a Debug |grep -a ${month}-$i |grep -a u3,${node} |wc -l)
      echo ${u3} >> ./tmp/u3_temp.tmp
      echo ${u3} >> node_temp.txt
      #u4
      u4=$(cat /var/log/sensor_engine.log |grep -a Debug |grep -a ${month}-$i |grep -a u4,${node} |wc -l)
      echo ${u4} >> ./tmp/u4_temp.tmp
      echo ${u4} >> node_temp.txt
      #lqi avg,sd
      cat /var/log/sensor_engine.log |grep -a Debug |grep -a ${month}-$i |grep -a n2,${node} |awk '{print $5}' > ./tmp/lqi_data.tmp
      lqi_avg=$(cat ./tmp/lqi_data.tmp | awk '{sum+=$1} END {print sum/NR}')
      echo ${lqi_avg} >> ./tmp/lqi_avg_temp.tmp
      echo ${lqi_avg} >> node_temp.txt
      lqi_sd=$(cat ./tmp/lqi_data.tmp | awk '{x[NR]=$0; s+=$0; n++} END{a=s/n; for (i in x){ss += (x[i]-a)^2} sd = sqrt(ss/n); print sd}')
      echo ${lqi_sd} >> ./tmp/lqi_sd_temp.tmp
      echo ${lqi_sd} >> node_temp.txt
      #n2(dataloss)
      n2=$(cat ./tmp/lqi_data.tmp | wc -l)
      echo ${n2} >> ./tmp/dataloss_temp.tmp
      echo ${n2} >> node_temp.txt
    done
    # AVG,SD(u3,u4)
    cat ./tmp/u3_temp.tmp | awk '{sum+=$1} END {print sum/NR}' >> temp.txt
    cat ./tmp/u3_temp.tmp | awk '{x[NR]=$0; s+=$0; n++} END{a=s/n; for (i in x){ss += (x[i]-a)^2} sd = sqrt(ss/n); print sd}' >> temp.txt
    cat ./tmp/u4_temp.tmp | awk '{sum+=$1} END {print sum/NR}' >> temp.txt
    cat ./tmp/u4_temp.tmp | awk '{x[NR]=$0; s+=$0; n++} END{a=s/n; for (i in x){ss += (x[i]-a)^2} sd = sqrt(ss/n); print sd}' >> temp.txt
    
    # AVG(nodes avg and sd)
    cat ./tmp/lqi_avg_temp.tmp | awk '{sum+=$1} END {print sum/NR}' >> temp.txt
    cat ./tmp/lqi_sd_temp.tmp | awk '{sum+=$1} END {print sum/NR}' >> temp.txt
    
    # n2() and dataloss%()
    cat ./tmp/dataloss_temp.tmp | awk '{sum+=$1} END {print sum/NR}' >> temp.txt
    cat ./tmp/dataloss_temp.tmp | awk '{x[NR]=$0; s+=$0; n++} END{a=s/n; for (i in x){ss += (x[i]-a)^2} sd = sqrt(ss/n); print sd}' >> temp.txt
    
    #Reports Collection
    printf '%2s\t %8s\t %8s\t %8s\t %8s\t %8s\t %8s\t %8s\t %8s\t \n' $(cat temp.txt) > report
    printf '%8s\t %8s\t %8s\t %8s\t %8s\t %8s\t %8s\t \n' $(cat node_temp.txt) > nodereport
    cp report ~/gv-admin/public
    cp nodereport ~/gv-admin/public    
    
    echo ""
    cat report
    echo ""
    cat nodereport
    echo "---------------------------------------------------------------------" 
    #each_node_report_by node_report.txt
    file=./tmp/mac.tmp
    seq=1
    while read line
    do
        lines[$seq]=$line
        ((seq++))
    done < $file
    
    for ((i=1;i<=${#lines[@]};i++))
    do
        cat nodereport |grep -a -e Node -e ${lines[$i]} > ${lines[$i]}
        cp ${lines[$i]} ~/gv-admin/public
        #cat ${lines[$i]}.txt
    done
  
done
