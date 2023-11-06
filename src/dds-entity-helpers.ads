package DDS.Entity.Helpers is
   function "<" (Left, Right : Ref_Access) return Boolean with Inline_Always => True;
   function "=" (Left, Right : Ref_Access) return Boolean with Inline_Always => True;
end DDS.Entity.Helpers;
