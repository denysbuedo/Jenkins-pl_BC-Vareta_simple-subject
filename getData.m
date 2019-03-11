function Jenkin_data = getData(field)

    %Clear data
    clc

    %Load xml_data_descriptor file by OS.
    xml_data_descriptor = 'data/xml_data_descriptor.xml';
    if ispc
        xml_data_descriptor = 'data\xml_data_descriptor.xml';
    end
    xmlDoc = xmlread(xml_data_descriptor); 
 
    %Get root element
    root = xmlDoc.getDocumentElement(); 

    %Get xml attribute
    job_name = char(root.getAttribute('job'));
    build_number = char(root.getAttribute('build'));
    owner_build_name = char(root.getAttribute('name'));
    egg_file_name = char(root.getAttribute('EEG'));
    leadfield_file_name = char(root.getAttribute('LeadField'));
    surface_file_name = char(root.getAttribute('Surface'));
    scalp_file_name = char(root.getAttribute('Scalp'));
    
    %Return value by field input
    
    if field == "EEG"
        Jenkin_data = egg_file_name;
    elseif field == "LeadField"
        Jenkin_data = leadfield_file_name;
    elseif field == "Surface"
        Jenkin_data = surface_file_name;
    elseif field == "Scalp"
        Jenkin_data = scalp_file_name;
    elseif field == "Job"
        Jenkin_data = job_name;
    elseif field == "Build"
        Jenkin_data = build_number;
    elseif field == "OwnerBuildName"
        Jenkin_data = owner_build_name;
    else
        disp("Invalid data")    
    end
end    

