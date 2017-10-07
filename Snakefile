"%dl", "rawtext.txt" <-
    curl -s http://homepages.neiu.edu/~dgrammen/2008RENTFROW.pdf | pdftk - cat 13 output /dev/stdout |  pdftotext -layout - /dev/stdout > $OUTPUT0

"data.csv" <- "rawtext.txt"
    #1) "of Columbia" -> "District of Columbia"
    #2) remove commas from numbers
    #3) minus signs were converted to spaces by pdftotext so convert " 1.3" -> "-1.3"
    less $INPUT0 | pawk -p 'l=l.replace("of Columbia","District of Columbia"); cols=re.split(" {2,}",l); if len(cols) == 7: write_line(cols)' | pcsv -p 'r[1] = r[1].replace(",",""); for idx in range(2,7): r[idx] = re.findall("\((.*)\)",r[idx])[0]; if r[idx][0] == " ": r[idx] = str(-1 * float(r[idx].strip()));' > $OUTPUT0


"%graph" <- "data.csv"
    for i in 2,Extroversion 3,Aggreableness 4,Conscientiousness 5,Neuroticism 6,Openness;
    do
        echo $i
        col=$(csvsplit.py $i 0)
        name=$(csvsplit.py $i 1)
        less data.csv | pcsv -c0,${col} | pawk -b 'print("state,val")' -g 'i>0' | ~/github/gists/choropleth/choropleth.py -f /dev/stdin -n $name -o $name.html
    done