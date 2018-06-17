clc, clear all, close

%%%%%%%%%%%%%%%%%%%%%%%%%
% 1 set parameters
%%%%%%%%%%%%%%%%%%%%%%%%%
region = 'AM';
cluster_no = 2487;
coseismic_date = 20091001;

lat_min = 35.8592;
lat_max = 36.9653;
lon_min = -118.4013;
lon_max = -117.2978;
demfilename = '/mnt/home/yujiang/program/40swarmsinsar/swarms_AM_2487/demLat_N35_N38_Lon_W119_W116.dem.wgs84';
geocodebox = [num2str(lat_min) ',' num2str(lat_max) ',' num2str(lon_min) ',' num2str(lon_max)];

orbit_number = 442;
frame_number = 2871;

orbit_ENVISAT_foldername = 'C:\Users\jiangyu\eolisa\orbits\ENVISAT';
instrument_ENVISAT_foldername = 'C:\Users\jiangyu\eolisa\instruments\ENVISAT';

%%%%%%%%%%%%%%%%%%%%%%%%%
% 2 write img_list.txt
%%%%%%%%%%%%%%%%%%%%%%%%%
filename = dir('*.N1');
file_size = size(filename);
file_number = file_size(1,1);

for i = 1:file_number
    img_list(i,:) = str2num(filename(i).name(15:22));
    mkdir(num2str(img_list(i,:)));
    movefile(filename(i).name, num2str(img_list(i,:)));
end

img_list = sort(img_list);
img_before_coseismic = img_list(img_list<coseismic_date,:);
img_after_coseismic = img_list(img_list>coseismic_date,:);

img_filename = 'img_list.txt';
fid = fopen(img_filename,'a+');
fprintf(fid,['orbit=' num2str(orbit_number) '\n']);
fprintf(fid,['frame=' num2str(frame_number) '\n']);
for i = 1:size(img_list,1)
    fprintf(fid, [num2str(img_list(i)) '\n']);
end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%
% 3 write ifg_list.txt
%%%%%%%%%%%%%%%%%%%%%%%%%
ifg_filename = 'ifg_list.txt';
fid = fopen(ifg_filename,'a+');
for i = 1:size(img_before_coseismic,1)
    for j = 1:size(img_after_coseismic,1)
        fprintf(fid, [num2str(img_before_coseismic(i)) ' ' num2str(img_after_coseismic(j)) '\n']);
    end
