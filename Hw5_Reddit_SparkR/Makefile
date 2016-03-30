all: hw5.html

hw5.html: hw5.Rmd Subreddits_Jan.Rdata Subreddits_Feb.Rdata Subreddits_Mar.Rdata Subreddits_Apr.Rdata Subreddits_May.Rdata Post_Freq.Rdata Post_Freq_Dow.Rdata Post_Freq_Gilded.Rdata Post_Freq_Gilded_Dow.Rdata Feb_14.Rdata Feb_2.Rdata Feb_20.Rdata
	Rscript -e "library(rmarkdown);render('hw5.Rmd')"

Subreddits_Jan.Rdata: Task_1_SparkR.R
	R --no-save < Task_1_SparkR.R

Subreddits_Feb.Rdata: Task_1_SparkR.R
	R --no-save < Task_1_SparkR.R

Subreddits_Mar.Rdata: Task_1_SparkR.R
	R --no-save < Task_1_SparkR.R

Subreddits_Apr.Rdata: Task_1_SparkR.R
	R --no-save < Task_1_SparkR.R

Subreddits_May.Rdata: Task_1_SparkR.R
	R --no-save < Task_1_SparkR.R
	
Post_Freq.Rdata: Task_2_SparkR.R
	R --no-save < Task_2_SparkR.R
	
Post_Freq_Dow.Rdata: Task_2_SparkR.R
	R --no-save < Task_2_SparkR.R
	
Post_Freq_Gilded.Rdata: Task_2_SparkR.R
	R --no-save < Task_2_SparkR.R
	
Post_Freq_Gilded_Dow.Rdata: Task_2_SparkR.R
	R --no-save < Task_2_SparkR.R

Feb_14.Rdata: Task_3_SparkR.R
	R --no-save < Task_3_SparkR.R

Feb_2.Rdata: Task_3_SparkR.R
	R --no-save < Task_3_SparkR.R

Feb_20.Rdata: Task_3_SparkR.R
	R --no-save < Task_3_SparkR.R

clean:
	rm -rf Subreddits_Jan.Rdata 
	rm -rf Subreddits_Feb.Rdata
	rm -rf Subreddits_Mar.Rdata
	rm -rf Subreddits_Apr.Rdata
	rm -rf Subreddits_May.Rdata
	rm -rf Post_Freq.Rdata
	rm -rf Post_Freq_Dow.Rdata.Rdata
	rm -rf Post_Freq_Gilded.Rdata
	rm -rf Post_Freq_Gilded_Dow.Rdata.Rdata
	rm -rf Feb_14.Rdata
	rm -rf Feb_2.Rdata
	rm -rf Feb_20.Rdata

.PHONY: all clean
