cd(main_dir);

years = [10,11,12,13,14];

do_metro_areas_income = true;

if do_metro_areas_income
    
    clear list_cities2;
    clear city_shouse_incomes;
    clear city_scounty_incomes;
    clear city_diffcounty_incomes;
    clear city_diffstate_incomes;
    
    for year = years(1):years(end)
        year_num = year - years(1) + 1;
        cd([main_dir '/' 'incbymob/metro stat area/mob']);
        tmp = csvimport(['ACS_' num2str(year) '_5YR_B07011_with_ann.csv']);
        num_rows = length(tmp);
        
        clear all_city_ids;
        clear all_cities;
        clear all_city_pops;
        
        counter =0;
        for i = 3:num_rows
            counter =counter +1;
            all_city_ids{counter} = tmp{i,2};
            all_cities{counter} = tmp{i,3};
        end
        
        counter2 =0;
        num_cities = length(areas_queried);
        for city_num = 1:num_cities
            city_id = areas_queried{city_num};
            if year_num> 3 &&isequal(city_id,'31100')
                % Keep city ids consistent between years
                city_id = '31080';
            end
            test = strmatch(city_id,all_city_ids);
            if ~isempty(test)
                counter2 = counter2 + 1;
                matching_row = test;
                
                list_cities2{year_num,city_num} = all_cities{matching_row};
                city_shouse_income = str2num(tmp{matching_row+2,7});
                city_scounty_income = str2num(tmp{matching_row+2,9});
                city_diffcounty_income = str2num(tmp{matching_row+2,11});
                city_diffstate_income = str2num(tmp{matching_row+2,13});
                
                city_shouse_incomes{year_num,counter2} = city_shouse_income;
                city_scounty_incomes{year_num,counter2} = city_scounty_income;
                city_diffcounty_incomes{year_num,counter2} = city_diffcounty_income;
                city_diffstate_incomes{year_num,counter2} = city_diffstate_income;
                
            else
                % Keep track of bad entries.
                list_cities2{year_num,city_num} = 'asdfasdfa';
            end
            
        end
        
        
    end
    
    cd(main_dir)
    
end

