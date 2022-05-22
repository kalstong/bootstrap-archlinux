if [ "$1" = "default" ]; then
	sudo cpupower frequency-set --governor powersave > /dev/null &&
	sudo cpupower frequency-set --max "4.30GHz" > /dev/null &&
	sudo cpupower set --perf-bias 6 > /dev/null &&
	sudo intel_gpu_frequency --custom max="1200MHz" > /dev/null &&
	sudo x86_energy_perf_policy normal &&
	sudo nvidia-smi -pl 250 > /dev/null &&
	echo "$1" >> "$XDG_CONFIG_HOME/.energypolicy"

elif [ "$1" = "balanced" ]; then
	sudo cpupower frequency-set --governor powersave > /dev/null &&
	sudo cpupower frequency-set --max "3.70GHz" > /dev/null &&
	sudo cpupower set --perf-bias 8 > /dev/null &&
	sudo intel_gpu_frequency --custom max="1000MHz" > /dev/null &&
	sudo x86_energy_perf_policy balance-power &&
	sudo nvidia-smi -pl 200 > /dev/null &&
	echo "$1" >> "$XDG_CONFIG_HOME/.energypolicy"

elif [ "$1" = "powersave" ]; then
	sudo cpupower frequency-set --governor powersave > /dev/null &&
	sudo cpupower frequency-set --max "2.90GHz" > /dev/null &&
	sudo cpupower set --perf-bias 10 > /dev/null &&
	sudo intel_gpu_frequency --custom max="700MHz" > /dev/null &&
	sudo x86_energy_perf_policy balance-power &&
	sudo nvidia-smi -pl 150 > /dev/null &&
	echo "$1" >> "$XDG_CONFIG_HOME/.energypolicy"

elif [ "$1" = "ultrapowersave" ]; then
	sudo cpupower frequency-set --governor powersave > /dev/null &&
	sudo cpupower frequency-set --max "1.50GHz" > /dev/null &&
	sudo cpupower set --perf-bias 15 > /dev/null &&
	sudo intel_gpu_frequency --custom max="600MHz" > /dev/null &&
	sudo x86_energy_perf_policy power &&
	sudo nvidia-smi -pl 105 > /dev/null &&
	echo "$1" >> "$XDG_CONFIG_HOME/.energypolicy"

elif [ "$1" = "performance" ]; then
	sudo cpupower frequency-set --governor performance > /dev/null &&
	sudo cpupower frequency-set --max "4.70GHz" > /dev/null &&
	sudo cpupower set --perf-bias 5 > /dev/null &&
	sudo intel_gpu_frequency --custom max="1200MHz" > /dev/null &&
	sudo x86_energy_perf_policy performance &&
	sudo nvidia-smi -pl 280 > /dev/null &&
	echo "$1" >> "$XDG_CONFIG_HOME/.energypolicy"

fi
