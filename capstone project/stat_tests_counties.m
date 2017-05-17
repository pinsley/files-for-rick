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
        new_vec =cat(1,county_pop_change(i,:),stationary_incomes2(i,:));
        if i>1
            new_vec = cat(2,old_vec,new_vec);
        end
    end
    
    test1 = new_vec(1,:);
    test2 = new_vec(2,:);
    fprintf('correlation of county population change with non-(county to county) mover income')
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
        new_vec =cat(1,county_pop_change(i,:),diffcounty_incomes2(i,:));
        if i>1
            new_vec = cat(2,old_vec,new_vec);
        end
    end
    
    test1 = new_vec(1,:);
    test2 = new_vec(2,:);
    fprintf('correlation of county population change with moved from different county in same state mover incomes')
    
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
        new_vec =cat(1,county_pop_change(i,:),diffstate_incomes2(i,:));
        if i>1
            new_vec = cat(2,old_vec,new_vec);
        end
    end
    
    test1 = new_vec(1,:);
    test2 = new_vec(2,:);
    
    fprintf('correlation of county population change with moved from different state mover incomes')
    
    corrcoef(test1,test2)
end



fprintf(' non-(county to county) mover, i.e. stationary, income stats')
mean(mean(stationary_incomes2))
test = reshape(stationary_incomes2,[13410,1]);
this_std = std(test)
std_error = this_std/sqrt(13410)

fprintf('different state mover income stats')
mean(mean(diffstate_incomes2))
test = reshape(diffstate_incomes2,[13410,1]);
this_std = std(test)
std_error = this_std/sqrt(13410)

fprintf('different county in same state mover income stats')
mean(mean(diffcounty_incomes2))
test = reshape(diffcounty_incomes2,[13410,1]);
this_std = std(test)
std_error = this_std/sqrt(13410)
