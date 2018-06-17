clc, clear all, close

%%%%%%%%%%%%%%%%%%%%%%%%%
% 1 set parameters
%%%%%%%%%%%%%%%%%%%%%%%%%
region = 'AM';
cluster_no = 769;
coseismic_date = 19950817;

lat_min = 35.138;
lat_max = 36.41;
lon_min = -118.268;
lon_max = -116.931;
demfilename = '/mnt/home/yujiang/program/40swarmsinsar/swarms_AM_2487/demLat_N35_N38_Lon_W119_W116.dem.wgs84';
geocodebox = [num2str(lat_min) ',' num2str(lat_max) ',' num2str(lon_min) ',' num2str(lon_max)];

orbit_number = 170;
frame_number = 2889;

%%%%%%%%%%%%%%%%%%%%%%%%%
% 2 write img_list.txt
%%%%%%%%%%%%%%%%%%%%%%%%%
filename = dir('*.gz');
file_size = size(filename);
file_number = file_size(1,1);

for i = 1:file_number
    img_list(i,:) = str2num(filename(i).name(17:24));
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
    ifg_foldername = [num2str(ifg_list(i,1)) '_' num2str(ifg_list(i,2)) '_ERS1_L0_WINSAR_' num2str(orbit_number) '_' num2str(frame_number)];
    xml_filename = 'insarApp.xml';

    imagefile_master = [swarmsfolder '/swarms_' region '_' num2str(cluster_no) '/' num2str(ifg_list(i,1)) '/DAT_01.001'];
    leaderfile_master = [swarmsfolder '/swarms_' region '_' num2str(cluster_no) '/' num2str(ifg_list(i,1)) '/LEA_01.001'];
    imagefile_slave = [swarmsfolder '/swarms_' region '_' num2str(cluster_no) '/' num2str(ifg_list(i,2)) '/DAT_01.001'];
    leaderfile_slave = [swarmsfolder '/swarms_' region '_' num2str(cluster_no) '/' num2str(ifg_list(i,2)) '/LEA_01.001'];
    orbit_type = 'ODR';
    orbit_directory = 'mnt/home/yujiang/program/orbits/ERS1_ODR';
   
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
    fprintf(fid, '    <value>ERS</value>\n');
    fprintf(fid, '  </property>\n');
    fprintf(fid, '<component name="insarproc">\n');
    fprintf(fid, '  <property name="applyWaterMask">\n');
    fprintf(fid, '    <value>False</value>\n');
    fprintf(fid, '  </property>\n');
    fprintf(fid, '</component>\n');
    fprintf(fid, ['  <property name="geocode bounding box">[' geocodebox ']</property>\n']);
    fprintf(fid, '<component name="Master">\n');
    fprintf(fid, ['	<property name="IMAGEFILE"><value>' imagefile_master '</value></property>\n']);
    fprintf(fid, ['  <property name="LEADERFILE"><value>' leaderfile_master '</value></property>\n']);
    fprintf(fid, ['  <property name="ORBIT_TYPE"><value>' orbit_type '</value></property>\n']);
    fprintf(fid, ['  <property name="ORBIT_DIRECTORY"><value>' orbit_directory '</value></property>\n']);
    fprintf(fid, '  <property name="OUTPUT"><value>master.raw</value></property>\n');
    fprintf(fid, '</component>\n');
    fprintf(fid, '<component name="Slave">\n');
    fprintf(fid, ['	<property name="IMAGEFILE"><value>' imagefile_slave '</value></property>\n']);
    fprintf(fid, ['  <property name="LEADERFILE"><value>' leaderfile_slave '</value></property>\n']);
    fprintf(fid, ['  <property name="ORBIT_TYPE"><value>' orbit_type '</value></property>\n']);
    fprintf(fid, ['  <property name="ORBIT_DIRECTORY"><value>' orbit_directory '</value></property>\n']);
    fprintf(fid, '  <property name="OUTPUT"><value>slave.raw</value></property>\n');
    fprintf(fid, ' </component>\n');
    fprintf(fid, '</component>\n');
    fprintf(fid, '</insarApp>\n');
    fclose(fid);
    
    mkdir(ifg_foldername)
    movefile(xml_filename, ifg_foldername)
end