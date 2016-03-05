enable=1
LOG_FILE="/data/log/memwatcher/procrank.log"
TRIGGER="/data/memwatcher"
BACKUP_LOG="/data/log/memwatcher/procrank.1.log"
LOG_FILE_SIZE=500000

function get_free_mem()
{
    tmp=`cat /proc/meminfo`
    arr=($tmp)
    echo ${arr[4]}
}

function get_oom_mem_limits()
{
    tmp=`cat /sys/module/lowmemorykiller/parameters/minfree`
    arr=(${tmp//,/ })
    echo ${arr[5]}
}

function get_file_size()
{
    filepath=$1
    tmp=`ls -la $filepath`
    arr=($tmp)
    echo ${arr[3]}
}

function capture_mem()
{
    date +"%n%n>>> memwatcher at %X ($free_mem K free)<<<%n" >> ${LOG_FILE};
    top -n 1 -s rss >> ${LOG_FILE}
}

free_mem=$(get_free_mem)
mem_limits=$(($(get_oom_mem_limits)+10000))
last_free_mem=$free_mem

if [ -f ${LOG_FILE} ]; then
    chmod 0644 ${LOG_FILE}
else
    touch ${LOG_FILE}
    chmod 0644 ${LOG_FILE}
fi

# if free_mem -lt mem_limits, capture the mem every 10s
# if free_mem - last_free_mem > 1024, capture the mem every 30s

retry=3                         # 3 * 10s
while [ $enable -eq 1 ]
do
    mem_limits=$(($(get_oom_mem_limits)+10000))
    size=$(get_file_size "${LOG_FILE}")
    if [ size -lt LOG_FILE_SIZE ] ; then
        free_mem=$(get_free_mem)
        if [ free_mem -gt mem_limits ]; then
            mem_increase=$(($last_free_mem - $free_mem))
            #echo "free_mem $free_mem last_free_mem $last_free_mem mem_increase $mem_increase mem_limits $mem_limits"
            if [ mem_increase -gt 1024 ]; then
                retry=$((retry-1))
            fi
            if [ mem_increase -lt 0 ]; then
                last_free_mem=$free_mem
            fi
            if [ retry -eq 0 ]; then
                capture_mem
                retry=3
                last_free_mem=$free_mem
            fi
        else
            #echo "free_mem $free_mem  mem_limits $mem_limits"
            capture_mem
        fi
        sleep 10
    else
        mv ${LOG_FILE} ${BACKUP_LOG}
        echo "" > ${LOG_FILE}
    fi
done
