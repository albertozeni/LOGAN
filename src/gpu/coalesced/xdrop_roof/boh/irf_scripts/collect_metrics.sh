#!/bin/bash
set -x
kenrel=(extendSeedLGappedXDropOneDirection)
#timing for kenrels
srun -n 1 nvprof --print-gpu-summary ./a.out |& tee clean.log 

#for nvvp 
#srun -n 1 nvprof --analysis-metrics --output-profile xdrop.nvvp ./a.out  
for k in ${kenrel[@]}
do
	echo "Profiling kernel: ${k}"
	
	srun -n 1 nvprof --kernels "${k}" --csv --metrics ipc --metrics inst_executed --metrics inst_integer ./a.out |& tee ${k}_set1.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_compute_ld_st --metrics inst_bit_convert --metrics inst_control ./a.out |& tee ${k}_set2.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_fp_64  --metrics inst_fp_32 --metrics inst_fp_16 ./a.out |& tee ${k}_set3.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics flop_count_dp --metrics flop_count_sp --metrics flop_count_hp ./a.out |& tee ${k}_set4.log 
    srun -n 1 nvprof --kernels "${k}" --csv --metrics flop_count_dp_fma ./a.out |& tee ${k}_flop_count_dp_fma.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics local_load_transactions --metrics local_store_transactions ./a.out |& tee ${k}_local.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics shared_load_transactions --metrics shared_store_transactions  ./a.out |& tee ${k}_share.log  
	srun -n 1 nvprof --kernels "${k}" --csv --metrics gst_transactions --metrics gld_transactions ./a.out |& tee ${k}_global.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics l2_write_transactions --metrics l2_read_transactions ./a.out |& tee ${k}_l2.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics dram_read_transactions --metrics dram_write_transactions ./a.out |& tee ${k}_dram.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics sysmem_read_transactions --metrics sysmem_write_transactions ./a.out |& tee ${k}_sysmem.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics branch_efficiency ./a.out |& tee ${k}_branch_efficiency.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics warp_nonpred_execution_efficiency --metrics warp_execution_efficiency ./a.out |& tee ${k}_warp_execu_eff.log
	srun -n 1 nvprof --kernels "${k}" --csv --events inst_executed --events thread_inst_executed ./a.out |& tee ${k}_event.log
	srun -n 1 nvprof --kernels "${k}" --csv --events shared_ld_bank_conflict --events shared_st_bank_conflict ./a.out |& tee ${k}_controlflow.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics stall_constant_memory_dependency --metrics stall_exec_dependency --metrics stall_inst_fetch ./a.out |& tee ${k}_stall1.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics stall_memory_dependency --metrics stall_memory_throttle --metrics stall_not_select ./a.out |& tee ${k}_stall2.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics stall_sleeping --metrics stall_pipe_busy --metrics stall_other ./a.out |& tee ${k}_stall3.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics stall_sync ./a.out |& tee ${k}_stall4.log



done
