#!/bin/bash
if [[ $1 = 'run' ]];
  then
      cd /home/software_install_dir/MATLAB/R2018a/$7/
      matlab -nodisplay < /home/software_install_dir/MATLAB/R2018a/$7/Main.m
  elif [[ $1 = 'test' ]];
    then
      cd /home/software_install_dir/MATLAB/R2018a/$7/
	  matlab -nodisplay < /home/software_install_dir/MATLAB/R2018a/$7/Main.
  elif [[ $1 = 'delivery' ]];
    then
      tar fcz /home/software_install_dir/MATLAB/R2018a/$7.tar.gz --absolute-names /home/software_install_dir/MATLAB/R2018a/$7/results/
      if [ -d "/data3_260T/DATA/Datasets/Data_Proccesaded/BC-Vareta/$2" ]
       then
	   mv /home/software_install_dir/MATLAB/R2018a/$7.tar.gz /data3_260T/DATA/Datasets/Data_Proccesaded/BC-Vareta/$2
       else
           mkdir /data3_260T/DATA/Datasets/Data_Proccesaded/BC-Vareta/$2
           mv /home/software_install_dir/MATLAB/R2018a/$7.tar.gz /data3_260T/DATA/Datasets/Data_Proccesaded/BC-Vareta/$2
       fi
       rm -rf /home/software_install_dir/MATLAB/R2018a/$7
    else
      echo "Invalid action"
  fi
