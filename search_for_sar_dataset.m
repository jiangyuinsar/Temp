clc

% be prepared to search for datasets in EOLI-SA & ASF & SENTINEL-HUB
input = [-118.4683333	-118.3683333	37.1601667	37.2521667	2016	2	16	2016	2	18];

% 0 set parameters
lon_min = input(1);
lon_max = input(2);
lat_min = input(3);
lat_max = input(4);
year_start = input(5);
month_start = input(6);
day_start = input(7);
year_end = input(8);
month_end = input(9);
day_end= input(10);

year_start_search = year_start;
month_start_search = month_start-2;
if month_start_search<1
    month_start_search = month_start_search+12;
    year_start_search = year_start_search-1;
end

year_end_search = year_end;
month_end_search = month_end+2;
if month_end_search>12
    month_end_search = month_end_search-12;
    year_end_search = year_end_search+1;
end

% 1 for EOLI-SAR
fprintf('this is for EOLI-SAR\n')
fprintf([num2str(lat_min) ' ' num2str(lon_min) '\n'])
fprintf([num2str(lat_min) ' ' num2str(lon_max) '\n'])
fprintf([num2str(lat_max) ' ' num2str(lon_max) '\n'])
fprintf([num2str(lat_max) ' ' num2str(lon_min) '\n'])
fprintf([num2str(lat_min) ' ' num2str(lon_min) '\n'])
fprintf([num2str(lat_min) ' ' num2str(lon_min) '\n'])
if month_start_search < 10
    fprintf(['01-0' num2str(month_start_search) '-' num2str(year_start_search) '\n'])
else
    fprintf(['01-' num2str(month_start_search) '-' num2str(year_start_search) '\n'])
end
if month_end_search < 10
    fprintf(['01-0' num2str(month_end_search) '-' num2str(year_end_search) '\n'])
else
    fprintf(['01-' num2str(month_end_search) '-' num2str(year_end_search) '\n'])
end
fprintf('\n\n\n\n')

% 2 for ASF
fprintf('this is for ASF\n')
fprintf([num2str(lon_min) ',' num2str(lat_min) ',' num2str(lon_min) ',' num2str(lat_max) ',' num2str(lon_max) ',' num2str(lat_max) ',' num2str(lon_max) ',' num2str(lat_min) ',' num2str(lon_min) ',' num2str(lat_min) '\n']);
if month_start_search < 10
    fprintf([num2str(year_start_search) '-0' num2str(month_start_search) '-01' '\n'])
else
    fprintf([num2str(year_start_search) '-' num2str(month_start_search) '-01' '\n'])
end
if month_end_search < 10
    fprintf([num2str(year_end_search) '-0' num2str(month_end_search) '-01' '\n'])
else
    fprintf([num2str(year_end_search) '-' num2str(month_end_search) '-01' '\n'])
end
fprintf('\n\n\n\n')

% 3 for SENTINEL-HUB
fprintf('this is for SENTINEL-HUB\n')
if month_start_search < 10
    month_start_search_str = [num2str(year_start_search) '-0' num2str(month_start_search) '-01'];
else
    month_start_search_str = [num2str(year_start_search) '-' num2str(month_start_search) '-01'];
end
if month_end_search < 10
    month_end_search_str = [num2str(year_end_search) '-0' num2str(month_end_search) '-01'];
else
    month_end_search_str = [num2str(year_end_search) '-' num2str(month_end_search) '-01'];
end
search_str = [month_start_search_str 'T00:00:00.000Z TO ' month_end_search_str 'T23:59:59.999Z'];
fprintf(['( footprint:"Intersects(POLYGON((' num2str(lon_min) ' ' num2str(lat_min) ',' num2str(lon_max) ' ' num2str(lat_min) ',' num2str(lon_max) ' ' num2str(lat_max) ',' num2str(lon_min) ' ' num2str(lat_max) ',' num2str(lon_min) ' ' num2str(lat_min) ')))" ) AND ( beginPosition:[' search_str '] AND endPosition:[' search_str '] ) AND (platformname:Sentinel-1 AND filename:S1A_* AND producttype:SLC)' '\n'])
fprintf('\n\n\n\n')

% 4 for ISCE geocoding
fprintf('this is for ISCE geocoding\n')
fprintf(['<property name="geocode bounding box">[' num2str(lat_min-0.5) ',' num2str(lat_max+0.5) ',' num2str(lon_min-0.5) ',' num2str(lon_max+0.5) ']</property>' '\n'])





