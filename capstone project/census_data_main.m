years = [10,11,12,13,14];

areas_queried = {'42660','41860','41940','31100','41740','41620','19740','19780','19100','31540','26420'};
bad_counties = {'51515','46102','02158','02270','46113'};

% generated in previous run
load('all_bad_counties2.mat');

% Generate the population totals for counties.

main_dir = 'C:/Users/Peter/Downloads/census data project';

do_counties = 0;
do_metro_areas = 1;

clear num_rowses;
if do_counties == 1
    
    clear county_pops;
    clear break_counties;
    clear county_ids;
    missing_pops = 0;
    missing_counties = 0;
    
    for year = years(1):years(end)
        year_num = year - years(1) + 1;
        cd([main_dir '/' 'incbymob/county data/pop']);
        tmp = csvimport(['ACS_' num2str(year) '_5YR_B01003_with_ann.csv']);
        
        num_rows = size(tmp,1)-2;
        num_rowses(year_num) = num_rows;
        
        counter =0;
        for i = 1:num_rows
            population = str2num(tmp{i+2,5});
            if isempty(population)||isnan(population)
                missing_pops = missing_pops + 1;
            end
            
            county_id = tmp{i+2,2};
            
            if isempty(county_id) || isnan(str2num(county_id))
                missing_counties = missing_counties + 1;
            end
            
            if isempty(strmatch(county_id,all_bad_counties2))
                counter = counter + 1;
                
                county_pops{year_num,counter} = population;
                county_ids{year_num,counter} = county_id;
            end
        end
        
    end
    
end

% cut last two counties because otherwise numbers won't match up between
% years
county_ids2 = county_ids(:,1:end-2);
clear county_pops2;
clear test;
for i = 1:size(county_pops,1)
    for j= 1:size(county_pops,2)-2
        test{i,j} = county_pops{i,j};
    end
end
county_pops2 = test;



cd(main_dir);

if do_metro_areas
    
    
    clear list_cities;
    test =0;
    clear problems_aray;
    counter2 =0;
    clear city_pops;
    
    for year = years(1):years(end)
        year_num = year - years(1) + 1;
        cd([main_dir '/' 'incbymob/metro stat area/pop']);
        tmp = csvimport(['ACS_' num2str(year) '_5YR_B01003_with_ann.csv']);
        num_rows = length(tmp);
        
        counter =0 ;
        clear all_city_ids;
        clear all_cities;
        clear all_city_pops;
        
        for i = 3:num_rows
            counter =counter +1;
            all_city_ids{counter} = tmp{i,2};
            all_cities{counter} = tmp{i,3};
            all_city_pops{counter} = tmp{i,5};
        end
        
        num_cities = length(areas_queried);
        for city_num = 1:num_cities
            city_id = areas_queried{city_num};
            if year_num> 3 &&isequal(city_id,'31100')
                % Keep city ids consistent between years
                city_id = '31080';
            end
            test = strmatch(city_id,all_city_ids);
            counter2 = counter2 + 1;
            if ~isempty(test)
                matching_row = test;
                fprintf('ok');
                list_cities{year_num,city_num} = all_cities{matching_row};
                city_pops{year_num,city_num} = str2num(all_city_pops{matching_row});
            else
                % Keep track of bad city entries
                list_cities{year_num,city_num} = 'asdfasdfa';
            end
            
        end
        
        cd(main_dir)
        
        
    end
    
end