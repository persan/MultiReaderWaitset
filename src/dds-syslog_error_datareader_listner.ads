with DDS.DataReaderListener;

package DDS.Syslog_Error_DataReader_Listner is
   type Ref is abstract new DDS.DataReaderListener.Ref with private;
   overriding procedure On_Requested_Deadline_Missed
     (Self       : not null access Ref;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.RequestedDeadlineMissedStatus);

   overriding procedure On_Requested_Incompatible_Qos
     (Self       : not null access Ref;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.RequestedIncompatibleQosStatus);

   overriding procedure On_Sample_Rejected
     (Self       : not null access Ref;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.SampleRejectedStatus);

   overriding procedure On_Sample_Lost
     (Self       : not null access Ref;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.SampleLostStatus);
   procedure Log_Message
     (Self       : not null access Ref;
      Message    : Standard.String);

private
   type Ref is abstract new DDS.DataReaderListener.Ref with record
      null;
   end record;
end DDS.Syslog_Error_DataReader_Listner;
