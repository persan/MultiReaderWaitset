package DDS.Helpers is
   generic
      type Element is private;
      pragma Compile_Time_Error (Element'Has_Access_Values, "Element may not contain pointers");
   function Element_As_Octets_Generic (Item : aliased Element) return DDS.Octets;

   generic
      type Element is private;
      pragma Compile_Time_Error (Element'Has_Access_Values, "Element may not contain pointers");
   function Octets_As_Element_Generic (Item : aliased DDS.Octets) return Element;

end DDS.Helpers;
