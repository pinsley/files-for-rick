do_pop_stat_corr=1;

do_pop_diffcount_corr = 1;

do_pop_diffstate_corr = 1;

if do_pop_stat_corr
    clear old_vec;
    clear new_vec;
    clear test_vec;
    for i = 1:4
        if i>1
            old_vec = new_vec;
        end
        new_vec =cat(1,city_pop_change(i,:),city_stationary_incomes2(i,:));
        if i>1
            new_vec = cat(2,old_vec,new_vec);
        end
    end
    
    test1 = new_vec(1,:);
    test2 = new_vec(2,:);
    fprintf('correlation of city population change with non-mover (county to county), i.e. stationary, income')
    
    corrcoef(test1,test2)
end


if do_pop_diffcount_corr
    clear old_vec;
    clear new_vec;
    clear test_vec;
    for i = 1:4
        if i>1
            old_vec = new_vec;
        end
        new_vec =cat(1,city_pop_change(i,:),city_diffcounty_incomes2(i,:));
        if i>1
            new_vec = cat(2,old_vec,new_vec);
        end
    end
    
    test1 = new_vec(1,:);
    test2 = new_vec(2,:);
    fprintf('correlation of city population change with moved from different county in same state mover incomes')
    corrcoef(test1,test2)
end


if do_pop_diffstate_corr
    clear old_vec;
    clear new_vec;
    clear test_vec;
    for i = 1:4
        if i>1
            old_vec = new_vec;
        end
        new_vec =cat(1,city_pop_change(i,:),city_diffstate_incomes2(i,:));
        if i>1
            new_vec = cat(2,old_vec,new_vec);
        end
    end
    
    test1 = new_vec(1,:);
    test2 = new_vec(2,:);
    fprintf('correlation of city population change with moved from different state mover incomes')
    
    corrcoef(test1,test2)
end





fprintf('non-mover(county to county), i.e. stationary, city income stats')

mean(mean(city_stationary_incomes2))
test = reshape(city_stationary_incomes2,[55,1]);
this_std = std(test)
std_error = this_std/sqrt(55)


fprintf('different state city mover income stats')

mean(mean(city_diffstate_incomes2))
test = reshape(city_diffstate_incomes2,[55,1]);
this_std = std(test)
std_error = this_std/sqrt(55)


fprintf('different county in same state to city mover income stats')

mean(mean(city_diffcounty_incomes2))
test = reshape(city_diffcounty_incomes2,[55,1]);
this_std = std(test)
std_error = this_std/sqrt(55)