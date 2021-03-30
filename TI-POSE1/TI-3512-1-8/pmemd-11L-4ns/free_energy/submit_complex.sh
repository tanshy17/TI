#!/bin/sh
#
# Run all ligand simulations.  This is mostly a template for the LSF job
# scheduler.
#


. ./windows

. /opt/intel/bin/compilervars.sh intel64
export LD_LIBRARY_PATH=/opt/pkgs/cuda/cuda-toolkit/lib64:/opt/pkgs/cuda/cublas/lib64
export CUDA_VISIBLE_DEVICES=0
mdrun=$AMBERHOME/bin/pmemd.cuda

#pmemd=$AMBERHOME/bin/pmemd.MPI
#mpirun="mpirun -np 40"

cd complex

#for step in decharge vdw_bonded recharge; do
for step in vdw_bonded recharge; do
  cd $step

  for w in $windows; do
    cd $w

        echo "eqing..."
	$mdrun  -i press.in -c ti.rst7 -ref ti.rst7 -p ti.parm7 \
        -O -o press.out -inf press.info -e press.en -r press.rst7 -x press.nc -l press.log

	echo "TI simulations..."
	$mdrun  -i ti.in -c press.rst7 -p ti.parm7 \
        -O -o ti001.out -inf ti001.info -e ti001.en -r ti001.rst7 -x ti001.nc \
        -l ti001.log

    cd ..
  done

  cd ..
done

