#!/usr/bin/bash
this_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

wrk_dir="/tmp/archiso-build"
out_dir="${this_script_dir}/out"

rm -rf "${wrk_dir}"
mkdir -p "${wrk_dir}" ${out_dir}

mkarchiso -v -w "$wrk_dir" -o "$out_dir" "${this_script_dir}/" &&
chown "$(/usr/bin/ls -ld ${this_script_dir} | awk '{printf "%s:%s", $3, $4}')" "${out_dir}" &&
chown "$(/usr/bin/ls -ld ${this_script_dir} | awk '{printf "%s:%s", $3, $4}')" "${out_dir}"/*.iso

rm -rf "${wrk_dir}"
