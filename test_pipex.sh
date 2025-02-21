#!/bin/bash

num=0
testNum=0
d='non'
filename='a'
clear

while IFS= read -r line;
do
	if [[ "$line" != infile=* ]]; then
		echo "$line" | sed 's/|||/\n/g' | head -1 | sed 's/\\n/\n/g' > input_file
	fi			
	((testNum++))
	echo -n -e "\e[31mTest $testNum\e[0m"
	echo -e -n  "\e[32m -->\e[0m" 
	echo -n "$(echo "$line" | sed 's/|||/ | /g')"
	echo -e "\e[32m <--\e[0m"
	echo "------------------------------------"
	num=0
	echo -e "#!/bin/bash\n" > test.sh
	filename=$(echo -n \"$line\" | sed 's/|||/\n/g' | head -1 | sed 's/infile=//g')
	if [[ "$line" != infile=* ]]; then
		echo -n 'valgrind --leak-check=full --show-leak-kinds=all --errors-for-leak-kinds=all --quiet ./pipex input_file' >> test.sh
	else
		echo -n "valgrind --leak-check=full --show-leak-kinds=all --errors-for-leak-kinds=all --quiet ./pipex " >> test.sh
		echo -n $filename\" >> test.sh
	fi
	echo "$line" | sed 's/|||/\n/g' | while IFS= read -r cmd;
	do		
		if [ $num -gt 0 ]; then
			echo -n ' "' >> test.sh
			echo -n "$cmd" | sed 's/"/\\"/g' | sed 's/\\n/\\\\n/g' | sed 's/\$/\\\$/g' >> test.sh
			echo -n '"' >> test.sh
		fi
		((num++))
	done	
	echo " pipex_output 2>> pipex_output" >> test.sh
	echo "echo \$? >> pipex_output" >> test.sh
	num=0
	echo -n '< input_file' >> test.sh
	echo "$line" | sed 's/|||/\n/g' | while IFS= read -r cmd;
	do		
		if [ $num -gt 1 ]; then
			echo -n " | $cmd " >> test.sh
		elif [ $num -gt 0 ]; then
			echo -n " $cmd " >> test.sh
		fi
		((num++))		
	done
	echo " > cmd_output 2>> cmd_output" >> test.sh
	echo "echo \$? >> cmd_output" >> test.sh
	chmod +x test.sh
	./test.sh 2>> cmd_output
	d=`diff -u cmd_output pipex_output`
	if [ $(echo "$d" | wc -c) -gt 1 ]; then
		echo -e "\e[31mTest $d\e[0m"
	else
		echo -e "\e[32m OK \e[0m"
	fi
	echo "------------------------------------"	
	rm cmd_output pipex_output input_file test.sh
done < test_case.txt
