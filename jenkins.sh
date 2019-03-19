#!/bin/bash
if [[ $1 = 'run' ]];
  then
      cd /home/software_install_dir/MATLAB/R2018a/$7/
      matlab -nodisplay < /home/software_install_dir/MATLAB/R2018a/$7/Main.m
  elif [[ $1 = 'test' ]];
    then
      matlab -nodisplay < /home/software_install_dir/MATLAB/R2018a/$7/Main.
  elif [[ $1 = 'delivery' ]];
    then
      tar fcz /home/software_install_dir/MATLAB/R2018a/$7/$7.tar.gz --absolute-names /home/software_install_dir/MATLAB/R2018a/$7/result/
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
