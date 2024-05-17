###~~~~~~~~~~~~~ creating socialmedia application database ~~~~~~~~~~~###

create database sma_db;

use sma_db;

show tables;

###~~~~~~~~~~~~~ creating user_status table ~~~~~~~~~~~~~###
create table user_status (
    user_status_id int primary key auto_increment,
    type char(30) not null unique
    );

###~~~~~~~~~~~~~ creating countries table ~~~~~~~~~~~~~###
create table countries (
    country_id int primary key auto_increment,
    name char(50) not null unique 
);


###~~~~~~~~~~~~~ creating states table ~~~~~~~~~~~~~###
create table states (
    state_id int primary key auto_increment,
    name char(50) not null,
    country_id int not null,
    constraint states_country_fk foreign key (country_id) references countries(country_id)
);


###~~~~~~~~~~~~~  creating cities table ~~~~~~~~~~~~~###
create table cities (
    city_id int primary key auto_increment,
    name char(50) not null,
    state_id int not null,
    constraint cities_state_fk foreign key (state_id) references states(state_id)
);


###~~~~~~~~~~~~~ creating institutes table ~~~~~~~~~~~~~###
create table institutes(
    institute_id int primary key auto_increment,
    name char(50) not null unique
);


###~~~~~~~~~~~~~ creating courses table ~~~~~~~~~~~~~###
create table courses(
    course_id int primary key auto_increment,
    name char(50) not null unique
);


###~~~~~~~~~~~~~ creating users table ~~~~~~~~~~~~~###
create table users (
    user_id int primary key auto_increment,
    username char(30) not null unique,
    fullname char(50),
    password varchar(300) not null,
    email char(255) not null unique,
    mobile_no char(10) not null unique,
    verification_code char(255),
    otp_code char(8),
    email_verify_time bigint,
    mobile_verify_time bigint,
    user_status_id int not null default 1,
    constraint users_us_fk foreign key (user_status_id) references user_status(user_status_id)
);


###~~~~~~~~~~~~~ creating table profiles ~~~~~~~~~~~~~###
create table profiles (
    profile_id int primary key auto_increment,
    creation_time datetime not null,
    profile_pic_path char(255),
    background_pic_path char(255),
    main_heading_name char(80) not null,
    side_heading char(150),
    about varchar(500),
    description varchar(2000),
    album_folder_name char(100) not null,
    profile_type boolean not null default TRUE
);


###~~~~~~~~~~~~~ creating personal_profiles table ~~~~~~~~~~~~~###
create table personal_profiles (
    personal_profile_id int primary key auto_increment,
    profile_id int not null unique,
    user_id int not null unique,
    date_of_birth date not null,
    gender char(1) not null,
    address varchar(500),
    profession char(50),
    linkedin char(255),
    instagram char(255),
    youtube char(255),
    github char(255),
    city_id int not null,
    profile_type boolean not null default TRUE,
    follower_count int not null default 0,
    following_count int not null default 0,
    constraint pp_profile_fk foreign key (profile_id) references profiles(profile_id),
    constraint pp_user_fk foreign key (user_id) references users(user_id),
    constraint pp_city_fk foreign key (city_id) references cities(city_id)
);


###~~~~~~~~~~~~~ creating educations table ~~~~~~~~~~~~~###
create table educations (
    education_id int primary key auto_increment,
    personal_profile_id int not null,
    institute_id int not null,
    course_id int not null,
    start_date date,
    completion_date date,
    constraint edu_pp_fk foreign key (personal_profile_id) references personal_profiles(personal_profile_id),
    constraint edu_institute_fk foreign key (institute_id) references institutes(institute_id),
    constraint edu_course_fk foreign key (course_id) references courses(course_id)
    );



###~~~~~~~~~~~~~ creating followers table ~~~~~~~~~~~~~###
create table followers (
    follower_id int primary key auto_increment,
    follower_profile_id int not null,
    following_profile_id int not null,
    viewed boolean not null default FALSE,
    constraint fol_pp_fk foreign key (follower_profile_id) references personal_profiles(personal_profile_id),
    constraint foll_pp_fk foreign key (following_profile_id) references personal_profiles(personal_profile_id)
);


