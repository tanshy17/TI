#!/bin/sh
#
# Setup for the free energy simulations: creates and links to the input file as
# necessary.  Two alternative for the de- and recharging step can be used.
#


. ./windows

# partial removal/addition of charges: softcore atoms only
decharge_crg=":1@C7,H4"
vdw_crg=":1@C7,H4 | :2@N2"
recharge_crg=":2@N2"

# complete removal/addition of charges
#decharge_crg=":2"
#vdw_crg=":1,2"
#recharge_crg=":1"

decharge=" ifsc = 0, crgmask = '$decharge_crg',"
vdw_bonded=" ifsc=1, scmask1=':1@C7,H4', scmask2=':2@N2', crgmask='$vdw_crg'"
recharge=" ifsc = 0, crgmask = '$recharge_crg',"

basedir=../setup
top=$(pwd)
setup_dir=$(cd "$basedir"; pwd)

for system in ligands complex; do
  if [ \! -d $system ]; then
    mkdir $system
  fi

  cd $system

  for step in decharge vdw_bonded recharge; do
    if [ \! -d $step ]; then
      mkdir $step
    fi

    cd $step

    for w in $windows; do
      if [ \! -d $w ]; then
        mkdir $w
      fi

      FE=$(eval "echo \${$step}")
      sed -e "s/%L%/$w/" -e "s/%FE%/$FE/" $top/press.tmpl > $w/press.in
      sed -e "s/%L%/$w/" -e "s/%FE%/$FE/" $top/prod.tmpl > $w/ti.in

      (
        cd $w
        ln -sf $setup_dir/${system}_$step.parm7 ti.parm7
        ln -sf $setup_dir/${system}_$step.rst7  ti.rst7
      )
    done

    cd ..
  done

  cd $top
done

