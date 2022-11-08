function [baseMVA, bus, gen, branch, areas, gencost, X_d, H, D] = bus14_PSCAD
%CASE14    Power flow data for IEEE 14 bus test case.
%   Please see 'help caseformat' for details on the case file format.
%   This data was converted from IEEE Common Data Format
%   (ieee14cdf.txt) on 20-Sep-2004 by cdf2matp, rev. 1.11
%   See end of file for warnings generated during conversion.
%
%   Converted from IEEE CDF file from:
%       http://www.ee.washington.edu/research/pstca/
% 
%  08/19/93 UW ARCHIVE           100.0  1962 W IEEE 14 Bus Test Case

%   MATPOWER
%   $Id: case14.m,v 1.5 2004/09/21 01:46:23 ray Exp $

%%-----  Power Flow Data  -----%%


% Modified by Olugbenga Moses Anubi, March 2019
% Modified by Olugbenga Moses Anubi, Carlos Wong , Jan 2020
% Data source: (https://egriddata.org/dataset/ieee-14-bus-case)




%% system MVA base
baseMVA = 100;

%% bus data
%	bus_i	type	Pd      Qd      Gs	Bs	area	Vm      Va      baseKV	zone	Vmax	Vmin
bus_data = [
	1       3       0       0       0	0	1       1.06	0       0	1	1.06	0.94;
	2       2       21.7	12.7	0	0	1       1.045	-4.98	0	1	1.06	0.94;
	3       2       94.2	19      0	0	1       1.01	-12.72	0	1	1.06	0.94;
	4       1       47.8	-3.9	0	0	1       1.019	-10.33	0	1	1.06	0.94;
	5       1       7.6     1.6     0	0	1       1.02	-8.78	0	1	1.06	0.94;
	6       2       11.2	7.5     0	0	1       1.07	-14.22	0	1	1.06	0.94;
	7       1       0       0       0	0	1       1.062	-13.37	0	1	1.06	0.94;
	8       2       0       0       0	0	1       1.09	-13.36	0	1	1.06	0.94;
	9       1       29.5	16.6	0	19	1       1.056	-14.94	0	1	1.06	0.94;
	10      1       9       5.8     0	0	1       1.051	-15.1	0	1	1.06	0.94;
	11      1       3.5     1.8     0	0	1       1.057	-14.79	0	1	1.06	0.94;
	12      1       6.1     1.6     0	0	1       1.055	-15.07	0	1	1.06	0.94;
	13      1       13.5	5.8     0	0	1       1.05	-15.16	0	1	1.06	0.94;
	14      1       14.9	5       0	0	1       1.036	-16.04	0	1	1.06	0.94;
];
bus = array2table(bus_data,'VariableNames',{'bus_i','type','Pd', 'Qd', 'Gs', 'Bs', 'area', 'Vm', 'Va', 'baseKV', 'zone', 'Vmax', 'Vmin'});

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin
gen_data = [
	1	232.4	-16.9	10	0	1.06	100	1	332.4	0;
	2	40	42.4	50	-40	1.045	100	1	140	0;
	3	0	23.4	40	0	1.01	100	1	100	0;
	6	0	12.2	24	-6	1.07	100	1	100	0;
	8	0	17.4	24	-6	1.09	100	1	100	0;
];
gen = array2table(gen_data,'VariableNames',{'bus', 'Pg', 'Qg', 'Qmax', 'Qmin', 'Vg', 'mBase', 'status', 'Pmax', 'Pmin'});
%% branch data

% branch_length_data = [% fbus tbus R_total[Ohms] length[km]
% 1 2 1.13E+01 2.25E+01;
% 1 5 4.25E+01 8.49E+01;
% 2 3 3.77E+01 7.54E+01;
% 2 4 3.35E+01 6.70E+01;
% 2 5 3.31E+01 6.63E+01;
% 3 4 3.26E+01 6.51E+01;
% 4 5 8.02E+00 1.60E+01;
% 6 11 3.79E+01 7.58E+01;
% 6 12 4.88E+01 9.75E+01;
% 6 13 2.48E+01 4.95E+01;
% 7 8 3.35E+01 6.70E+01;
% 7 9 2.09E+01 4.19E+01;
% 9 10 1.61E+01 3.22E+01;
% 9 14 5.14E+01 1.03E+02;
% 10 11 3.66E+01 7.31E+01;
% 12 13 3.81E+01 7.62E+01;
% 13 14 6.63E+01 1.33E+02;
% ];
% 
% branch_xter_data = [ % fbus tbus R[pu/m] X[pu/m] B[pu/m]
% 1 2 1.94E-07 5.92E-07 5.28E-07;
% 1 5 5.40E-07 2.23E-06 4.92E-07;
% 2 3 4.70E-07 1.98E-06 4.38E-07;
% 2 4 5.81E-07 1.76E-06 3.40E-07;
% 2 5 5.70E-07 1.74E-06 3.46E-07;
% 3 4 6.70E-07 1.71E-06 1.28E-07;
% 4 5 1.34E-07 4.21E-07 1.00E-09;
% 6 11 9.50E-07 1.99E-06 1.00E-09;
% 6 12 1.23E-06 2.56E-06 1.00E-09;
% 6 13 6.62E-07 1.30E-06 1.00E-09;
% 7 8 1.00E-09 1.76E-06 1.00E-09;
% 7 9 1.00E-09 1.10E-06 1.00E-09;
% 9 10 3.18E-07 8.45E-07 1.00E-09;
% 9 14 1.27E-06 2.70E-06 1.00E-09;
% 10 11 8.21E-07 1.92E-06 1.00E-09;
% 12 13 2.21E-06 2.00E-06 1.00E-09;
% 13 14 1.71E-06 3.48E-06 1.00E-09;
% ];

%	fbus	tbus	r       x       b       rateA	rateB	rateC	ratio angle	status angmin angmax
branch_data = [
	1	2	0.01938	0.05917	0.0528	0	0	0	0	0	1	-360	360;
	1	5	0.05403	0.22304	0.0492	0	0	0	0	0	1	-360	360;
	2	3	0.04699	0.19797	0.0438	0	0	0	0	0	1	-360	360;
	2	4	0.05811	0.17632	0.034	0	0	0	0	0	1	-360	360;
	2	5	0.05695	0.17388	0.0346	0	0	0	0	0	1	-360	360;
	3	4	0.06701	0.17103	0.0128	0	0	0	0	0	1	-360	360;
	4	5	0.01335	0.04211	0	0	0	0	0	0	1	-360	360;
	4	7	0	0.20912	0	0	0	0	0.978	0	1	-360	360;
	4	9	0	0.55618	0	0	0	0	0.969	0	1	-360	360;
	5	6	0	0.25202	0	0	0	0	0.932	0	1	-360	360;
	6	11	0.09498	0.1989	0	0	0	0	0	0	1	-360	360;
	6	12	0.12291	0.25581	0	0	0	0	0	0	1	-360	360;
	6	13	0.06615	0.13027	0	0	0	0	0	0	1	-360	360;
	7	8	0	0.17615	0	0	0	0	0	0	1	-360	360;
	7	9	0	0.11001	0	0	0	0	0	0	1	-360	360;
	9	10	0.03181	0.0845	0	0	0	0	0	0	1	-360	360;
	9	14	0.12711	0.27038	0	0	0	0	0	0	1	-360	360;
	10	11	0.08205	0.19207	0	0	0	0	0	0	1	-360	360;
	12	13	0.22092	0.19988	0	0	0	0	0	0	1	-360	360;
	13	14	0.17093	0.34802	0	0	0	0	0	0	1	-360	360;
];

% updated branch data based on PSCAD 
% branch_data(:,3:5) = branch_xter_data(:,2:4).*repmat(branch_length_data(:,4),1,3)*1e3;
branch = array2table(branch_data,'VariableNames',{'fbus', 'tbus', 'r', 'x', 'b', 'rateA', 'rateB', 'rateC', 'ratio', 'angle', 'status', 'angmin', 'angmax'});

%%-----  OPF Data  -----%%
%% area data
areas = [
	1	1;
];

%% generator cost data
%	1	startup	shutdown	n	x0	y0	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
gencost = [
	2	0	0	3	0.0430293	20	0;
	2	0	0	3	0.25	20	0;
	2	0	0	3	0.01	40	0;
	2	0	0	3	0.01	40	0;
	2	0	0	3	0.01	40	0;
];

%% Other properties
X_d      = [0.2995 0.185 0.185 0.232 0.232]; % generator transient reactances
H        = [5.148 6.54 6.54 5.06 5.06];  % normalized inertia constant Joules/VA
D        = [2 2 2 2 2]; % damping coefficents


return;



