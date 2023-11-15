PCI_DEV_LIST=`lspci | awk '/Mella/ && /ConnectX-7/{print $1}'`
for ethdev in `ip a | awk '$2~/^ens/{gsub(":","",$2); print  $2}'`; do
        PCI_ID=`ethtool -i $ethdev | awk '/bus-info/{gsub("0000:","",$2); print $2}'`
        for dev in $PCI_DEV_LIST; do
                if [ $PCI_ID == $dev ] ; then
                        echo "$ethdev is a ConnectX7 Device"
                        lspci -s $PCI_ID
                        lspci -vvv -s $PCI_ID | grep -i speed
                        echo 9000 > /sys/class/net/${ethdev}/mtu
                        echo "Enabling 16 SRIOV VFs on $ethdev"
                        echo 16 > /sys/class/net/${ethdev}/device/sriov_numvfs
                        NUM_VFS=`cat /sys/class/net/${ethdev}/device/sriov_numvfs`
                        n=0
                        while ((n < NUM_VFS)) ; do
                                ip link set ${ethdev} vf $n trust on
                                n=$((n+1));
                        done
                        VF_DEVS="`ls -l /sys/class/net/${ethdev}/device/virtfn* | awk '{print $9}'`"
                        for vfdev in $VF_DEVS; do
                                VF_ETH_DEV="`echo $vfdev/net/* | awk -F'/' '{print $NF}'`"
                                ip link set dev $VF_ETH_DEV mtu 9000
                        done
                fi
        done
done
