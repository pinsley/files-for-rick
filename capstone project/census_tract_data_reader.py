import pandas as pd

years = ['2010','2011','2012','2013','2014']
states = ['AK','AL','AR','AZ','CA','CO','CT','DE','FL','GA','HI','IA','ID','IL','IN','KS','KY','LA','MA','MD','ME','MI','MN','MO','MS','MT','NC','ND','NE','NH','NJ','NM','NV','NY','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VA','VT','WA','WI','WV','WY']
state = 'NC'
special_cases = ['MA2009']

panel_data = {}


for year in years:

    table_idx = state + year
    
    file_path = 'C:/census main/' + state  + '/' + 'ACS_' + year[-2:] + '_5YR_S0701_with_ann.csv'
  
    if year == '2009':
        imp_cols = ['GEO.id','GEO.id2','HC01_EST_VC46','HC01_MOE_VC46','HC02_EST_VC46','HC02_MOE_VC46','HC03_EST_VC46','HC03_MOE_VC46']
        imp_cols = imp_cols + ['HC04_EST_VC46','HC04_MOE_VC46','HC05_EST_VC46','HC05_MOE_VC46','HC01_EST_VC55','HC01_MOE_VC55','HC02_EST_VC55','HC02_MOE_VC55']
        imp_cols = imp_cols + ['HC03_EST_VC55','HC03_MOE_VC55','HC04_EST_VC55','HC04_MOE_VC55', 'HC05_EST_VC55','HC05_MOE_VC55']
    elif year == '2010' or year == '2011' or year == '2012':
        imp_cols = ['GEO.id','GEO.id2','HC01_EST_VC57','HC01_MOE_VC57','HC02_EST_VC57','HC02_MOE_VC57','HC03_EST_VC57','HC03_MOE_VC57']
        imp_cols = imp_cols + ['HC04_EST_VC57','HC04_MOE_VC57','HC05_EST_VC57','HC05_MOE_VC57','HC01_EST_VC67','HC01_MOE_VC67','HC02_EST_VC67','HC02_MOE_VC67']
        imp_cols = imp_cols + ['HC03_EST_VC67','HC03_MOE_VC67','HC04_EST_VC67','HC04_MOE_VC67', 'HC05_EST_VC67','HC05_MOE_VC67']
    elif year == '2013':
        imp_cols = ['GEO.id','GEO.id2','HC01_EST_VC54','HC01_MOE_VC54','HC02_EST_VC54','HC02_MOE_VC54','HC03_EST_VC54','HC03_MOE_VC54']
        imp_cols = imp_cols + ['HC04_EST_VC54','HC04_MOE_VC54','HC05_EST_VC54','HC05_MOE_VC54','HC01_EST_VC64','HC01_MOE_VC64','HC02_EST_VC64','HC02_MOE_VC64']
        imp_cols = imp_cols + ['HC03_EST_VC64','HC03_MOE_VC64','HC04_EST_VC64','HC04_MOE_VC64', 'HC05_EST_VC64','HC05_MOE_VC64']
    elif year == '2014':
        imp_cols = ['GEO.id','GEO.id2','HC01_EST_VC54','HC01_MOE_VC54','HC02_EST_VC54','HC02_MOE_VC54','HC03_EST_VC54','HC03_MOE_VC54']
        imp_cols = imp_cols + ['HC04_EST_VC54','HC04_MOE_VC54','HC05_EST_VC54','HC05_MOE_VC54','HC01_EST_VC64','HC01_MOE_VC64','HC02_EST_VC64','HC02_MOE_VC64']
        imp_cols = imp_cols + ['HC03_EST_VC64','HC03_MOE_VC64','HC04_EST_VC64','HC04_MOE_VC64', 'HC05_EST_VC64','HC05_MOE_VC64']
    
    
    data = pd.read_csv(file_path, low_memory=False, header='infer')
    
    
    data = data[imp_cols]
        
    col_names = ['id1','id2','pop','pop_marg','perc_sc_move','perc_sc_marg','perc_dc_move','perc_dc_marg','perc_ds_move','perc_ds_marg','perc_dcount_move','perc_dcount_marg']
    
    col_names = col_names + ['medinc','medinc_marg','medinc_sc_move','medinc_sc_marg','medinc_dc_move','medinc_dc_marg','medinc_ds_move','medinc_ds_marg','medinc_dcount_move','medinc_dcount_marg']
    
    data.columns = col_names
    
    data2 = data.apply(pd.to_numeric, errors='coerce')

    del data2['id1']
    del data2['id2']
    data2 = pd.concat([data['id1'],data['id2'],data2],axis=1)
    data2.drop(0,axis=0,inplace=True)
    data2.reset_index(drop=True,inplace=True)
    
    
    def table_special_case(case):
        if case == 'MA2009':
            data2.drop(0,axis=0,inplace=True)
            data2.reset_index(drop=True,inplace=True)
            
    if table_idx in special_cases:
        table_special_case(table_idx)
    
    panel_data[year] = data2
    
    data_final = data2
    data_final.to_csv(r'C:/census main/Zgen_tbls/data2 ' + state + ' ' + year + '.txt')
