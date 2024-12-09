#!/bin/bash

counter=0

log_reader() {
    touch report.txt

    while IFS= read -r line
    do
    let counter+=1
    done < $1

    echo "Отчёт сохранён в файл report.txt"
    echo "Отчёт о логе веб-сервера" >> report.txt
    echo "========================" >> report.txt
    echo "Общее количество запросов: $counter" >> report.txt
    awk '{ count[$1]++ } END { printf "Количество уникальных IP-адресов: %d\n", length(count) }' log.txt >> report.txt
    echo "" >> report.txt
    echo "Количество запросов по методам:" >> report.txt
    awk '{gsub(/"/,"")} {count[$6]++} END {for (method in count) print method, count[method]}' log.txt >> report.txt
    echo "" >> report.txt
    awk '{ count[$7]++ } END { 
    max_count = 0; 
    max_url = ""; 
    for (url in count) { 
        if (count[url] > max_count) { 
            max_count = count[url]; 
            max_url = url; 
        } 
    } 
    print "Самый популярный URL:", max_url, "Количество:", max_count; 
    }' log.txt >> report.txt
}

log_reader log.txt
