#!/bin/bash
kernels=(extendSeedLGappedXDropOneDirectionGlobal)
metric=(inst_per_warp inst_executed inst_integer inst_compute_ld_st inst_bit_convert inst_control inst_fp_64 inst_fp_32 inst_fp_16 flop_count_dp flop_count_sp flop_count_hp flop_count_dp_fma local_load_transactions local_store_transactions shared_load_transactions shared_store_transactions gst_transactions gld_transactions l2_read_transactions l2_write_transactions dram_read_transactions dram_write_transactions sysmem_read_transactions sysmem_write_transactions stall_memory_dependency stall_memory_throttle stall_sleeping stall_pipe_busy stall_other stall_sync branch_efficiency shared_ld_bank_conflict shared_st_bank_conflict ipc) 
for kernel in ${kernels[@]}
do
	echo ${kernel}
	filename=${kernel}
	echo ${filename}
	rm -f ${filename}.csv	
	
	for m in ${metric[@]}
	do
		echo $m
		data=`grep -rin -E "${kernel}.*${m}" ./${kernel}_*.log | awk -F':' '{print $3}'`  
		echo "${data}" >> ${filename}.csv
	
	done
	echo time
	data="gpu_activities"
	data+=`grep -rin -E "GPU activities" ./times_data.log | awk -F':' '{print $3}'`
	echo "${data}" >> ${filename}.csv
done
