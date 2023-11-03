with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNATCOLL.Opt_Parse;    use GNATCOLL.Opt_Parse;
with DDS;
package MultiReaderWaitset.Args is

   Parser : Argument_Parser := Create_Argument_Parser
     (Help => "Help string for the parser");

   function Convert (Arg : Standard.String) return Duration is (Duration'Value (Arg));
   function Convert (Arg : Standard.String) return DDS.DomainId_T is (DDS.DomainId_T'Value (Arg));
   function Convert (Arg : Standard.String) return DDS.String is (DDS.To_DDS_String (Arg));

   DomainId_Deafult : constant DDS.DomainId_T := 0;
   package DomainId is new Parse_Option
     (Parser      => Parser,
      Short       => "-d",
      Long        => "--DomainId",
      Arg_Type    => DDS.DomainId_T,
      Default_Val => DomainId_Deafult,
      Help        => "DomainId to use, default:" & DomainId_Deafult'Image);

   Execution_Time_Deafult : constant Duration := 30.0;
   package Execution_Time is new Parse_Option
     (Parser      => Parser,
      Short       => "-t",
      Long        => "--exec-time",
      Arg_Type    => Duration,
      Default_Val => Execution_Time_Deafult,
      Help        => "Execution_Time in seconds to use, default:" & Execution_Time_Deafult'Image);

end MultiReaderWaitset.Args;
