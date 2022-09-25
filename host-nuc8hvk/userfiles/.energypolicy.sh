AMDGPU_POWERLEVEL_AUTO="auto"
AMDGPU_POWERLEVEL_MANUAL="manual"
AMDGPU_POWERLEVEL_HIGH="high"
AMDGPU_POWERLEVEL_LOW="low"
AMDGPU_PROFILE_DEFAULT="0"
AMDGPU_PROFILE_POWERSAVE="2"

gpuid="card0"
[ -f /sys/class/drm/card1/device/power_dpm_force_performance_level ] &&
[ -f /sys/class/drm/card1/device/pp_power_profile_mode ] &&
	gpuid="card1"

power_dpm_fpl="/sys/class/drm/$gpuid/device/power_dpm_force_performance_level"
power_pm="/sys/class/drm/$gpuid/device/pp_power_profile_mode"

if [ "$1" = "default" ]; then
	sudo cpupower frequency-set --governor powersave > /dev/null &&
	sudo cpupower frequency-set --max "4.20GHz" > /dev/null &&
	sudo cpupower set --perf-bias 6 > /dev/null &&
	sudo intel_gpu_frequency --defaults > /dev/null &&
	sudo x86_energy_perf_policy normal &&
	echo "$AMDGPU_POWERLEVEL_AUTO" > $power_dpm_fpl &&
	echo "$1" >> "$XDG_CONFIG_HOME/.energypolicy"

elif [ "$1" = "balanced" ]; then
	sudo cpupower frequency-set --governor powersave > /dev/null &&
	sudo cpupower frequency-set --max "3.20GHz" > /dev/null &&
	sudo cpupower set --perf-bias 8 > /dev/null &&
	sudo intel_gpu_frequency --defaults > /dev/null &&
	sudo intel_gpu_frequency --custom max="900MHz" > /dev/null &&
	sudo x86_energy_perf_policy balance-power &&
	echo "$AMDGPU_POWERLEVEL_AUTO" > $power_dpm_fpl &&
	echo "$1" >> "$XDG_CONFIG_HOME/.energypolicy"

elif [ "$1" = "powersave" ]; then
	sudo cpupower frequency-set --governor powersave > /dev/null &&
	sudo cpupower frequency-set --max "2.20GHz" > /dev/null &&
	sudo cpupower set --perf-bias 10 > /dev/null &&
	sudo intel_gpu_frequency --defaults > /dev/null &&
	sudo intel_gpu_frequency --custom max="700MHz" > /dev/null &&
	sudo x86_energy_perf_policy balance-power &&
	echo "$AMDGPU_POWERLEVEL_MANUAL" > $power_dpm_fpl &&
	echo "$AMDGPU_PROFILE_POWERSAVE" > $power_pm &&
	echo "$AMDGPU_POWERLEVEL_LOW" > $power_dpm_fpl &&
	echo "$1" >> "$XDG_CONFIG_HOME/.energypolicy"

elif [ "$1" = "ultrapowersave" ]; then
	sudo cpupower frequency-set --governor powersave > /dev/null &&
	sudo cpupower frequency-set --max "1.20GHz" > /dev/null &&
	sudo cpupower set --perf-bias 15 > /dev/null &&
	sudo intel_gpu_frequency --defaults > /dev/null &&
	sudo intel_gpu_frequency --custom max="600MHz" > /dev/null &&
	sudo x86_energy_perf_policy power &&
	echo "$AMDGPU_POWERLEVEL_MANUAL" > $power_dpm_fpl &&
	echo "$AMDGPU_PROFILE_POWERSAVE" > $power_pm &&
	echo "$AMDGPU_POWERLEVEL_LOW" > $power_dpm_fpl &&
	echo "$1" >> "$XDG_CONFIG_HOME/.energypolicy"

elif [ "$1" = "performance" ]; then
	sudo cpupower frequency-set --governor performance > /dev/null &&
	sudo cpupower frequency-set --max "4.40GHz" > /dev/null &&
	sudo cpupower set --perf-bias 5 > /dev/null &&
	sudo intel_gpu_frequency --defaults > /dev/null &&
	sudo intel_gpu_frequency --max > /dev/null &&
	sudo x86_energy_perf_policy performance &&
	echo "$AMDGPU_POWERLEVEL_MANUAL" > $power_dpm_fpl &&
	echo "$AMDGPU_POWERLEVEL_HIGH" > $power_dpm_fpl &&
	echo "$1" >> "$XDG_CONFIG_HOME/.energypolicy"

fi
