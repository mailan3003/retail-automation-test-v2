
*** Variables ***
${CREATE_BRANCH_NAME}    Hạ Long
${INVALID_BRANCH_NAME}    Hà Đông
${Address}           Hà Nội
${LocationName}      Hà Nội - Quận Hà Đông
${WardName}          Phường Văn Quán
${LocationId}        238
${WardId}            260
${ContactNumber}     +84998987676


&{BRANCH_BODY}
    ...    TimeZone=Asia/Bangkok
    ...    temploc=Hà Nội - Quận Hà Đông
    ...    tempw=Phường Văn Quán
    ...    ContactNumber=${ContactNumber}
    ...    SubContactNumber=
    ...    Name=${CREATE_BRANCH_NAME}
    ...    Email=hanoi@gmail.com
    ...    Address=${Address}
    ...    LocationName=${LocationName}
    ...    WardName=${WardName} 
    ...    LocationId=${LocationId}
    ...    WardId=${WardId} 
    ...    AdministrativeAreaId=${NONE}
    ...    chooseTimeZone=${CHOOSE_TIMEZONE_LIST}

&{BRANCH}
    ...    Branch=${BRANCH_BODY}
    ...    IsAddMore=${False}
    ...    IsRemove=${False}
    ...    ApplyFrom=${NONE}

