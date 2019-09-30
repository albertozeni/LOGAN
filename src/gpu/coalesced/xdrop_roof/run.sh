#!/bin/bash
set -x
kernel=(extendSeedLGappedXDropOneDirectionGlobal)
#timing for kernels
srun -n 1 nvprof --print-gpu-summary ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee times_data.log 

for k in ${kernel[@]}
do
	echo "Profiling kernel: ${k}"
	
	srun -n 1 nvprof --kernels "${k}" --csv --metrics ipc --metrics inst_executed --metrics inst_integer ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_set1.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_compute_ld_st --metrics ldst_executed --metrics ldst_fu_utilization ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_ld.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_bit_convert --metrics inst_control ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_set2.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_fp_64  --metrics inst_fp_32 --metrics inst_fp_16 ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_set3.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics flop_count_dp --metrics flop_count_sp --metrics flop_count_hp ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_set4.log 
    srun -n 1 nvprof --kernels "${k}" --csv --metrics flop_count_dp_fma ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_flop_count_dp_fma.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics local_load_transactions --metrics local_store_transactions ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_local.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics shared_load_transactions --metrics shared_store_transactions  ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_share.log  
	srun -n 1 nvprof --kernels "${k}" --csv --metrics gst_transactions --metrics gld_transactions ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_global.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics local_load_transactions_per_request --metrics local_store_transactions_per_request ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_local_req.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics shared_load_transactions_per_request --metrics shared_store_transactions_per_request ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_shared_req.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics gld_transactions_per_request --metrics gst_transactions_per_request ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_gld_req.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_executed_global_reductions --metrics inst_executed_global_stores --metrics inst_executed_global_loads ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_inst_glo.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_executed_local_loads --metrics inst_executed_local_stores ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_inst_local.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_executed_shared_loads --metrics inst_executed_shared_stores ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_inst_shared.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics l2_write_transactions --metrics l2_read_transactions ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_l2.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics dram_read_transactions --metrics dram_write_transactions ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_dram.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics sysmem_read_transactions --metrics sysmem_write_transactions ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_sysmem.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics branch_efficiency ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_branch_efficiency.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics warp_nonpred_execution_efficiency --metrics warp_execution_efficiency ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_warp_execu_eff.log
	srun -n 1 nvprof --kernels "${k}" --csv --events inst_executed --events thread_inst_executed ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_event.log
	
    
    #srun -n 1 nvprof --kernels "${k}" --csv --events shared_ld_bank_conflict --events shared_st_bank_conflict ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_controlflow.log
    #srun -n 1 nvprof --kernels "${k}" --csv --metrics stall_constant_memory_dependency --metrics stall_exec_dependency --metrics stall_inst_fetch ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_stall1.log
	#srun -n 1 nvprof --kernels "${k}" --csv --metrics stall_memory_dependency --metrics stall_memory_throttle --metrics stall_not_select ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_stall2.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics stall_sleeping --metrics stall_pipe_busy --metrics stall_other ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_stall3.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics stall_sync ./../test ../../input_gen/input5000.txt 17 21 1 1 |& tee ${k}_stall4.log



done
