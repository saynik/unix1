#!/bin/bash

deck_of_cards=( )
croupier="Croupier"
bank=0

echo "Write name player #1: " ; read player1
echo "Write name player #2: " ; read player2

cards_p1=( ) ; cards_p2=( ) ; cards_croupier=( )

action=(
    bet
    call
    raise
    fold
    check
    all-in
)

players=( 
    [1]=$player1
    [2]=$player2
)

coin=(
    [1]=1000
    [2]=1000
)

bets=( 
    [1]=0
    [2]=0
)

initialize_card () {
    cards=(2 3 4 5 6 7 8 9 10 J Q K A)
    suits=( '\u2663' '\u2660' '\u2665' '\u2666' ) # Unicode value a Clubs, Diamonds,Hearts and a Spades
    for ix in {0..12}; do
        for i in {0..3}; do
            deck_of_cards+=( "${suits[$i]}\u0020${cards[$ix]}" )
        done
    done
}

put_card () {
    rand_ind=$[$RANDOM % ${#deck_of_cards[@]}] #select random card
    if [ "$1" == "${players[1]}" ] ; then
       cards_p1+=( ${deck_of_cards[$rand_ind]} )
    elif [ "$1" == "${players[2]}" ] ; then
        cards_p2+=( ${deck_of_cards[$rand_ind]} )
    elif [ "$1" == "$croupier" ] ; then
        cards_croupier+=( ${deck_of_cards[$rand_ind]} )
    fi
    deck_of_cards=( ${deck_of_cards[@]/"${deck_of_cards[$rand_ind]}"/} ) #delete 1 card in array 

}

view () {
    clear
    echo "Bank === $bank"
    separator
    echo -e $croupier ${cards_croupier[@]}
    separator
    echo -e "${coin[1]} coin | ${players[1]} ${cards_p1[@]}"
    echo -e "${coin[2]} coin | ${players[2]} ${cards_p2[@]}"
}

start_game () {
    for i in {1..2}; do
        put_card ${players[1]} ; put_card ${players[2]} ; put_card $croupier
    done
}

separator () {
    echo "-------------------------------------------"
}

view_action () {
    separator
    echo  "${action[@]}" | sed "s/ /\ | /g"
    separator
}

checkpoint () { 
    echo ${player[@]}
    for step in {0..3}; do
        for i in ${!players[@]}; do 
            view_action && echo "Choose action,${players[$i]}"
            read answer && $answer ${i}            
        done
        put_card $croupier
        view
    done
    exit 0
}

bet () {
    test -z $2 && echo "How coin ? "
    test -z $2 && read rate
    rate=${rate:=$2}
    if [ $rate -le ${coin[$1]} ] ; then
        bets[$1]=${rate}
        bank=$(( $bank + $rate ))
        coin[$1]=$(( ${coin[$1]} - $rate ))
    else
        echo "You don't have money"
        bet $1
    fi
}

call () {
    koef=1
    if [ "$1" == '1' ] ; then
        bet $1 $(( ${bets[2]} * ${2:-$koef} ))
    elif [ "$1" == '2' ] ; then
        bet $1 $(( ${bets[1]} * ${2:-$koef} ))
    fi
}

raise () {
    call $1 2
}

fold () {
    echo -e "${players[$1]} - fold " && exit 0
}

check () {
    echo "check" > /dev/null
}

all-in () {
    bet $1 ${coin[$1]}
}

main () {
    initialize_card
    start_game
    view
    checkpoint
}

main
