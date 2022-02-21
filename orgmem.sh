#!/bin/bash

c=0

banner(){
echo -e ""
echo -e " ██████  ██████   ██████  ███    ███ ███████ ███    ███ "
echo -e "██    ██ ██   ██ ██       ████  ████ ██      ████  ████ "
echo -e "██    ██ ██████  ██   ███ ██ ████ ██ █████   ██ ████ ██ "
echo -e "██    ██ ██   ██ ██    ██ ██  ██  ██ ██      ██  ██  ██ "
echo -e " ██████  ██   ██  ██████  ██      ██ ███████ ██      ██ "
echo
echo -e "\e[31m\t\tBy @DarkLotusKDB <3\e[0m"
}

Prt_usage(){
echo
echo "Usage: ./orgmem.sh -o <org_username>"
echo "-o: organization username according to github"
echo
echo "Example: ./orgmem.sh -o apple"
}

Ready(){
mkdir -p Output/$org
}

Main_Logic(){
echo -e "\n\e[32m[+] Feteching Public Members Of $org From Github\e[0m"

for (( i=1; i<=20; i++))
do
	Resp=$(curl -ksi1 "https://github.com/orgs/$org/people?page=$i")
	Err=$(echo "This organization has no public members")

	if echo "$Resp" | grep -i "$Err" &> /dev/null
	then
		break
	else
		echo -e "\n\e[33m[+] Members Found On People Page No: $i\e[0m"
		echo "$Resp" | grep -Eo 'href="[^\"]+"' | grep -i -v "github\|login\|signup\|\/features\|http\|\/trending\|\/topics\|\/team\|\/sponsors\|#\|\/customer-s\|\/readme\|\/pricing\|\/mobile\|\.xml\|\.json\|\/events\|\/explore\|\/collections\|\/enterprise\|marketplace\|\/orgs\/\|\/$org" | sort -u | sed 's/href="\//user:/g' | sed 's/"/ /g' | tr -d '\n' | tee Output/$org/$i-user-dork.txt
		cat Output/$org/$i-user-dork.txt | sed 's/user://g' | tr " " "\n" | grep . >> Output/$org/All-$org-users.txt
		echo ""
	fi

x=$(cat Output/$org/$i-user-dork.txt | wc -w)
c=$(($x + $c))

done

echo -e "\n\e[32m[+] Total Number Of Members: \e[0m\e[31m$c\e[0m"

}

banner

while getopts 'o:' flag; do
	case "${flag}" in
		o) org="${OPTARG}" ;;
		*) Prt_usage
			exit 1 ;;
	esac
done

if [ ! -z $org ]; then
	Ready
	Main_Logic
else
	Prt_usage
fi

