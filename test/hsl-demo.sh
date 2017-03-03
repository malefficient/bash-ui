##
# BIW-TOOLS - Bash Inline Widget Tools
# Copyright 2017 by Chad Juliano
# 
# Licensed under GNU Lesser General Public License v3.0 only. Some rights
# reserved. See LICENSE.
##

set -o nounset

source ${BIW_HOME}/biw-term-sgr.sh
source ${BIW_HOME}/biw-term-hsl.sh

function fn_print_padding()
{
    local _width=$1
    local _char="$2"
    local _result

    printf -v _result '%*s' $_width
    printf '%s' "${_result// /$_char}"
}

function fn_print_heading()
{
    local -i _width=$1
    local _label=$2

    _label=" $_label "
    local -i _label_length=${#_label}

    local -i _start=$(( (_width - _label_length) / 2 ))
    fn_print_padding $_start '-'

    printf '%s' "$_label"
    
    local -i _end=$((_width - _label_length - _start))
    fn_print_padding $_end '-'
}

function fn_demo_hsl216_sat_blocks()
{
    local -ir _margin=4
    local -a _sat_list=( $* )

    local -i _sat
    for _sat in ${_sat_list[@]}
    do
        fn_print_padding 5 ' '
        fn_print_heading 36 "S=${_sat}"
        fn_print_padding $_margin ' '
    done
    echo

    local -i _light
    for((_light = HSL216_LIGHT_SIZE - 1; _light >= 0; _light--))
    do
        for _sat in ${_sat_list[@]}
        do
            echo -n "L=${_light}) "

            fn_sgr_seq_start

            for((_hue = 0; _hue < HSL216_HUE_SIZE; _hue++))
            do
                fn_hsl216_set $SGR_ATTR_BG $_hue $_sat $_light || exit 1
                fn_sgr_print " "
            done
            
            fn_sgr_seq_flush
            fn_sgr_op $SGR_ATTR_DEFAULT

            fn_print_padding $_margin ' '
        done
        echo
    done
    echo
}

function fn_demo_hsl216_sat()
{
    fn_demo_hsl216_sat_blocks 0 1
    fn_demo_hsl216_sat_blocks 2 3
    fn_demo_hsl216_sat_blocks 4 5
}

function fn_demo_hsl216_lum_blocks()
{
    local -ir _margin=4
    local -a _lum_list=( $* )

    local -i _light
    for _light in ${_lum_list[@]}
    do
        fn_print_padding 5 ' '
        fn_print_heading 36 "L=${_light}"
        fn_print_padding $_margin ' '
    done
    echo

    local -i _light
    for((_light = HSL216_LIGHT_SIZE - 1; _light >= 0; _light--))
    do
        for _light in ${_lum_list[@]}
        do
            echo -n "S=${_sat}) "

            fn_sgr_seq_start

            for((_hue = 0; _hue < HSL216_HUE_SIZE; _hue++))
            do
                fn_hsl216_set $SGR_ATTR_BG $_hue $_sat $_light || exit 1
                fn_sgr_print " "
            done
            
            fn_sgr_seq_flush
            fn_sgr_op $SGR_ATTR_DEFAULT

            fn_print_padding $_margin ' '
        done
        echo
    done
    echo
}

function fn_demo_hsl216_lum()
{
    fn_demo_hsl216_lum_blocks 0 1
    fn_demo_hsl216_lum_blocks 2 3
    fn_demo_hsl216_lum_blocks 4 5
}

function fn_demo_hsl216_comp_blocks()
{
    local -ir _margin=4
    local -a _hue_list=( $* )

    local -i _hue
    for _hue in ${_hue_list[@]}
    do
        fn_print_heading 11 "H=${_hue}"
        fn_print_padding $_margin ' '
    done
    echo

    local -i _light
    for((_light = HSL216_LIGHT_SIZE - 1; _light >= 0; _light--))
    do
        for _hue in ${_hue_list[@]}
        do
            for((_sat = -1*(HSL216_SAT_SIZE - 1); _sat < HSL216_SAT_SIZE; _sat++))
            do
                fn_hsl216_set $SGR_ATTR_BG $_hue $_sat $_light || exit 1
                echo -n " "
            done
            fn_sgr_op $SGR_ATTR_DEFAULT
            fn_print_padding $_margin ' '
        done
        echo
    done
    echo
}

function fn_demo_hsl216_comp()
{
    fn_demo_hsl216_comp_blocks 0 3 6
    fn_demo_hsl216_comp_blocks 9 12 15
}

echo "Computing HSL216 Table..."
fn_hsl216_init

# display 6 rainbows of variable saturation
fn_demo_hsl216_sat

#fn_demo_hsl216_lum

# display 6 blocks of color compliments by saturation
fn_demo_hsl216_comp