###~~~~~~~~~~~~~ creating hobbies table ~~~~~~~~~~~~~###
create table hobbies (
    hobby_id int primary key auto_increment,
    personal_profile_id int not null,
    name char(40) not null,
    constraint fk_h_pp foreign key (personal_profile_id) references personal_profiles(personal_profile_id)
);


###~~~~~~~~~~~~~ creating keywords table ~~~~~~~~~~~~~###
create table keywords (
    keyword_id int primary key auto_increment,
    personal_profile_id int not null,
    name char(40) not null,
    constraint fk_k_pp foreign key (personal_profile_id) references personal_profiles(personal_profile_id)    
);


###~~~~~~~~~~~~~ create group_types table ~~~~~~~~~~~~~###
create table group_types (
    group_type_id int primary key auto_increment,
    type char(30) not null unique
);



###~~~~~~~~~~~~~ create group_profiles table ~~~~~~~~~~~~~###
create table group_profiles (
    group_id int primary key auto_increment,
    profile_id int not null unique,
    personal_profile_id int not null,
    group_type_id int not null,
    member_count int not null,
    constraint group_profiles foreign key (profile_id) references profiles(profile_id),
    constraint group_pp foreign key (personal_profile_id) references personal_profiles(personal_profile_id),
    constraint group_gtypes foreign key (group_type_id) references group_types(group_type_id)
);


###~~~~~~~~~~~~~ creating visibility_types table ~~~~~~~~~~~~~###
create table visibility_types (
    visibility_type_id int primary key auto_increment,
    type char(10) not null unique
);



###~~~~~~~~~~~~~ creating combines table ~~~~~~~~~~~~~###
create table combines (
    combine_id int primary key auto_increment,
    creation_time datetime not null,
    personal_profile_id int not null,
    visibility_type_id int not null,
    folder_name char(100) not null unique,
    comments_count int not null default 0,
    likes_count int not null default 0,
    combine_type boolean not null default TRUE,
    deletion_time datetime,
    combine_status boolean not null default TRUE,
    story_status boolean not null default FALSE,
    constraint combine_pp_fk foreign key (personal_profile_id) references personal_profiles(personal_profile_id),
    constraint combine_vt_fk foreign key (visibility_type_id) references visibility_types(visibility_type_id)
);



###~~~~~~~~~~~~~ creating posts table ~~~~~~~~~~~~~###
create table posts (
    post_id int primary key auto_increment,
    combine_id int not null unique,
    main_heading char(80) not null,
    side_heading char(150),
    about varchar(500),
    constraint posts_combine_fk foreign key (combine_id) references combines(combine_id)
);



###~~~~~~~~~~~~~ creating combine_comments table ~~~~~~~~~~~~~###
create table combine_comments (
    comment_id int primary key auto_increment,
    personal_profile_id int not null,
    combine_id int not null,
    comment varchar(1000) not null,
    comment_time datetime not null,
    viewed boolean not null default FALSE,
    constraint cc_pp_fk foreign key (personal_profile_id) references personal_profiles(personal_profile_id),
    constraint cc_combine_fk foreign key (personal_profile_id) references combines(combine_id)
);






###~~~~~~~~~~~~~ creating combine_likes table ~~~~~~~~~~~~~###
create table combine_likes (
    combine_like_id int primary key auto_increment,
    personal_profile_id int not null,
    combine_id int not null,
    viewed boolean not null default FALSE,
    constraint cl_pp_fk foreign key (personal_profile_id) references personal_profiles(personal_profile_id),
    constraint cl_combine_fk foreign key (combine_id) references combines(combine_id)
);



###~~~~~~~~~~~~~ creating request_status ~~~~~~~~~~~~~###
create table request_status (
    request_status_id int primary key auto_increment,
    type char(30) not null unique
);



###~~~~~~~~~~~~~ creating table friend_requests ~~~~~~~~~~~~~###
create table friend_requests (
    request_id int primary key auto_increment,
    sender_profile_id int not null,
    reciever_profile_id int not null,
    request_time datetime not null,
    request_status_id int not null default 0,
    viewed boolean not null default FALSE,
    constraint fr_pp_fk1 foreign key (sender_profile_id) references personal_profiles (personal_profile_id),
    constraint fr_pp_fk2 foreign key (reciever_profile_id) references personal_profiles (personal_profile_id),
    constraint fr_rs_fk foreign key (request_status_id) references request_status(request_status_id)
);



