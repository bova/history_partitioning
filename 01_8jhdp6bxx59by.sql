/*
SQL_ID: 8jhdp6bxx59by
EXECUTIONS: 602
*/

SELECT b.Time_Stamp  AS "TimeStamp",
       b.User_       AS "User1",
       b.Comment_    AS "Comment1",
       b.Time_Stamp_ AS "TimeStamp1",
       b.Source_     AS "Source"
  FROM (SELECT DISTINCT To_Char(a.Time_Stamp,
                                'DD Month YYYY, hh24:mi',
                                'NLS_DATE_LANGUAGE = RUSSIAN') Time_Stamp,
                        (SELECT u.Full_Name
                           FROM Client.Users u
                          WHERE u.Id = a.User_Id) User_,
                        a.Comment_,
                        a.Time_Stamp Time_Stamp_,
                        'de' AS Source_
          FROM (SELECT h.Rec_Id,
                       h.Time_Stamp,
                       h.User_Id,
                       Hd.Old_Value AS Comment_
                  FROM Client.History h, Client.History_Detail Hd
                 WHERE h.Id = Hd.History_Id
                   AND h.Group_Id = 52
                   AND h.Deal_Id = 7
                   AND h.Action_Id IN (1, 7, 8)
                   AND h.Branch = 1
                   AND h.Rec_Id IN
                       (SELECT s.Id
                          FROM Client.z_Subscriber s
                         WHERE s.Msisdn_Id =
                               (SELECT m.Id
                                  FROM Client.z_Msisdn m
                                 WHERE m.Msisdn = :B1))
                   AND Hd.Field_Name = 'MSG'
                UNION ALL
                SELECT h.Rec_Id,
                       h.Time_Stamp,
                       h.User_Id,
                       Hd.New_Value AS Comment_
                  FROM Client.History h, Client.History_Detail Hd
                 WHERE h.Id = Hd.History_Id
                   AND h.Group_Id = 52
                   AND h.Deal_Id = 7
                   AND h.Action_Id = 6
                   AND h.Branch = 1
                   AND h.Rec_Id IN
                       (SELECT s.Id
                          FROM Client.z_Subscriber s
                         WHERE s.Msisdn_Id =
                               (SELECT m.Id
                                  FROM Client.z_Msisdn m
                                 WHERE m.Msisdn = :B1))
                   AND Hd.Field_Name = 'MSG'
                UNION ALL
                SELECT Sd.Id       AS Rec_Id,
                       Sd.Ins_Date AS Time_Stamp,
                       Sd.User_Id,
                       Sd.Msg      AS Comment_
                  FROM Client.z_Subscriber_Documents Sd
                 WHERE Sd.Id IN (SELECT s.Id
                                   FROM Client.z_Subscriber s
                                  WHERE s.Msisdn_Id =
                                        (SELECT m.Id
                                           FROM Client.z_Msisdn m
                                          WHERE m.Msisdn = :B1))) a
        UNION ALL
        SELECT To_Char(h.Time_Stamp,
                       'DD Month YYYY, hh24:mi',
                       'NLS_DATE_LANGUAGE = RUSSIAN') Time_Stamp,
               (SELECT u.Full_Name FROM Client.Users u WHERE u.Id = h.User_Id) User_,
               (SELECT Hd.New_Value
                  FROM Client.History_Detail Hd
                 WHERE Hd.History_Id = h.Id) Comment_,
               h.Time_Stamp,
               'ms' AS Source_
          FROM Client.History h
         WHERE h.Group_Id = 50
           AND h.Deal_Id = 2
           AND h.Action_Id = 12
           AND h.Branch = 1
           AND h.Rec_Id =
               (SELECT m.Id FROM Client.z_Msisdn m WHERE m.Msisdn = :B1)
        UNION ALL
        SELECT To_Char(t.Log_Date,
                       'DD Month YYYY, hh24:mi',
                       'NLS_DATE_LANGUAGE = RUSSIAN') Time_Stamp,
               u.Full_Name User_,
               t.Comments Comment_,
               t.Log_Date,
               'SM' AS Source_
          FROM Client.Subscriber_Managment t, Client.Users u
         WHERE t.Msisdn = :B1
           AND t.User_Id = u.Id
           AND t.Comments IS NOT NULL) b
 ORDER BY b.Time_Stamp_ DESC