#toggle CPUs offline/online

#NUMA node16 CPU(s):                 128-135
#NUMA node17 CPU(s):                 136-143
#NUMA node18 CPU(s):                 192-199
#NUMA node19 CPU(s):                 200-207
#NUMA node20 CPU(s):                 160-167
#NUMA node21 CPU(s):                 168-175
#NUMA node22 CPU(s):                 224-231
#NUMA node23 CPU(s):                 232-239
#NUMA node24 CPU(s):                 176-183
#NUMA node25 CPU(s):                 184-191
#NUMA node26 CPU(s):                 240-247
#NUMA node27 CPU(s):                 248-255
#NUMA node28 CPU(s):                 144-151
#NUMA node29 CPU(s):                 152-159
#NUMA node30 CPU(s):                 208-215
#NUMA node31 CPU(s):                 216-223

if (($1 == 0)); then
        echo "Powering off CPUs"
        for cpu in {128..255}; do
                echo 0 > /sys/devices/system/cpu/cpu${cpu}/online;
        done
elif (($1 == 1)); then
        echo "Powering on CPUs"
        for cpu in {128..255}; do
                echo 1 > /sys/devices/system/cpu/cpu${cpu}/online;
        done
fi
