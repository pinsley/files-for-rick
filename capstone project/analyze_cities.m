num_years = size(city_pops,1);
num_cities = size(city_pops,2);

city_shouse_incomes2 = cell2mat(city_shouse_incomes);
city_scounty_incomes2 = cell2mat(city_scounty_incomes);
city_diffcounty_incomes2 = cell2mat(city_diffcounty_incomes);
city_diffstate_incomes2 = cell2mat(city_diffstate_incomes);
city_pops2 = cell2mat(city_pops);

city_stationary_incomes2 = (city_shouse_incomes2 + city_scounty_incomes2)/2;

for i = 1:num_years-1
    city_pop_change(i,:) = city_pops2(i+1,:) - city_pops2(i,:);
end

city_total_pop_change = sum(city_pop_change,1);
city_avg_stationary_incomes = mean(city_stationary_incomes2,1);
city_avg_diffcounty_incomes = mean(city_diffcounty_incomes2,1);
city_avg_diffstate_incomes = mean(city_diffstate_incomes2,1);

figure;
plotid1 = scatter(1:num_cities,sort(city_avg_stationary_incomes),'b');
hold on;
plotid2 = scatter(1:num_cities,sort(city_avg_diffcounty_incomes),'o');
plotid3 = scatter(1:num_cities,sort(city_avg_diffstate_incomes),'r');


title('Rank order income by city by move state. Blue: stationary. Red: different county in state.\rOrange: moved from different state.');

plotid1.SizeData = 14;
plotid1.MarkerFaceColor = 'b';
plotid2.SizeData = 14;
plotid2.MarkerFaceColor ='k';
plotid3.SizeData = 14;
plotid3.MarkerFaceColor = 'r';


% Make second figure where dots are connected to one another sorted on
% average stationary incomes.

[a,I] = sort(city_avg_stationary_incomes);

figure;
plotid1 = scatter(1:num_cities,city_avg_stationary_incomes(I),'b');
hold on;
plotid2 = scatter(1:num_cities,city_avg_diffcounty_incomes(I),'o');
plotid3 = scatter(1:num_cities,city_avg_diffstate_incomes(I),'r');


title('Income by city by move state. Blue: stationary. Red: moved from different state.\rOrange: moved from different county in same state.');

plotid1.SizeData = 8;
plotid2.SizeData = 8;
plotid3.SizeData = 8;