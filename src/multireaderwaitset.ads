with DDS.Helpers;
package MultiReaderWaitset is
   type String_7 is new String (1 .. 7);
   function String_As_Octets is new DDS.Helpers.Element_As_Octets_Generic (String_7);
   function Octets_As_String is new DDS.Helpers.Octets_As_Element_Generic (String_7);
end MultiReaderWaitset;
