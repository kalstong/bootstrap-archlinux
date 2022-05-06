# @NOTE: About amdgpu power profiles.
# https://wiki.archlinux.org/title/AMDGPU#Power_profiles
AMDGPU_POWERLEVEL_AUTO="auto"
AMDGPU_POWERLEVEL_MANUAL="manual"
AMDGPU_POWERLEVEL_HIGH="high"
AMDGPU_POWERLEVEL_LOW="low"
AMDGPU_PROFILE_DEFAULT="0"
AMDGPU_PROFILE_POWERSAVE="2"

if [ "$1" = "default" ]; then
	sudo cpupower frequency-set --governor ondemand > /dev/null &&
	sudo cpupower frequency-set --max "4.00GHz" > /dev/null &&
	echo "$AMDGPU_POWERLEVEL_AUTO" > /sys/class/drm/card0/device/power_dpm_force_performance_level &&
	echo "$1" >> "$XDG_CONFIG_HOME/.energypolicy"

elif [ "$1" = "balanced" ]; then
	sudo cpupower frequency-set --governor conservative > /dev/null &&
	sudo cpupower frequency-set --max "3.30GHz" > /dev/null &&
	echo "$AMDGPU_POWERLEVEL_AUTO" > /sys/class/drm/card0/device/power_dpm_force_performance_level &&
	echo "$1" >> "$XDG_CONFIG_HOME/.energypolicy"

elif [ "$1" = "powersave" ]; then
	sudo cpupower frequency-set --governor powersave > /dev/null &&
	sudo cpupower frequency-set --max "2.70GHz" > /dev/null &&
	echo "$AMDGPU_POWERLEVEL_MANUAL" > /sys/class/drm/card0/device/power_dpm_force_performance_level &&
	echo "$AMDGPU_PROFILE_POWERSAVE" > /sys/class/drm/card0/device/pp_power_profile_mode &&
	echo "$AMDGPU_POWERLEVEL_LOW" > /sys/class/drm/card0/device/power_dpm_force_performance_level &&
	echo "$1" >> "$XDG_CONFIG_HOME/.energypolicy"

elif [ "$1" = "performance" ]; then
	sudo cpupower frequency-set --governor performance > /dev/null &&
	sudo cpupower frequency-set --max "4.00GHz" > /dev/null &&
	echo "$AMDGPU_POWERLEVEL_MANUAL" > /sys/class/drm/card0/device/power_dpm_force_performance_level &&
	echo "$AMDGPU_PROFILE_DEFAULT" > /sys/class/drm/card0/device/pp_power_profile_mode &&
	echo "$AMDGPU_POWERLEVEL_HIGH" > /sys/class/drm/card0/device/power_dpm_force_performance_level &&
	echo "$1" >> "$XDG_CONFIG_HOME/.energypolicy"

elif [ "$1" = "ultrapowersave" ]; then
	sudo cpupower frequency-set --governor powersave > /dev/null &&
	sudo cpupower frequency-set --max "1.70GHz" > /dev/null &&
	echo "$AMDGPU_POWERLEVEL_MANUAL" > /sys/class/drm/card0/device/power_dpm_force_performance_level &&
	echo "$AMDGPU_PROFILE_POWERSAVE" > /sys/class/drm/card0/device/pp_power_profile_mode &&
	echo "$AMDGPU_POWERLEVEL_LOW" > /sys/class/drm/card0/device/power_dpm_force_performance_level &&
	echo "$1" >> "$XDG_CONFIG_HOME/.energypolicy"

fi
