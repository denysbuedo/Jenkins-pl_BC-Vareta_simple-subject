#!/bin/bash
if [[ $1 = 'run' ]];
  then
      cd /root/matlab/$7/
      /usr/local/MATLAB/R2018a/bin/matlab -nodisplay < /root/matlab/$7/Main.m
  elif [[ $1 = 'test' ]];
    then
      /usr/local/MATLAB/R2018a/bin/matlab -nodisplay < /root/matlab/$7/Main.m
  elif [[ $1 = 'delivery' ]];
    then
      tar fcz /root/matlab/$7/$7.tar.gz --absolute-names /root/matlab/$7/result/
      if [ -d "/media/DATA/FTP/Matlab/BC-Vareta/$2" ]
       then
	  	   mv /root/matlab/$7/$7.tar.gz /media/DATA/FTP/Matlab/BC-Vareta/$2
	   	   rm -rf /root/matlab/$7
       else
           mkdir /media/DATA/FTP/Matlab/BC-Vareta/$2
           mv /root/matlab/$7/$7.tar.gz /media/DATA/FTP/Matlab/BC-Vareta/$2
           rm -rf /root/matlab/$7 
       fi
    else
      echo "Invalid action"
  fi