###~~~~~~~~~~~~~ creating chat_status table ~~~~~~~~~~~~~###
create table chat_status (
    chat_status_id int primary key auto_increment,
    type char(30) not null unique
);



###~~~~~~~~~~~~~ creating friend_chats table ~~~~~~~~~~~~~###
create table friend_chats (
    friend_chat_id int primary key auto_increment,
    from_profile_id int not null,
    to_profile_id int not null,
    message varchar(1000) not null,
    send_time datetime not null,
    recieved_time datetime not null,
    chat_status_id int not null,
    constraint fc_pp_fk1 foreign key (from_profile_id) references personal_profiles(personal_profile_id),
    constraint fc_pp_fk2 foreign key (to_profile_id) references personal_profiles(personal_profile_id),
    constraint fc_cs_fk foreign key (chat_status_id) references chat_status(chat_status_id)
);


### ~~~~~~~~~~~~ creating custom_profiles table ~~~~~~~~~~~~~###
create table custom_profiles (
    custom_profile_id int primary key auto_increment,
    combine_id int not null,
    profile_id int not null,
    constraint cf_combine_fk foreign key (combine_id) references combines(combine_id),
    constraint cf_profile_fk foreign key (profile_id) references profiles(profile_id)
);


###~~~~~~~~~~~~~ creating media_types table ~~~~~~~~~~~~~###
create table media_types (
    media_type_id int primary key auto_increment,
    type char(20) not null unique
);



###~~~~~~~~~~~~~ creating combine_medias table ~~~~~~~~~~~~~###
create table combine_medias (
    combine_media_id int primary key auto_increment,
    combine_id int not null,
    media_path char(255) not null,
    media_type_id int not null,
    constraint cm_combine_fk foreign key (combine_id) references combines(combine_id),
    constraint cm_mt_fk foreign key (media_type_id) references media_types(media_type_id)
);


###~~~~~~~~~~~~~ creating group_members table ~~~~~~~~~~~~~###
create table group_members (
    group_member_id int primary key auto_increment,
    group_id int not null,
    role boolean not null default TRUE,
    personal_profile_id int not null,
    constraint gm_group_fk foreign key (group_id) references group_profiles(group_id),
    constraint gm_pp_fk foreign key (personal_profile_id) references personal_profiles(personal_profile_id)
);



###~~~~~~~~~~~~~ creating group_chats table ~~~~~~~~~~~~~###
create table group_chats (
    group_chat_id int primary key auto_increment,
    personal_profile_id int not null,
    group_id int not null,
    message varchar(1000) not null,
    send_date datetime not null,
    recieved_date datetime not null,
    chat_status_id int not null,
    constraint gc_pp_fk foreign key (personal_profile_id) references personal_profiles(personal_profile_id),
    constraint gc_group_fk foreign key (group_id) references group_profiles(group_id),
    constraint gc_cs_fk foreign key (chat_status_id) references chat_status(chat_status_id)
);



system cls;



show tables;



insert into user_status (type) values ('inactive'), ('active'), ('temporarily inactive'), ('permanently deleted');



insert into group_types (type) values ('social'), ('friends'), ('family'), ('work');



insert into visibility_types (type) values ('all'), ('no one'), ('custom');



insert into request_status (type) values ('pending'), ('accepted'), ('rejected'), ('reciever blocked'), ('sender blocked'), ('both blocked');



insert into chat_status (type) values ('unread'), ('read'), ('deleted');



insert into media_types (type) values ('audio'), ('video'), ('image'), ('gif');


system cls;


