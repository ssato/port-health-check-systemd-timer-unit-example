#!/usr/bin/bash
#
# This is a very experimental tool to generate systemd.timer(5) unit and
# related (service) unit files.
#
# Usage: $0 -o OUTDIR -s SVC_UNIT_TMPL CONF_FILE
# Examples:
#   $0 -o /usr/lib/systemd/system \
#      -s /usr/share/port-health-checker/port-health-checker-.service.in \
#      /etc/port-health-checker/nginx_80_127.0.0.1.conf
#
set -e

OUTDIR=.
SVC_UNIT_TMPL=/usr/share/port-health-checker/port-health-checker-.service.in
CONF=
VERBOSE=0

function show_help () {
    cat << EOH
$0 [Options ...] CONF_FILE
Options:
    -o     Unit directory to output generated unit files [${OUTDIR}]
    -s     Service unit template path
    -v     Verbose mode
EOH
}

# @param outdir
# @param svc_unit_tmpl
# @param conf
generate_units () {
    local outdir=$1
    local svc_unit_tmpl=$2
    local conf=$3
    local verbose=$4

    [[ -n ${outdir} ]] && [[ -n ${svc_unit_tmpl} ]] && [[ -n ${conf} ]] || {
        echo "[Error] You must specify \$outdir, \$svc_unit_tmpl and \$conf"
        exit 22  # EINVAL
    }
    [[ -f ${svc_unit_tmpl} ]] || {
        echo "[Error] Could not find the service unit template: ${svc_unit_tmpl}"
        exit 2  # ENOENT, errno(3)
    }

    source ${conf}  # $PORT, $WANTS [, $ADDR, $AFTER, $OPTIONS]

    [[ ${PORT} =~ ^[0-9]+$ ]] || {
        echo "[Error] PORT must be a number but: ${PORT}"
        exit 22  # EINVAL
    }
    [[ -n ${WANTS} ]] || {
        echo "[Error] WANTS must be set"
        exit 22  # EINVAL
    }
    [[ ${ADDR} =~ ^[0-9.]+$ ]] || ADDR=127.0.0.1
    [[ ${AFTER} =~ ^[0-9a-z-.]+$ ]] || AFTER=${WANTS}

    [[ ${VERBOSE} -eq 0 ]] || {
        echo "[Info] PORT=$PORT, WANTS=$WANTS, ADDR=$ADDR, ..."
    }

    tmr_unit_tmpl=${svc_unit_tmpl/.service/.timer}
    [[ -f ${tmr_unit_tmpl} ]] || {
        echo "[Error] Could not find the timer unit template: ${tmr_unit_tmpl}"
        exit 2  # ENOENT, errno(3)
    }

    unit_tmpl_dir=${svc_unit_tmpl%/*}
    unit_basename=${svc_unit_tmpl##*/}
    unit_basename=${unit_basename/.service.in/}
    unit_basename=${unit_basename}${ADDR}@${PORT}

    svc_unit=${unit_basename}.service
    tmr_unit=${unit_basename}.timer

    _generate_unit_from_template () {
        sed -r "
s/@PORT@/${PORT}/g
s/@ADDR@/${ADDR}/g
s/@WANTS@/${WANTS}/g
s/@AFTER@/${AFTER}/g
" $1 > $2
    }

    [[ -d ${outdir} ]] || mkdir -p ${outdir}
    _generate_unit_from_template ${svc_unit_tmpl} ${outdir}/${svc_unit}
    _generate_unit_from_template ${tmr_unit_tmpl} ${outdir}/${tmr_unit}

    [[ ${VERBOSE} -eq 0 ]] || {
        echo "[Info] Generated: ${svc_unit}, ${tmr_unit}"
    }
}

# main:
while getopts "o:s:hv" opt
do
    case $opt in
        o) OUTDIR=$OPTARG ;;
        s) SVC_UNIT_TMPL=$OPTARG ;;
        v) VERBOSE=1;;
        h) show_help; exit 0 ;;
        \?) show_help; exit 1 ;;
    esac
done
shift $(($OPTIND - 1))
CONF=$1

[[ -n ${CONF} ]] || {
    echo "[Error] You must specify a config file path!"
    show_help
    exit 22  # EINVAL
}

generate_units ${OUTDIR} ${SVC_UNIT_TMPL} ${CONF} ${VERBOSE}

# vim:sw=4:ts=4:et:
