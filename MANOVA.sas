/* Importing data */
libname course '/folders/myfolders';
proc print data=paper;
run;
data paper;
set work.paper;
run;
proc sort data=paper out=paper_sort;
key relationship/ascending;
run;

/* Some basic statistics*/
proc means data =paper;
var price productq service;
by size ;
run;

proc boxplot data=paper_sort;
id relationship price;
plot price*relationship;
run;

/* Use of macros files to compute multivariate normality and plot qq plots*/
%include "C:\Users\Ambe\Desktop\First Semester\Multivariate Statistics\Assignment 4\multnorm.sas";
%include "C:\Users\Ambe\Desktop\First Semester\Multivariate Statistics\Assignment 4\cqplot.sas";
%multnorm (data=paper, var =price productq service);
%cqplot(data=paper, var =price productq service, nvar=3, gplot=yes,detrend=no);
run;

/*checking for significant main effects and interaction*/
/*2 way manova*/
proc glm;
class relationship size;
model price productq service = relationship size relationship*size;
manova h=relationship size relationship*size;
run;
/*one way manova*/
proc glm;
class relationship;
model price productq service = relationship;
contrast 'mean1-2' relationship -1 1 0;
contrast 'mean1-3' relationship -1 0 1;
manova h=relationship;
run;
/*one way anova with contrast */
/* The variable was also changed for productQ and Price*/
proc glm;
class relationship;
model service = relationship;
contrast 'mean1-2' relationship -1 1 0;
contrast 'mean1-3' relationship -1 0 1;
run;

/* MANOVA with responses price, productq and service*/
proc glm;
class relationship ;
model price productq service = relationship;
manova h=relationship;
run;

/* MANOVA model using candisc*/
proc candisc data=paper out=canout;
class relationship;
var price productq service;
run;

proc plot data=canout;
plot can1*relationship="-";
run;