insert into countries (name) values
('Afghanistan'),
('Albania'),
('Algeria'),
('Andorra'),
('Angola'),
('Antigua and Barbuda'),
('Argentina'),
('Armenia'),
('Australia'),
('Austria'),
('Azerbaijan'),
('Bahamas'),
('Bahrain'),
('Bangladesh'),
('Barbados'),
('Belarus'),
('Belgium'),
('Belize'),
('Benin'),
('Bhutan'),
('Bolivia'),
('Bosnia and Herzegovina'),
('Botswana'),
('Brazil'),
('Brunei'),
('Bulgaria'),
('Burkina Faso'),
('Burundi'),
('Cabo Verde'),
('Cambodia'),
('Cameroon'),
('Canada'),
('Central African Republic'),
('Chad'),
('Chile'),
('China'),
('Colombia'),
('Comoros'),
('Congo, Democratic Republic of the'),
('Congo, Republic of the'),
('Costa Rica'),
('Croatia'),
('Cuba'),
('Cyprus'),
('Czech Republic'),
('Denmark'),
('Djibouti'),
('Dominica'),
('Dominican Republic'),
('Ecuador'),
('Egypt'),
('El Salvador'),
('Equatorial Guinea'),
('Eritrea'),
('Estonia'),
('Eswatini'),
('Ethiopia'),
('Fiji'),
('Finland'),
('France'),
('Gabon'),
('Gambia'),
('Georgia'),
('Germany'),
('Ghana'),
('Greece'),
('Grenada'),
('Guatemala'),
('Guinea'),
('Guinea-Bissau'),
('Guyana'),
('Haiti'),
('Honduras'),
('Hungary'),
('Iceland'),
('India'),
('Indonesia'),
('Iran'),
('Iraq'),
('Ireland'),
('Israel'),
('Italy'),
('Jamaica'),
('Japan'),
('Jordan'),
('Kazakhstan'),
('Kenya'),
('Kiribati'),
('Korea, North'),
('Korea, South'),
('Kosovo'),
('Kuwait'),
('Kyrgyzstan'),
('Laos'),
('Latvia'),
('Lebanon'),
('Lesotho'),
('Liberia'),
('Libya'),
('Liechtenstein'),
('Lithuania'),
('Luxembourg'),
('Madagascar'),
('Malawi'),
('Malaysia'),
('Maldives'),
('Mali'),
('Malta'),
('Marshall Islands'),
('Mauritania'),
('Mauritius'),
('Mexico'),
('Micronesia'),
('Moldova'),
('Monaco'),
('Mongolia'),
('Montenegro'),
('Morocco'),
('Mozambique'),
('Myanmar'),
('Namibia'),
('Nauru'),
('Nepal'),
('Netherlands'),
('New Zealand'),
('Nicaragua'),
('Niger'),
('Nigeria'),
('North Macedonia'),
('Norway'),
('Oman'),
('Pakistan'),
('Palau'),
('Palestine'),
('Panama'),
('Papua New Guinea'),
('Paraguay'),
('Peru'),
('Philippines'),
('Poland'),
('Portugal'),
('Qatar'),
('Romania'),
('Russia'),
('Rwanda'),
('Saint Kitts and Nevis'),
('Saint Lucia'),
('Saint Vincent and the Grenadines'),
('Samoa'),
('San Marino'),
('Sao Tome and Principe'),
('Saudi Arabia'),
('Senegal'),
('Serbia'),
('Seychelles'),
('Sierra Leone'),
('Singapore'),
('Slovakia'),
('Slovenia'),
('Solomon Islands'),
('Somalia'),
('South Africa'),
('South Sudan'),
('Spain'),
('Sri Lanka'),
('Sudan'),
('Suriname'),
('Sweden'),
('Switzerland'),
('Syria'),
('Taiwan'),
('Tajikistan'),
('Tanzania'),
('Thailand'),
('Timor-Leste'),
('Togo'),
('Tonga'),
('Trinidad and Tobago'),
('Tunisia'),
('Turkey'),
('Turkmenistan'),
('Tuvalu'),
('Uganda'),
('Ukraine'),
('United Arab Emirates'),
('United Kingdom'),
('United States'),
('Uruguay'),
('Uzbekistan'),
('Vanuatu'),
('Vatican City'),
('Venezuela'),
('Vietnam'),
('Yemen'),
('Zambia'),
('Zimbabwe');


system cls;


select * from countries;


select * from user_status;


select * from group_types;


select * from visibility_types;


select * from request_status;


select * from chat_status;


select * from media_types;


system cls;


show tables;