@{CHOOSE_TIMEZONE_LIST} 
    ...    {"Name": "(UTC-12:00) International Date Line West", "Id": "Etc/GMT+12"}
    ...    {"Name": "(UTC-11:00) Coordinated Universal Time-11", "Id": "Etc/GMT+11"}
    ...    {"Name": "(UTC-10:00) Aleutian Islands", "Id": "America/Adak"}
    ...    {"Name": "(UTC-10:00) Hawaii", "Id": "Pacific/Honolulu"}
    ...    {"Name": "(UTC-09:30) Marquesas Islands", "Id": "Pacific/Marquesas"}
    ...    {"Name": "(UTC-09:00) Alaska", "Id": "America/Anchorage"}
    ...    {"Name": "(UTC-09:00) Coordinated Universal Time-09", "Id": "Etc/GMT+9"}
    ...    {"Name": "(UTC-08:00) Baja California", "Id": "America/Tijuana"}
    ...    {"Name": "(UTC-08:00) Coordinated Universal Time-08", "Id": "Etc/GMT+8"}
    ...    {"Name": "(UTC-08:00) Pacific Time (US & Canada)", "Id": "America/Los_Angeles"}
    ...    {"Name": "(UTC-07:00) Arizona", "Id": "America/Phoenix"}
    ...    {"Name": "(UTC-07:00) La Paz, Mazatlan", "Id": "America/Mazatlan"}
    ...    {"Name": "(UTC-07:00) Mountain Time (US & Canada)", "Id": "America/Boise"}
    ...    {"Name": "(UTC-07:00) Yukon", "Id": "America/Whitehorse"}
    ...    {"Name": "(UTC-06:00) Central America", "Id": "America/Merida"}
    ...    {"Name": "(UTC-06:00) Central Time (US & Canada)", "Id": "America/Chicago"}
    ...    {"Name": "(UTC-06:00) Easter Island", "Id": "Pacific/Easter"}
    ...    {"Name": "(UTC-06:00) Guadalajara, Mexico City, Monterrey", "Id": "America/Mexico_City"}
    ...    {"Name": "(UTC-06:00) Saskatchewan", "Id": "America/Regina"}
    ...    {"Name": "(UTC-05:00) Bogota, Lima, Quito, Rio Branco", "Id": "America/Bogota"}
    ...    {"Name": "(UTC-05:00) Chetumal", "Id": "America/Cancun"}
    ...    {"Name": "(UTC-05:00) Eastern Time (US & Canada)", "Id": "America/Detroit"}
    ...    {"Name": "(UTC-05:00) Haiti", "Id": "America/Port-au-Prince"}
    ...    {"Name": "(UTC-05:00) Havana", "Id": "America/Havana"}
    ...    {"Name": "(UTC-05:00) Indiana (East)", "Id": "America/Indiana/Indianapolis"}
    ...    {"Name": "(UTC-05:00) Turks and Caicos", "Id": "America/Grand_Turk"}
    ...    {"Name": "(UTC-04:00) Asuncion", "Id": "America/Asuncion"}
    ...    {"Name": "(UTC-04:00) Atlantic Time (Canada)", "Id": "America/Glace_Bay"}
    ...    {"Name": "(UTC-04:00) Caracas", "Id": "America/Caracas"}
    ...    {"Name": "(UTC-04:00) Cuiaba", "Id": "America/Cuiaba"}
    ...    {"Name": "(UTC-04:00) Georgetown, La Paz, Manaus, San Juan", "Id": "America/Guyana"}
    ...    {"Name": "(UTC-04:00) Santiago", "Id": "America/Santiago"}
    ...    {"Name": "(UTC-03:30) Newfoundland", "Id": "America/St_Johns"}
    ...    {"Name": "(UTC-03:00) Araguaina", "Id": "America/Araguaina"}
    ...    {"Name": "(UTC-03:00) Brasilia", "Id": "America/Araguaina"}
    ...    {"Name": "(UTC-03:00) Cayenne, Fortaleza", "Id": "America/Cayenne"}
    ...    {"Name": "(UTC-03:00) Buenos Aires", "Id": "America/Argentina/Buenos_Aires"}
    ...    {"Name": "(UTC-03:00) Greenland", "Id": "America/Nuuk"}
    ...    {"Name": "(UTC-03:00) Montevideo", "Id": "America/Montevideo"}
    ...    {"Name": "(UTC-03:00) Punta Arenas", "Id": "America/Punta_Arenas"}
    ...    {"Name": "(UTC-03:00) Saint Pierre and Miquelon", "Id": "America/Miquelon"}
    ...    {"Name": "(UTC-03:00) Salvador", "Id": "America/Bahia"}
    ...    {"Name": "(UTC-02:00) Coordinated Universal Time-02", "Id": "Etc/GMT+2"}
    ...    {"Name": "(UTC-01:00) Azores", "Id": "Atlantic/Azores"}
    ...    {"Name": "(UTC-01:00) Cabo Verde Is.", "Id": "Atlantic/Cape_Verde"}
    ...    {"Name": "(UTC) Coordinated Universal Time", "Id": "Etc/UTC"}
    ...    {"Name": "(UTC+00:00) Dublin, Edinburgh, Lisbon, London", "Id": "Europe/Dublin"}
    ...    {"Name": "(UTC+00:00) Monrovia, Reykjavik", "Id": "Africa/Monrovia"}
    ...    {"Name": "(UTC+00:00) Sao Tome", "Id": "Africa/Sao_Tome"}
    ...    {"Name": "(UTC+01:00) Casablanca", "Id": "Africa/Casablanca"}
    ...    {"Name": "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna", "Id": "Europe/Amsterdam"}
    ...    {"Name": "(UTC+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague", "Id": "Europe/Belgrade"}
    ...    {"Name": "(UTC+01:00) Brussels, Copenhagen, Madrid, Paris", "Id": "Europe/Brussels"}
    ...    {"Name": "(UTC+01:00) Sarajevo, Skopje, Warsaw, Zagreb", "Id": "Europe/Sarajevo"}
    ...    {"Name": "(UTC+01:00) West Central Africa", "Id": "Africa/Algiers"}
    ...    {"Name": "(UTC+02:00) Athens, Bucharest", "Id": "Europe/Athens"}
    ...    {"Name": "(UTC+02:00) Beirut", "Id": "Asia/Beirut"}
    ...    {"Name": "(UTC+02:00) Cairo", "Id": "Africa/Cairo"}
    ...    {"Name": "(UTC+02:00) Chisinau", "Id": "Europe/Chisinau"}
    ...    {"Name": "(UTC+02:00) Damascus", "Id": "Asia/Damascus"}
    ...    {"Name": "(UTC+02:00) Gaza, Hebron", "Id": "Africa/Maputo"}
    ...    {"Name": "(UTC+02:00) Harare, Pretoria", "Id": "Africa/Harare"}
    ...    {"Name": "(UTC+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius", "Id": "Europe/Helsinki"}
    ...    {"Name": "(UTC+02:00) Jerusalem", "Id": "Asia/Jerusalem"}
    ...    {"Name": "(UTC+02:00) Juba", "Id": "Africa/Juba"}
    ...    {"Name": "(UTC+02:00) Kaliningrad", "Id": "Europe/Kaliningrad"}
    ...    {"Name": "(UTC+02:00) Khartoum", "Id": "Africa/Khartoum"}
    ...    {"Name": "(UTC+02:00) Tripoli", "Id": "Africa/Tripoli"}
    ...    {"Name": "(UTC+02:00) Windhoek", "Id": "Africa/Windhoek"}
    ...    {"Name": "(UTC+03:00) Amman", "Id": "Asia/Amman"}
    ...    {"Name": "(UTC+03:00) Baghdad", "Id": "Asia/Baghdad"}
    ...    {"Name": "(UTC+03:00) Istanbul", "Id": "Europe/Istanbul"}
    ...    {"Name": "(UTC+03:00) Kuwait, Riyadh", "Id": "Asia/Kuwait"}
    ...    {"Name": "(UTC+03:00) Minsk", "Id": "Europe/Minsk"}
    ...    {"Name": "(UTC+03:00) Moscow, St. Petersburg", "Id": "Europe/Moscow"}
    ...    {"Name": "(UTC+03:00) Nairobi", "Id": "Africa/Nairobi"}
    ...    {"Name": "(UTC+03:00) Volgograd", "Id": "Europe/Volgograd"}
    ...    {"Name": "(UTC+03:30) Tehran", "Id": "Asia/Tehran"}
    ...    {"Name": "(UTC+04:00) Abu Dhabi, Muscat", "Id": "Asia/Dubai"}
    ...    {"Name": "(UTC+04:00) Astrakhan, Ulyanovsk", "Id": "Europe/Samara"}
    ...    {"Name": "(UTC+04:00) Baku", "Id": "Asia/Baku"}
    ...    {"Name": "(UTC+04:00) Izhevsk, Samara", "Id": "Europe/Samara"}
    ...    {"Name": "(UTC+04:00) Port Louis", "Id": "Indian/Mauritius"}
    ...    {"Name": "(UTC+04:00) Saratov", "Id": "Europe/Saratov"}
    ...    {"Name": "(UTC+04:00) Tbilisi", "Id": "Asia/Tbilisi"}
    ...    {"Name": "(UTC+04:00) Yerevan", "Id": "Asia/Yerevan"}
    ...    {"Name": "(UTC+04:30) Kabul", "Id": "Asia/Kabul"}
    ...    {"Name": "(UTC+05:00) Ashgabat, Tashkent", "Id": "Asia/Ashgabat"}
    ...    {"Name": "(UTC+05:00) Ekaterinburg", "Id": "Asia/Yekaterinburg"}
    ...    {"Name": "(UTC+05:00) Islamabad, Karachi", "Id": "Asia/Karachi"}
    ...    {"Name": "(UTC+05:00) Qyzylorda", "Id": "Asia/Qyzylorda"}
    ...    {"Name": "(UTC+05:30) Chennai, Kolkata, Mumbai, New Delhi", "Id": "Asia/Kolkata"}
    ...    {"Name": "(UTC+05:30) Sri Jayawardenepura", "Id": "Asia/Colombo"}
    ...    {"Name": "(UTC+05:45) Kathmandu", "Id": "Asia/Kathmandu"}
    ...    {"Name": "(UTC+06:00) Astana", "Id": "Asia/Almaty"}
    ...    {"Name": "(UTC+06:00) Dhaka", "Id": "Asia/Dhaka"}
    ...    {"Name": "(UTC+06:00) Omsk", "Id": "Asia/Omsk"}
    ...    {"Name": "(UTC+06:30) Yangon (Rangoon)", "Id": "Asia/Yangon"}
    ...    {"Name": "(UTC+07:00) Bangkok, Hanoi, Jakarta", "Id": "Asia/Bangkok"}
    ...    {"Name": "(UTC+07:00) Barnaul, Gorno-Altaysk", "Id": "Asia/Krasnoyarsk"}
    ...    {"Name": "(UTC+07:00) Hovd", "Id": "Asia/Hovd"}
    ...    {"Name": "(UTC+07:00) Krasnoyarsk", "Id": "Asia/Krasnoyarsk"}
    ...    {"Name": "(UTC+07:00) Novosibirsk", "Id": "Asia/Novosibirsk"}
    ...    {"Name": "(UTC+07:00) Tomsk", "Id": "Asia/Omsk"}
    ...    {"Name": "(UTC+08:00) Beijing, Chongqing, Hong Kong, Urumqi", "Id": "Asia/Shanghai"}
    ...    {"Name": "(UTC+08:00) Irkutsk", "Id": "Asia/Irkutsk"}
    ...    {"Name": "(UTC+08:00) Kuala Lumpur, Singapore", "Id": "Asia/Kuala_Lumpur"}
    ...    {"Name": "(UTC+08:00) Manila", "Id": "Asia/Manila"}
    ...    {"Name": "(UTC+08:00) Perth", "Id": "Australia/Perth"}
    ...    {"Name": "(UTC+08:00) Taipei", "Id": "Asia/Taipei"}
    ...    {"Name": "(UTC+08:00) Ulaanbaatar", "Id": "Asia/Ulaanbaatar"}
    ...    {"Name": "(UTC+08:45) Eucla", "Id": "Australia/Eucla"}
    ...    {"Name": "(UTC+09:00) Chita", "Id": "Asia/Chita"}
    ...    {"Name": "(UTC+09:00) Osaka, Sapporo, Tokyo", "Id": "Asia/Tokyo"}
    ...    {"Name": "(UTC+09:00) Pyongyang", "Id": "Asia/Pyongyang"}
    ...    {"Name": "(UTC+09:00) Seoul", "Id": "Asia/Seoul"}
    ...    {"Name": "(UTC+09:00) Yakutsk", "Id": "Asia/Yakutsk"}
    ...    {"Name": "(UTC+09:30) Adelaide", "Id": "Australia/Adelaide"}
    ...    {"Name": "(UTC+09:30) Darwin", "Id": "Australia/Darwin"}
    ...    {"Name": "(UTC+10:00) Brisbane", "Id": "Australia/Brisbane"}
    ...    {"Name": "(UTC+10:00) Canberra, Melbourne, Sydney", "Id": "Australia/Sydney"}
    ...    {"Name": "(UTC+10:00) Guam, Port Moresby", "Id": "Pacific/Guam"}
    ...    {"Name": "(UTC+10:00) Hobart", "Id": "Australia/Hobart"}
    ...    {"Name": "(UTC+10:00) Vladivostok", "Id": "Asia/Vladivostok"}
    ...    {"Name": "(UTC+10:30) Lord Howe Island", "Id": "Australia/Lord_Howe"}
    ...    {"Name": "(UTC+11:00) Bougainville Island", "Id": "Pacific/Bougainville"}
    ...    {"Name": "(UTC+11:00) Chokurdakh", "Id": "Asia/Magadan"}
    ...    {"Name": "(UTC+11:00) Magadan", "Id": "Asia/Magadan"}
    ...    {"Name": "(UTC+11:00) Norfolk Island", "Id": "Pacific/Norfolk"}
    ...    {"Name": "(UTC+11:00) Sakhalin", "Id": "Asia/Sakhalin"}
    ...    {"Name": "(UTC+11:00) Solomon Is., New Caledonia", "Id": "Pacific/Guadalcanal"}
    ...    {"Name": "(UTC+12:00) Anadyr, Petropavlovsk-Kamchatsky", "Id": "Asia/Anadyr"}
    ...    {"Name": "(UTC+12:00) Auckland, Wellington", "Id": "Pacific/Auckland"}
    ...    {"Name": "(UTC+12:00) Coordinated Universal Time+12", "Id": "Etc/GMT-12"}
    ...    {"Name": "(UTC+12:00) Fiji", "Id": "Pacific/Fiji"}
    ...    {"Name": "(UTC+12:45) Chatham Islands", "Id": "Pacific/Chatham"}
    ...    {"Name": "(UTC+13:00) Coordinated Universal Time+13", "Id": "Etc/GMT-13"}
    ...    {"Name": "(UTC+13:00) Nuku'alofa", "Id": "Pacific/Tongatapu"}
    ...    {"Name": "(UTC+13:00) Samoa", "Id": "Pacific/Apia"}
    ...    {"Name": "(UTC+14:00) Kiritimati Island", "Id": "Pacific/Kiritimati"}  

${BRANCH_INACTIVE_ID}    35205
# trang thai ban dau = 0
${BRANCH_ACTIVE_ID}    35206
# trang thai  ban dau = 1


&{Branch_Active}
    ...    Id=
    ...    LimitAccess=
   
&{Branchs_Active}
    ...    Branch=${Branch_Active}


