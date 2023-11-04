with GNATCOLL.Opt_Parse;    use GNATCOLL.Opt_Parse;
with DDS;
package MultiReaderWaitset.Args is

   Parser : Argument_Parser := Create_Argument_Parser
     (Help => "Help string for the parser");

   function Convert (Arg : Standard.String) return Duration is (Duration'Value (Arg));
   function Convert (Arg : Standard.String) return DDS.DomainId_T is (DDS.DomainId_T'Value (Arg));
   function Convert (Arg : Standard.String) return DDS.String is (DDS.To_DDS_String (Arg));
   function Convert (Arg : Standard.String) return DDS.String_Ptr is (new DDS.String'(DDS.To_DDS_String (Arg)));

   DomainId_Deafult : constant DDS.DomainId_T := 0;
   package DomainId is new Parse_Option
     (Parser      => Parser,
      Short       => "-d",
      Long        => "--DomainId",
      Arg_Type    => DDS.DomainId_T,
      Default_Val => DomainId_Deafult,
      Help        => "DomainId to use, default:" & DomainId_Deafult'Image);

   Library_Deafult  : constant DDS.String_Ptr := new DDS.String'(DDS.To_DDS_String ("DefaultLibrary"));
   package Library is new Parse_Option
     (Parser      => Parser,
      Short       => "-l",
      Long        => "--library",
      Arg_Type    => DDS.String_Ptr,
      Default_Val => Library_Deafult,
      Help        => "Library to use, default:" & DDS.To_Standard_String (Library_Deafult.all));

   Profile_Deafult  : constant DDS.String_Ptr := new DDS.String'(DDS.To_DDS_String ("Demo"));
   package Profile is new Parse_Option
     (Parser      => Parser,
      Short       => "-p",
      Long        => "--profile",
      Arg_Type    => DDS.String_Ptr,
      Default_Val => Profile_Deafult,
      Help        => "Profile to use, default:" & DDS.To_Standard_String (Profile_Deafult.all));

   Execution_Time_Deafult : constant Duration := 10.0;
   package Execution_Time is new Parse_Option
     (Parser      => Parser,
      Short       => "-t",
      Long        => "--exec-time",
      Arg_Type    => Duration,
      Default_Val => Execution_Time_Deafult,
      Help        => "Execution_Time for publisher to use in seconds to use, default:" & Execution_Time_Deafult'Image);

   package Debug is new Parse_Flag
     (Parser => Parser,
      Short  => "-d",
      Long   => "--debug",
      Help   => "Set DDS-loglevel to Debug.");

end MultiReaderWaitset.Args;