end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%
% 4 write .xml
%%%%%%%%%%%%%%%%%%%%%%%%%
ifg_list = load('ifg_list.txt');
for i = 1:size(ifg_list,1)
    swarmsfolder= '/mnt/home/yujiang/program/RAW/40swarmsinsar';
    ifg_foldername = [num2str(ifg_list(i,1)) '_' num2str(ifg_list(i,2)) '_ENVISAT_L0_WINSAR_' num2str(orbit_number) '_' num2str(frame_number)];
    xml_filename = 'insarApp.xml';

    imagefile_master_filename = dir([num2str(ifg_list(i,1)) '\*']);
    imagefile_master = [swarmsfolder '/swarms_' region '_' num2str(cluster_no) '/' num2str(ifg_list(i,1)) '/' imagefile_master_filename(3).name];
    imagefile_slave_filename = dir([num2str(ifg_list(i,2)) '\*']);
    imagefile_slave = [swarmsfolder '/swarms_' region '_' num2str(cluster_no) '/' num2str(ifg_list(i,2)) '/' imagefile_slave_filename(3).name];
    
    orbit_filename = dir([orbit_ENVISAT_foldername '/*']);
    file_size = size(orbit_filename);
    file_number = file_size(1,1);
    for j = 1:file_number
        date = num2str(ifg_list(i,1));
        year = str2num(date(1:4));
        month = str2num(date(5:6));
        day = str2num(date(7:8));
        before_date = datevec(datenum(year,month,day)-1);
        after_date = datevec(datenum(year,month,day)+1);
        if strfind(orbit_filename(j).name,num2str(before_date(1)*10000+ before_date(2)*100+ before_date(3))) & strfind(orbit_filename(j).name,num2str(after_date(1)*10000+ after_date(2)*100+after_date(3)))
            orbitfile_master = ['/mnt/home/yujiang/myData/orbits/ENVISAT/' orbit_filename(j).name];
        end
        date = num2str(ifg_list(i,2));
        year = str2num(date(1:4));
        month = str2num(date(5:6));
        day = str2num(date(7:8));
        before_date = datevec(datenum(year,month,day)-1);
        after_date = datevec(datenum(year,month,day)+1);
        if strfind(orbit_filename(j).name,num2str(before_date(1)*10000+ before_date(2)*100+ before_date(3))) & strfind(orbit_filename(j).name,num2str(after_date(1)*10000+ after_date(2)*100+after_date(3)))
            orbitfile_slave = ['/mnt/home/yujiang/myData/orbits/ENVISAT/' orbit_filename(j).name];
        end
    end
    
    if ifg_list(i,1) > 20070307 && ifg_list(i,1) < 20090428
        instrumentfile_master = ['/mnt/home/yujiang/myData/instruments/ENVISAT/' 'ASA_INS_AXVIEC20090525_115408_20070307_060000_20090428_095959'];
    elseif ifg_list(i,1) > 20090428 && ifg_list(i,1) < 20101231
        instrumentfile_master = ['/mnt/home/yujiang/myData/instruments/ENVISAT/' 'ASA_INS_AXVIEC20091217_114637_20090428_100000_20101231_235959'];
    end
    
    if ifg_list(i,2) > 20070307 && ifg_list(i,2) < 20090428
        instrumentfile_slave = ['/mnt/home/yujiang/myData/instruments/ENVISAT/' 'ASA_INS_AXVIEC20090525_115408_20070307_060000_20090428_095959'];
    elseif ifg_list(i,2) > 20090428 && ifg_list(i,2) < 20101231
        instrumentfile_slave = ['/mnt/home/yujiang/myData/instruments/ENVISAT/' 'ASA_INS_AXVIEC20091217_114637_20090428_100000_20101231_235959'];
    end
    
    fid = fopen(xml_filename,'wt');
    fprintf(fid, '<?xml version="1.0" encoding="UTF-8"?> \n');
    fprintf(fid, '<insarApp>\n');
    fprintf(fid, '<component name="insar">\n');
    fprintf(fid, '  <property name="Posting">\n');
    fprintf(fid, '    <value>40</value>\n');
    fprintf(fid, '  </property>\n');
    fprintf(fid, '  <property name="unwrap">\n');
    fprintf(fid, '    <value>True</value>\n');
    fprintf(fid, '  </property>\n');
    fprintf(fid,   '<property name="unwrapper name">\n');
    fprintf(fid, '    <value>snaphu_mcf</value>\n');
    fprintf(fid, '  </property>\n');
    fprintf(fid, '  <property name="Doppler Method">\n');
    fprintf(fid, '    <value>useDOPIQ</value>\n');
    fprintf(fid, '  </property>\n');
    fprintf(fid, '  <property name="Sensor Name">\n');
    fprintf(fid, '    <value>ENVISAT</value>\n');
    fprintf(fid, '  </property>\n');
    fprintf(fid, '<component name="insarproc">\n');
    fprintf(fid, '  <property name="applyWaterMask">\n');
    fprintf(fid, '    <value>False</value>\n');
    fprintf(fid, '  </property>\n');
    fprintf(fid, '</component>\n');
    fprintf(fid, ['  <property name="geocode bounding box">[' geocodebox ']</property>\n']);
    fprintf(fid, '<component name="Master">\n');
    fprintf(fid, ['	<property name="IMAGEFILE"><value>' imagefile_master '</value></property>\n']);
    fprintf(fid, ['  <property name="INSTRUMENTFILE"><value>' instrumentfile_master '</value></property>\n']);
    fprintf(fid, ['  <property name="ORBITFILE"><value>' orbitfile_master '</value></property>\n']);
    fprintf(fid, '  <property name="OUTPUT"><value>master.raw</value></property>\n');
    fprintf(fid, '</component>\n');
    fprintf(fid, '<component name="Slave">\n');
    fprintf(fid, ['	<property name="IMAGEFILE"><value>' imagefile_slave '</value></property>\n']);
    fprintf(fid, ['  <property name="INSTRUMENTFILE"><value>' instrumentfile_slave '</value></property>\n']);
    fprintf(fid, ['  <property name="ORBITFILE"><value>' orbitfile_slave '</value></property>\n']);
    fprintf(fid, '  <property name="OUTPUT"><value>slave.raw</value></property>\n');
    fprintf(fid, ' </component>\n');
    fprintf(fid, '</component>\n');
    fprintf(fid, '</insarApp>\n');
    fclose(fid);
    
    mkdir(ifg_foldername)
    movefile(xml_filename, ifg_foldername)
end