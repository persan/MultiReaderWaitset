pragma Ada_2022;
with DDS.DataReader;
with GNATCOLL.Traces.Syslog;
package body DDS.Syslog_Error_DataReader_Listner is

   procedure Log_Message
     (Self       : not null access Ref;
      Message    : Standard.String) is
   begin
      GNATCOLL.Traces.Syslog.Syslog (Facility => GNATCOLL.Traces.Syslog.Local0,
                                     Level    => GNATCOLL.Traces.Syslog.Warning,
                                     Message  => Message);
   end;

   ----------------------------------
   -- On_Requested_Deadline_Missed --
   ----------------------------------

   overriding procedure On_Requested_Deadline_Missed
     (Self       :    not null access Ref;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.RequestedDeadlineMissedStatus)
   is
   begin
      Self.Log_Message ("Requested_Deadline_Missed:" & To_Standard_String (DataReader.Ref_Access (The_Reader).Get_Topicdescription.Get_Name));
   end On_Requested_Deadline_Missed;

   -----------------------------------
   -- On_Requested_Incompatible_Qos --
   -----------------------------------

   overriding procedure On_Requested_Incompatible_Qos
     (Self       :    not null access Ref;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.RequestedIncompatibleQosStatus)
   is
   begin
      Self.Log_Message ("Requested_Incompatible_Qos:" & To_Standard_String (DataReader.Ref_Access (The_Reader).Get_Topicdescription.Get_Name));
   end On_Requested_Incompatible_Qos;

   ------------------------
   -- On_Sample_Rejected --
   ------------------------

   overriding procedure On_Sample_Rejected
     (Self       :    not null access Ref;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.SampleRejectedStatus)
   is
   begin
      Self.Log_Message ("Requested_Incompatible_Qos:" & To_Standard_String (DataReader.Ref_Access (The_Reader).Get_Topicdescription.Get_Name));
   end On_Sample_Rejected;

   --------------------
   -- On_Sample_Lost --
   --------------------

   overriding procedure On_Sample_Lost
     (Self       :    not null access Ref;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.SampleLostStatus)
   is
   begin
      Self.Log_Message ("Sample_Lost:" & To_Standard_String (DataReader.Ref_Access (The_Reader).Get_Topicdescription.Get_Name));
   end On_Sample_Lost;

end DDS.Syslog_Error_DataReader_Listner;
