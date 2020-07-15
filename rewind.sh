pkill ipmi_sim &&

for sensor in 'lm75' 'hwm_temp'; do
  cp ./${sensor}_template.sdrs ./${sensor}.sdrs
  lower_non_recoverable_temp=0
  lower_critical_temp=0
  lower_non_critical_temp=0
  upper_non_critical_temp=0
  upper_critical_temp=0
  upper_non_recoverable_temp=0
  source '/etc/tempcn'/${sensor}_limits
  sed -i 's/$sensor_lnr/'${lower_non_recoverable_temp}'/g' ./${sensor}.sdrs;
  sed -i 's/$sensor_lc/'${lower_critical_temp}'/g' ./${sensor}.sdrs;
  sed -i 's/$sensor_lnc/'${lower_non_critical_temp}'/g' ./${sensor}.sdrs;
  sed -i 's/$sensor_unc/'${upper_non_critical_temp}'/g' ./${sensor}.sdrs;
  sed -i 's/$sensor_uc/'${upper_critical_temp}'/g' ./${sensor}.sdrs;
  sed -i 's/$sensor_unr/'${upper_non_recoverable_temp}'/g' ./${sensor}.sdrs;
done

cp ./vdd_template.sdrs ./vdd.sdrs

sdrcomp ./main.sdrs > /var/ipmi_sim/ipmi0/sdr.20.main;
ipmi_sim -n &
