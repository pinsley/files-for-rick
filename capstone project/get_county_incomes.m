years = [10,11,12,13,14];
bad_counties = {'51515','46102','02158','02270','46113'};

do_county_incomes = 1;

if do_county_incomes
    clear these_county_ids;
    clear shouse_incomes;
    clear scounty_incomes;
    clear diffcounty_incomes;
    clear diffstate_incomes;
    clear income_county_ids;
    
    for year = years(1):years(end)
    year_num = year - years(1) + 1;
    cd([main_dir '/' 'incbymob/county data/mob']);
    tmp = csvimport(['ACS_' num2str(year) '_5YR_B07011_with_ann.csv']);
    num_rows = size(tmp,1)-2;
    
    counter = 0;
    counter2 = 0;
        for i = 1:num_rows-2
            this_bad = 0 ;
            counter = counter + 1;
            these_county_ids{year_num,counter} = tmp{i+2,2};
            county_id = tmp{i+2,2};
        
            shouse_income = str2num(tmp{i+2,7});
            scounty_income = str2num(tmp{i+2,9});
            diffcounty_income = str2num(tmp{i+2,11});
            diffstate_income = str2num(tmp{i+2,13});
            
            if isempty(strmatch(county_id,all_bad_counties2))
            counter2 = counter2 + 1;
            
            shouse_incomes{year_num,counter2} = shouse_income;
            scounty_incomes{year_num,counter2} = scounty_income;
            diffcounty_incomes{year_num,counter2} = diffcounty_income;
            diffstate_incomes{year_num,counter2} = diffstate_income;
            income_county_ids{year_num,counter2} = county_id;
            
            end
        end
    end
    
cd(main_dir);
    
end